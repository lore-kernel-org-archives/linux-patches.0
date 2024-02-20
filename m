Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6814A4E6;
	Tue, 20 Feb 2024 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464426; cv=none; b=uq51tsB8Xm27Plg7COawO39B66MbeNXH3qYCzXXxlyDz7PZAO/xLJWGj3V5qG+2iUCm92BgEHA6MXCYqoL04C/TEcXZFBjHCF4vv/+jezzhkbCfjJSl/RyXr/v1L2EXX1Suh0nOjMH1upOY9FoENzCAetGJgjvDO8usJh9qG/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464426; c=relaxed/simple;
	bh=6uFiHGqZxGywwR+I2sb/vfiV2RG9DO5s2JsQWfILvt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IH5WpONYVq6IDKCVHRnlESGohsGiTKrVf9RpL2ovWTENdOndjn9hVyQjgnUimV8otfP8HpV7zjH+wbz//rVcdi2hoDh0Ms23LyjSRJWcqYHUxPMIsZ+KfXK+TY3//QUxz9ZZJbsnk8gEEToh8hKwHS7s+cc7PyvxMKIEEXud5r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEAuREgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEAuREgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BD7C43390;
	Tue, 20 Feb 2024 21:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464426;
	bh=6uFiHGqZxGywwR+I2sb/vfiV2RG9DO5s2JsQWfILvt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEAuREgQ9eKsmX4bo5lmJEjJdjG2HPHa6Y/BsIQwHTPi2Jjan6wFXjTHXBwyCuKwc
	 7DU9iu0lBwvIcOxwVPzoSnaiDg8qLi9x3bDEr0Z/9tfPEAZnT+O7x4R3kvvJniS7hu
	 o4Nugbavn83uHsfVFHOPO59jWINwFv6lnZoCbgfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 021/309] drm/msm/gem: Fix double resv lock aquire
Date: Tue, 20 Feb 2024 21:53:00 +0100
Message-ID: <20240220205633.842184723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 03facb39d6c6433a78d0f79c7a146b1e6a61943e ]

Since commit 79e2cf2e7a19 ("drm/gem: Take reservation lock for vmap/vunmap
operations"), the resv lock is already held in the prime vmap path, so
don't try to grab it again.

v2: This applies to vunmap path as well
v3: Fix fixes commit

Fixes: 79e2cf2e7a19 ("drm/gem: Take reservation lock for vmap/vunmap operations")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Acked-by: Christian König <christian.koenig@amd.com>
Patchwork: https://patchwork.freedesktop.org/patch/576642/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_prime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index 5f68e31a3e4e..0915f3b68752 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -26,7 +26,7 @@ int msm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map)
 {
 	void *vaddr;
 
-	vaddr = msm_gem_get_vaddr(obj);
+	vaddr = msm_gem_get_vaddr_locked(obj);
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 	iosys_map_set_vaddr(map, vaddr);
@@ -36,7 +36,7 @@ int msm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map)
 
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, struct iosys_map *map)
 {
-	msm_gem_put_vaddr(obj);
+	msm_gem_put_vaddr_locked(obj);
 }
 
 struct drm_gem_object *msm_gem_prime_import_sg_table(struct drm_device *dev,
-- 
2.43.0



