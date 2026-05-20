Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945CA3EFD3D;
	Wed, 20 May 2026 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298630; cv=none; b=sSlK/b76L00Jyt6KWcRO2ttCXStlFoe3STFI/Z+hwwGrZXKXo3D83N7HGtfZmnMTo2g/59dm+mlbFtWWtof/GkTjzSQueW4PKbugq+Sp2i2FOGArf1lS8O+5Uy3Y2XsEA58qwHjaN9FtuCqLhpvfkqshkHvjvVVyVtzp5SJxW0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298630; c=relaxed/simple;
	bh=MwJL0l1pipqHENZ/wXnCHAzBXLFwKni6YE1Y7ndEB8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGsJFG6spqhBkbcDkqCLiMR1CNo3yW+GSQgFgSsTeyD3+o9Fq0Qx5P83ipR/e3wfIYGhFc04zSZRDOCZjWxSD5imV99fRd9+Fya1VRvZ1QaPpFkVXUEc/uVpsFN2xdzLolGetZX+0IftKJsduV1wNMhCt+CPu04N/Sx8JXAK4bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHLu9Btn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHLu9Btn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D781F000E9;
	Wed, 20 May 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298628;
	bh=QRrZlRpS5D+rSSgroYBoHiM8yoCyTz/F7p6e+GYBYnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHLu9Btn5xo+QTAjG8rueFpxni7f7z9a1FLysRgd85yRjQRLFJRLCYtVbINbwmVh5
	 UkYywAmqZp73S5M3bq8RZU1+bNfxwWWKVNr0TTYE3b9ZysbGJjh0LYx5A1p6VlizMp
	 JhtMXXhH0wk+i88f+jrd4UaiLFqTgDpYj6qvB4l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/957] mtd: spinand: Give the bus interface to the configuration helper
Date: Wed, 20 May 2026 18:16:04 +0200
Message-ID: <20260520162144.956968894@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 0a331a1851aedd670b95a2d16c6a82496137378d ]

The chip configuration hook is the one responsible to actually switch
the switch between bus interfaces. It is natural to give it the bus
interface we expect with a new parameter. For now the only value we can
give is SSDR, but this is subject to change in the future, so add a bit
of extra logic in the implementations of this callback to make sure
both the core and the chip driver are aligned on the request.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c    |  2 +-
 drivers/mtd/nand/spi/winbond.c | 28 +++++++++++++++++++++-------
 include/linux/mtd/spinand.h    |  6 ++++--
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 9f6682c0af102..2f656a5e4af89 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1499,7 +1499,7 @@ static int spinand_configure_chip(struct spinand_device *spinand)
 		return ret;
 
 	if (spinand->configure_chip) {
-		ret = spinand->configure_chip(spinand);
+		ret = spinand->configure_chip(spinand, SSDR);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index 6cb5dd45e6fb7..0ea5b1c97d33d 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -284,13 +284,17 @@ static int w25n02kv_ecc_get_status(struct spinand_device *spinand,
 	return -EINVAL;
 }
 
-static int w25n0xjw_hs_cfg(struct spinand_device *spinand)
+static int w25n0xjw_hs_cfg(struct spinand_device *spinand,
+			   enum spinand_bus_interface iface)
 {
 	const struct spi_mem_op *op;
 	bool hs;
 	u8 sr4;
 	int ret;
 
+	if (iface != SSDR)
+		return -EOPNOTSUPP;
+
 	op = spinand->op_templates->read_cache;
 	if (op->cmd.dtr || op->addr.dtr || op->dummy.dtr || op->data.dtr)
 		hs = false;
@@ -347,17 +351,25 @@ static int w35n0xjw_write_vcr(struct spinand_device *spinand, u8 reg, u8 val)
 	return 0;
 }
 
-static int w35n0xjw_vcr_cfg(struct spinand_device *spinand)
+static int w35n0xjw_vcr_cfg(struct spinand_device *spinand,
+			    enum spinand_bus_interface iface)
 {
-	const struct spi_mem_op *op;
+	const struct spi_mem_op *ref_op;
 	unsigned int dummy_cycles;
 	bool dtr, single;
 	u8 io_mode;
 	int ret;
 
-	op = spinand->op_templates->read_cache;
+	switch (iface) {
+	case SSDR:
+		ref_op = spinand->ssdr_op_templates.read_cache;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	};
 
-	dummy_cycles = ((op->dummy.nbytes * 8) / op->dummy.buswidth) / (op->dummy.dtr ? 2 : 1);
+	dummy_cycles = ((ref_op->dummy.nbytes * 8) / ref_op->dummy.buswidth) /
+		(ref_op->dummy.dtr ? 2 : 1);
 	switch (dummy_cycles) {
 	case 8:
 	case 12:
@@ -373,8 +385,10 @@ static int w35n0xjw_vcr_cfg(struct spinand_device *spinand)
 	if (ret)
 		return ret;
 
-	single = (op->cmd.buswidth == 1 && op->addr.buswidth == 1 && op->data.buswidth == 1);
-	dtr = (op->cmd.dtr && op->addr.dtr && op->data.dtr);
+	single = (ref_op->cmd.buswidth == 1 &&
+		  ref_op->addr.buswidth == 1 &&
+		  ref_op->data.buswidth == 1);
+	dtr = (ref_op->cmd.dtr && ref_op->addr.dtr && ref_op->data.dtr);
 	if (single && !dtr)
 		io_mode = W35N01JW_VCR_IO_MODE_SINGLE_SDR;
 	else if (!single && !dtr)
diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index c991c6c3bdedf..07e4d87019c64 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -532,7 +532,8 @@ struct spinand_info {
 	} op_variants;
 	int (*select_target)(struct spinand_device *spinand,
 			     unsigned int target);
-	int (*configure_chip)(struct spinand_device *spinand);
+	int (*configure_chip)(struct spinand_device *spinand,
+			      enum spinand_bus_interface iface);
 	int (*set_cont_read)(struct spinand_device *spinand,
 			     bool enable);
 	struct spinand_fact_otp fact_otp;
@@ -704,7 +705,8 @@ struct spinand_device {
 	const struct spinand_manufacturer *manufacturer;
 	void *priv;
 
-	int (*configure_chip)(struct spinand_device *spinand);
+	int (*configure_chip)(struct spinand_device *spinand,
+			      enum spinand_bus_interface iface);
 	bool cont_read_possible;
 	int (*set_cont_read)(struct spinand_device *spinand,
 			     bool enable);
-- 
2.53.0



