Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CAAFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4D2C433EF;
	Mon, 15 May 2023 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170054;
	bh=MUMro1ON8i1GRPAlfObErMXpHnnUZ2lJ85KxPh8j/AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JouLIrhqj8WMCbXUbOqo3JL5s0zJIqNqbUNovNyE01ntaoD4wXUBAJu0+6+ng42wB
	 VC/e299C3ZZ3+PttV5s4k6IU+UXXRdJc5ufxXPILo6F5DTIQTT0BbnR0P5a/Ng7uHc
	 ZOMo5Pi3zx+jAS6UtR72prEQanrXANUXAJZea0zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudip Mukherjee <sudip.mukherjee@sifive.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/239] mtd: spi-nor: add SFDP fixups for Quad Page Program
Date: Mon, 15 May 2023 18:24:33 +0200
Message-Id: <20230515161721.900376188@linuxfoundation.org>
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

From: Sudip Mukherjee <sudip.mukherjee@sifive.com>

[ Upstream commit 1799cd8540b67b88514c82f5fae1c75b986bcbd8 ]

SFDP table of some flash chips do not advertise support of Quad Input
Page Program even though it has support. Use flags and add hardware
cap for these chips.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@sifive.com>
[tudor.ambarus@microchip.com: move pp setting in spi_nor_init_default_params]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20220920184808.44876-2-sudip.mukherjee@sifive.com
Stable-dep-of: 9fd0945fe6fa ("mtd: spi-nor: spansion: Enable JFFS2 write buffer for Infineon s28hx SEMPER flash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 6 ++++++
 drivers/mtd/spi-nor/core.h | 2 ++
 drivers/mtd/spi-nor/issi.c | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 9a7bea365acb7..88da4a125c743 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2578,6 +2578,12 @@ static void spi_nor_init_default_params(struct spi_nor *nor)
 	params->hwcaps.mask |= SNOR_HWCAPS_PP;
 	spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP],
 				SPINOR_OP_PP, SNOR_PROTO_1_1_1);
+
+	if (info->flags & SPI_NOR_QUAD_PP) {
+		params->hwcaps.mask |= SNOR_HWCAPS_PP_1_1_4;
+		spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP_1_1_4],
+					SPINOR_OP_PP_1_1_4, SNOR_PROTO_1_1_4);
+	}
 }
 
 /**
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 00bf0d0e955a0..8a846ad86d298 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -458,6 +458,7 @@ struct spi_nor_fixups {
  *   SPI_NOR_NO_ERASE:        no erase command needed.
  *   NO_CHIP_ERASE:           chip does not support chip erase.
  *   SPI_NOR_NO_FR:           can't do fastread.
+ *   SPI_NOR_QUAD_PP:         flash supports Quad Input Page Program.
  *
  * @no_sfdp_flags:  flags that indicate support that can be discovered via SFDP.
  *                  Used when SFDP tables are not defined in the flash. These
@@ -507,6 +508,7 @@ struct flash_info {
 #define SPI_NOR_NO_ERASE		BIT(6)
 #define NO_CHIP_ERASE			BIT(7)
 #define SPI_NOR_NO_FR			BIT(8)
+#define SPI_NOR_QUAD_PP			BIT(9)
 
 	u8 no_sfdp_flags;
 #define SPI_NOR_SKIP_SFDP		BIT(0)
diff --git a/drivers/mtd/spi-nor/issi.c b/drivers/mtd/spi-nor/issi.c
index 89a66a19d754f..7c8eee808dda6 100644
--- a/drivers/mtd/spi-nor/issi.c
+++ b/drivers/mtd/spi-nor/issi.c
@@ -73,6 +73,7 @@ static const struct flash_info issi_nor_parts[] = {
 	{ "is25wp256", INFO(0x9d7019, 0, 64 * 1024, 512)
 		NO_SFDP_FLAGS(SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ)
 		FIXUP_FLAGS(SPI_NOR_4B_OPCODES)
+		FLAGS(SPI_NOR_QUAD_PP)
 		.fixups = &is25lp256_fixups },
 
 	/* PMC */
-- 
2.39.2



