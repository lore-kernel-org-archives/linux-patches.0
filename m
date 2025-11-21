Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D534DB59;
	Fri, 21 Nov 2025 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732581; cv=none; b=glWUf7INKWakLiwHOv+Jz4B5rmgM5poa1tkSjfJzf0ahi0URg1kuJTUxYGCNnkSh0O9D1NkPJIGRBGlq+bFUzViETSYf7CHWVoaQrGofFRsSuA4kNNVtoCpEPuDLX2Pb2PEXJXQuynJZsJR59tPBvDzbJhx5gxXN1Vy1eXhUm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732581; c=relaxed/simple;
	bh=qYKjezj3OwEZJs65IH1MgZf329Y9dzypT09ZQVJKChM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKt7Jwqd/VCqMtIq15H15B4HkxiJqC3jb2O8UgRI4scJDA0Sq23QnyAI1LdktA76hqftYgyv61JwyCNhm1E9W1PMTHJuHhtEC2L9GnDCaEIN/zPOwFkhKaRIjzu9IsXBzs/P4UQAOFkd0tPmN0Fp5MMFRegH9lWQT5LtMCbQnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTrEy49C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTrEy49C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F710C4CEF1;
	Fri, 21 Nov 2025 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732581;
	bh=qYKjezj3OwEZJs65IH1MgZf329Y9dzypT09ZQVJKChM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTrEy49Cp2YBHqimpkNMZNdd/o0DtPxHFNhWkO/qqQKrVU+qXuuPG55puEx0wLTdN
	 T58sXRBMI9SxmZStFA+LMW5pcwW9TworT6Qg6hNV4D8ehKHKE8/Jf70aGMkyW6ioLl
	 7TQG9kZqKllpV1+8iLqRe3QEvmjg03QZwZA6eFGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/529] thunderbolt: Use is_pciehp instead of is_hotplug_bridge
Date: Fri, 21 Nov 2025 14:07:17 +0100
Message-ID: <20251121130235.927958552@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aae702063ba3d..30a5f809ee798 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3825,7 +3825,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf80, quirk_no_pm_reset);
  */
 static void quirk_thunderbolt_hotplug_msi(struct pci_dev *pdev)
 {
-	if (pdev->is_hotplug_bridge &&
+	if (pdev->is_pciehp &&
 	    (pdev->device != PCI_DEVICE_ID_INTEL_CACTUS_RIDGE_4C ||
 	     pdev->revision <= 1))
 		pdev->no_msi = 1;
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index b92a8a5b2e8c9..bf35fd23b5e16 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -3022,7 +3022,7 @@ static bool tb_apple_add_links(struct tb_nhi *nhi)
 		if (!pci_is_pcie(pdev))
 			continue;
 		if (pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
-		    !pdev->is_hotplug_bridge)
+		    !pdev->is_pciehp)
 			continue;
 
 		link = device_link_add(&pdev->dev, &nhi->pdev->dev,
-- 
2.51.0



