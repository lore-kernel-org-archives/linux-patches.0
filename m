Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC72A2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233E7C4339C;
	Tue,  7 Feb 2023 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775315;
	bh=luAWA2kmVjmQlSUsWDLmvjS1AZ+J8yi2TgyOPedMqM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+lyDYw7H8Gvyr7laxXs5aqrpiB9EbVcJsY4cqR4NZuDNp+TqQK0E7wF2WB0OCfer
	 mQ+SM4x3VqFHsnt9I9Gh0C5T7T/uMRnKF4M4d5Z3tZU3Mydz27Qw2WBvm1lkdr8NJw
	 fWT4RTZyHuEWeTeUcLuWg1JfLByn5igEXJUm7f4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 180/208] drm/i915: Fix potential bit_17 double-free
Date: Tue,  7 Feb 2023 13:57:14 +0100
Message-Id: <20230207125642.613555477@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

commit 7057a8f126f14f14b040faecfa220fd27c6c2f85 upstream.

A userspace with multiple threads racing I915_GEM_SET_TILING to set the
tiling to I915_TILING_NONE could trigger a double free of the bit_17
bitmask.  (Or conversely leak memory on the transition to tiled.)  Move
allocation/free'ing of the bitmask within the section protected by the
obj lock.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Cc: <stable@vger.kernel.org> # v5.5+
[tursulin: Correct fixes tag and added cc stable.]
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127200550.3531984-1-robdclark@gmail.com
(cherry picked from commit 10e0cbaaf1104f449d695c80bcacf930dcd3c42e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_tiling.c
@@ -305,10 +305,6 @@ i915_gem_object_set_tiling(struct drm_i9
 	spin_unlock(&obj->vma.lock);
 
 	obj->tiling_and_stride = tiling | stride;
-	i915_gem_object_unlock(obj);
-
-	/* Force the fence to be reacquired for GTT access */
-	i915_gem_object_release_mmap_gtt(obj);
 
 	/* Try to preallocate memory required to save swizzling on put-pages */
 	if (i915_gem_object_needs_bit17_swizzle(obj)) {
@@ -321,6 +317,11 @@ i915_gem_object_set_tiling(struct drm_i9
 		obj->bit_17 = NULL;
 	}
 
+	i915_gem_object_unlock(obj);
+
+	/* Force the fence to be reacquired for GTT access */
+	i915_gem_object_release_mmap_gtt(obj);
+
 	return 0;
 }
 


