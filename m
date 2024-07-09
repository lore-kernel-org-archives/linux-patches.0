Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4314EC4D;
	Tue,  9 Jul 2024 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523792; cv=none; b=a0Bf3vRETlO4rnrortCs/O15C8uG4qFRUc/IulRp5FGj5z4ffFS9tnES653MmMpXzhzyFqWQERweBGUvbT6jELxYofsrIxBhudBHMseXX4p+BinO641K5dXH157VAqh8Taie6woN9iCSfXz5SeesUfzV83FIh0N3yiq4d05EEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523792; c=relaxed/simple;
	bh=rXd6DZJM5ywA81ioiXc/UoGLaA25F0AyBZT5cz+Ym8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc7fCI9bdgMZ2NiLvwHioV86WYSsotlPLd4QCcMjLNb+7VMWToOjen9hrHUuBSfEFiP3D3J226KWEJjb/JkvLrGyn6qQWh0MeFWrZdsizGLn4MFEnFiqkgsyVKeH2odz4/K0HAX33PB+NcUkbCg/jyaZuTcVqxvUspp3U0oGiGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5WrfLuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5WrfLuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EBBC3277B;
	Tue,  9 Jul 2024 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523792;
	bh=rXd6DZJM5ywA81ioiXc/UoGLaA25F0AyBZT5cz+Ym8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5WrfLuHJuGphrMzAIYHhd53c6H9D0bl1v5KMVYv7sdh/BbmzGjavrY6Zqigju54i
	 zh69GSdFIgB4yjIsdeSEL+IhdjXJzNmOJktpeEGGczYt8BnreuzzqNdbZFkTthn43D
	 LmqaZYldnh/cEFTDKhB6Q5Nvlqff55DAZTH4U460=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 109/139] mtd: rawnand: Ensure ECC configuration is propagated to upper layers
Date: Tue,  9 Jul 2024 13:10:09 +0200
Message-ID: <20240709110702.389048387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 3a1b777eb9fb75d09c45ae5dd1d007eddcbebf1f upstream.

Until recently the "upper layer" was MTD. But following incremental
reworks to bring spi-nand support and more recently generic ECC support,
there is now an intermediate "generic NAND" layer that also needs to get
access to some values. When using "converted" ECC engines, like the
software ones, these values are already propagated correctly. But
otherwise when using good old raw NAND controller drivers, we need to
manually set these values ourselves at the end of the "scan" operation,
once these values have been negotiated.

Without this propagation, later (generic) checks like the one warning
users that the ECC strength is not high enough might simply no longer
work.

Fixes: 8c126720fe10 ("mtd: rawnand: Use the ECC framework nand_ecc_is_strong_enough() helper")
Cc: stable@vger.kernel.org
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Closes: https://lore.kernel.org/all/Zhe2JtvvN1M4Ompw@pengutronix.de/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/linux-mtd/20240507085842.108844-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -6282,6 +6282,7 @@ static const struct nand_ops rawnand_ops
 static int nand_scan_tail(struct nand_chip *chip)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	struct nand_device *base = &chip->base;
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	int ret, i;
 
@@ -6426,9 +6427,13 @@ static int nand_scan_tail(struct nand_ch
 	if (!ecc->write_oob_raw)
 		ecc->write_oob_raw = ecc->write_oob;
 
-	/* propagate ecc info to mtd_info */
+	/* Propagate ECC info to the generic NAND and MTD layers */
 	mtd->ecc_strength = ecc->strength;
+	if (!base->ecc.ctx.conf.strength)
+		base->ecc.ctx.conf.strength = ecc->strength;
 	mtd->ecc_step_size = ecc->size;
+	if (!base->ecc.ctx.conf.step_size)
+		base->ecc.ctx.conf.step_size = ecc->size;
 
 	/*
 	 * Set the number of read / write steps for one page depending on ECC
@@ -6436,6 +6441,8 @@ static int nand_scan_tail(struct nand_ch
 	 */
 	if (!ecc->steps)
 		ecc->steps = mtd->writesize / ecc->size;
+	if (!base->ecc.ctx.nsteps)
+		base->ecc.ctx.nsteps = ecc->steps;
 	if (ecc->steps * ecc->size != mtd->writesize) {
 		WARN(1, "Invalid ECC parameters\n");
 		ret = -EINVAL;


