Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8255266EEA;
	Tue,  8 Apr 2025 12:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113988; cv=none; b=CFC1ksW05pwK9zUz6rIQt61NFPf2wyl/dd6+NEWms5wb+qcCaohLO+uzGggF/EnBcWvLYvKMm05iqdn7v9/AdHenAVsMWC74iiV0uczgTzoLD3k9KbOb8KjkcgeT4UT9ZjrjVMnUS9Nnjr++KywaTuBAbm1VdPGItfTX04Dz8hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113988; c=relaxed/simple;
	bh=B/ag3ZxDhCEg+yw/92LljLpMZ+3l4cZ2Z87zEU64jHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggcmCHEy7Hu9Z2OjUzTCAHa/BpCj/awBsSxH7NeTBOwcc+MRsP3DC4Ul5fX9T/jZFY4Dkm/40Go1R7/KGCH9w0UOtqRbTUFGGjbRi3wV/uWE+4troZ56DICHReWL5WzGwdugwkU3DJrW+9apoE7xczeVU27IpBMDYcQlRfUPPnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcU/EsAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcU/EsAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A667C4CEE5;
	Tue,  8 Apr 2025 12:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113988;
	bh=B/ag3ZxDhCEg+yw/92LljLpMZ+3l4cZ2Z87zEU64jHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcU/EsAgfz78N2H3S0hQXJuTi0KRaJNUNTdlbudOyA9cCyWBJOa7xMBrUNHVJ8U7v
	 ii5nw34hEnrWDKkNGi8W/BMxRzxIoMwytGM8Jn6feZZl5P9dzJMTN6W+6NV7lATc1m
	 0stfPbVMuObGBUReImlSiGkU/Sf+yIzFMWtbdv1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/154] PCI/portdrv: Only disable pciehp interrupts early when needed
Date: Tue,  8 Apr 2025 12:50:36 +0200
Message-ID: <20250408104818.370790259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/pcie/portdrv_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 8637f6068f9c2..07d2699286448 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -214,10 +214,12 @@ static int get_port_device_capability(struct pci_dev *dev)
 
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



