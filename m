Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E2762E5;
	Mon,  8 Apr 2024 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582475; cv=none; b=ftlQsS3ix+6OZWWHhjW2ugnXH3dHfL9HwTa1qAUrbh/fmQkw/By/6M5TbqvztxeifVeYoHqkqMQJvXezqoFaeB/SjAzIYsgHWd/7XYdyrT2t5TiSBUi2jjEcMDWwRgUzwliD3SMUj9OoE8og/2jB4GHROjTw81qz/BQgeoRk1d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582475; c=relaxed/simple;
	bh=sKNIh643/3mpeII46zPupH+qo0h3tjH4PCu2avk/A7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP1ZYMGZstLlsQsa+vSbWoI838zRafr6a8N5tnwNgfsxUK734L29/vdxhAIb9M8mbYYXubbW5FCHELyjWMiDjsgiUFPIGL31dCgvycs9i+SNOllJrRJG1E0jXj56p2Q6jK/2hQ9hvl2mcROKSS42ZsqLV6eQkgqqLc0foyQqpSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRMMw7pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRMMw7pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4BCC43390;
	Mon,  8 Apr 2024 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582474;
	bh=sKNIh643/3mpeII46zPupH+qo0h3tjH4PCu2avk/A7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRMMw7pQxWYhPZg5EtLq+yFytldcQ++oLAN2znG9MMzxcLfNDPNvfEbbekc3Il5dr
	 4+qWEyBcARM+Mr7xkp3bt93BSTPjmKxK8ZRpskDqNxHj6faH+4byRBCDxFqTzNklIQ
	 yxV5ucAenfvR759vHdPhZoMzrVmqPY8IRSnMMjkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/138] ata: sata_mv: Fix PCI device ID table declaration compilation warning
Date: Mon,  8 Apr 2024 14:58:43 +0200
Message-ID: <20240408125259.622980821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3137b83a90646917c90951d66489db466b4ae106 ]

Building with W=1 shows a warning for an unused variable when CONFIG_PCI
is diabled:

drivers/ata/sata_mv.c:790:35: error: unused variable 'mv_pci_tbl' [-Werror,-Wunused-const-variable]
static const struct pci_device_id mv_pci_tbl[] = {

Move the table into the same block that containsn the pci_driver
definition.

Fixes: 7bb3c5290ca0 ("sata_mv: Remove PCI dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 63 +++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 17f9062b0eaa5..9cf540017a5e5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -787,37 +787,6 @@ static const struct ata_port_info mv_port_info[] = {
 	},
 };
 
-static const struct pci_device_id mv_pci_tbl[] = {
-	{ PCI_VDEVICE(MARVELL, 0x5040), chip_504x },
-	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
-	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
-	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
-	/* RocketRAID 1720/174x have different identifiers */
-	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
-
-	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
-	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
-	{ PCI_VDEVICE(MARVELL, 0x6042), chip_6042 },
-	{ PCI_VDEVICE(MARVELL, 0x6080), chip_608x },
-	{ PCI_VDEVICE(MARVELL, 0x6081), chip_608x },
-
-	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
-
-	/* Adaptec 1430SA */
-	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
-
-	/* Marvell 7042 support */
-	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
-
-	/* Highpoint RocketRAID PCIe series */
-	{ PCI_VDEVICE(TTI, 0x2300), chip_7042 },
-	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
-
-	{ }			/* terminate list */
-};
-
 static const struct mv_hw_ops mv5xxx_ops = {
 	.phy_errata		= mv5_phy_errata,
 	.enable_leds		= mv5_enable_leds,
@@ -4301,6 +4270,36 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 static int mv_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static const struct pci_device_id mv_pci_tbl[] = {
+	{ PCI_VDEVICE(MARVELL, 0x5040), chip_504x },
+	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
+	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
+	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1720/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
+
+	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
+	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
+	{ PCI_VDEVICE(MARVELL, 0x6042), chip_6042 },
+	{ PCI_VDEVICE(MARVELL, 0x6080), chip_608x },
+	{ PCI_VDEVICE(MARVELL, 0x6081), chip_608x },
+
+	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
+
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
+	/* Marvell 7042 support */
+	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
+
+	/* Highpoint RocketRAID PCIe series */
+	{ PCI_VDEVICE(TTI, 0x2300), chip_7042 },
+	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
+
+	{ }			/* terminate list */
+};
 
 static struct pci_driver mv_pci_driver = {
 	.name			= DRV_NAME,
@@ -4313,6 +4312,7 @@ static struct pci_driver mv_pci_driver = {
 #endif
 
 };
+MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 
 /**
  *      mv_print_info - Dump key info to kernel log for perusal.
@@ -4485,7 +4485,6 @@ static void __exit mv_exit(void)
 MODULE_AUTHOR("Brett Russ");
 MODULE_DESCRIPTION("SCSI low-level driver for Marvell SATA controllers");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
 
-- 
2.43.0



