Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AFE18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17465C433C7;
	Wed, 20 Sep 2023 11:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210461;
	bh=Nc4pV7bevJHuTVVa7SJ5WaCeZXB78TAxwR0r2kO09DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBOPdKRsRuGc5uRsd1+2pVDRFE77BpWfavBR2/daIM4RSRsqcvpAFNGcmI2yr0+lw
	 xEfVIPeivttm+bo6uFnjsGN/zEzfvzb8GV+vcos92Thlk8i3BzXd1i836EFcGH3zxD
	 YyW5c2rqwSIRJsxwN7Lix5J34SbYpuo2Jro3lCaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 085/211] drm/exynos: fix a possible null-pointer dereference due to data race in exynos_drm_crtc_atomic_disable()
Date: Wed, 20 Sep 2023 13:28:49 +0200
Message-ID: <20230920112848.449787403@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 2e63972a2de14482d0eae1a03a73e379f1c3f44c ]

The variable crtc->state->event is often protected by the lock
crtc->dev->event_lock when is accessed. However, it is accessed as a
condition of an if statement in exynos_drm_crtc_atomic_disable() without
holding the lock:

  if (crtc->state->event && !crtc->state->active)

However, if crtc->state->event is changed to NULL by another thread right
after the conditions of the if statement is checked to be true, a
null-pointer dereference can occur in drm_crtc_send_vblank_event():

  e->pipe = pipe;

To fix this possible null-pointer dereference caused by data race, the
spin lock coverage is extended to protect the if statement as well as the
function call to drm_crtc_send_vblank_event().

Reported-by: BassCheck <bass@buaa.edu.cn>
Link: https://sites.google.com/view/basscheck/home
Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Added relevant link.
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 4153f302de7c4..d19e796c20613 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -39,13 +39,12 @@ static void exynos_drm_crtc_atomic_disable(struct drm_crtc *crtc,
 	if (exynos_crtc->ops->atomic_disable)
 		exynos_crtc->ops->atomic_disable(exynos_crtc);
 
+	spin_lock_irq(&crtc->dev->event_lock);
 	if (crtc->state->event && !crtc->state->active) {
-		spin_lock_irq(&crtc->dev->event_lock);
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
-		spin_unlock_irq(&crtc->dev->event_lock);
-
 		crtc->state->event = NULL;
 	}
+	spin_unlock_irq(&crtc->dev->event_lock);
 }
 
 static int exynos_crtc_atomic_check(struct drm_crtc *crtc,
-- 
2.40.1



