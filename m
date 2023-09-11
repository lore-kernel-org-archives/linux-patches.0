Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAECE1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5931DC433C7;
	Mon, 11 Sep 2023 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441954;
	bh=K/y+2mNIxx6Tb/185biJznHgDORnCSCrVoSjHYz0TI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLabwdDFB7H0dM3CvQCigCYtPiw6SP9ueY7sGx9O9zmH6PO7cHyBVR+M4cZU5nVa3
	 S8s6xNpg98UiyUXiyR3Azd/S/pVbA/9I0cCOCFQdE6+HdQBuNV29lfUGsjvhWFjdlW
	 bcgjmejZt7O8yiyv+2+QwxyJ/S7RkKo8+kC94PEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 595/739] mtd: rawnand: brcmnand: Fix mtd oobsize
Date: Mon, 11 Sep 2023 15:46:34 +0200
Message-ID: <20230911134707.721235769@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 2e9c2e2d9c9f7..d8418d7fcc372 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2612,6 +2612,8 @@ static int brcmnand_setup_dev(struct brcmnand_host *host)
 	struct nand_chip *chip = &host->chip;
 	const struct nand_ecc_props *requirements =
 		nanddev_get_ecc_requirements(&chip->base);
+	struct nand_memory_organization *memorg =
+		nanddev_get_memorg(&chip->base);
 	struct brcmnand_controller *ctrl = host->ctrl;
 	struct brcmnand_cfg *cfg = &host->hwcfg;
 	char msg[128];
@@ -2633,10 +2635,11 @@ static int brcmnand_setup_dev(struct brcmnand_host *host)
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



