Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21563EBF35;
	Wed, 20 May 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298611; cv=none; b=MkfD2vg7jj1WigDKdxAQ7REJcvAjAPjpogorfEF9g+l1sKhOYi95gS7mS9hGc9flxw7AC3w+SzneOkSHb0SOw6+Kmr1jIsVZv6GfIq+ojk73EB+KLIHI85KRplAteOawRaEgrwISzQOecXjCd8z9Eb6MCYKbe23kVlxjvUnRm0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298611; c=relaxed/simple;
	bh=VVOifEw3Z2gKHCsj0QiPDAY/H95JAAy2Vq9pW9uGb0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBWiJqS+P++uBhyWvsSQmJV92LnSlenatm6oxX6aLkX+yTa75f1M38wSpB7mJ7rCUwbKUkoRouFov8k9wblxhX30888GO6pIMssTBQ74oM3APpndoAYLOhW+8q2tS9HWUzIbFni2UrpXQaD8/rmpVLAkA9emAKzbTFGbFeiVznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZjZ+pEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZjZ+pEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FDB1F000E9;
	Wed, 20 May 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298609;
	bh=uGihaR7Dqm++pR+5NDi/P+WLby0LLJ4yZoAttKRuJXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZjZ+pEqUQyEdjMBy+EAXjtjAophlR2utGpMkDS6V3/+vdBEeh81f+5vtlRErQkRv
	 vNg3J3EZAFbSn1XT8Lm0K0FmpJIYW0tN7DQjNYPQc6tODaJd5MWyhaXH2hfWQSQLS/
	 dP4NIXwGSyqf/hL2DR9qKaFXJkLF5CW6QqqpXbSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 475/957] mtd: spinand: Decouple write enable and write disable operations
Date: Wed, 20 May 2026 18:15:58 +0200
Message-ID: <20260520162144.827869173@linuxfoundation.org>
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

[ Upstream commit c0ba929cf7a960c796cc9946b3f79d8405e9b805 ]

In order to introduce templates for all operations and not only for page
helpers (in order to introduce octal DDR support), decouple the WR_EN
and WR_DIS operations into two separate macros.

Adapt the callers accordingly.

There is no functional change.

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c   |  2 +-
 drivers/mtd/nand/spi/esmt.c   |  2 +-
 drivers/mtd/nand/spi/micron.c |  2 +-
 include/linux/mtd/spinand.h   | 10 ++++++++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 33e6b76944ab8..d3029ce2fe9ae 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -362,7 +362,7 @@ static void spinand_ondie_ecc_save_status(struct nand_device *nand, u8 status)
 
 int spinand_write_enable_op(struct spinand_device *spinand)
 {
-	struct spi_mem_op op = SPINAND_WR_EN_DIS_1S_0_0_OP(true);
+	struct spi_mem_op op = SPINAND_WR_EN_1S_0_0_OP;
 
 	return spi_mem_exec_op(spinand->spimem, &op);
 }
diff --git a/drivers/mtd/nand/spi/esmt.c b/drivers/mtd/nand/spi/esmt.c
index 9a9325c0bc497..f880c3b15ceab 100644
--- a/drivers/mtd/nand/spi/esmt.c
+++ b/drivers/mtd/nand/spi/esmt.c
@@ -137,7 +137,7 @@ static int f50l1g41lb_user_otp_info(struct spinand_device *spinand, size_t len,
 static int f50l1g41lb_otp_lock(struct spinand_device *spinand, loff_t from,
 			       size_t len)
 {
-	struct spi_mem_op write_op = SPINAND_WR_EN_DIS_1S_0_0_OP(true);
+	struct spi_mem_op write_op = SPINAND_WR_EN_1S_0_0_OP;
 	struct spi_mem_op exec_op = SPINAND_PROG_EXEC_1S_1S_0_OP(0);
 	u8 status;
 	int ret;
diff --git a/drivers/mtd/nand/spi/micron.c b/drivers/mtd/nand/spi/micron.c
index a49d7cb6a96da..b8130e04e8e79 100644
--- a/drivers/mtd/nand/spi/micron.c
+++ b/drivers/mtd/nand/spi/micron.c
@@ -251,7 +251,7 @@ static int mt29f2g01abagd_user_otp_info(struct spinand_device *spinand,
 static int mt29f2g01abagd_otp_lock(struct spinand_device *spinand, loff_t from,
 				   size_t len)
 {
-	struct spi_mem_op write_op = SPINAND_WR_EN_DIS_1S_0_0_OP(true);
+	struct spi_mem_op write_op = SPINAND_WR_EN_1S_0_0_OP;
 	struct spi_mem_op exec_op = SPINAND_PROG_EXEC_1S_1S_0_OP(0);
 	u8 status;
 	int ret;
diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 1c741145e4971..c74c9ba0cd0a4 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -26,8 +26,14 @@
 		   SPI_MEM_OP_NO_DUMMY,					\
 		   SPI_MEM_OP_NO_DATA)
 
-#define SPINAND_WR_EN_DIS_1S_0_0_OP(enable)					\
-	SPI_MEM_OP(SPI_MEM_OP_CMD((enable) ? 0x06 : 0x04, 1),		\
+#define SPINAND_WR_EN_1S_0_0_OP						\
+	SPI_MEM_OP(SPI_MEM_OP_CMD(0x06, 1),				\
+		   SPI_MEM_OP_NO_ADDR,					\
+		   SPI_MEM_OP_NO_DUMMY,					\
+		   SPI_MEM_OP_NO_DATA)
+
+#define SPINAND_WR_DIS_1S_0_0_OP					\
+	SPI_MEM_OP(SPI_MEM_OP_CMD(0x04, 1),				\
 		   SPI_MEM_OP_NO_ADDR,					\
 		   SPI_MEM_OP_NO_DUMMY,					\
 		   SPI_MEM_OP_NO_DATA)
-- 
2.53.0



