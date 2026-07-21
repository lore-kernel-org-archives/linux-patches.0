Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86643C05F;
	Tue, 21 Jul 2026 21:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671026; cv=none; b=u4sI9K3+f7Mjj0wuszB/yYULjJ0t1snHtQXQvvaXnl+6AjtD7Dchxzv4h9liaYXxiofypecy5OJzsEhulZpIuQ1S9gPbkF0n+iF4ZgV4dr+Yz7uYonYsfusdWsEJdnFnfaUp1nMvdkrF1MzePYEeoRwfic1eWv5R7/qV3Hm/2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671026; c=relaxed/simple;
	bh=WASa6fupuIvjwJ8FXDfXErrYOlwFR1vMs+4yMO5Gfcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAjxJC7XksF4oG0GlO9tgy+MeN65dtuxM5WUS2Uze39s30qgMXDknsW220d6rxXVzP/qBZf/QGhvWOF5UR1MKp4gl9TDANTpL9e58ZdISSpXIDJeH3Mz8aM3c69XRgpk1GCOM8e4MeHnE6X6AdM0XvD9nWezpdtoPjnGIdGUixg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXR3sC0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXR3sC0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF31F00A3A;
	Tue, 21 Jul 2026 21:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671024;
	bh=o/qeqGIJcneP7PYED6YJpCIMrdrG2Jww5Q3sSca8KwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXR3sC0xzQY1acLTDd7LGAlho0IdLfWq/HvauLiCRWaTOwMyh3nWy37pVXm10Xgl5
	 w4iR07Z2ed7fRo7hV6EnkHVOSlfhANFlz0BXJ226HCenSsSIAHB+l3xBbwX8x6Aa7Y
	 QU9k9pnWX1SCf7s3IM7Bt2khU2nXcSu32rg5Y90s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 091/843] media: staging: ipu3-imgu: Add range check for imgu_css_cfg_acc_stripe
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152408.046798293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1773,6 +1773,8 @@ static int imgu_css_cfg_acc_stripe(struc
 		acc->stripe.bds_out_stripes[0].width =
 			ALIGN(css_pipe->rect[IPU3_CSS_RECT_BDS].width, f);
 	} else {
+		u32 offset;
+
 		/* Image processing is divided into two stripes */
 		acc->stripe.bds_out_stripes[0].width =
 			acc->stripe.bds_out_stripes[1].width =
@@ -1791,8 +1793,10 @@ static int imgu_css_cfg_acc_stripe(struc
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


