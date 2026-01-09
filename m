Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4683C2737EE;
	Fri,  9 Jan 2026 12:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961268; cv=none; b=boryfrtek9TpTyouYGQMuw0t+ccOZNW455/TrFm3QbsUP2zBacvh8k8ON24Wz/6cavT7Xk2JzPaI2OObBGL600/S2F+kqu8NtIZns3FpnFDp8C4H8mlHUjLmBHE5+Dpw8rf25R+C7ccNKdzDYstkVxWfsSfUFguFEwU0iUYjeo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961268; c=relaxed/simple;
	bh=A8xlIIkXfnKf1LxgqOujq1PkjpjBYASuDSsrgMOOA9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAwICIWeXHXrr+VNhrybObsHRnRVi0KFyFfcXlqwzhDWc1VEKy05stnp/zthVUM/FJQa7RCvJ+sPvHXweIsn/qrJxwrE4NWaqPRAh7S5U54TZz+Z1A2OJqSKBml793Qi2MZI2LnV4zIw/XnCchBJTs2rzj+QfEYtlmvBq3/q4YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0f2MGY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0f2MGY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9CAC4CEF1;
	Fri,  9 Jan 2026 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961267;
	bh=A8xlIIkXfnKf1LxgqOujq1PkjpjBYASuDSsrgMOOA9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0f2MGY3Z3bQhvECdGbPJPl188zvD3Tg5NBvsX3cP1/Yv4GNn2jyKBix9A5xBjcWv
	 Tq5bM8i2aNHHQZbZu/+6dy5BY/NDvQ8RbZoGflEWjqlDvFuBqgiZ5GIcBpqkkxNiBj
	 KQ6ARZALk+Jj//YZNwAWB1cpcxja6NrpT+6K95uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 693/737] media: verisilicon: Fix CPU stalls on G2 bus error
Date: Fri,  9 Jan 2026 12:43:52 +0100
Message-ID: <20260109112200.133768357@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 19c286b755072a22a063052f530a6b1fac8a1f63 ]

In some seek stress tests, we are getting IRQ from the G2 decoder where
the dec_bus_int and the dec_e bits are high, meaning the decoder is
still running despite the error.

Fix this by reworking the IRQ handler to only finish the job once we
have reached completion and move the software reset to when our software
watchdog triggers.

This way, we let the hardware continue on errors when it did not self
reset and in worse case scenario the hardware timeout will
automatically stop it. The actual error will be fixed in a follow up
patch.

Fixes: 3385c514ecc5a ("media: hantro: Convert imx8m_vpu_g2_irq to helper")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/hantro_g2.c          |   84 ++++++++++++----
 drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c |    2 
 drivers/media/platform/verisilicon/hantro_g2_regs.h     |   13 ++
 drivers/media/platform/verisilicon/hantro_g2_vp9_dec.c  |    2 
 drivers/media/platform/verisilicon/hantro_hw.h          |    1 
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c       |    2 
 6 files changed, 83 insertions(+), 21 deletions(-)

--- a/drivers/media/platform/verisilicon/hantro_g2.c
+++ b/drivers/media/platform/verisilicon/hantro_g2.c
@@ -5,43 +5,93 @@
  * Copyright (C) 2021 Collabora Ltd, Andrzej Pietrasiewicz <andrzej.p@collabora.com>
  */
 
+#include <linux/delay.h>
 #include "hantro_hw.h"
 #include "hantro_g2_regs.h"
 
 #define G2_ALIGN	16
 
-void hantro_g2_check_idle(struct hantro_dev *vpu)
+static bool hantro_g2_active(struct hantro_ctx *ctx)
 {
-	int i;
+	struct hantro_dev *vpu = ctx->dev;
+	u32 status;
+
+	status = vdpu_read(vpu, G2_REG_INTERRUPT);
+
+	return (status & G2_REG_INTERRUPT_DEC_E);
+}
 
