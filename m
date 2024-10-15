Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E91A76DA;
	Tue, 15 Oct 2024 11:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992754; cv=none; b=VRtV9F3i0lCKMCsm5b4/92TUCoV9COnNpwiS7+gWVJL2oSpct4KHjE+vW2872+X7aa8qEu8hr6Fo11m6WQ0mtH8LEwBHM+PdMqprPgxNXkLvuLBwycQzCbUrWJI6G/P0nQtOAqZLLBqqKni6aDxH1S8e5OdyMcO1MH/pWmGfYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992754; c=relaxed/simple;
	bh=x0AT9vmK8oSKRLHeNtammqFCXyxJrTfQO1VbFYH2oxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJKfkknuahSh9aNh+OOZqemJfFMCyok3Uutpb4WzOPH59+wF3HQWvnxH9qzQxOJCF5xN8HOqpXGsa1P+UJgN1ZMiC2HYCw1B4f/7xTSCOSsOp2de7SX3yb0SjmEhs+R11Mt4vxK/v/Iisjin8f+UI3AyQ3zM9aMd4MMCf02vloo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAGpjO8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAGpjO8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9822FC4CEC6;
	Tue, 15 Oct 2024 11:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992754;
	bh=x0AT9vmK8oSKRLHeNtammqFCXyxJrTfQO1VbFYH2oxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAGpjO8RKnSVLJE3+WINEynDvpbg6RYSdBPwpzmPJCV7sw4IUfjtSycNPZyqQmrA3
	 2ecSj7pu9u6GwUssiqHLzDm8zv9J8C7b/k6t74tOTxlGV9s7xVY9/DTeb+kb4oANF6
	 h+5bm6VtR3DF/qM2Fx3qtfaHbXCghEE2Qz9XWKuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/691] drm/msm/a5xx: disable preemption in submits by default
Date: Tue, 15 Oct 2024 13:22:08 +0200
Message-ID: <20241015112447.506393964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit db9dec2db76146d65e1cfbb6afb2e2bd5dab67f8 ]

Fine grain preemption (switching from/to points within submits)
requires extra handling in command stream of those submits, especially
when rendering with tiling (using GMEM). However this handling is
missing at this point in mesa (and always was). For this reason we get
random GPU faults and hangs if more than one priority level is used
because local preemption is enabled prior to executing command stream
from submit.
With that said it was ahead of time to enable local preemption by
default considering the fact that even on downstream kernel it is only
enabled if requested via UAPI.

Fixes: a7a4c19c36de ("drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/612041/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index e9c8111122bd6..22aa05d08f5ea 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -152,9 +152,13 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_PKT7(ring, CP_SET_PROTECTED_MODE, 1);
 	OUT_RING(ring, 1);
 
-	/* Enable local preemption for finegrain preemption */
+	/*
+	 * Disable local preemption by default because it requires
+	 * user-space to be aware of it and provide additional handling
+	 * to restore rendering state or do various flushes on switch.
+	 */
 	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
-	OUT_RING(ring, 0x1);
+	OUT_RING(ring, 0x0);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
-- 
2.43.0



