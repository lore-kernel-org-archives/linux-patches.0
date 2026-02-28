Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BA0313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301135; cv=none; b=krgMC70atYmNEi6TmtbrADFSBD4GCN7TPR7eXE6q3xtRS/krLtwqjCyvNsqOGK6aD5hDyuLNZ8GEvHcBVSopTkyA8QD3pQN6Np561vebVcMDwZdNWoFOysBlt5qwivPfyGdT2fwToTzcP9Au97QvdnJ8GPPBEbyYDjX3S5IGQcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301135; c=relaxed/simple;
	bh=a9KAbVqmHpQYlH0JB4A4KbdlmXu4lwqEf90W4OKDYNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+nFZu7wPvB5zRVSGR6TTh+LUHEHcqc2uq+kCLDHesOchk7s5L4CBtBqrGkHLWucF2AyydqRoRsmpN9Ah0IikSsGgn/GVw0Jgg3aBtdei5zPB/0AFki3KqbBMOosXPOUu/ZH+1tA+/KvsbDYGo7uVjIpsxLHfL3i1fs+bQ29wjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vM9D1slM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vM9D1slM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB990C2BC87;
	Sat, 28 Feb 2026 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301135;
	bh=a9KAbVqmHpQYlH0JB4A4KbdlmXu4lwqEf90W4OKDYNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vM9D1slMQYFUT7O3Z3EU3t3nshWZtu4h3M0IfGmbkWdk5hOdjfL4yopdAmfW7Sx1v
	 lJ0PjFa1Fc4B6qAhQCtMXVADebBiRAfwZYat10xhawYWjZZjQnqMyeWIoOcqXqb29m
	 zvcGK/nJr7Wo9Eyb+/Ra8DGDny0sib/4bh42I7PipDrzz7nOcdDlFDV/L1vbhPgyVt
	 FwcO4xb0fby5zsSgZjmOD7gYV+2/c3kogP5NuWFCwhfbUHXPWveoWG4ClcosYOaE32
	 Pux8L4UNMKbzXXLYZCOqs/4Phi6xp4lRk3tLzu1SO6NY9vyvhfoZQ0Rlqc4pLMvZRa
	 umdX83cTjoMIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Adam Stylinski <kungfujesus06@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/752] PCI/bwctrl: Disable BW controller on Intel P45 using a quirk
Date: Sat, 28 Feb 2026 12:40:06 -0500
Message-ID: <20260228174750.1542406-295-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 46a9f70e93ef73860d1dbbec75ef840031f8f30a ]

The commit 665745f27487 ("PCI/bwctrl: Re-add BW notification portdrv as
PCIe BW controller") was found to lead to a boot hang on a Intel P45
system. Testing without setting Link Bandwidth Management Interrupt Enable
(LBMIE) and Link Autonomous Bandwidth Interrupt Enable (LABIE) (PCIe r7.0,
sec 7.5.3.7) in bwctrl allowed system to come up.

P45 is a very old chipset and supports only up to gen2 PCIe, so not having
bwctrl does not seem a huge deficiency.

Add no_bw_notif in struct pci_dev and quirk Intel P45 Root Port with it.

Reported-by: Adam Stylinski <kungfujesus06@gmail.com>
Link: https://lore.kernel.org/linux-pci/aUCt1tHhm_-XIVvi@eggsbenedict/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Adam Stylinski <kungfujesus06@gmail.com>
Link: https://patch.msgid.link/20260116131513.2359-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/bwctrl.c |  3 +++
 drivers/pci/quirks.c      | 10 ++++++++++
 include/linux/pci.h       |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index 36f939f23d34e..4ae92c9f912a8 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -250,6 +250,9 @@ static int pcie_bwnotif_probe(struct pcie_device *srv)
 	struct pci_dev *port = srv->port;
 	int ret;
 
+	if (port->no_bw_notif)
+		return -ENODEV;
+
 	/* Can happen if we run out of bus numbers during enumeration. */
 	if (!port->subordinate)
 		return -ENODEV;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3c7aebf3d238a..d32a47e81fcf3 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1359,6 +1359,16 @@ static void quirk_transparent_bridge(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82380FB,	quirk_transparent_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge);
 
+/*
+ * Enabling Link Bandwidth Management Interrupts (BW notifications) can cause
+ * boot hangs on P45.
+ */
+static void quirk_p45_bw_notifications(struct pci_dev *dev)
+{
+	dev->no_bw_notif = 1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e21, quirk_p45_bw_notifications);
+
 /*
  * Common misconfiguration of the MediaGX/Geode PCI master that will reduce
  * PCI bandwidth from 70MB/s to 25MB/s.  See the GXM/GXLV/GX1 datasheets
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bf97d49c23cf5..05aeee8c8844a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -406,6 +406,7 @@ struct pci_dev {
 						      user sysfs */
 	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
 						   bit manually */
+	unsigned int	no_bw_notif:1;	/* BW notifications may cause issues */
 	unsigned int	d3hot_delay;	/* D3hot->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 
-- 
2.51.0

