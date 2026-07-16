Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2942883E;
	Thu, 16 Jul 2026 14:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211888; cv=none; b=YiJEBI8aXVWpgEYnEbL5W3LwhTKWfop5zADDGua3OKP5Wu1CHEi0of2XAYAkJ1urSNCMjAxp+PsVhx2xHJLrcpoehCA95oc3yhBoCRg8jivRyx3YYYz/kTU5ag0Ud49u1mxBZrrLCIerULs1JkIK5T5kUQ/sc5KbSnfLfxcMbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211888; c=relaxed/simple;
	bh=aAbaLp5OUjN3x5iIM4svuuBsxXcG9aMP6bTqyiLOlMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llZp/naq3N2uDnwJat9aQ6Ij8c73Zx1/LjKKWx/uxQtCvgps8vLy06U8ysWHWyZ5TCIE6ghUdy1Vo/Jaqyb2kbtUTUE2/OVCBsOxc1l7wRGRBHyVsM2Y3sdcRJXXdo3YowhASbGjWalcXyEKW1RwNI3XwKxyV1olCxRCCM+GPmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrAEzZdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrAEzZdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61281F00A3A;
	Thu, 16 Jul 2026 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211887;
	bh=XVLWZNrUB59Dpaa/4Vd27PFN/21DPcC+jNyuQRG6PLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrAEzZdrUhsburMMlMlRGJ5ByOMgI9fhIXc3/VIYN5U7Xj88LRCK4rFCLWdz77RzX
	 o7erw/4jE9zhEmUkYtE6MXFXj3D0DapkBOoJSPZE/Vayh5cr5CgxU2p3DVrSmvUye8
	 pxtAANH1EKTcscJAP/BqJKngSbbHmxQ5Kf+f8nVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 118/349] media: staging: ipu3-imgu: Add range check for imgu_css_cfg_acc_stripe
Date: Thu, 16 Jul 2026 15:30:52 +0200
Message-ID: <20260716133036.000650704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


