Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175373321A2;
	Thu, 16 Jul 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209365; cv=none; b=TuLdMeH+cUdMsejyE2KhNoS0ln0Q14427ABbNRThA/ysyw9eYqlnRct8cuSPVS6ZkmukRRN5P2IgCJsHsjVlmBIIxzjyOlFIys/NIjkMtGLHk2M1pNUxmmfVByXnojREjPtqfS4pVP9tm9BcIYdYzGJYj1ctmKrYsCSW+IePWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209365; c=relaxed/simple;
	bh=YPhiLSW2SwHme5WssjTRMyMBhVZu/VAyighKrATcPb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcmR7iUeWY2iiFF0ut8xnteOKCh6CssElt0P3Y1zpueLe3Z+ipl1K7PfDyL83jxsDWLIX0x1MzfcPY71lSQ1gIgfGbHDfpbmAIWZMXEIrmqN2Kvz6WATIBvIpRJDpxoYh7vQI+rIVIfm1bYLWiRosEEpf9aDMEFLys+u6bATvzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDTSqiOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDTSqiOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3351D1F000E9;
	Thu, 16 Jul 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209363;
	bh=7bPzU9JNSAAwOyqXKj7i0GlRDUK55eYcUBhW8WZsZXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDTSqiOxIzq4X4FQIK0VUw7efPygS0rm/x20WgNJw6BzxQ7MKU4aWsjR7rD3c+DtB
	 jK8fKtuIGaSXj0iTG3Pt4ao8uRa5UGDdY3qPeMJrnYxgW8yQ0qh5ipJDdvqsjfv7Yz
	 VLZkJCw6WzepuRFG4Ht23dJPQTk5kIDixtEGIOPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 156/518] media: staging: ipu3-imgu: Add range check for imgu_css_cfg_acc_stripe
Date: Thu, 16 Jul 2026 15:27:04 +0200
Message-ID: <20260716133051.257719368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


