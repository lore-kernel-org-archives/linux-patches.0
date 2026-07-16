Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C942D76E;
	Thu, 16 Jul 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212127; cv=none; b=GDXaH7ioNzjsATV0qJw3lrg6yKDlF73ZrWr/aRRDka/c57K0SsnDS9Is2gvK2I7wM6+IkhpRPPUlQJU6hCVW1qM47OfeUsm660E1USHYXuvjVh69aycUI1rK7YGluFRJ9AR0Ca387J1w52iU8LhyLiuwnMfPRgRJpz892QWMFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212127; c=relaxed/simple;
	bh=N4wDSZhDnQzC3uNn/F53RDdZ63+6O9SilxmRArJg2uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsRaec0RWr0fqHG0y2nrOS/s6ahbjCIo1z4zU6g1jM5bVPuvswWJRl195K6s4/CiF5aX4B7tti2ncGj25eZoVEZkzn+dCrTZC7QancX0yCmFP1A51XBSB9PNM1vFTiP1U2rqHUc7M8hG5zZI7JCL6Hv3xbNpdPOBKC8i8GjTNGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPNvjn0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPNvjn0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7859D1F00A3A;
	Thu, 16 Jul 2026 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212126;
	bh=PHG8lqQv2uKoGdOxTWAsJXkjzm8Gmwxj7iROcXaW/2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPNvjn0Ll2esqvqYXpoqELancaEiH6FeIZ/wUiGqIRXQfgpC79QFWOlhBYc8SXXc8
	 r3at0WIRBFbTLaQVEkMpxcK9YDk1IIsw9aF6z/qkNwG84000o9IIFE6CCpYlm7Y3h4
	 jbvKQeFj2fmrnUChllLkSmDfBFLDIFEgWfmJnAOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 209/349] media: mtk-jpeg: cancel workqueue on release for supported platforms only
Date: Thu, 16 Jul 2026 15:32:23 +0200
Message-ID: <20260716133038.040442520@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

commit b1845a227fda37b2fe5327df3ca0015d7e290235 upstream.

Since a recent fix the mtk_jpeg_release function cancels any pending
or running work present in the driver workqueue using
cancel_work_sync function.
Currently, only the multicore based variants use this workqueue and they
have the jpeg_worker platform data field initialized with a workqueue
callback function. For the others, this field value remain NULL by
default.
The cancel_work_sync function is unconditionally called in
mtk_jpeg_release function, even for the variants that do not use the
workqueue. This call generates a WARN_ON print in __flush_work because
the workqueue callback function presence check fails in __flush_work
function (used by cancel_work_sync).

So, to avoid these warnings, call cancel_work_sync only if a workqueue
callback is defined in platform data.

Fixes: 34c519feef3e ("media: mtk-jpeg: fix use-after-free in release path due to uncancelled work")
Cc: stable@vger.kernel.org
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1213,7 +1213,8 @@ static int mtk_jpeg_release(struct file
 	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
 	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(file->private_data);
 
-	cancel_work_sync(&ctx->jpeg_work);
+	if (jpeg->variant->jpeg_worker)
+		cancel_work_sync(&ctx->jpeg_work);
 	mutex_lock(&jpeg->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);


