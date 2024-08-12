Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61752C1A5;
	Mon, 12 Aug 2024 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480309; cv=none; b=sCa29S5XbScsIg8K59bWk4Z1xlxyKhMO2XEtsHNztLc7yyRlMpu1XagYPybpeyHYaMj5MlkfYQ+stHXh24hV9aFYZw0C6nK90XblHUusrXqLJNIjxJAD9DXzhT+GK8cO1VR32JZiJNyESMER2imlQ2gJcxIbgT0yE3qNzFsduas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480309; c=relaxed/simple;
	bh=LsCaPVwE3QEcTNxwy/AmBVR8I1GRsvYFN7nMRezlY7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdVFr1CzVbJOpo/u1QznU8OpdARwTUrKyFSCYlXLKlxSC+TsPWHQHqjOt8O26ZM+cCDqr+Tsx82y5Tmh1vXdWQNuIrk6VRIUA8XgLATYNy0cRO+LnqiOsqsjf9620iSLAQ9WlMRc8aDSn+/ifnd5+7PBmHVEjp0JzEyhHUABElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDr8aTkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDr8aTkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC90C32782;
	Mon, 12 Aug 2024 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480309;
	bh=LsCaPVwE3QEcTNxwy/AmBVR8I1GRsvYFN7nMRezlY7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDr8aTkt0VotwdV8SnkTw9NJL3tyiggxsoGW5yn6uT9DPh+A5KEBU4C8tSv7QflwK
	 KOslYBYaYdetMtLWGab9a3fVympRSDc6J45nm5wmcf6LyOa+Q8LqzYZ0opz+MFTFwJ
	 t6tVQvgQF+v9o6y0voUxLEDxb84krPXRur+7PEpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 159/263] drm/i915: Attempt to get pages without eviction first
Date: Mon, 12 Aug 2024 18:02:40 +0200
Message-ID: <20240812160152.633348201@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 787db3bb6ed5cee56fc97fecdd61517d89763f0a ]

In commit a78a8da51b36 ("drm/ttm: replace busy placement with flags v6"),
__i915_ttm_get_pages was updated to use flags instead of the separate
'busy' placement list. However, the behaviour was subtly changed.
Originally, the function would attempt to use the preferred placement
without eviction, and give an opportunity to restart the operation
before falling back to allowing eviction.

This was unintentionally changed, as the preferred placement was not
given the TTM_PL_FLAG_DESIRED flag, and so eviction could be triggered
in that first pass. This caused thrashing, and a significant performance
regression on DG2 systems with small BAR. For example, Minecraft and
Team Fortress 2 would drop to single-digit framerates.

Restore the original behaviour by marking the initial placement as
desired on that first attempt. Also, rework this to use a separate
struct ttm_palcement, as the individual placements are marked 'const',
so hot-patching the flags is even more dodgy than before.

Thanks to Justin Brewer for bisecting this.

Fixes: a78a8da51b36 ("drm/ttm: replace busy placement with flags v6")
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11255
Signed-off-by: David Gow <david@davidgow.net>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240804091851.122186-3-david@davidgow.net
(cherry picked from commit 92653f2a572505adaf7f13f695c1907e71a1dc84)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index fb848fd8ba15a..5c72462d1f57e 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -778,13 +778,16 @@ static int __i915_ttm_get_pages(struct drm_i915_gem_object *obj,
 		.interruptible = true,
 		.no_wait_gpu = false,
 	};
-	int real_num_busy;
+	struct ttm_placement initial_placement;
+	struct ttm_place initial_place;
 	int ret;
 
 	/* First try only the requested placement. No eviction. */
-	real_num_busy = placement->num_placement;
-	placement->num_placement = 1;
-	ret = ttm_bo_validate(bo, placement, &ctx);
+	initial_placement.num_placement = 1;
+	memcpy(&initial_place, placement->placement, sizeof(struct ttm_place));
+	initial_place.flags |= TTM_PL_FLAG_DESIRED;
+	initial_placement.placement = &initial_place;
+	ret = ttm_bo_validate(bo, &initial_placement, &ctx);
 	if (ret) {
 		ret = i915_ttm_err_to_gem(ret);
 		/*
@@ -799,7 +802,6 @@ static int __i915_ttm_get_pages(struct drm_i915_gem_object *obj,
 		 * If the initial attempt fails, allow all accepted placements,
 		 * evicting if necessary.
 		 */
-		placement->num_placement = real_num_busy;
 		ret = ttm_bo_validate(bo, placement, &ctx);
 		if (ret)
 			return i915_ttm_err_to_gem(ret);
-- 
2.43.0



