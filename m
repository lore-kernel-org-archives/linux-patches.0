Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328C7159580;
	Mon, 29 Jan 2024 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548086; cv=none; b=j7joW3Px7XSgNTecn1gNjDpRjdwH69ZwR4VD8w8RePwmh+Q2D1R3BoUkbw2IfdHE5mfA7pCTX15KqNR03TF1yuF8SwF6wCIsQaQUUvlNNDyXkLw/BaGV5ZUIcBTEX7dDebal6PVusDRhXniKVHTgD1Q9j/tVeFWgP4DN6QSeFKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548086; c=relaxed/simple;
	bh=Y3GDXyHc+4mF04UrLcWbKawKL0bneocYnVAnRpr1Eso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTEy0W/zzDVbVibiki73CU0Xjyt9+ogHejrTp1Bc/LE6qfKOyLDqdG0GgvCqxDKoE7lGVYHlRwnrEkrNHJyd5Bh7nMxMEm+52+KWNH/uX2g5PbcjilctYXX6ClugxvgZTOMerRXh1KGLstu3wCY5zYSp8kELiWQo9KEQegsvRtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss96PoN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss96PoN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE393C43601;
	Mon, 29 Jan 2024 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548086;
	bh=Y3GDXyHc+4mF04UrLcWbKawKL0bneocYnVAnRpr1Eso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss96PoN6NB/wNWLccwBufgvqH4rDmo3GvwUd8B4SKwwDLOgFy1HT1je0G5SzsRpyZ
	 i785mGjeGzSKmNjvJROgaTT35BNtHXhllVt5xCt2Fx6+2Sv/BkamgSLhLp/psnlEBr
	 yTX6gRsqxIqJVfIP0PLzvQ5GhvdgnL5rAprNEJjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.7 100/346] media: mtk-jpeg: Fix timeout schedule error in mtk_jpegdec_worker.
Date: Mon, 29 Jan 2024 09:02:11 -0800
Message-ID: <20240129170019.342163042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

commit 38e1857933def4b3fafc28cc34ff3bbc84cad2c3 upstream.

In mtk_jpegdec_worker, if error occurs in mtk_jpeg_set_dec_dst, it
will start the timeout worker and invoke v4l2_m2m_job_finish at
the same time. This will break the logic of design for there should
be only one function to call v4l2_m2m_job_finish. But now the timeout
handler and mtk_jpegdec_worker will both invoke it.

Fix it by start the worker only if mtk_jpeg_set_dec_dst successfully
finished.

Fixes: da4ede4b7fd6 ("media: mtk-jpeg: move data/code inside CONFIG_OF blocks")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1749,9 +1749,6 @@ retry_select:
 	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
-	schedule_delayed_work(&comp_jpeg[hw_id]->job_timeout_work,
-			      msecs_to_jiffies(MTK_JPEG_HW_TIMEOUT_MSEC));
-
 	mtk_jpeg_set_dec_src(ctx, &src_buf->vb2_buf, &bs);
 	if (mtk_jpeg_set_dec_dst(ctx,
 				 &jpeg_src_buf->dec_param,
@@ -1761,6 +1758,9 @@ retry_select:
 		goto setdst_end;
 	}
 
+	schedule_delayed_work(&comp_jpeg[hw_id]->job_timeout_work,
+			      msecs_to_jiffies(MTK_JPEG_HW_TIMEOUT_MSEC));
+
 	spin_lock_irqsave(&comp_jpeg[hw_id]->hw_lock, flags);
 	ctx->total_frame_num++;
 	mtk_jpeg_dec_reset(comp_jpeg[hw_id]->reg_base);


