Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1B4FF7B;
	Mon, 18 Dec 2023 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmZS/0Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A984AC433C8;
	Mon, 18 Dec 2023 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908166;
	bh=e1hDEaP4ud1tjf7gNWmjw/dJVt//ty/k2fmV0Xc4D5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmZS/0Bfr3e8g9gUNFq4nHYTo5BX70K5bp1kg8RYP5SzDVgvIRqpYXayiHFte7Td9
	 ZLkZXliQooYm78VOyS+WpZ5UiZGqqUObIqeU3JaTglar5F0WX0mgNpgdEFRbNhAHBy
	 YMYTTZVr3qMCoL7H8V7wP9lOj1BI0MUWaFjAqs4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Michael Bottini <michael.a.bottini@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>
Subject: [PATCH 6.6 077/166] PCI: vmd: Fix potential deadlock when enabling ASPM
Date: Mon, 18 Dec 2023 14:50:43 +0100
Message-ID: <20231218135108.481814039@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 49de0dc87965079a8e2803ee4b39f9d946259423 upstream.

The vmd_pm_enable_quirk() helper is called from pci_walk_bus() during
probe to enable ASPM for controllers with VMD_FEAT_BIOS_PM_QUIRK set.

Since pci_walk_bus() already holds a pci_bus_sem read lock, use
pci_enable_link_state_locked() to enable link states in order to avoid a
potential deadlock (e.g. in case someone takes a write lock before
reacquiring the read lock).

Fixes: f492edb40b54 ("PCI: vmd: Add quirk to configure PCIe ASPM and LTR")
Link: https://lore.kernel.org/r/20231128081512.19387-3-johan+linaro@kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
[bhelgaas: add "potential" in subject since the deadlock has only been
reported by lockdep, include helper name in commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org>	# 6.3
Cc: Michael Bottini <michael.a.bottini@linux.intel.com>
Cc: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/vmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 94ba61fe1c44..0452cbc362ee 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -751,7 +751,7 @@ static int vmd_pm_enable_quirk(struct pci_dev *pdev, void *userdata)
 	if (!(features & VMD_FEAT_BIOS_PM_QUIRK))
 		return 0;
 
-	pci_enable_link_state(pdev, PCIE_LINK_STATE_ALL);
+	pci_enable_link_state_locked(pdev, PCIE_LINK_STATE_ALL);
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
 	if (!pos)
-- 
2.43.0



