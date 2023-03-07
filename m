Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E80BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008B2C433EF;
	Tue,  7 Mar 2023 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211871;
	bh=kOz2Ku7XhOjq2b6BWWyE6jt3Eqg6VwTeGTTfFzpchiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qAZbX9JSoRJ3S68pt4luaMJUVSC7Ovn/rNeDvNnPFcMW0JjWTz77VaoIKIt6ctgo
	 eC+Rl68sms6+DL0Bg8fTBy5QBBZvc9ThvUoQZ2BTz4jseOL6nhqUQp1JQehy/BN8u2
	 CcD2mVghClC16zvsMn06UJdsuTis8rpVJ63XNjCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	intel-gfx@lists.freedesktop.org,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 0997/1001] drm/i915: Dont use stolen memory for ring buffers with LLC
Date: Tue,  7 Mar 2023 18:02:49 +0100
Message-Id: <20230307170105.569062646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Harrison <John.C.Harrison@Intel.com>

commit 690e0ec8e63da9a29b39fedc6ed5da09c7c82651 upstream.

Direction from hardware is that stolen memory should never be used for
ring buffer allocations on platforms with LLC. There are too many
caching pitfalls due to the way stolen memory accesses are routed. So
it is safest to just not use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: c58b735fc762 ("drm/i915: Allocate rings from stolen")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-2-John.C.Harrison@Intel.com
(cherry picked from commit f54c1f6c697c4297f7ed94283c184acc338a5cf8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -116,7 +116,7 @@ static struct i915_vma *create_ring_vma(
 
 	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE |
 					  I915_BO_ALLOC_PM_VOLATILE);
-	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt))
+	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);


