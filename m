Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF5B579818;
	Wed,  9 Sep 2026 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962846; cv=none; b=EnFqSmIqqh+9PShSGLwZ9ZzG2AVgfc3C6Pbuksm5Tx5+998Nq7TbiRHrrN6VVUobGpVtQ3UpgqxmtDZaG6ijUh3+/qllCyDSJCTuBQaMd0rQW9WIABDLNleY7A1/lw9NMGsk2Nh4AnlA4iR2T94ntKoqXk0jdBtqGvE5skXpilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962846; c=relaxed/simple;
	bh=MDLoriD0Zc8dMs8kWPJc8z/NbICi+eG+0hBNvQElXIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLV7pA02nwFrZJJOM+PIvKO15o8HTOGzFAOdmutN+By3Ld1Fcm/p2k3up+bmVzEA2XMUB9i16F7YxLOk93eLr+s9JeJw4m/Hsb0YJL/QxdLgnAJr9ZOqWPzziWkVr7hRL65yqDf32cq8H6NEfO4m/0/AopVMkSyDyXQ0KOb92vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jx3KDCma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jx3KDCma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D3E1F00A3A;
	Wed,  9 Sep 2026 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962845;
	bh=bIP1j6ejGbhXjd4dJq4ufO819w5qKIEF95r9srbouCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jx3KDCmaSSEfgy23qC8zPz0tmN/zp89HUdeH0tnL9E9vVxGyBGGNz9IY2+4rtSZO/
	 Md0JzjphD7+9t9tX9zCk8fEovx9y1drNmVSVq1CA73i28q0pRaVd8wN9c4WUBz+pXB
	 uUVpmXcLPLEr/u9KaXoQLDxdNLP3iYc03mAQMVVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 391/556] media: rzg2l-cru: Align bytesperline to hardware DMA stride requirement
Date: Wed,  9 Sep 2026 15:41:11 +0200
Message-ID: <20260909134244.415936005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

commit 56c29fa3ee666197516a231e75aed789ae9c530d upstream.

The RZ/G3E CRU programs the line stride via the AMnIS register, whose
IS field encodes the value in units of 128 bytes. If bytesperline is
not a multiple of 128, the division truncates and the hardware uses a
wrong stride, causing horizontal banding.

Commit ace92ccef0c9 ("media: platform: rzg2l-cru: Use v4l2_fill_pixfmt()")
replaced the open-coded aligned calculation with v4l2_fill_pixfmt(),
which sets no alignment, reintroducing the issue.

Round bytesperline up to RZG2L_CRU_STRIDE_ALIGN and recompute
sizeimage when info->has_stride is set. RZ/G2L has no AMnIS register
and keeps the values from v4l2_fill_pixfmt() unchanged.

Fixes: ace92ccef0c9 ("media: platform: rzg2l-cru: Use v4l2_fill_pixfmt()")
Cc: stable@vger.kernel.org
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c
+++ b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c
@@ -851,6 +851,11 @@ static void rzg2l_cru_format_align(struc
 
 	v4l2_fill_pixfmt(pix, pix->pixelformat, pix->width, pix->height);
 
+	if (info->has_stride) {
+		pix->bytesperline = ALIGN(pix->bytesperline, RZG2L_CRU_STRIDE_ALIGN);
+		pix->sizeimage = pix->bytesperline * pix->height;
+	}
+
 	dev_dbg(cru->dev, "Format %ux%u bpl: %u size: %u\n",
 		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
 }