-	for (i = 0; i < 3; i++) {
-		u32 status;
+/**
+ * hantro_g2_reset:
+ * @ctx: the hantro context
+ *
+ * Emulates a reset using Hantro abort function. Failing this procedure would
+ * results in programming a running IP which leads to CPU hang.
+ *
+ * Using a hard reset procedure instead is prefferred.
+ */
+void hantro_g2_reset(struct hantro_ctx *ctx)
+{
+	struct hantro_dev *vpu = ctx->dev;
+	u32 status;
 
-		/* Make sure the VPU is idle */
-		status = vdpu_read(vpu, G2_REG_INTERRUPT);
-		if (status & G2_REG_INTERRUPT_DEC_E) {
-			dev_warn(vpu->dev, "device still running, aborting");
-			status |= G2_REG_INTERRUPT_DEC_ABORT_E | G2_REG_INTERRUPT_DEC_IRQ_DIS;
-			vdpu_write(vpu, status, G2_REG_INTERRUPT);
-		}
+	status = vdpu_read(vpu, G2_REG_INTERRUPT);
+	if (status & G2_REG_INTERRUPT_DEC_E) {
+		dev_warn_ratelimited(vpu->dev, "device still running, aborting");
+		status |= G2_REG_INTERRUPT_DEC_ABORT_E | G2_REG_INTERRUPT_DEC_IRQ_DIS;
+		vdpu_write(vpu, status, G2_REG_INTERRUPT);
+
+		do {
+			mdelay(1);
+		} while (hantro_g2_active(ctx));
 	}
 }
 
 irqreturn_t hantro_g2_irq(int irq, void *dev_id)
 {
 	struct hantro_dev *vpu = dev_id;
-	enum vb2_buffer_state state;
 	u32 status;
 
 	status = vdpu_read(vpu, G2_REG_INTERRUPT);
-	state = (status & G2_REG_INTERRUPT_DEC_RDY_INT) ?
-		 VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
 
-	vdpu_write(vpu, 0, G2_REG_INTERRUPT);
-	vdpu_write(vpu, G2_REG_CONFIG_DEC_CLK_GATE_E, G2_REG_CONFIG);
+	if (!(status & G2_REG_INTERRUPT_DEC_IRQ))
+		return IRQ_NONE;
+
+	hantro_reg_write(vpu, &g2_dec_irq, 0);
+	hantro_reg_write(vpu, &g2_dec_int_stat, 0);
+	hantro_reg_write(vpu, &g2_clk_gate_e, 1);
+
+	if (status & G2_REG_INTERRUPT_DEC_RDY_INT) {
+		hantro_irq_done(vpu, VB2_BUF_STATE_DONE);
+		return IRQ_HANDLED;
+	}
+
+	if (status & G2_REG_INTERRUPT_DEC_ABORT_INT) {
+		/* disabled on abort, though lets be safe and handle it */
+		dev_warn_ratelimited(vpu->dev, "decode operation aborted.");
+		return IRQ_HANDLED;
+	}
+
+	if (status & G2_REG_INTERRUPT_DEC_LAST_SLICE_INT)
+		dev_warn_ratelimited(vpu->dev, "not all macroblocks were decoded.");
+
+	if (status & G2_REG_INTERRUPT_DEC_BUS_INT)
+		dev_warn_ratelimited(vpu->dev, "bus error detected.");
+
+	if (status & G2_REG_INTERRUPT_DEC_ERROR_INT)
+		dev_warn_ratelimited(vpu->dev, "decode error detected.");
 
-	hantro_irq_done(vpu, state);
+	if (status & G2_REG_INTERRUPT_DEC_TIMEOUT)
+		dev_warn_ratelimited(vpu->dev, "frame decode timed out.");
+
+	/**
+	 * If the decoding haven't stopped, let it continue. The hardware timeout
+	 * will trigger if it is trully stuck.
+	 */
+	if (status & G2_REG_INTERRUPT_DEC_E)
+		return IRQ_HANDLED;
 
+	hantro_irq_done(vpu, VB2_BUF_STATE_ERROR);
 	return IRQ_HANDLED;
 }
 
--- a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
@@ -578,8 +578,6 @@ int hantro_g2_hevc_dec_run(struct hantro
 	struct hantro_dev *vpu = ctx->dev;
 	int ret;
 
-	hantro_g2_check_idle(vpu);
-
 	/* Prepare HEVC decoder context. */
 	ret = hantro_hevc_dec_prepare_run(ctx);
 	if (ret)
--- a/drivers/media/platform/verisilicon/hantro_g2_regs.h
+++ b/drivers/media/platform/verisilicon/hantro_g2_regs.h
@@ -22,7 +22,14 @@
 #define G2_REG_VERSION			G2_SWREG(0)
 
 #define G2_REG_INTERRUPT		G2_SWREG(1)
+#define G2_REG_INTERRUPT_DEC_LAST_SLICE_INT	BIT(19)
+#define G2_REG_INTERRUPT_DEC_TIMEOUT	BIT(18)
+#define G2_REG_INTERRUPT_DEC_ERROR_INT	BIT(16)
+#define G2_REG_INTERRUPT_DEC_BUF_INT	BIT(14)
+#define G2_REG_INTERRUPT_DEC_BUS_INT	BIT(13)
 #define G2_REG_INTERRUPT_DEC_RDY_INT	BIT(12)
+#define G2_REG_INTERRUPT_DEC_ABORT_INT	BIT(11)
+#define G2_REG_INTERRUPT_DEC_IRQ	BIT(8)
 #define G2_REG_INTERRUPT_DEC_ABORT_E	BIT(5)
 #define G2_REG_INTERRUPT_DEC_IRQ_DIS	BIT(4)
 #define G2_REG_INTERRUPT_DEC_E		BIT(0)
@@ -35,6 +42,9 @@
 #define BUS_WIDTH_128			2
 #define BUS_WIDTH_256			3
 
+#define g2_dec_int_stat		G2_DEC_REG(1, 11, 0xf)
+#define g2_dec_irq		G2_DEC_REG(1, 8, 0x1)
+
 #define g2_strm_swap		G2_DEC_REG(2, 28, 0xf)
 #define g2_strm_swap_old	G2_DEC_REG(2, 27, 0x1f)
 #define g2_pic_swap		G2_DEC_REG(2, 22, 0x1f)
@@ -225,6 +235,9 @@
 #define vp9_filt_level_seg5	G2_DEC_REG(19,  8, 0x3f)
 #define vp9_quant_seg5		G2_DEC_REG(19,  0, 0xff)
 
+#define g2_timemout_override_e	G2_DEC_REG(45, 31, 0x1)
+#define g2_timemout_cycles	G2_DEC_REG(45, 0, 0x7fffffff)
+
 #define hevc_cur_poc_00		G2_DEC_REG(46, 24, 0xff)
 #define hevc_cur_poc_01		G2_DEC_REG(46, 16, 0xff)
 #define hevc_cur_poc_02		G2_DEC_REG(46, 8,  0xff)
--- a/drivers/media/platform/verisilicon/hantro_g2_vp9_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_vp9_dec.c
@@ -893,8 +893,6 @@ int hantro_g2_vp9_dec_run(struct hantro_
 	struct vb2_v4l2_buffer *dst;
 	int ret;
 
-	hantro_g2_check_idle(ctx->dev);
-
 	ret = start_prepare_run(ctx, &decode_params);
 	if (ret) {
 		hantro_end_prepare_run(ctx);
--- a/drivers/media/platform/verisilicon/hantro_hw.h
+++ b/drivers/media/platform/verisilicon/hantro_hw.h
@@ -541,6 +541,7 @@ void hantro_g2_vp9_dec_done(struct hantr
 int hantro_vp9_dec_init(struct hantro_ctx *ctx);
 void hantro_vp9_dec_exit(struct hantro_ctx *ctx);
 void hantro_g2_check_idle(struct hantro_dev *vpu);
+void hantro_g2_reset(struct hantro_ctx *ctx);
 irqreturn_t hantro_g2_irq(int irq, void *dev_id);
 
 #endif /* HANTRO_HW_H_ */
--- a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
@@ -312,11 +312,13 @@ static const struct hantro_codec_ops imx
 static const struct hantro_codec_ops imx8mq_vpu_g2_codec_ops[] = {
 	[HANTRO_MODE_HEVC_DEC] = {
 		.run = hantro_g2_hevc_dec_run,
+		.reset = hantro_g2_reset,
 		.init = hantro_hevc_dec_init,
 		.exit = hantro_hevc_dec_exit,
 	},
 	[HANTRO_MODE_VP9_DEC] = {
 		.run = hantro_g2_vp9_dec_run,
+		.reset = hantro_g2_reset,
 		.done = hantro_g2_vp9_dec_done,
 		.init = hantro_vp9_dec_init,
 		.exit = hantro_vp9_dec_exit,


