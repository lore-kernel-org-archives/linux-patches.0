Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339A22FF143;
	Tue, 11 Nov 2025 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823271; cv=none; b=fQhSK+qi9g03XwZdBjsNAUfqrQn5s4aMBd/ixd1cVhS3hcZybbAh6Dhx6pkt0ZCa7e9nZi9QuKMH0nK3PhD3WyuJ1Y1sLMQUY0HrbfGG3K74O8twGWivbeg4Y9mAHrB9eRSRfoaI4gIfh0gbCNnGNeZ0wfZ1klwYQz/klyJVLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823271; c=relaxed/simple;
	bh=Ky/PR4YfO44R7ITxocZ0MobMnqb/3vnlEuPyNSM/8vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJBCxGdHxWvDllMYB0lIoNavJ6i5odhG+//6l2towoI7y2ywzIY3RTgeiXDbOUcYdtPDmPT2N/nY38zi2pMXq81ro5rzLvI2fWBA/IqepPGSMslgidIWFPeUODE6s1YCgFO4EL+7eOldsBxjwFKWbl9HT/MdoCoDTpvNyAi5cbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nA1B2VWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nA1B2VWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4D2C19421;
	Tue, 11 Nov 2025 01:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823270;
	bh=Ky/PR4YfO44R7ITxocZ0MobMnqb/3vnlEuPyNSM/8vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nA1B2VWRxFhlYSy2qp5/6d+okb2kFiDeRLCTz40c5WAeLrpGM32hCsOnj4FjVGZXv
	 f2m4Pp954oCif215nJaDNxpD3GurU/P3ePY+ruMBCZAmwHoIRYRHHFI9OYUG7AqxHZ
	 DCiOPM4BzDwqnwMqAlXxfTWhijmpa3yWDRDK7Iv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/565] thunderbolt: Use is_pciehp instead of is_hotplug_bridge
Date: Tue, 11 Nov 2025 09:41:05 +0900
Message-ID: <20251111004531.625169042@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 5d03847175e81e86d4865456c15638faaf7c0634 ]

The thunderbolt driver sets up device link dependencies from hotplug ports
to the Host Router (aka Native Host Interface, NHI).  When resuming from
system sleep, this allows the Host Router to re-establish tunnels to
attached Thunderbolt devices before the hotplug ports resume.

To identify the hotplug ports, the driver utilizes the is_hotplug_bridge
flag which also encompasses ACPI slots handled by the ACPI hotplug driver.

Thunderbolt hotplug ports are always Hot-Plug Capable PCIe ports, so it is
more apt to identify them with the is_pciehp flag.

Similarly, hotplug ports on older Thunderbolt controllers have broken MSI
support and are quirked to use legacy INTx interrupts instead.  The quirk
identifies them with is_hotplug_bridge, even though all affected ports are
also matched by is_pciehp.  So use is_pciehp here as well.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c     | 2 +-
 drivers/thunderbolt/tb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index aa4733787cd7e..18fa918b4e537 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3832,7 +3832,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf80, quirk_no_pm_reset);
  */
 static void quirk_thunderbolt_hotplug_msi(struct pci_dev *pdev)
 {
-	if (pdev->is_hotplug_bridge &&
+	if (pdev->is_pciehp &&
 	    (pdev->device != PCI_DEVICE_ID_INTEL_CACTUS_RIDGE_4C ||
 	     pdev->revision <= 1))
 		pdev->no_msi = 1;
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index e1da433a9e7fb..4ef8e67e9987e 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -3242,7 +3242,7 @@ static bool tb_apple_add_links(struct tb_nhi *nhi)
 		if (!pci_is_pcie(pdev))
 			continue;
 		if (pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
-		    !pdev->is_hotplug_bridge)
+		    !pdev->is_pciehp)
 			continue;
 
 		link = device_link_add(&pdev->dev, &nhi->pdev->dev,
-- 
2.51.0



