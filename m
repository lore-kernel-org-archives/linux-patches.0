Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE453AB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A573C433C8;
	Sun, 17 Sep 2023 20:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982612;
	bh=QvtYXOwAx1FkUYPfZi0UNgnxOek0zIXpDDXeWXOQ0qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FP74Fd1mzFLZArFZNR579eeDqtiT/tpSfXYNhtjqDptWHmYEeGv87BtMdBv/pOkE3
	 e/jyQ9Enh5nwyw5Vtplycex0pl0uVo4/Wu0LR2+g2v5M4ZghVKyz0gFaIrzTK8spNP
	 XvZkYY6bUwRaziwfC8mCj2LRQEEL3XJbZucglq4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/511] mtd: rawnand: brcmnand: Fix mtd oobsize
Date: Sun, 17 Sep 2023 21:12:08 +0200
Message-ID: <20230917191121.100445913@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Zhang <william.zhang@broadcom.com>

[ Upstream commit 60177390fa061c62d156f4a546e3efd90df3c183 ]

brcmnand controller can only access the flash spare area up to certain
bytes based on the ECC level. It can be less than the actual flash spare
area size. For example, for many NAND chip supporting ECC BCH-8, it has
226 bytes spare area. But controller can only uses 218 bytes. So brcmand
driver overrides the mtd oobsize with the controller's accessible spare
area size. When the nand base driver utilizes the nand_device object, it
resets the oobsize back to the actual flash spare aprea size from
nand_memory_organization structure and controller may not able to access
all the oob area as mtd advises.

This change fixes the issue by overriding the oobsize in the
nand_memory_organization structure to the controller's accessible spare
area size.

Fixes: a7ab085d7c16 ("mtd: rawnand: Initialize the nand_device object")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230706182909.79151-6-william.zhang@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index aee78f5f4f156..ff3891b774561 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2583,6 +2583,8 @@ static int brcmnand_setup_dev(struct brcmnand_host *host)
 	struct nand_chip *chip = &host->chip;
 	const struct nand_ecc_props *requirements =
 		nanddev_get_ecc_requirements(&chip->base);
+	struct nand_memory_organization *memorg =
+		nanddev_get_memorg(&chip->base);
 	struct brcmnand_controller *ctrl = host->ctrl;
 	struct brcmnand_cfg *cfg = &host->hwcfg;
 	char msg[128];
@@ -2604,10 +2606,11 @@ static int brcmnand_setup_dev(struct brcmnand_host *host)
 	if (cfg->spare_area_size > ctrl->max_oob)
 		cfg->spare_area_size = ctrl->max_oob;
 	/*
-	 * Set oobsize to be consistent with controller's spare_area_size, as
-	 * the rest is inaccessible.
+	 * Set mtd and memorg oobsize to be consistent with controller's
+	 * spare_area_size, as the rest is inaccessible.
 	 */
 	mtd->oobsize = cfg->spare_area_size * (mtd->writesize >> FC_SHIFT);
+	memorg->oobsize = mtd->oobsize;
 
 	cfg->device_size = mtd->size;
 	cfg->block_size = mtd->erasesize;
-- 
2.40.1



