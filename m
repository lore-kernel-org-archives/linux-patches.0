Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6922F24;
	Mon, 23 Jun 2025 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686061; cv=none; b=nrb+V9WwySPU4irmIRJCKfSy/ZTNxnsGdB9Fjpr2mZuhdbUXiilt3txaskW2Wp1KcBVL5XQls+pPoZL/FH0+DWQxUrtcYXafndGWJVaMy0pzPwtuNQS9Z3q6Ym87O8F4tNto+xL4FNVeeChtpg6dzlU9OFWS2dsfpKU30rEET0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686061; c=relaxed/simple;
	bh=3XmBoRokdptO0Vy+EZYZ66+Nu/HRKMKk5RmzoIjwuWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+kGLOSRG4YXat3hWHaCqE7X0Mji85ZY4vw6SWk1zVzizvVN8g/bn/xVsOx0PhjrZuekgmewbtTsRKhNlWtdt3C7vxaBTS02yfM/J4QS347aH0oZSXbH3uADBimWv24blb3uaDJS377fhTs3T3QmdUe7gGr0TI7+YfK8JRkLNu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnV7Hojj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnV7Hojj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8F8C4CEEA;
	Mon, 23 Jun 2025 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686060;
	bh=3XmBoRokdptO0Vy+EZYZ66+Nu/HRKMKk5RmzoIjwuWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnV7HojjFYwMdQP6mhtxMCXAnQqGy1ObQVjie6PjxpMT1jLdRGNz7J2eQhn6HH9ma
	 G0AqSvk/QxxccAE0JdqTzHbOYhxye1SEZrT7D5RLSvKUOv1UH01SWPqyso9pCzRES3
	 imNUjjPgMgiZooNQFulSPEFJQ15xBDeDegaH084U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 279/592] media: ti: cal: Fix wrong goto on error path
Date: Mon, 23 Jun 2025 15:03:57 +0200
Message-ID: <20250623130706.975189325@linuxfoundation.org>
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
 drivers/media/platform/ti/cal/cal-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti/cal/cal-video.c b/drivers/media/platform/ti/cal/cal-video.c
index e29743ae61e27..c16754c136ca0 100644
--- a/drivers/media/platform/ti/cal/cal-video.c
+++ b/drivers/media/platform/ti/cal/cal-video.c
@@ -758,7 +758,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	ret = pm_runtime_resume_and_get(ctx->cal->dev);
 	if (ret < 0)
-		goto error_pipeline;
+		goto error_unprepare;
 
 	cal_ctx_set_dma_addr(ctx, addr);
 	cal_ctx_start(ctx);
@@ -775,8 +775,8 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 error_stop:
 	cal_ctx_stop(ctx);
 	pm_runtime_put_sync(ctx->cal->dev);
+error_unprepare:
 	cal_ctx_unprepare(ctx);
-
 error_pipeline:
 	video_device_pipeline_stop(&ctx->vdev);
 error_release_buffers:
-- 
2.39.5



