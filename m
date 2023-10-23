Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E915E80;
	Mon, 23 Oct 2023 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9JrcLm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45013C433C8;
	Mon, 23 Oct 2023 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060356;
	bh=xXvY4xmd2AnMqShJdWovg+G43rAKn8hdI+9YL5/JR7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9JrcLm6joP5AnMckmalDI0P/9GR9I55kAMQ9ce8vpyC9dRPd4k7r12UJI36no4cP
	 Na4N3JUxTl6s3tXCDNFiG6hPUfdXzraqu7ZCFUBhgqQIvQEREn/XkJ54k5wKbVjTFz
	 li5gcjJ7t0U8wjlMgGcKJKO3onXo/2qJMD3sxC1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 137/196] ice: Remove redundant pci_enable_pcie_error_reporting()
Date: Mon, 23 Oct 2023 12:56:42 +0200
Message-ID: <20231023104832.357990560@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit ba153552c18d7eb839ec0bad7d7484e29ba4719c ]

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this doesn't control interrupt generation by the Root Port; that
is controlled by the AER Root Error Command register, which is managed by
the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 0288c3e709e5 ("ice: reset first in crash dump kernels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ae733207d0116..f0f39364819ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4723,7 +4723,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	pf->pdev = pdev;
@@ -5016,7 +5015,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 	return err;
 }
@@ -5142,7 +5140,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_reset(&pf->hw, ICE_RESET_PFR);
 	pci_wait_for_pending_transaction(pdev);
 	ice_clear_interrupt_scheme(pf);
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.40.1



