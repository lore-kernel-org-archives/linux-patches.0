Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC652676E1;
	Tue,  8 Apr 2025 11:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113142; cv=none; b=P2xB8r/Qiw+bk97XExSXj6h3FK/Ik8Q/dGdsU0dsEsGFsIogM6LGCEfcK2AcHk/5e7Q4deQjAaLcMDMX5yIvJdBJAD/4p6ULFDk80WNyjgbz2GZql2ZsF4z06rXfol5V4X2gWpnkhExDOOkNDkOl+YFGFmqzwF5ZMT0ObotWHWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113142; c=relaxed/simple;
	bh=rBUtddYSsdtNlMLojixHZaoE+BcweCdbcnmLSJTH4os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDMhvkeB6WLpKwscuAV2FdsNwmNcNCouq2FhS1hYxVc4GrXC44mFo/GX1uSkUlpaFX/ykKaiIArwj/Rr1rLh8jx7T4L1JDCt/lr3MRgQXsT6pt1V+JCD8eO9rbWMhK5MKoFMvB/K6Nox0yn4phEt4adQvdllRvo9JNvBsA93yyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOJC2vRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOJC2vRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32976C4CEE7;
	Tue,  8 Apr 2025 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113142;
	bh=rBUtddYSsdtNlMLojixHZaoE+BcweCdbcnmLSJTH4os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOJC2vRCW39QConHPcWBhMPSri13uyiQ8J5O8UQDVGMFnsBLZ8G0m4xacp0F+pZgo
	 +K9xZrQ7jQa9FSDP1tp7rq5tQRGvEk/QlNqqzFhOGyKVAQlJw2OWZDEV1M+qUKIpFb
	 HfqBGtQ/PoZFH8AZQNM5VdnLiZWePYfFOYcDH9xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/268] PCI/portdrv: Only disable pciehp interrupts early when needed
Date: Tue,  8 Apr 2025 12:47:40 +0200
Message-ID: <20250408104829.823238796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Feng Tang <feng.tang@linux.alibaba.com>

[ Upstream commit 9d7db4db19827380e225914618c0c1bf435ed2f5 ]

Firmware developers reported that Linux issues two PCIe hotplug commands in
very short intervals on an ARM server, which doesn't comply with the PCIe
spec.  According to PCIe r6.1, sec 6.7.3.2, if the Command Completed event
is supported, software must wait for a command to complete or wait at
least 1 second before sending a new command.

In the failure case, the first PCIe hotplug command is from
get_port_device_capability(), which sends a command to disable PCIe hotplug
interrupts without waiting for its completion, and the second command comes
from pcie_enable_notification() of pciehp driver, which enables hotplug
interrupts again.

Fix this by only disabling the hotplug interrupts when the pciehp driver is
not enabled.

Link: https://lore.kernel.org/r/20250303023630.78397-1-feng.tang@linux.alibaba.com
Fixes: 2bd50dd800b5 ("PCI: PCIe: Disable PCIe port services during port initialization")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index 46fad0d813b2b..d6e5fef54c3b8 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -227,10 +227,12 @@ static int get_port_device_capability(struct pci_dev *dev)
 
 		/*
 		 * Disable hot-plug interrupts in case they have been enabled
-		 * by the BIOS and the hot-plug service driver is not loaded.
+		 * by the BIOS and the hot-plug service driver won't be loaded
+		 * to handle them.
 		 */
-		pcie_capability_clear_word(dev, PCI_EXP_SLTCTL,
-			  PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
+		if (!IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
+			pcie_capability_clear_word(dev, PCI_EXP_SLTCTL,
+				PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
 	}
 
 #ifdef CONFIG_PCIEAER
-- 
2.39.5



