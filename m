Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3101D8DF6;
	Thu, 17 Apr 2025 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912830; cv=none; b=SLPT4poic4Jk2aL/ZbOcffqALLm7z2AQJJPklWW6mSjG/Kqil/cpTocLGWL4csQlNLfNVsUdRa64KWZmxvxb2UA1okn0bVeaTN4rRWhfFPwzxaBCf+GxuniqvfJm/rhpMo0rEZmWiXmc3838e7i1jsSG1be6MqUU2atybEu8zR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912830; c=relaxed/simple;
	bh=Ropr6+/GaKC7JDaqEZ+uSuOyMRokAlQHYCqkZ1rXgsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjiUoHdKXOW3wQfARnOj7Vvk0fJQyVc0iuLNLBHG3Z48wmbVkqrYvrMG+t+TXZrYSqDZ7TOlvQQ9nnYr8Px2ozjmsCDeGSPxrxMIGF1+9s5zw4FZ/9F3xKM6C/qhe2bVIv+M8AF0baE6zj621eLqBEu5KPPkHYYJ66ICo3lg4qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUg8ahvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUg8ahvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D546C4CEE4;
	Thu, 17 Apr 2025 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912830;
	bh=Ropr6+/GaKC7JDaqEZ+uSuOyMRokAlQHYCqkZ1rXgsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUg8ahvCXXsyTgUBfPG4IHEgRpNcVG9gALtnzgksUhbUSww4RVtR7IDThAxGrB9BQ
	 tV6EjEZ8QKEq5xMptmvt6rNvEH+/2bm5vh8vyWSDQXHit6QtT5kFY6c2RoyKtOlWRu
	 dkaosSc+g8dXs3FlGJ06N55crBinG3dtnmo6HLBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Jie Fan <fanjie@uniontech.com>,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 131/449] ahci: Marvell 88SE9215 controllers prefer DMA for ATAPI
Date: Thu, 17 Apr 2025 19:46:59 +0200
Message-ID: <20250417175123.239937301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 0507c777f5d8f9e34b137d28ee263599a7b81242 ]

We use CD/DVD drives under Marvell 88SE9215 SATA controller on many
Loongson-based machines. We found its PIO doesn't work well, and on the
opposite its DMA seems work very well.

We don't know the detail of the 88SE9215 SATA controller, but we have
tested different CD/DVD drives and they all have problems under 88SE9215
(but they all work well under an Intel SATA controller). So, we consider
this problem is bound to 88SE9215 SATA controller rather than bound to
CD/DVD drives.

As a solution, we define a new dedicated AHCI board id which is named
board_ahci_yes_fbs_atapi_dma for 88SE9215, and for this id we set the
AHCI_HFLAG_ATAPI_DMA_QUIRK and ATA_QUIRK_ATAPI_MOD16_DMA flags on the
SATA controller in order to prefer ATAPI DMA.

Reported-by: Yuli Wang <wangyuli@uniontech.com>
Tested-by: Jie Fan <fanjie@uniontech.com>
Tested-by: Erpeng Xu <xuerpeng@uniontech.com>
Tested-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250318104314.2160526-1-chenhuacai@loongson.cn
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c    | 11 ++++++++++-
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c |  4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 52ae8f9a7dd61..f3a6bfe098cd4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -63,6 +63,7 @@ enum board_ids {
 	board_ahci_pcs_quirk_no_devslp,
 	board_ahci_pcs_quirk_no_sntf,
 	board_ahci_yes_fbs,
+	board_ahci_yes_fbs_atapi_dma,
 
 	/* board IDs for specific chipsets in alphabetical order */
 	board_ahci_al,
@@ -188,6 +189,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_yes_fbs_atapi_dma] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_FBS |
+				 AHCI_HFLAG_ATAPI_DMA_QUIRK),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	/* by chipsets */
 	[board_ahci_al] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_MSI),
@@ -590,7 +599,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9215),
-	  .driver_data = board_ahci_yes_fbs },
+	  .driver_data = board_ahci_yes_fbs_atapi_dma },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9235),
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index c842e2de6ef98..2c10c8f440d12 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -246,6 +246,7 @@ enum {
 	AHCI_HFLAG_NO_SXS		= BIT(26), /* SXS not supported */
 	AHCI_HFLAG_43BIT_ONLY		= BIT(27), /* 43bit DMA addr limit */
 	AHCI_HFLAG_INTEL_PCS_QUIRK	= BIT(28), /* apply Intel PCS quirk */
+	AHCI_HFLAG_ATAPI_DMA_QUIRK	= BIT(29), /* force ATAPI to use DMA */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index e7ace4b10f15b..22afa4ff860d1 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1322,6 +1322,10 @@ static void ahci_dev_config(struct ata_device *dev)
 {
 	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
 
+	if ((dev->class == ATA_DEV_ATAPI) &&
+	    (hpriv->flags & AHCI_HFLAG_ATAPI_DMA_QUIRK))
+		dev->quirks |= ATA_QUIRK_ATAPI_MOD16_DMA;
+
 	if (hpriv->flags & AHCI_HFLAG_SECT255) {
 		dev->max_sectors = 255;
 		ata_dev_info(dev,
-- 
2.39.5



