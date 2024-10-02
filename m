Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3451D049D;
	Wed,  2 Oct 2024 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880501; cv=none; b=N1wM8wOzY13sznIu5+aZ1upfItb1utq3+cSocb62rs5a92dvKeNvx+RRlUe1tjrZBizUCDeuZk+7CDF/nfOAD9EryFVGf2N3Bs9RzKZ0nwETWRjn+tk/gxvIs+oU+A4cDTmgYeeerE1rMOORNgsVqlV/pe9IFKNuKmHv5TxnBWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880501; c=relaxed/simple;
	bh=NzX7W0OqNs94/OgCVPcZQbqp32MzjOf9SK8M1gIVURo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0OnqLM+YTGUSUQ/d96BWlRB3a6GrabyemI81yqrG5Y964u3A6qL18SkozHo0HSK4jdAjqNu0Z7qw9dzAwB5u8C0WyXIrH3eX43E6B+DvlrIuRjVfswHehSG9jykf6HoFjAWzIZrZE5DnvqZ0+a+afrB+nIpWjA2EkPMgVNL4XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUq/K/Rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUq/K/Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D5C4CEC2;
	Wed,  2 Oct 2024 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880501;
	bh=NzX7W0OqNs94/OgCVPcZQbqp32MzjOf9SK8M1gIVURo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUq/K/RldwgMoTzUkP49OmKz/tr517OnSZveyDqEQJhjE5yaoafTye9JJpXifE5Ti
	 Wb1SwbSzW8MKb87E8wqzTxLKz9VJj62HExGVanr5T4QiPMtU/SftT9HnDr/4rSIxqa
	 k6AVqQ84B4LxeXYb4gEMjy6RArkUO/bB7D9ehhQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 481/538] spi: fspi: involve lut_num for struct nxp_fspi_devtype_data
Date: Wed,  2 Oct 2024 15:02:00 +0200
Message-ID: <20241002125811.430602665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

commit 190b7e2efb1ed8435fc7431d9c7a2447d05d5066 upstream.

The flexspi on different SoCs may have different number of LUTs.
So involve lut_num in nxp_fspi_devtype_data to make distinguish.
This patch prepare for the adding of imx8ulp.

Fixes: ef89fd56bdfc ("arm64: dts: imx8ulp: add flexspi node")
Cc: stable@kernel.org
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240905094338.1986871-3-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-nxp-fspi.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -57,13 +57,6 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-mem.h>
 
-/*
- * The driver only uses one single LUT entry, that is updated on
- * each call of exec_op(). Index 0 is preset at boot with a basic
- * read operation, so let's use the last entry (31).
- */
-#define	SEQID_LUT			31
-
 /* Registers used by the driver */
 #define FSPI_MCR0			0x00
 #define FSPI_MCR0_AHB_TIMEOUT(x)	((x) << 24)
@@ -263,9 +256,6 @@
 #define FSPI_TFDR			0x180
 
 #define FSPI_LUT_BASE			0x200
-#define FSPI_LUT_OFFSET			(SEQID_LUT * 4 * 4)
-#define FSPI_LUT_REG(idx) \
-	(FSPI_LUT_BASE + FSPI_LUT_OFFSET + (idx) * 4)
 
 /* register map end */
 
@@ -341,6 +331,7 @@ struct nxp_fspi_devtype_data {
 	unsigned int txfifo;
 	unsigned int ahb_buf_size;
 	unsigned int quirks;
+	unsigned int lut_num;
 	bool little_endian;
 };
 
@@ -349,6 +340,7 @@ static struct nxp_fspi_devtype_data lx21
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
 	.quirks = 0,
+	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
 
@@ -357,6 +349,7 @@ static struct nxp_fspi_devtype_data imx8
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
 	.quirks = 0,
+	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
 
@@ -365,6 +358,7 @@ static struct nxp_fspi_devtype_data imx8
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
 	.quirks = 0,
+	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
 
@@ -373,6 +367,7 @@ static struct nxp_fspi_devtype_data imx8
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
 	.quirks = FSPI_QUIRK_USE_IP_ONLY,
