Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA5F1F4192;
	Wed, 17 Sep 2025 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112973; cv=none; b=gDNdZHSUKtV9v9078ViYOm8DudpreSt8Wgv4iuBHi/Pv66jWe7JIXwpD7C2GGgnPxMXJJFylHBBRhnrQZpwQimfy4zj8u7qfgD8reVlcXHpZL/eJ012gtyb+EUX2lz7oMTQl9iKODmRjrmxYPynd59vldnvKXIFvzPUhSoUsvbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112973; c=relaxed/simple;
	bh=nk/e64xq/KVqMjTHl8Fgte/8w9J9JdFTy0T5XZ0pzr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmUeYBCsGoKpCVNjtiy8iNi3489i3OaGRj/FEtzVkl8ojO2tWZ5/7UP3pGsMj/8TMR016MV63a0FhTr/ztDUj1w6LqAyLKiSem434NW5v4oEd3ZKF8Ik13NrMaJ0X+T1z+WYaqLpPsj3VDG9z11W/dYJYudcYmsMhg2ucRpDqmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGDpsLB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGDpsLB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2083C4CEF0;
	Wed, 17 Sep 2025 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112973;
	bh=nk/e64xq/KVqMjTHl8Fgte/8w9J9JdFTy0T5XZ0pzr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGDpsLB68tOA5RqDzBvAccX0toA8ogE74FIaAMfSbR9cvBuZFPFtydfcPYHB0czl8
	 Oa0hTE5IOJU9gZiM3qscPpFvAgPpLRVqzyUgjQDuF0YHcS8OmgPAZEsjVxj1nMFK2/
	 q3K4U33Q2LkinRVEpYqTNzYRT5XmjeI7ZKrjJ2Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 105/189] mtd: spinand: Add a ->configure_chip() hook
Date: Wed, 17 Sep 2025 14:33:35 +0200
Message-ID: <20250917123354.429037608@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit da55809ebb45d1d80b7a388ffef841ed683e1a6f ]

There is already a manufacturer hook, which is manufacturer specific but
not chip specific. We no longer have access to the actual NAND identity
at this stage so let's add a per-chip configuration hook to align the
chip configuration (if any) with the core's setting.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 4550d33e1811 ("mtd: spinand: winbond: Fix oob_layout for W25N01JW")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   16 ++++++++++++++--
 include/linux/mtd/spinand.h |    7 +++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1253,8 +1253,19 @@ static int spinand_id_detect(struct spin
 
 static int spinand_manufacturer_init(struct spinand_device *spinand)
 {
-	if (spinand->manufacturer->ops->init)
-		return spinand->manufacturer->ops->init(spinand);
+	int ret;
+
+	if (spinand->manufacturer->ops->init) {
+		ret = spinand->manufacturer->ops->init(spinand);
+		if (ret)
+			return ret;
+	}
+
+	if (spinand->configure_chip) {
+		ret = spinand->configure_chip(spinand);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -1349,6 +1360,7 @@ int spinand_match_and_init(struct spinan
 		spinand->flags = table[i].flags;
 		spinand->id.len = 1 + table[i].devid.len;
 		spinand->select_target = table[i].select_target;
+		spinand->configure_chip = table[i].configure_chip;
 		spinand->set_cont_read = table[i].set_cont_read;
 		spinand->fact_otp = &table[i].fact_otp;
 		spinand->user_otp = &table[i].user_otp;
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -484,6 +484,7 @@ struct spinand_user_otp {
  * @op_variants.update_cache: variants of the update-cache operation
  * @select_target: function used to select a target/die. Required only for
  *		   multi-die chips
+ * @configure_chip: Align the chip configuration with the core settings
  * @set_cont_read: enable/disable continuous cached reads
  * @fact_otp: SPI NAND factory OTP info.
  * @user_otp: SPI NAND user OTP info.
@@ -507,6 +508,7 @@ struct spinand_info {
 	} op_variants;
 	int (*select_target)(struct spinand_device *spinand,
 			     unsigned int target);
+	int (*configure_chip)(struct spinand_device *spinand);
 	int (*set_cont_read)(struct spinand_device *spinand,
 			     bool enable);
 	struct spinand_fact_otp fact_otp;
@@ -539,6 +541,9 @@ struct spinand_info {
 #define SPINAND_SELECT_TARGET(__func)					\
 	.select_target = __func
 
+#define SPINAND_CONFIGURE_CHIP(__configure_chip)			\
+	.configure_chip = __configure_chip
+
 #define SPINAND_CONT_READ(__set_cont_read)				\
 	.set_cont_read = __set_cont_read
 
@@ -607,6 +612,7 @@ struct spinand_dirmap {
  *		passed in spi_mem_op be DMA-able, so we can't based the bufs on
  *		the stack
  * @manufacturer: SPI NAND manufacturer information
+ * @configure_chip: Align the chip configuration with the core settings
  * @cont_read_possible: Field filled by the core once the whole system
  *		configuration is known to tell whether continuous reads are
  *		suitable to use or not in general with this chip/configuration.
@@ -647,6 +653,7 @@ struct spinand_device {
 	const struct spinand_manufacturer *manufacturer;
 	void *priv;
 
+	int (*configure_chip)(struct spinand_device *spinand);
 	bool cont_read_possible;
 	int (*set_cont_read)(struct spinand_device *spinand,
 			     bool enable);


