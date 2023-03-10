Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D98489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B00C4339B;
	Fri, 10 Mar 2023 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457845;
	bh=06DzgdHzH8eY8KzCTJnDJv99Wvx9apdUuqmEj/v3Rdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awD9SCM/Mcz4NqnLkjbaCuGSizyR62NT/F4+PBDmcYxEzpQ74CrRR6UMjdMpPMa16
	 f5YzRDw1SB9xetSBTj7B9VDaN5GHBK+V7khyDuA6OlfUA08T1Dy7Ppbr23bW36ePXC
	 rlLN5VVb41tOoeRI4uMLyG/OWx2G/gwk0JweFyYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/252] drm/msm: use strscpy instead of strncpy
Date: Fri, 10 Mar 2023 14:37:27 +0100
Message-Id: <20230310133721.160669063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

[ Upstream commit d7fd8634f48d76aa799ed57beb7d87dab91bde80 ]

Using strncpy can result in non-NULL-terminated destination string. Use
strscpy instead. This fixes following warning:

drivers/gpu/drm/msm/msm_fence.c: In function ‘msm_fence_context_alloc’:
drivers/gpu/drm/msm/msm_fence.c:25:9: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]
   25 |         strncpy(fctx->name, name, sizeof(fctx->name));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: f97decac5f4c ("drm/msm: Support multiple ringbuffers")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/518787/
Link: https://lore.kernel.org/r/20230118020152.1689213-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index 6c11be79574e5..ef79c3661acb4 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -31,7 +31,7 @@ msm_fence_context_alloc(struct drm_device *dev, const char *name)
 		return ERR_PTR(-ENOMEM);
 
 	fctx->dev = dev;
-	strncpy(fctx->name, name, sizeof(fctx->name));
+	strscpy(fctx->name, name, sizeof(fctx->name));
 	fctx->context = dma_fence_context_alloc(1);
 	init_waitqueue_head(&fctx->event);
 	spin_lock_init(&fctx->spinlock);
-- 
2.39.2