+	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
 
@@ -544,6 +539,8 @@ static void nxp_fspi_prepare_lut(struct
 	void __iomem *base = f->iobase;
 	u32 lutval[4] = {};
 	int lutidx = 1, i;
+	u32 lut_offset = (f->devtype_data->lut_num - 1) * 4 * 4;
+	u32 target_lut_reg;
 
 	/* cmd */
 	lutval[0] |= LUT_DEF(0, LUT_CMD, LUT_PAD(op->cmd.buswidth),
@@ -588,8 +585,10 @@ static void nxp_fspi_prepare_lut(struct
 	fspi_writel(f, FSPI_LCKER_UNLOCK, f->iobase + FSPI_LCKCR);
 
 	/* fill LUT */
-	for (i = 0; i < ARRAY_SIZE(lutval); i++)
-		fspi_writel(f, lutval[i], base + FSPI_LUT_REG(i));
+	for (i = 0; i < ARRAY_SIZE(lutval); i++) {
+		target_lut_reg = FSPI_LUT_BASE + lut_offset + i * 4;
+		fspi_writel(f, lutval[i], base + target_lut_reg);
+	}
 
 	dev_dbg(f->dev, "CMD[%x] lutval[0:%x \t 1:%x \t 2:%x \t 3:%x], size: 0x%08x\n",
 		op->cmd.opcode, lutval[0], lutval[1], lutval[2], lutval[3], op->data.nbytes);
@@ -876,7 +875,7 @@ static int nxp_fspi_do_op(struct nxp_fsp
 	void __iomem *base = f->iobase;
 	int seqnum = 0;
 	int err = 0;
-	u32 reg;
+	u32 reg, seqid_lut;
 
 	reg = fspi_readl(f, base + FSPI_IPRXFCR);
 	/* invalid RXFIFO first */
@@ -892,8 +891,9 @@ static int nxp_fspi_do_op(struct nxp_fsp
 	 * the LUT at each exec_op() call. And also specify the DATA
 	 * length, since it's has not been specified in the LUT.
 	 */
+	seqid_lut = f->devtype_data->lut_num - 1;
 	fspi_writel(f, op->data.nbytes |
-		 (SEQID_LUT << FSPI_IPCR1_SEQID_SHIFT) |
+		 (seqid_lut << FSPI_IPCR1_SEQID_SHIFT) |
 		 (seqnum << FSPI_IPCR1_SEQNUM_SHIFT),
 		 base + FSPI_IPCR1);
 
@@ -1017,7 +1017,7 @@ static int nxp_fspi_default_setup(struct
 {
 	void __iomem *base = f->iobase;
 	int ret, i;
-	u32 reg;
+	u32 reg, seqid_lut;
 
 	/* disable and unprepare clock to avoid glitch pass to controller */
 	nxp_fspi_clk_disable_unprep(f);
@@ -1092,11 +1092,17 @@ static int nxp_fspi_default_setup(struct
 	fspi_writel(f, reg, base + FSPI_FLSHB1CR1);
 	fspi_writel(f, reg, base + FSPI_FLSHB2CR1);
 
+	/*
+	 * The driver only uses one single LUT entry, that is updated on
+	 * each call of exec_op(). Index 0 is preset at boot with a basic
+	 * read operation, so let's use the last entry.
+	 */
+	seqid_lut = f->devtype_data->lut_num - 1;
 	/* AHB Read - Set lut sequence ID for all CS. */
-	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHA1CR2);
-	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHA2CR2);
-	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHB1CR2);
-	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHB2CR2);
+	fspi_writel(f, seqid_lut, base + FSPI_FLSHA1CR2);
+	fspi_writel(f, seqid_lut, base + FSPI_FLSHA2CR2);
+	fspi_writel(f, seqid_lut, base + FSPI_FLSHB1CR2);
+	fspi_writel(f, seqid_lut, base + FSPI_FLSHB2CR2);
 
 	f->selected = -1;
 


