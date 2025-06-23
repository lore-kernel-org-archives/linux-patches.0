Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091114409;
	Mon, 23 Jun 2025 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716093; cv=none; b=oXDu1KkHmuJ/fOSV75I+J9sFYfexhvHKdZ5h9c8WfdOZvca9ccYTOcp9UuZStKpxalGvhEY3BlpuByYRJZYoIutE6u93AbpoQrgQEBoWNJS0xA9Z6wlEV1MX0lEfoveOtvBFJfnul3oFbI+EL8ISGtc+6JOU5xO4/xdW4Uq1TE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716093; c=relaxed/simple;
	bh=X/zI9ankXMLBAzBSpOF1oSD1h5+AiRshnH7hjhdmg30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAVCoe8Rw/d7uECvZOgGEFsfroKLGUs4I8JxorZRwrGVLteeXxlWdR7XHT3vqTYxF8M8J1FfvT/E/tHH4q9OvTsF/LGbGRyNR0yKhZfZcITB32rqscbCk2dJySFBrW5ZQXtTbyNWUOxdoWO6/VelLcD8a1o0loT9KIUGQcftGhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+kzBkA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+kzBkA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E48C4CEEA;
	Mon, 23 Jun 2025 22:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716092;
	bh=X/zI9ankXMLBAzBSpOF1oSD1h5+AiRshnH7hjhdmg30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+kzBkA1opZAT4Bv96VS1fZE9Q3lpsaMsBuMKgTM1ExNQzvJ9dXHdyAwPuUTQIJ6v
	 YE4ueb6ketnRSORGqAjYlMg2bAbjRC1TuiCL6MCO31tFZIKzTj1wbWySFk7owKVCo+
	 d1S3NycWwTqDT8WGTZyu+2Ey/bKh+pRIoDWvENWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/411] media: ti: cal: Fix wrong goto on error path
Date: Mon, 23 Jun 2025 15:07:13 +0200
Message-ID: <20250623130640.921507648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit a5b18fd769b7dc2e77a9e6a390844cbf50626ae8 ]

If pm_runtime_resume_and_get() fails, we should unprepare the context,
but currently we skip that as we goto to a later line.

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal-video.c b/drivers/media/platform/ti-vpe/cal-video.c
index d87177d04e921..2e93c1b8f3597 100644
--- a/drivers/media/platform/ti-vpe/cal-video.c
+++ b/drivers/media/platform/ti-vpe/cal-video.c
@@ -744,7 +744,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	ret = pm_runtime_resume_and_get(ctx->cal->dev);
 	if (ret < 0)
-		goto error_pipeline;
+		goto error_unprepare;
 
 	cal_ctx_set_dma_addr(ctx, addr);
 	cal_ctx_start(ctx);
@@ -761,8 +761,8 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 error_stop:
 	cal_ctx_stop(ctx);
 	pm_runtime_put_sync(ctx->cal->dev);
+error_unprepare:
 	cal_ctx_unprepare(ctx);
-
 error_pipeline:
 	media_pipeline_stop(&ctx->vdev.entity);
 error_release_buffers:
-- 
2.39.5



