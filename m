Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80E3115B8;
	Sat, 17 Oct 2026 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260234; cv=none; b=KIJ9Am9Bm/cX/LNppYOOCgxnGxNVtRZMgAp8y527WvJdGBxbBYcN0Mav7ITJefMWMhVewNinYnUGaKuFf1n5Lx84FnQvdyrIvbjPPX6zX4YIxoJgrK5bDrCx3pJES0khwWNdoKsDKSRTxpG2c3m2AVAMGP4rJeMyrtXIpCV197A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260234; c=relaxed/simple;
	bh=zXRBANqTZNlEZaVOqSa34PE+mD771Pzbp86K1g1hs00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3FfttcsbJ66cNTRbkYKHQTrA5uGYsXhV8B8yL2y/B6gQTvuFHg/MwQZ1Zb9aTnMV0lk0e/YI7iOx6M2x1ZCKqQg56yXN6MpzIRuk+HZFXRPRkCklPNPj/PMtJb86KBQaF1a4+SSDdLJaANTgOq0Mh7hJMn3zEtaqYQygrPdLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMx4EqJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMx4EqJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630E61F000C4;
	Sat, 17 Oct 2026 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260233;
	bh=wzqPM0DHherUmzqvHVuoE2ioafwlQOTUQFUdZCXidP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMx4EqJ9PqQ1l74/9ClmIHEyaK57k1HZBr7XBqfoIRvEoeE3gU4zhYvvngL8SO20Q
	 Q+K2YS5xieZeu2PkY248mmsiq1vqikalzL73IyvLZS28XEixz0jnZxFZ2fefgwmamX
	 8i7JmBSfrbdMP1CQV5llk/GoIRzqoSaRgGFAsqbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1477/1674] drm/msm: Only fini scheduler after successful init
Date: Sat, 17 Oct 2026 18:02:29 +0200
Message-ID: <20261017160509.070290288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca8e7e7af4741..ba9d51f47ffb6 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -101,9 +101,9 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->memptrs_iova = memptrs_iova;
 
 	ret = drm_sched_init(&ring->sched, &args);
-	if (ret) {
+	if (ret)
 		goto fail;
-	}
+	ring->sched_initialized = true;
 
 	INIT_LIST_HEAD(&ring->submits);
 	spin_lock_init(&ring->submit_lock);
@@ -125,7 +125,8 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 	if (IS_ERR_OR_NULL(ring))
 		return;
 
-	drm_sched_fini(&ring->sched);
+	if (ring->sched_initialized)
+		drm_sched_fini(&ring->sched);
 
 	msm_fence_context_free(ring->fctx);
 
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index 698b333abccd6..eafaa7cef3242 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -50,6 +50,7 @@ struct msm_ringbuffer {
 	 * The job scheduler for this ring.
 	 */
 	struct drm_gpu_scheduler sched;
+	bool sched_initialized;
 
 	/*
 	 * List of in-flight submits on this ring.  Protected by submit_lock.
-- 
2.53.0



