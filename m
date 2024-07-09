Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D6355E4C;
	Tue,  9 Jul 2024 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524720; cv=none; b=rm0SjDAmWP1tD3tt/kGZbWe43V/4jf95TTTPfmTaMxKZ9OwKuibNnM59Ppq4RwSovS9buS5EQISiMvH6vAqzJPAPZG3a//ihqj1XQvFMN8H3oiQY6KIpuAjdRNSCygLuapERlZJjZfDgMoK1WMz7D6Sj4GaR7PWB+bIjIbWl7KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524720; c=relaxed/simple;
	bh=uCk3xmjniH/poIshEEvv1cQQSvykAjPCCA/XN6ZNrhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnMYqsC1HUlHnTqEGVD/6zGLr24D7/mQECdZGUjzCvk/CtwJvt2A04FAc1salw5jYx54k3SMvIzVxe7IzWuOwi52LNRSck5CCr6D2M9L8FChAuZNqGxWifQhyhbQx3mcSwhs2pNHy4e11WJAqJjUd8LeciEbukNd3qcKQa1F1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deprFh3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deprFh3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A69CC3277B;
	Tue,  9 Jul 2024 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524720;
	bh=uCk3xmjniH/poIshEEvv1cQQSvykAjPCCA/XN6ZNrhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deprFh3fPiQfYX3YhFbwl4iysnUbGqcZdz4SU8/F/kgCdb6nNYL89QS19JvAz81hm
	 CbvQH0JdzADnLuZ7oh3QO0WEnapQdMWMBdOpAL5uLCRtPXlWQ7AZGkBqf+f18b0L69
	 Tcc19veqYq5gE5Hjy8dGwH7A8gdj0Ac49TSyOM2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 078/102] mtd: rawnand: Ensure ECC configuration is propagated to upper layers
Date: Tue,  9 Jul 2024 13:10:41 +0200
Message-ID: <20240709110654.412191358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
@@ -6062,6 +6062,7 @@ static const struct nand_ops rawnand_ops
 static int nand_scan_tail(struct nand_chip *chip)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	struct nand_device *base = &chip->base;
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	int ret, i;
 
@@ -6206,9 +6207,13 @@ static int nand_scan_tail(struct nand_ch
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
@@ -6216,6 +6221,8 @@ static int nand_scan_tail(struct nand_ch
 	 */
 	if (!ecc->steps)
 		ecc->steps = mtd->writesize / ecc->size;
+	if (!base->ecc.ctx.nsteps)
+		base->ecc.ctx.nsteps = ecc->steps;
 	if (ecc->steps * ecc->size != mtd->writesize) {
 		WARN(1, "Invalid ECC parameters\n");
 		ret = -EINVAL;


