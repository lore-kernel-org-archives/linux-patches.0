Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A4634D385;
	Thu, 30 Jul 2026 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422721; cv=none; b=O9hck+er1Sstmw4JgcurwcB+U8PdA9SkEJ+8R/cD6OuSrUdgvQF3g0VpAd0C4O5jJ4MhaC6BtnX8JbvXStlVYM3uEf57EstDMvcRP4WRsg3wqDq6BIGLRd1Q3Aeq4474XoFJdwy2vLWfRzS57f7fDJImrWR4vWTkd2et2w77YOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422721; c=relaxed/simple;
	bh=VQFMJ2MaADL4PxWUw74R150lTcBGvqZ5uNcNI1cz2VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0Y6bLMttyBybXif1bpHVT1UOeJ+1ba8YrgdO6lB5gw/AyTsMItsQNTiTRKzhseqZnK76tYhcESrzTScYV2DfmJMGwBgtR4fqAkWF4sbJlsk2xvTVd0xk65u3uWGq4kSgJMtFrkc2APf14IJs3v98H6JPROnvaej8AVYCRFsUOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fkw5IYFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fkw5IYFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79401F000E9;
	Thu, 30 Jul 2026 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422720;
	bh=jq9DIoZ6gj1xjru5AQ4OgEuvq4ZDrmfX8rIfM1o+pq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fkw5IYFRRDlFaYLZ2uoiXzAH5mclFMXBOVCOSVIhDLooP0ophZR2VE0NBTkyC+FF3
	 t/UfSgsBl6kVD/EfJI1DhmBpY/m38LoUz/tnaMNPXp5OFyWDp4D6LdAOt5Esbg2y0w
	 d36scGp2hY+r8d+JgpLkhLI7s/tlmPckiezZiJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.1 507/744] media: qcom: camss: Fix RDI streaming for CSID GEN2
Date: Thu, 30 Jul 2026 16:13:00 +0200
Message-ID: <20260730141455.056877510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 618765634cefbdddafa84f07f82e9dd05b86cb9c upstream.

Fix streaming from CSIDn RDI1 and RDI2 to VFEn RDI1 and RDI2. A pattern we
have replicated throughout CAMSS where we use the VC number to populate
both the VC fields and port fields of the CSID means that in practice only
VC = 0 on CSIDn:RDI0 to VFEn:RDI0 works.

Fix that for CSID gen2 by separating VC and port. Fix to VC zero as a
bugfix we will look to properly populate the VC field with follow on
patches later.

Fixes: 729fc005c8e2 ("media: qcom: camss: Split testgen, RDI and RX for CSID 170")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-gen2.c |   47 ++++++++++----------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-gen2.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-gen2.c
@@ -203,10 +203,10 @@ static void __csid_ctrl_rdi(struct csid_
 	writel_relaxed(val, csid->base + CSID_RDI_CTRL(rdi));
 }
 
-static void __csid_configure_testgen(struct csid_device *csid, u8 enable, u8 vc)
+static void __csid_configure_testgen(struct csid_device *csid, u8 enable, u8 port, u8 vc)
 {
 	struct csid_testgen_config *tg = &csid->testgen;
-	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + vc];
+	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + port];
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
@@ -253,10 +253,10 @@ static void __csid_configure_testgen(str
 	writel_relaxed(val, csid->base + CSID_TPG_CTRL);
 }
 
-static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 vc)
+static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 port, u8 vc)
 {
 	/* Source pads matching RDI channels on hardware. Pad 1 -> RDI0, Pad 2 -> RDI1, etc. */
-	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + vc];
+	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + port];
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
@@ -267,14 +267,14 @@ static void __csid_configure_rdi_stream(
 	 * the four least significant bits of the five bit VC
 	 * bitfield to generate an internal CID value.
 	 *
-	 * CSID_RDI_CFG0(vc)
+	 * CSID_RDI_CFG0(port)
 	 * DT_ID : 28:27
 	 * VC    : 26:22
 	 * DT    : 21:16
 	 *
 	 * CID   : VC 3:0 << 2 | DT_ID 1:0
 	 */
-	u8 dt_id = vc & 0x03;
+	u8 dt_id = port & 0x03;
 
 	val = 1 << RDI_CFG0_BYTE_CNTR_EN;
 	val |= 1 << RDI_CFG0_FORMAT_MEASURE_EN;
@@ -284,56 +284,57 @@ static void __csid_configure_rdi_stream(
 	val |= format->data_type << RDI_CFG0_DATA_TYPE;
 	val |= vc << RDI_CFG0_VIRTUAL_CHANNEL;
 	val |= dt_id << RDI_CFG0_DT_ID;
-	writel_relaxed(val, csid->base + CSID_RDI_CFG0(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_CFG0(port));
 
 	/* CSID_TIMESTAMP_STB_POST_IRQ */
 	val = 2 << RDI_CFG1_TIMESTAMP_STB_SEL;
-	writel_relaxed(val, csid->base + CSID_RDI_CFG1(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_CFG1(port));
 
 	val = 1;
-	writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PERIOD(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PERIOD(port));
 
 	val = 0;
-	writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PATTERN(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PATTERN(port));
 
 	val = 1;
-	writel_relaxed(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(port));
 
 	val = 0;
-	writel_relaxed(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(port));
 
 	val = 1;
-	writel_relaxed(val, csid->base + CSID_RDI_RPP_PIX_DROP_PERIOD(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_RPP_PIX_DROP_PERIOD(port));
 
 	val = 0;
-	writel_relaxed(val, csid->base + CSID_RDI_RPP_PIX_DROP_PATTERN(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_RPP_PIX_DROP_PATTERN(port));
 
 	val = 1;
-	writel_relaxed(val, csid->base + CSID_RDI_RPP_LINE_DROP_PERIOD(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_RPP_LINE_DROP_PERIOD(port));
 
 	val = 0;
-	writel_relaxed(val, csid->base + CSID_RDI_RPP_LINE_DROP_PATTERN(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_RPP_LINE_DROP_PATTERN(port));
 
 	val = 0;
-	writel_relaxed(val, csid->base + CSID_RDI_CTRL(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_CTRL(port));
 
-	val = readl_relaxed(csid->base + CSID_RDI_CFG0(vc));
+	val = readl_relaxed(csid->base + CSID_RDI_CFG0(port));
 	val |=  enable << RDI_CFG0_ENABLE;
-	writel_relaxed(val, csid->base + CSID_RDI_CFG0(vc));
+	writel_relaxed(val, csid->base + CSID_RDI_CFG0(port));
 }
 
 static void csid_configure_stream(struct csid_device *csid, u8 enable)
 {
 	struct csid_testgen_config *tg = &csid->testgen;
 	u8 i;
-	/* Loop through all enabled VCs and configure stream for each */
+
+	/* Loop through all enabled ports and configure a stream for each */
 	for (i = 0; i < MSM_CSID_MAX_SRC_STREAMS; i++)
 		if (csid->phy.en_vc & BIT(i)) {
 			if (tg->enabled)
-				__csid_configure_testgen(csid, enable, i);
+				__csid_configure_testgen(csid, enable, i, 0);
 
-			__csid_configure_rdi_stream(csid, enable, i);
-			__csid_configure_rx(csid, &csid->phy, i);
+			__csid_configure_rdi_stream(csid, enable, i, 0);
+			__csid_configure_rx(csid, &csid->phy, 0);
 			__csid_ctrl_rdi(csid, enable, i);
 		}
 }


