Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E638C2A0;
	Tue, 21 Jul 2026 21:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668374; cv=none; b=fJ4H3LykY29srSo+t/k721bcTwVguT8fagdKmE9hHUTWVyGJxszhSHlxyUTWSZ6ZLdlpkV0k/hIBHelYwkygNOMS/d1mAWK2T9/wzfOnHvf3iycBHdiqrcwdrNRkFtjFQaxVB2duDnBI4WXd/EFG/GZ1koTxJV8OTIZqeq0p+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668374; c=relaxed/simple;
	bh=m1/6e3sm6+bBq7Y0dFbCoV42zHGlPdEhefvVXkcH3KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8JiXyzpxHg9YvYXSzop41HXzsWCiXVReatOlV6IZPcUW7WzBCMvYIDOC5b8eDlsXTUUsZOO2KBd2H9x0osDE1ZF92/I31JaO1aPGTtfUU8/33R9xwc4LVvVdS80W2o9oSIt/RaJFvbT7FNZqcM9D9sHNaFidKfzFq4cjI+S9S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7DaWC5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7DaWC5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A01F000E9;
	Tue, 21 Jul 2026 21:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668372;
	bh=X3rvx4547WRJE4ovjhlGdSum420IZ+OysNcBgM3G1mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7DaWC5ftL26nYn9mRfw9JVDQ9aMhBOxNdAocPyWvSHCD74GdpAQht454QKR+LDe5
	 b6bhTk86pIFbEDg0sGbqSmnlySLDp5m/6ZQinupgjXgIJkucJYeMzgy76evJMpXGL7
	 JJSMwzH4q88xh+otDwpWn+uFLi7FgpujZazIsJPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0107/1067] media: staging: ipu3-imgu: Add range check for imgu_css_cfg_acc_stripe
Date: Tue, 21 Jul 2026 17:11:48 +0200
Message-ID: <20260721152426.981515636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit c32fe4c4918c9aa49f61359e3b42619c4d8686de upstream.

If the driver's stripe information is invalid it can result in an integer
underflow. Add a range check to avoid this kind of error.

This patch fixes the following smatch error:
drivers/staging/media/ipu3/ipu3-css-params.c:1792 imgu_css_cfg_acc_stripe() warn: 'acc->stripe.bds_out_stripes[0]->width - 2 * f' 4294967168 can't fit into 65535 'acc->stripe.bds_out_stripes[1]->offset'

Cc: stable@vger.kernel.org
Fixes: e11110a5b744 ("media: staging/intel-ipu3: css: Compute and program ccs")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-css-params.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-css-params.c
+++ b/drivers/staging/media/ipu3/ipu3-css-params.c
@@ -1770,6 +1770,8 @@ static int imgu_css_cfg_acc_stripe(struc
 		acc->stripe.bds_out_stripes[0].width =
 			ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f);
 	} else {
+		u32 offset;
+
 		/* Image processing is divided into two stripes */
 		acc->stripe.bds_out_stripes[0].width =
 			acc->stripe.bds_out_stripes[1].width =
@@ -1788,8 +1790,10 @@ static int imgu_css_cfg_acc_stripe(struc
 			acc->stripe.bds_out_stripes[1].width += f;
 		}
 		/* Overlap between stripes is IPU3_UAPI_ISP_VEC_ELEMS * 4 */
-		acc->stripe.bds_out_stripes[1].offset =
-			acc->stripe.bds_out_stripes[0].width - 2 * f;
+		offset = acc->stripe.bds_out_stripes[0].width - 2 * f;
+		if (offset > 65535)
+			return -EINVAL;
+		acc->stripe.bds_out_stripes[1].offset = offset;
 	}
 
 	acc->stripe.effective_stripes[0].height =


