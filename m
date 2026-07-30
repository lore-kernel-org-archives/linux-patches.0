Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EA243E094;
	Thu, 30 Jul 2026 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424514; cv=none; b=Dks0eQtYXZviumLY60BQQY+H6yVcbRZJAsFkA0GgsylQlKQK4Am6SToix1OZ0V/bCBaNce9ucvjEbmopViE/Ui2nDpuw6h+NMwAndz8nGIBFXfAXltuvIA1CcEAlHvgayl09qUfKjDgr2NaCdcUk1q8Lp68zMAChwFnCbG++bfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424514; c=relaxed/simple;
	bh=sjwaBdtHFMPDmsS8jhd+by0lZNfyE5r3lc48cLQHPB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqFYjiAUVGarC6GFK/sccQE1kFMmWE8/CddToXlCnBZ5p1ADWPljAFXTLXZKeXqByKbqMPlWfiHU0QXRrsyWAXwWbRXfWCfgUToDR1FFO0Wxv1eHMjlyyIFYJ7MpsBTvLh/I7uYSv2HA+AYRlWzTzkxqZBZhBKp1V8bzHWh/12c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJWoU96s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJWoU96s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2B41F000E9;
	Thu, 30 Jul 2026 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424512;
	bh=fTdbb5abFfefrYEZXeO89gUgU5mQAhd3K6gS1YbyJYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJWoU96spMthuUwKCn7I34BszeDvwefL/Zf/YZ/NAuDYL5Xb+Em1ZLwjxdL3gHatP
	 yuMEegYOGM+Z3SrChyND4xjXQYn1rNg9whX8Zfvy6nDqZ04e3C240QxG0kTRwpyL08
	 s3N3CiIVwqBqYf0ijW81NgYeu/C6RgWA9Ysz8w/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 421/675] media: qcom: camss: Fix RDI streaming for CSID 680
Date: Thu, 30 Jul 2026 16:12:31 +0200
Message-ID: <20260730141454.082795442@linuxfoundation.org>
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

commit 93ea81d16570442dbca04d2e2563ae8c3e65fa1b upstream.

Fix streaming to RDI1 and RDI2. csid->phy.en_vc contains a bitmask of
enabled CSID ports not virtual channels.

We cycle through the number of available CSID ports and test this value
against the vc_en bitmask.

We then use the passed value both as an index to the port configuration
macros and as a virtual channel index.

This is a very broken pattern. Reviewing the initial introduction of VC
support it states that you can only map one CSID to one VFE. This is true
however each CSID has multiple sources which can sink inside of the VFE -
for example there is a "pixel" path for bayer stats which sources @
CSID(x):3 and sinks on VFE(x):pix.

That is CSID port # 3 should drive VFE port #3. With our current setup only
a sensor which drives virtual channel number #3 could possibly enable that
setup.

This is deeply wrong the virtual channel has no relevance to hooking CSID
to VFE, a fact that is proven after this patch is applied allowing
RDI0,RDI1 and RDI2 to function with VC0 whereas before only RDI1 worked.

Another way the current model breaks is the DT field. A sensor driving
different data-types on the same VC would not be able to separate the VC:DT
pair to separate RDI outputs, thus breaking another feature of VCs in the
MIPI data-stream.

Default the VC back to zero. A follow on series will implement subdev
streams to actually enable VCs without breaking CSID source to VFE sink.

Fixes: 253314b20408 ("media: qcom: camss: Add CSID 680 support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-680.c |   30 ++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-680.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-680.c
@@ -219,9 +219,9 @@ static void __csid_configure_top(struct
 	    CSID_TOP_IO_PATH_CFG0(csid->id));
 }
 
-static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 vc)
+static void __csid_configure_rdi_stream(struct csid_device *csid, u8 enable, u8 port, u8 vc)
 {
-	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + vc];
+	struct v4l2_mbus_framefmt *input_format = &csid->fmt[MSM_CSID_PAD_FIRST_SRC + port];
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
@@ -233,28 +233,28 @@ static void __csid_configure_rdi_stream(
 		lane_cnt = 4;
 
 	val = 0;
-	writel(val, csid->base + CSID_RDI_FRM_DROP_PERIOD(vc));
+	writel(val, csid->base + CSID_RDI_FRM_DROP_PERIOD(port));
 
 	/*
 	 * DT_ID is a two bit bitfield that is concatenated with
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
-	dt_id = vc & 0x03;
+	dt_id = port & 0x03;
 
 	/* note: for non-RDI path, this should be format->decode_format */
 	val |= DECODE_FORMAT_PAYLOAD_ONLY << RDI_CFG0_DECODE_FORMAT;
 	val |= format->data_type << RDI_CFG0_DATA_TYPE;
 	val |= vc << RDI_CFG0_VIRTUAL_CHANNEL;
 	val |= dt_id << RDI_CFG0_DT_ID;
-	writel(val, csid->base + CSID_RDI_CFG0(vc));
+	writel(val, csid->base + CSID_RDI_CFG0(port));
 
 	val = RDI_CFG1_TIMESTAMP_STB_FRAME;
 	val |= RDI_CFG1_BYTE_CNTR_EN;
@@ -265,23 +265,23 @@ static void __csid_configure_rdi_stream(
 	val |= RDI_CFG1_CROP_V_EN;
 	val |= RDI_CFG1_PACKING_MIPI;
 
-	writel(val, csid->base + CSID_RDI_CFG1(vc));
+	writel(val, csid->base + CSID_RDI_CFG1(port));
 
 	val = 0;
-	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(vc));
+	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(port));
 
 	val = 1;
-	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(vc));
+	writel(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PATTERN(port));
 
 	val = 0;
-	writel(val, csid->base + CSID_RDI_CTRL(vc));
+	writel(val, csid->base + CSID_RDI_CTRL(port));
 
-	val = readl(csid->base + CSID_RDI_CFG0(vc));
+	val = readl(csid->base + CSID_RDI_CFG0(port));
 	if (enable)
 		val |= RDI_CFG0_ENABLE;
 	else
 		val &= ~RDI_CFG0_ENABLE;
-	writel(val, csid->base + CSID_RDI_CFG0(vc));
+	writel(val, csid->base + CSID_RDI_CFG0(port));
 }
 
 static void csid_configure_stream(struct csid_device *csid, u8 enable)
@@ -290,11 +290,11 @@ static void csid_configure_stream(struct
 
 	__csid_configure_top(csid);
 
-       /* Loop through all enabled VCs and configure stream for each */
+	/* Loop through all enabled ports and configure a stream for each */
 	for (i = 0; i < MSM_CSID_MAX_SRC_STREAMS; i++) {
 		if (csid->phy.en_vc & BIT(i)) {
-			__csid_configure_rdi_stream(csid, enable, i);
-			__csid_configure_rx(csid, &csid->phy, i);
+			__csid_configure_rdi_stream(csid, enable, i, 0);
+			__csid_configure_rx(csid, &csid->phy, 0);
 			__csid_ctrl_rdi(csid, enable, i);
 		}
 	}


