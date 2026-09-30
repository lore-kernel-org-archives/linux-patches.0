Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DCD320A37;
	Wed, 30 Sep 2026 19:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796984; cv=none; b=uHX9NVyZ2OjwyWokoUebALeaKuWlu7WLiB1tcrN9YvfXSGojh4VXdF/H35g6Dm2M0cmbsR51adCzzIhqIarStGRqk3vbhptCDnstLCwGijBQcOdttT4g2Ka9D/52StW7kJFce9wIlwVQyfERHOZ8ouF93hjVNQBY3M7ygDlE6a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796984; c=relaxed/simple;
	bh=Vo3ja5SHeIDzinK15ee/hysWKm0pSK8q+W1li37yicw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diJsC1HBnOLtPik/4wUMyO2Epbnekot3tJofzdWCEhsmatpdxictWCE5K//OPTqDInaMd00eFfNS8OteRhog/RAUVj5JhqTu41dXZtknsQ/kbOH5bb1iMGl9PCVWjrCMfe8wg3l07QPqA5RXIGUG2Mg9EQpEyvxb4F7e4jmeESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEXyWJhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEXyWJhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0021F000FF;
	Wed, 30 Sep 2026 19:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796983;
	bh=x/juyFRQeNzZDjbjH00DS0XgHgCbPHGmXKhMBZZ4iB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEXyWJhXSTMvQiVJQ0twULKm2I2aVIy1OJArDTw0K63c8JPbMrroOhYtDGUPrJvup
	 6kIjrEgGFYEHPiFEecC8IZaQKb5NSoqM1YWPs0sG3sSe0yte2IdvEc+tKal7Mw9vLV
	 aGtx3OPtP08AHG5uBMjX22/MyfPSdiCM9hiaLyhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 1107/1193] drm/i915: fix incorrect RCU teardown order
Date: Wed, 30 Sep 2026 17:29:51 +0200
Message-ID: <20260930152458.825679988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -86,6 +86,7 @@ struct drm_i915_gem_object *i915_gem_obj
 
 void i915_gem_object_free(struct drm_i915_gem_object *obj)
 {
+	dma_resv_fini(&obj->base._resv);
 	return kmem_cache_free(slab_objects, obj);
 }
 
@@ -137,7 +138,6 @@ void __i915_gem_object_fini(struct drm_i
 {
 	mutex_destroy(&obj->mm.get_page.lock);
 	mutex_destroy(&obj->mm.get_dma_page.lock);
-	dma_resv_fini(&obj->base._resv);
 }
 
 /**


