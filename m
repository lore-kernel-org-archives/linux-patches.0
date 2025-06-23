Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AF670838;
	Mon, 23 Jun 2025 21:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713069; cv=none; b=B6SYBTvtoaM4nrroO6OjBtuFqrT0w53Ia2mtLuUzWPKBw2zKe27D+/t+vKmois0OYGkQ5mnIriVfgYZau7dMXTwnYQgOQamKAiXmlkx2EIamf5KbwPKVzffYFZAY5VDWITLY4VcbzmCKjAhlqTTowxK8GwUxdgIk5U1KAh1xhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713069; c=relaxed/simple;
	bh=Pt+JI9ez0YkfQ5OYgk4ljxNpkSgZg2aMs/g5h1dxtfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRpNkfP3WBk447fcgyQgy57PMaTCkSwtO39hj8M4ZTHcd0Wq93Dexw3fibxcg5RZiVVd3hvZ0RHc1q4ucEDZ/p+r8IHaewZyYJum5X82xj0KRFzKSHrGgiejYrwBi2P4wGpgblcsDxhbug1hBs05AI6eQYEya/RlxFycLYs5kds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNuAvpp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNuAvpp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BBAC4CEEA;
	Mon, 23 Jun 2025 21:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713069;
	bh=Pt+JI9ez0YkfQ5OYgk4ljxNpkSgZg2aMs/g5h1dxtfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNuAvpp4L5p6XpFz7ChzpN0L3sX8x+oAk7qDJCCpEFZil3GQBlSUEQXausEVOZsxL
	 53ulArEaGApB5TlgnzuahfMRjyt847aAuWjLMb/uwooTxht5iIzBjEGRbhEOYylEp0
	 usP5gJMFPNDbnoBH3fv8Dnzn8jSJZ8AYea2yNtxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 044/414] media: nxp: imx8-isi: better handle the m2m usage_count
Date: Mon, 23 Jun 2025 15:03:01 +0200
Message-ID: <20250623130643.139718437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

commit 910efa649076be9c2e1326059830327cf4228cf6 upstream.

Currently, if streamon/streamoff calls are imbalanced we can either end up
with a negative ISI m2m usage_count (if streamoff() is called more times
than streamon()) in which case we'll not be able to restart the ISI pipe
next time, or the usage_count never gets to 0 and the pipe is never
switched off.

To avoid that, add a 'streaming' flag to mxc_isi_m2m_ctx_queue_data and use it
in the streamon/streamoff to avoid incrementing/decrementing the usage_count
uselessly, if called multiple times from the same context.

Fixes: cf21f328fcafac ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241023085643.978729-1-laurentiu.palcu@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
@@ -43,6 +43,7 @@ struct mxc_isi_m2m_ctx_queue_data {
 	struct v4l2_pix_format_mplane format;
 	const struct mxc_isi_format_info *info;
 	u32 sequence;
+	bool streaming;
 };
 
 struct mxc_isi_m2m_ctx {
@@ -486,15 +487,18 @@ static int mxc_isi_m2m_streamon(struct f
 				enum v4l2_buf_type type)
 {
 	struct mxc_isi_m2m_ctx *ctx = to_isi_m2m_ctx(fh);
+	struct mxc_isi_m2m_ctx_queue_data *q = mxc_isi_m2m_ctx_qdata(ctx, type);
 	const struct v4l2_pix_format_mplane *out_pix = &ctx->queues.out.format;
 	const struct v4l2_pix_format_mplane *cap_pix = &ctx->queues.cap.format;
 	const struct mxc_isi_format_info *cap_info = ctx->queues.cap.info;
 	const struct mxc_isi_format_info *out_info = ctx->queues.out.info;
 	struct mxc_isi_m2m *m2m = ctx->m2m;
 	bool bypass;
-
 	int ret;
 
+	if (q->streaming)
+		return 0;
+
 	mutex_lock(&m2m->lock);
 
 	if (m2m->usage_count == INT_MAX) {
@@ -547,6 +551,8 @@ static int mxc_isi_m2m_streamon(struct f
 		goto unchain;
 	}
 
+	q->streaming = true;
+
 	return 0;
 
 unchain:
@@ -569,10 +575,14 @@ static int mxc_isi_m2m_streamoff(struct
 				 enum v4l2_buf_type type)
 {
 	struct mxc_isi_m2m_ctx *ctx = to_isi_m2m_ctx(fh);
+	struct mxc_isi_m2m_ctx_queue_data *q = mxc_isi_m2m_ctx_qdata(ctx, type);
 	struct mxc_isi_m2m *m2m = ctx->m2m;
 
 	v4l2_m2m_ioctl_streamoff(file, fh, type);
 
+	if (!q->streaming)
+		return 0;
+
 	mutex_lock(&m2m->lock);
 
 	/*
@@ -598,6 +608,8 @@ static int mxc_isi_m2m_streamoff(struct
 
 	mutex_unlock(&m2m->lock);
 
+	q->streaming = false;
+
 	return 0;
 }
 


