Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5B21DDCE;
	Tue, 16 Jul 2024 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146127; cv=none; b=Io5aKlJW13uYODCiIBrtz5jLtANkLy39oWrDm2e/4GjvAqGUZD4J9h81W8JSG5VOUwKB5Ws80xmrIS6olJqULUdmfqTNDt0RedPXDWaLiGfoJNHqetyPYdNFFIexwUBDQyOpDKzaQdmpIaHVABNnD8R1oq6LC5OPzxqYXZ2ZAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146127; c=relaxed/simple;
	bh=clm4OnFkBGTW7qhWQVF8TI4oKRnyyrpO4UE4YnrOpWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrKzemxo6uA88ieRH1QEXeNB9+TXcr1oJDAH+37/9zWX9EPshbrGkp/f2R8t8HVp5g1toB5NtkC7EinAop4S+1Zl41PkGz4H4788cT51bVcdhvX3HiWlS+NIXMat/Ds19x4aSerTZWWwapOpJaTJAtNl9iJmKb7Be3ymgV5LCAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPsiwxaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPsiwxaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ADFC116B1;
	Tue, 16 Jul 2024 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146127;
	bh=clm4OnFkBGTW7qhWQVF8TI4oKRnyyrpO4UE4YnrOpWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPsiwxaJAmcGE9nUenc1+wq+XHVtknk5o8rgbzF2CFv0h+niy6WlU3XNk8JuE1efC
	 lbUqTvk9/enCSj8r69BCQHpF5nt/+KF4WxdUPoLhlECGDHbl6V9Tx2SFKZTe3lnaKY
	 /s/yupwmJz9mJil+3+tOPnQYP8cz0LIeYp+TjEAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 058/144] mtd: rawnand: Ensure ECC configuration is propagated to upper layers
Date: Tue, 16 Jul 2024 17:32:07 +0200
Message-ID: <20240716152754.777918135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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
@@ -6050,6 +6050,7 @@ static const struct nand_ops rawnand_ops
 static int nand_scan_tail(struct nand_chip *chip)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	struct nand_device *base = &chip->base;
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	int ret, i;
 
@@ -6194,9 +6195,13 @@ static int nand_scan_tail(struct nand_ch
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
@@ -6204,6 +6209,8 @@ static int nand_scan_tail(struct nand_ch
 	 */
 	if (!ecc->steps)
 		ecc->steps = mtd->writesize / ecc->size;
+	if (!base->ecc.ctx.nsteps)
+		base->ecc.ctx.nsteps = ecc->steps;
 	if (ecc->steps * ecc->size != mtd->writesize) {
 		WARN(1, "Invalid ECC parameters\n");
 		ret = -EINVAL;


