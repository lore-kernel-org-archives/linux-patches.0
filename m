Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F6DF58
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75966C433D2;
	Mon, 15 May 2023 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169325;
	bh=3Y9fsrdc034hAnuKyLCr5IHhWsu8oO0DlVC+6etVIJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFSd0L78stWMficed/ngayKtAaZjM/+cmWWppEDdvjzmHLt6SPyOkr2FbWhIxPVip
	 gA5Me0jZfutII6tAfJZKz8KKTCB8aATHQF6n28wohAiSOqCGBh5BvpC/XL2ANWBbEL
	 AzQ7uCgu8h5TTtT24bf0Co7T6R36fAKJ7uhZFL74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 004/246] mtd: spi-nor: Add a RWW flag
Date: Mon, 15 May 2023 18:23:36 +0200
Message-Id: <20230515161722.744591143@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 4eddee70140b3ae183398b246a609756546c51f1 ]

Introduce a new (no SFDP) flag for the feature that we are about to
support: Read While Write. This means, if the chip has several banks and
supports RWW, once a page of data to write has been transferred into the
chip's internal SRAM, another read operation happening on a different
bank can be performed during the tPROG delay.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230328154105.448540-7-miquel.raynal@bootlin.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Stable-dep-of: 9fd0945fe6fa ("mtd: spi-nor: spansion: Enable JFFS2 write buffer for Infineon s28hx SEMPER flash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c    | 3 +++
 drivers/mtd/spi-nor/core.h    | 3 +++
 drivers/mtd/spi-nor/debugfs.c | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 71ea5b2e10140..f9c226ba644ea 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2470,6 +2470,9 @@ static void spi_nor_init_flags(struct spi_nor *nor)
 
 	if (flags & NO_CHIP_ERASE)
 		nor->flags |= SNOR_F_NO_OP_CHIP_ERASE;
+
+	if (flags & SPI_NOR_RWW)
+		nor->flags |= SNOR_F_RWW;
 }
 
 /**
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index e0cc42a4a0c84..ea128ab0ec0e0 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -130,6 +130,7 @@ enum spi_nor_option_flags {
 	SNOR_F_IO_MODE_EN_VOLATILE = BIT(11),
 	SNOR_F_SOFT_RESET	= BIT(12),
 	SNOR_F_SWP_IS_VOLATILE	= BIT(13),
+	SNOR_F_RWW		= BIT(14),
 };
 
 struct spi_nor_read_command {
@@ -459,6 +460,7 @@ struct spi_nor_fixups {
  *   NO_CHIP_ERASE:           chip does not support chip erase.
  *   SPI_NOR_NO_FR:           can't do fastread.
  *   SPI_NOR_QUAD_PP:         flash supports Quad Input Page Program.
+ *   SPI_NOR_RWW:             flash supports reads while write.
  *
  * @no_sfdp_flags:  flags that indicate support that can be discovered via SFDP.
  *                  Used when SFDP tables are not defined in the flash. These
@@ -509,6 +511,7 @@ struct flash_info {
 #define NO_CHIP_ERASE			BIT(7)
 #define SPI_NOR_NO_FR			BIT(8)
 #define SPI_NOR_QUAD_PP			BIT(9)
+#define SPI_NOR_RWW			BIT(10)
 
 	u8 no_sfdp_flags;
 #define SPI_NOR_SKIP_SFDP		BIT(0)
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index fc7ad203df128..7e30b94b49983 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -25,6 +25,7 @@ static const char *const snor_f_names[] = {
 	SNOR_F_NAME(IO_MODE_EN_VOLATILE),
 	SNOR_F_NAME(SOFT_RESET),
 	SNOR_F_NAME(SWP_IS_VOLATILE),
+	SNOR_F_NAME(RWW),
 };
 #undef SNOR_F_NAME
 
-- 
2.39.2



