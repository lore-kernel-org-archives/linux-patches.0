Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F234D3A3;
	Wed,  3 Dec 2025 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777751; cv=none; b=m8RwJfp3doW1+/iAdds9yrAYlovcIy9AtbkqgPM/hF1j7eG3/c49/mWEuXNKnOt2cKhue1RLc5WdZ1Uk3LXDle/cXWAx/+b5V6axZteln9Cp0+WQu8uULQY4EeUt5/U5uyKCE8WJtO8+dFzmXezBLfmnmXaDdJEDni8Gb+xUMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777751; c=relaxed/simple;
	bh=GQu0030PQobScksb0RKw7OEXuPpwk4cApNybvezbUTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fftLOXu8kyF40wFisMFaXN1CGVgTi4o2wu/OuqxDiaewhPQFPZ3Q1PFj+IlssmcuXhh1B5x8fwpBjf2CDuuqINFjSJu+9wVID87okB6kRzUhyQNH/R4f+8zB0uGnJtmONtTtdYxolgPI/Z+/plMvjPYZYMcMjvvuTZimmUhqNUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS50ukpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS50ukpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F02C4CEF5;
	Wed,  3 Dec 2025 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777751;
	bh=GQu0030PQobScksb0RKw7OEXuPpwk4cApNybvezbUTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS50ukpwyfG1uPlpnY5TpUdJ2LG2dCx1mfhHRhyRxdRjriG7od0BWQOXLCnL7+QBg
	 MB3MMuXnS1AZhkgi0xZbB91l+OPzB8s+sn+nYYXJgZ17XREZCwI8IAgf0hQdqGiFcH
	 HQNLKMt1xegFEXsWP1afdlDb+wN6xWzlt9iNGOvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/392] thunderbolt: Use is_pciehp instead of is_hotplug_bridge
Date: Wed,  3 Dec 2025 16:24:13 +0100
Message-ID: <20251203152417.889357809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7cc346fff87e3..7597aedc05c37 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3693,7 +3693,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf80, quirk_no_pm_reset);
  */
 static void quirk_thunderbolt_hotplug_msi(struct pci_dev *pdev)
 {
-	if (pdev->is_hotplug_bridge &&
+	if (pdev->is_pciehp &&
 	    (pdev->device != PCI_DEVICE_ID_INTEL_CACTUS_RIDGE_4C ||
 	     pdev->revision <= 1))
 		pdev->no_msi = 1;
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 8bf45da1012e8..abe171769dc7e 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1698,7 +1698,7 @@ static void tb_apple_add_links(struct tb_nhi *nhi)
 		if (!pci_is_pcie(pdev))
 			continue;
 		if (pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
-		    !pdev->is_hotplug_bridge)
+		    !pdev->is_pciehp)
 			continue;
 
 		link = device_link_add(&pdev->dev, &nhi->pdev->dev,
-- 
2.51.0



