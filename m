Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C5E51476F;
	Wed, 30 Sep 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789452; cv=none; b=X90Ff9+ghhKRe395wdLGAjoAC/eMR2/HZrb3HjXwCUKEl4Py8Rn76YGXHdw9rcQL+7ZbVqiZMJNB+NirlNtLKGCBKRVBMIh18WCKCOO+/nxgEGL6VrVjKwdRmQc7zXXKIyF/t1zNY0gmINxgxBJovKH2xU162ijuR0ZVpATScZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789452; c=relaxed/simple;
	bh=H2DujFTHu47CGQ2Psqf2piEbGtUqv9vY2vpETShg3sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmDUl3lZLKymDhUdsLVnw6mr/chJl32zGcTp3xnenChmZCdReOAqcvYjUDR3d5ZYslpmvUvH1RSGD9gViPTWFhUJRhQC18DtFqUU7cs8D+dIvXB4F5m5JwZuB1XFlDGhkr3As5qcmnEevVgHlttk6DayUMDc5t59MbuQJ3fKdAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMO7TR9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMO7TR9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E95A1F000FF;
	Wed, 30 Sep 2026 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789451;
	bh=c9dTthGSPIQgiLyxxGTyeTUSyUUORvyZuaJNsQjwb88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMO7TR9s7rZ2qKXez6fqCgXFkbKmpX+KzLKzEZO0HDPbFvbrzw0ADXS6MyMJkc5Hh
	 Sat+8ThZchdF/5r4pg6KujauUF/bBWpJ5I7IaD93HxTN/Ovc0S9YODmvWGhwrgi+Ed
	 F2lv+pdBmBq4SPqa2JdTs4OsxL/AZ6YT6m/qiFvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 481/877] drm/i915: fix incorrect RCU teardown order
Date: Wed, 30 Sep 2026 17:23:12 +0200
Message-ID: <20260930152425.047228603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <ckoenig.leichtzumerken@gmail.com>

commit d2da6696e0c4e60414706e607029d0bb0330c67e upstream.

i915_gem_busy_ioctl uses dma_resv_for_each_fence_unlocked() to iterate
over the fences in an GEM object without holding a reference but only
the RCU read side lock.

What can happen here is that the GEM object is destroyed concurrently
while i915_gem_busy_ioctl is still running. This won't free the GEM
objects memory, but still drops all the dma_fence references.

Now when dma_resv_for_each_fence_unlocked() sees a destroyed dma_fence it
assumes that a new fence list was installed and re-starts the loop.

But in the case of a destroyed GEM object a new fence list is never
installed, only the old one freed and therefore the iteration never
finishes resulting in an endless loop.

The solution is to drop the fence references only after the RCU grace
period.

The fixes tag is not necessary the patch introducing the problem, but the
one making it so worse that we need to address it.

This problem was pointed out by Sashiko-bot.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 912ff2ebd695 ("drm/i915: use the new iterator in i915_gem_busy_ioctl v2")
CC: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260903113621.54660-1-christian.koenig@amd.com
(cherry picked from commit 5113479556025093bf8133bb2dcaa33be2d50921)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -87,6 +87,7 @@ struct drm_i915_gem_object *i915_gem_obj
 
 void i915_gem_object_free(struct drm_i915_gem_object *obj)
 {
+	dma_resv_fini(&obj->base._resv);
 	return kmem_cache_free(slab_objects, obj);
 }
 
@@ -142,7 +143,6 @@ void __i915_gem_object_fini(struct drm_i
 {
 	mutex_destroy(&obj->mm.get_page.lock);
 	mutex_destroy(&obj->mm.get_dma_page.lock);
-	dma_resv_fini(&obj->base._resv);
 }
 
 /**


