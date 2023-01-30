Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4064528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98889C433D2;
	Mon, 30 Jan 2023 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086985;
	bh=cUU1aRo6HSj4DaLlkf/JYxR0YlomfgTIUj+GT8mhEoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7bBNJm8252K+lHq9uEgiHc45WH2sWB5tqqQayReiMnGIqhpT+aOe1J1QkVIkUZin
	 W7nvRPAsBOxHPjlYKmMmMUZx3gMN/9p2kF1Uo7kVppjH71Mszo0r2GBxMwZ0bvXbw4
	 6jh1huQgHo2OIWUO3NjvDs0RbmzJOQrVtYdWZ/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/313] drm/vc4: bo: Fix drmm_mutex_init memory hog
Date: Mon, 30 Jan 2023 14:48:16 +0100
Message-Id: <20230130134339.533874079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 07a2975c65f2be2e22591d795a9c39b00f95fd11 ]

Commit 374146cad469 ("drm/vc4: Switch to drmm_mutex_init") converted,
among other functions, vc4_create_object() to use drmm_mutex_init().

However, that function is used to allocate a BO, and therefore the
mutex needs to be freed much sooner than when the DRM device is removed
from the system.

For each buffer allocation we thus end up allocating a small structure
as part of the DRM-managed mechanism that is never freed, eventually
leading us to no longer having any free memory anymore.

Let's switch back to mutex_init/mutex_destroy to deal with it properly.

Fixes: 374146cad469 ("drm/vc4: Switch to drmm_mutex_init")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230112091243.490799-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 231add8b8e12..ab2573525d77 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -179,6 +179,7 @@ static void vc4_bo_destroy(struct vc4_bo *bo)
 		bo->validated_shader = NULL;
 	}
 
+	mutex_destroy(&bo->madv_lock);
 	drm_gem_dma_free(&bo->base);
 }
 
@@ -406,9 +407,7 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 	bo->madv = VC4_MADV_WILLNEED;
 	refcount_set(&bo->usecnt, 0);
 
-	ret = drmm_mutex_init(dev, &bo->madv_lock);
-	if (ret)
-		return ERR_PTR(ret);
+	mutex_init(&bo->madv_lock);
 
 	mutex_lock(&vc4->bo_lock);
 	bo->label = VC4_BO_TYPE_KERNEL;
-- 
2.39.0



