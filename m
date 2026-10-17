Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7483BE646;
	Sat, 17 Oct 2026 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255370; cv=none; b=XU6ZB9K4M2EMe/7aHJ2xPtiDgwoyWGdxeFUfnG/Mq4j6fmjkzCGV3wSwSqVGtrER4ht+JAB4Bc/29RhFPgjgZJZ/HGxhzqL3LZ1A0AknzaJMF9DUGP7QBs8SUBPxxOvBRmnUNbGdRjGjas+1mvnH9AN9g1yt1fXUFRctnYyXLtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255370; c=relaxed/simple;
	bh=TwycdgUvMiRxfXAEgeKmGO6vec33/YHL2xRGYnatu9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6POyxUiRqAyXfMeKhD/Hvs6n4Mb+UQaDXsxU6DrjJKJxbXMFH4UJozlYEm3OOSPNSI0w0NQEzsTFZy8yRMCezhzyrzS9Y3qau2faRsy4LVL4/elezaBs72IkQLsP0AMsuqIVbjBdIeCt+7nuea/WbCCMxhLtEXq5KQPP1dcRh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIlFg+8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIlFg+8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F701F000C5;
	Sat, 17 Oct 2026 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255369;
	bh=cfBk81sPzbonMPNG1JXhIwHfo5fPnVb6Q7HB0N1arI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIlFg+8oKO6qNmZ8+8euXZJTKhfJ33E7naRhkSOGzfkv/obHcvOoXsh/UtDUIJw6N
	 seglHHcOClJWreXh4+oUOn5LH7bf52ucX7e7u6WT0pyJELOYDSeCQdG8wLrSEDmZGz
	 pHD47YK46xbqB8p8Lx+aNn8WRpE15l3m7RluTCdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 700/869] drm/msm: Only fini scheduler after successful init
Date: Sat, 17 Oct 2026 17:59:01 +0200
Message-ID: <20261017160054.917358682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit e2332abed2a4d3caa59052095dc16e4ce44791ea ]

msm_ringbuffer_new() destroys a partially initialized ring through
msm_ringbuffer_destroy() when an allocation or scheduler setup step
fails.

If drm_sched_init() fails before it finishes initializing the scheduler,
the failure path still calls drm_sched_fini(). That teardown path assumes
the scheduler work items, lists, and workqueue state were initialized.

Track successful scheduler initialization and call drm_sched_fini() only
after drm_sched_init() returned 0.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 1d8a5ca436ee ("drm/msm: Conversion to drm scheduler")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/738905/
Message-ID: <20260709062309.4168362-1-ruoyuw560@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 7 ++++---
 drivers/gpu/drm/msm/msm_ringbuffer.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index 8a20355ca314a..917768a17a0b9 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -103,9 +103,9 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->memptrs_iova = memptrs_iova;
 
 	ret = drm_sched_init(&ring->sched, &args);
-	if (ret) {
+	if (ret)
 		goto fail;
-	}
+	ring->sched_initialized = true;
 
 	INIT_LIST_HEAD(&ring->submits);
 	spin_lock_init(&ring->submit_lock);
@@ -127,7 +127,8 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 	if (IS_ERR_OR_NULL(ring))
 		return;
 
-	drm_sched_fini(&ring->sched);
+	if (ring->sched_initialized)
+		drm_sched_fini(&ring->sched);
 
 	msm_fence_context_free(ring->fctx);
 
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index 0d6beb8cd39a7..72e4de1aafa2c 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -52,6 +52,7 @@ struct msm_ringbuffer {
 	 * The job scheduler for this ring.
 	 */
 	struct drm_gpu_scheduler sched;
+	bool sched_initialized;
 
 	/*
 	 * List of in-flight submits on this ring.  Protected by submit_lock.
-- 
2.53.0



