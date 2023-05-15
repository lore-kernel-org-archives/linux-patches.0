Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F50D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981D3C433D2;
	Mon, 15 May 2023 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170057;
	bh=kltuW1aT/nc6YOfj7X4MjHR1svWrsydIFor7E6q6lyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEwneCItm+eBlAn4L0eRxPMXrQu0Lr9I2+77dO6mlzQGoOJ8clUA3n+7VMeY7Wt1t
	 OqbnHqQTmqr3D3MjQ+IXbXQKYx2HD5Je5/KFqmboVW/J0K8sQ7AnCADrJGgWxE7+mm
	 btFWMlRV3sNkfK+5Z5aFS4czJCm4dgIbzmpfxUIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/239] mtd: spi-nor: Add a RWW flag
Date: Mon, 15 May 2023 18:24:34 +0200
Message-Id: <20230515161721.929383534@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
index 88da4a125c743..621e9ad4bcc39 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2440,6 +2440,9 @@ static void spi_nor_init_flags(struct spi_nor *nor)
 
 	if (flags & NO_CHIP_ERASE)
 		nor->flags |= SNOR_F_NO_OP_CHIP_ERASE;
+
+	if (flags & SPI_NOR_RWW)
+		nor->flags |= SNOR_F_RWW;
 }
 
 /**
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 8a846ad86d298..f23d1e77199e5 100644
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
index 5f56b23205d8b..8b4922a1aafb9 100644
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



