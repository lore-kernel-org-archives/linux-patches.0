Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6146A429CC1;
	Thu, 16 Jul 2026 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209697; cv=none; b=pZJI4E/9VisQSBg7/iv9fG3fiCAhunn3MOAjuAsU+C4fgP89uklMhUHdlkgNLaxS8VGT67oBb6Wssc3sqtTROrVLu51s00N9yOCWc40P0MP5Exj62ReVt4dGKo1F5gYf9Z89FATLc0klY6eO+fR0MAVphIEoXsVaqpO4yv4yEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209697; c=relaxed/simple;
	bh=1jygYR/uGFCRIqkdFf8uQA/hXoLZPKNjnrCsrBJNEU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNI5N6Q/E0tsMQPAGRzOVIgBZ1CFxcrIC/jxL7l8ELbeDINPPjQpuIGqv+Am3pZWfo3+On3+DGYSeOCATZ4nuxXV8Ov+KJbE5Be3zuLa3l6FdomNw8Qo6ayaBnqjZqY/uNlWbM/fM42/DHfcnQzjUfwlgDjxJmJ1nK1/8nVkPAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdDgdjqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdDgdjqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B3E1F000E9;
	Thu, 16 Jul 2026 13:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209686;
	bh=YfE5xiTjO8eFnHfp/2bItZQDvKRDv/ZF9cdjnax5wsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdDgdjqkg/z9mP3QvecS8PPJvphw4ds5+K30IvQ7lyrsgCBo4e0D704YkWwoarPER
	 s2W6b/5eVYrAh8iznBy0Kz0lFj8PxbLLHxeUY/aiX6W5n/L/WVTi1E18GYm8sMVGCx
	 1ogmHO3wwtPwswVi7y3y/by032KnRJ6ExQwwXBUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 280/518] media: mtk-jpeg: cancel workqueue on release for supported platforms only
Date: Thu, 16 Jul 2026 15:29:08 +0200
Message-ID: <20260716133053.939420551@linuxfoundation.org>
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
@@ -1202,7 +1202,8 @@ static int mtk_jpeg_release(struct file
 	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
 	struct mtk_jpeg_ctx *ctx = mtk_jpeg_file_to_ctx(file);
 
-	cancel_work_sync(&ctx->jpeg_work);
+	if (jpeg->variant->jpeg_worker)
+		cancel_work_sync(&ctx->jpeg_work);
 	mutex_lock(&jpeg->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);


