Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD87136988;
	Mon, 23 Jun 2025 13:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684415; cv=none; b=pzdgB9wUoBWkzfRktxdYKbOmmVAUrL29gw/q7Ow7UiwnSG9t2mhH3Ijy93zKMhDpjw+tpjFz7trruq1nhuzPXeDLmD1+wvbDKpLaOcNETgONQuL3HcP+lPknC216A/f6JwmnSnCO5piBkrGnE68N0N/Qq+xmiRCQ96AabQiiZ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684415; c=relaxed/simple;
	bh=sb2FX0vgEGKl6qcqzSLwWTdvE5kvFWC+4s1YLQr4G3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I53zju2r5fDoxVdbmgHiN4ryMjUqC9gAZCT6uIHeRVxqopCT2QLF8M2CIwb5WiOlB5Y52Y6JrmjGbiUS/Bv7yUveQQevm9+c/Eyn2pjPCFE9KElcN3S5MEvbCVwkEFfsKD3Fbuh7paXjMWhpfPUwdExIesmEkDhSFZrupe7lTaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0aPlkjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0aPlkjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986EDC4CEEA;
	Mon, 23 Jun 2025 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684414;
	bh=sb2FX0vgEGKl6qcqzSLwWTdvE5kvFWC+4s1YLQr4G3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0aPlkjvi5wI5VLcHrpysD0TRbEQbr2G/quVRfzJ7LuE7BcDlyol6TATdrNLKWJG4
	 5wXuUt5JKx6/GEpHSGZBvXH1BkxxGTb37KpOlAYBREr9utq+Bvedu259mvvBPUrYhI
	 t4BusamlqVE7dX5E17woG/jYWkomMyLe+CdW3nIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.15 059/592] media: nxp: imx8-isi: better handle the m2m usage_count
Date: Mon, 23 Jun 2025 15:00:17 +0200
Message-ID: <20250623130701.661316677@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,15 +485,18 @@ static int mxc_isi_m2m_streamon(struct f
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
@@ -545,6 +549,8 @@ static int mxc_isi_m2m_streamon(struct f
 		goto unchain;
 	}
 
+	q->streaming = true;
+
 	return 0;
 
 unchain:
@@ -567,10 +573,14 @@ static int mxc_isi_m2m_streamoff(struct
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
@@ -596,6 +606,8 @@ static int mxc_isi_m2m_streamoff(struct
 
 	mutex_unlock(&m2m->lock);
 
+	q->streaming = false;
+
 	return 0;
 }
 


