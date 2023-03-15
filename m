Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D94431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049D1C43443;
	Wed, 15 Mar 2023 12:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882872;
	bh=w+0UgV/xH/5e0p6nE0ONsssNMM0Yzh/JK9dM1d3d1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0cJNC+q50ojfBHGI7cdI8loMtA0g+Pr3ImC6G3rA2a2wP9xCyREiFcI+UllP+rFP
	 17TKtAhfxJZAzYzlWUvHmu3yAHKIdvuI2pFKOhvhklMxMIEt+swweoomHRWs/8tD5z
	 qKmPpjvHj/DMYqORvA3lM5uz043ANiP+wU5q1AFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/104] drm/msm/a5xx: fix the emptyness check in the preempt code
Date: Wed, 15 Mar 2023 13:12:04 +0100
Message-Id: <20230315115733.395199739@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b4fb748f0b734ce1d2e7834998cc599fcbd25d67 ]

Quoting Yassine: ring->memptrs->rptr is never updated and stays 0, so
the comparison always evaluates to false and get_next_ring always
returns ring 0 thinking it isn't empty.

Fix this by calling get_rptr() instead of reading rptr directly.

Reported-by: Yassine Oudjana <y.oudjana@protonmail.com>
Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522642/
Link: https://lore.kernel.org/r/20230214020956.164473-4-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 183de1139eeb6..9da0aff0072d7 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -63,7 +63,7 @@ static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 		struct msm_ringbuffer *ring = gpu->rb[i];
 
 		spin_lock_irqsave(&ring->preempt_lock, flags);
-		empty = (get_wptr(ring) == ring->memptrs->rptr);
+		empty = (get_wptr(ring) == gpu->funcs->get_rptr(gpu, ring));
 		spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 		if (!empty)
-- 
2.39.2



