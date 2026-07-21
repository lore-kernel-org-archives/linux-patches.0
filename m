Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EBD46C4D8;
	Tue, 21 Jul 2026 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648572; cv=none; b=AzeBo5im62kw9JfO3ElrLqkU2UeLWe2j7nUX1yJTk6L0Zv0VIR+Plti55keKKIOZrRiv3QM9bRJ6NKu+pCagCpq4/PG9iXdN2XBObT+Ky3RV+mTmV22GBuCGYXlNMLwuXRxVmFb/yQQRQAP0+ABaEXkQpvM9iedethLnBOZ2Tjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648572; c=relaxed/simple;
	bh=Hob88hj3f9tOHH4hMD1lZc4IkjFSXtqM6wxyylEnMkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3/T6YOie3/9xhVIRTyW6pK99W7nLPxBpr0hCDibX56BdkZbrPoSioO8I1mz+ASZWLuk/kvfZXhC0l+eRXjFY9ZBchOY6q0vpWZulfUWMC2xQ8hcxC8EbnYyOHjeITjQoCSha/aMjMm/QtNfPx2kCjQAqqynzIh70NZbwGNNAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjUo/ZUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjUo/ZUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8491F000E9;
	Tue, 21 Jul 2026 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648571;
	bh=t44flIdDi0SQ5vyeU2hyRomUwzHrUG7eeHhd/sxYsBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjUo/ZUQ4BckzNjHlUhl/tchaTMtIG+SXgY5nvGqJbKv00mcbYrgMuCM+aMqFwfze
	 Eq+GZoWLz9xHQb43n3SoOCrITwtVTARNitCLNAUvrAMyEj5E2NOW4MPGNGqSaBRAEJ
	 4aC/Z62j0FFTJB5vpTcWLvkmKdektdx5FApyCvRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0250/2077] media: synopsys: Fix IPI using hardcoded datatype
Date: Tue, 21 Jul 2026 16:58:43 +0200
Message-ID: <20260721152558.576622819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

[ Upstream commit 8ba166ff7c921da610376156d7c0a5fc985fa983 ]

The imx93_csi2rx_dphy_ipi_enable() function configures the IPI datatype
using csi2->formats->csi_dt, which is initialized during probe but never
updated in set_fmt(). This causes the IPI to always use the probe-time
default datatype, ignoring the actual media bus format negotiated at
runtime. When userspace requests a different format, the IPI hardware is
configured with the wrong datatype, resulting in incorrect image output.

Fix by updating csi2->formats in the set_fmt callback to reflect the
currently negotiated format, ensuring the IPI configuration matches the
runtime datatype.

Fixes: ec40b431f0ab ("media: synopsys: csi2rx: add i.MX93 support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/synopsys/dw-mipi-csi2rx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/synopsys/dw-mipi-csi2rx.c b/drivers/media/platform/synopsys/dw-mipi-csi2rx.c
index 02eb4a6cafadea..0b80e84983f9e2 100644
--- a/drivers/media/platform/synopsys/dw-mipi-csi2rx.c
+++ b/drivers/media/platform/synopsys/dw-mipi-csi2rx.c
@@ -311,7 +311,7 @@ dw_mipi_csi2rx_find_format(struct dw_mipi_csi2rx_device *csi2, u32 mbus_code)
 	WARN_ON(csi2->formats_num == 0);
 
 	for (unsigned int i = 0; i < csi2->formats_num; i++) {
-		const struct dw_mipi_csi2rx_format *format = &csi2->formats[i];
+		const struct dw_mipi_csi2rx_format *format = &formats[i];
 
 		if (format->code == mbus_code)
 			return format;
@@ -433,7 +433,7 @@ dw_mipi_csi2rx_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index >= csi2->formats_num)
 			return -EINVAL;
 
-		code->code = csi2->formats[code->index].code;
+		code->code = formats[code->index].code;
 		return 0;
 	default:
 		return -EINVAL;
@@ -470,6 +470,17 @@ static int dw_mipi_csi2rx_set_fmt(struct v4l2_subdev *sd,
 
 	*src = *sink;
 
+	/* Store the CSIS format descriptor for active formats. */
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		csi2->formats = fmt ? :
+			dw_mipi_csi2rx_find_format(csi2, default_format.code);
+
+		if (!csi2->formats) {
+			dev_err(csi2->dev, "Failed to find valid format\n");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.53.0



