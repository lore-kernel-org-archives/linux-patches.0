Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016D374A0E;
	Thu, 30 Jul 2026 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424516; cv=none; b=cLUH0CUx7j8vpyGwEYWW+tDGFL0yCRtac96Gn/NOka8ir0H54ZJMClphpC6z6M/4vKAhq7hvqDfKzQfzmrz0viBcs0mNEbS1PS4jHQQnb0ehXq99F2kMeUt+mEiTqN/JdqoH2L9Ws6CHCVWgz7tFwznge9BlzGns795s7sN3xw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424516; c=relaxed/simple;
	bh=GAktAmhNgGRcnjt/zAGQyYkS6w6kWZ6syEqlOG6xcaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQlvOXKQs7qgX8+7E7dMLkhnD+nqkQfhxtTHEMoSRjo/a9Cz3de9yXWFyXMybN6RDAdTmYB+1AZ3AojbJPIQLUl79ScL/hoE/S+sFEI/9gagifXZULwK4y1Z/nNpiH03SOrDj+DSq0ng/2BvqjQRL+j66q4+s/0RvVHSuGKLtcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxIahthq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxIahthq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12041F000E9;
	Thu, 30 Jul 2026 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424515;
	bh=aW8tA1/TiR/GH8rR0lwQnmX/2XCXrzCxmDAvgPs8ifs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxIahthq8s3SWiwbmOZ6aL8xFYf+qUY6YcymON5mzV3EO27IhT0UKAiUqkAP5JmWT
	 vfTkdkxlT1JutZ6DJyTovKTB4ETA4jvuL06Djt+kxPSfHsbgYVZWxfRn9DVk3QK+pk
	 qDQYnIQNbK23PrJAcdOEJWSKu7yXYhOFchEm1oR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 422/675] media: qcom: camss: Fix RDI streaming for CSID GEN2
Date: Thu, 30 Jul 2026 16:12:32 +0200
Message-ID: <20260730141454.103144875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


