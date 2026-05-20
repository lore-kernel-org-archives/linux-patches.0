Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015083EF0D7;
	Wed, 20 May 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296755; cv=none; b=oq30NPHbt73DtgVJn8FiozIn4oFlhCGSCfWQ8G5YOsQYLpLYW1fE7PbAZhVziLpmlQasyc0CniruuPx0u9pmEVm46kc+OyMM2eGDJUmVCYP7/eXEHriTDhbILpgAFs9xCOxyv5s0LxxNbmJYjHMcedNwsxmgYdmp8hPKAnHj/tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296755; c=relaxed/simple;
	bh=OcnQVvU1VO97j1GJrWI4GVw33aB0M/RlKqiMErGyWPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXetEbmXBmOejCTtISv4X/l4jF9F+oWGOGpLn/SY/gf6KsugUz49kJr+349xYj+wX+AOxKhPm6aw/fXWXXnTQPLp9LvXfzC/gwM6GzPxtkHoMzkviTWN7lmnltSv0y+i2/TuxgpcmIHDZPvrn/b/oxdfGHKz/jXQe5f6v8bZX4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqmJFXMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqmJFXMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666651F000E9;
	Wed, 20 May 2026 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296753;
	bh=QTrkxB0d9Mdk3MOyXFHshrDaCE5Y733or0XEidar04Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqmJFXMA/aod2TNXh9qkoU0x38+O4/lBlko0E7B5LfrCjMKEaQdOphQPabZgtMrk/
	 dr1eY82YYh1KLCsoiz+UijvYZIN7YRHAJlJpXmWaV+oGrshGEmzD2wxAgnQ7FahtbM
	 PH7C6JJllxixq6hFv8UymavUNCmnj4qrgFywz/K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0920/1146] mtd: spinand: Add support for packed read data ODTR commands
Date: Wed, 20 May 2026 18:19:30 +0200
Message-ID: <20260520162209.061376483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 5e25407b68f460142539536e31fa20338db6146f ]

Some devices stuff address bits in the double byte opcode (in place of
the repeated byte) in order to be able to increase the size of the
devices, without adding extra address bytes.

Create a flag to identify those devices. When the flag is set, use the
"packed" variant for the read data operation.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 8d655748aba1 ("mtd: spinand: winbond: Set the packed page read flag to W35N02/04JW")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 24 +++++++++++++++++++++---
 include/linux/mtd/spinand.h |  7 +++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 8aa3753aaaa1d..0b076790bd9df 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -100,6 +100,17 @@ spinand_fill_page_read_op(struct spinand_device *spinand, u64 addr)
 	return op;
 }
 
+static struct spi_mem_op
+spinand_fill_page_read_packed_op(struct spinand_device *spinand, u64 addr)
+{
+	struct spi_mem_op op = spinand->op_templates->page_read;
+
+	op.cmd.opcode |= addr >> 16;
+	op.addr.val = addr & 0xFFFF;
+
+	return op;
+}
+
 struct spi_mem_op
 spinand_fill_prog_exec_op(struct spinand_device *spinand, u64 addr)
 {
@@ -453,7 +464,10 @@ static int spinand_load_page_op(struct spinand_device *spinand,
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
 	unsigned int row = nanddev_pos_to_row(nand, &req->pos);
-	struct spi_mem_op op = SPINAND_OP(spinand, page_read, row);
+	bool packed = spinand->flags & SPINAND_ODTR_PACKED_PAGE_READ;
+	struct spi_mem_op op = packed ?
+		SPINAND_OP(spinand, page_read_packed, row) :
+		SPINAND_OP(spinand, page_read, row);
 
 	return spi_mem_exec_op(spinand->spimem, &op);
 }
@@ -1489,9 +1503,13 @@ static int spinand_init_odtr_instruction_set(struct spinand_device *spinand)
 	if (!spi_mem_supports_op(spinand->spimem, &tmpl->blk_erase))
 		return -EOPNOTSUPP;
 
-	tmpl->page_read = (struct spi_mem_op)SPINAND_PAGE_READ_8D_8D_0_OP(0);
-	if (!spi_mem_supports_op(spinand->spimem, &tmpl->page_read))
+	if (spinand->flags & SPINAND_ODTR_PACKED_PAGE_READ)
+		tmpl->page_read = (struct spi_mem_op)SPINAND_PAGE_READ_PACKED_8D_8D_0_OP(0);
+	else
+		tmpl->page_read = (struct spi_mem_op)SPINAND_PAGE_READ_8D_8D_0_OP(0);
+	if (!spi_mem_supports_op(spinand->spimem, &tmpl->page_read)) {
 		return -EOPNOTSUPP;
+	}
 
 	tmpl->prog_exec = (struct spi_mem_op)SPINAND_PROG_EXEC_8D_8D_0_OP(0);
 	if (!spi_mem_supports_op(spinand->spimem, &tmpl->prog_exec))
diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 6a024cf1c53ac..f2f80103649d5 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -290,6 +290,12 @@
 		   SPI_MEM_OP_NO_DUMMY,					\
 		   SPI_MEM_OP_NO_DATA)
 
+#define SPINAND_PAGE_READ_PACKED_8D_8D_0_OP(addr)			\
+	SPI_MEM_OP(SPI_MEM_DTR_OP_PACKED_CMD(0x13, addr >> 16, 8),	\
+		   SPI_MEM_DTR_OP_ADDR(2, addr & 0xffff, 8),		\
+		   SPI_MEM_OP_NO_DUMMY,					\
+		   SPI_MEM_OP_NO_DATA)
+
 #define SPINAND_PAGE_READ_FROM_CACHE_8D_8D_8D_OP(addr, ndummy, buf, len, freq) \
 	SPI_MEM_OP(SPI_MEM_DTR_OP_RPT_CMD(0x9d, 8),			\
 		   SPI_MEM_DTR_OP_ADDR(2, addr, 8),			\
@@ -482,6 +488,7 @@ struct spinand_ecc_info {
 #define SPINAND_HAS_PROG_PLANE_SELECT_BIT		BIT(2)
 #define SPINAND_HAS_READ_PLANE_SELECT_BIT		BIT(3)
 #define SPINAND_NO_RAW_ACCESS				BIT(4)
+#define SPINAND_ODTR_PACKED_PAGE_READ			BIT(5)
 
 /**
  * struct spinand_ondie_ecc_conf - private SPI-NAND on-die ECC engine structure
-- 
2.53.0



