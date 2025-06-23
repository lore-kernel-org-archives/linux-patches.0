Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD4A347DD;
	Mon, 23 Jun 2025 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685792; cv=none; b=nsIubLh532Jq5VOTacIYD9bmKbEw/HZH0jWZ5Mo/52bYn/CUNMfIXz+cvcNOD1iv9tSe/umbiq2Pb1h/2Pw9ztumvEGuq6ceUJSht5jcY/j2mqAZir5jW2gH+MRJkBxSiZAwKefSuVKvRayDC38wx3l5nDCIJIwyTVkzljQzDGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685792; c=relaxed/simple;
	bh=ZWgMOVluDj9kMtwicgRB0n2bfY6GeNLQ2/z5iG9ZA0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz2nqua1aKxeDV9lldg6d3NZ9I0G451UxEayTQnaHE/DeE2gXCXhA1otZ8DHfEQHnFyvY4QxojVpgQec3qcbjn2Ewfc3giRJvSd/AnnWOIcHqSJizKCr6Lu7lIAlBsDwBnXV+4rDVZQVPd2ECJeKG6f8X/YvnYc027G1dum+TE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv5nPjls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv5nPjls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48CBC4CEF1;
	Mon, 23 Jun 2025 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685792;
	bh=ZWgMOVluDj9kMtwicgRB0n2bfY6GeNLQ2/z5iG9ZA0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv5nPjlssudrstgCJHGkuQwH4kzIGXtNO5u2wUNmV0DdnF7P8BNV84TselI0XLNGo
	 mdFqNhYzhM0iT8HrOzfWQgYrQAbBJz6YmHqRqxnKYWzTVU9PyM4PKwDwxaLL3acBe6
	 EgAas30RqH21K/PrXBwK57Ya6mL5XEKWtdRMKKm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 285/592] media: rkvdec: Initialize the m2m context before the controls
Date: Mon, 23 Jun 2025 15:04:03 +0200
Message-ID: <20250623130707.133245039@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit d43d7db3c8a1868dcbc6cb8de90a3cdf309d6cbb ]

Setting up the control handler calls into .s_ctrl ops. While validating
the controls the ops may need to access some of the context state, which
could lead to a crash if not properly initialized.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index a9bfd5305410c..65befffc35696 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -825,24 +825,24 @@ static int rkvdec_open(struct file *filp)
 	rkvdec_reset_decoded_fmt(ctx);
 	v4l2_fh_init(&ctx->fh, video_devdata(filp));
 
-	ret = rkvdec_init_ctrls(ctx);
-	if (ret)
-		goto err_free_ctx;
-
 	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(rkvdec->m2m_dev, ctx,
 					    rkvdec_queue_init);
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
-		goto err_cleanup_ctrls;
+		goto err_free_ctx;
 	}
 
+	ret = rkvdec_init_ctrls(ctx);
+	if (ret)
+		goto err_cleanup_m2m_ctx;
+
 	filp->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
 	return 0;
 
-err_cleanup_ctrls:
-	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+err_cleanup_m2m_ctx:
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 err_free_ctx:
 	kfree(ctx);
-- 
2.39.5



