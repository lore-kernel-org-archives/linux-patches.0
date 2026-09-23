Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D157486B8C;
	Wed, 23 Sep 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174463; cv=none; b=kZ9CPsNAan/SMp9k3Als9MN5LR18XS414wRcUxLbyWFgGJ205Di3HdbHYMTkLwKrgXWGXMWjIkTvhn7U+78F37DWOjZZtc6RxtZsfZNM0z7dyx74DeUn2yP37SF3Rz9zSOvNy7kwfhxzlX37SqxrKz6PTTwzuI2+Qi5zJsW9qtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174463; c=relaxed/simple;
	bh=qcJ75r+aBWSSyAknij+L5k3zTT8MYHq+ygixE0y1+WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYEctUkU0InStWAwdaugqufOYxKsVPFw9JuzSI/dQ/Ov79AG1L20OIPNYyalwIxJFhSfMpd58H32e32f3cIhIlQbrtiMV8H99/Zz5+7NH8VSBlIPCxob7S0bgpafTIm5bcv4kAAFFAGKSS0FzKlVWzbXuqgsCOyi41xnyO8uUKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW2yp6GJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW2yp6GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA001F000FF;
	Wed, 23 Sep 2026 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174462;
	bh=gJeElkjBcHhaN/arq9DEkXHGPA1cSGu8b6A8RaIQN5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xW2yp6GJnrMf3t/9hwoNIVNUYA4fvDUu/x+woUm+eopUIkjK9B8Qi7IlBNrP5+UGp
	 6CUb9m2zQREfblG3/r7y8R9MOqmNpgYXv31E3Mv6+nYpsmkgWJKjz4P3TKOXZ0emsb
	 bJoJVQY/3lFULI/A2FuH43BcauCAPUDJ4OgOtf3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/398] drm/xe/shrinker: Return the freed page count through a parameter
Date: Wed, 23 Sep 2026 16:03:16 +0200
Message-ID: <20260923140646.602882382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 3c90e42a01426262f0cd166bc01b45c05562640d ]

__xe_shrinker_walk() and xe_shrinker_walk() return either the number of
pages freed or a negative error, so the two cannot be reported at once.
On error the pages already freed are dropped, and since xe_shrinker_scan()
only accumulates non-negative returns while *scanned is updated by
pointer, the shrinker tells mm that it scanned without freeing.

Accumulate the count into a caller-provided counter and return only the
status, so an error no longer discards what the walk had freed.

Fixes: 00c8efc3180f ("drm/xe: Add a shrinker for xe bos")
Assisted-by: Claude:claude-opus-5
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260909162102.1097006-2-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit d7aac1a0235a6ce41e30cec385e2db8c33dad12d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_shrinker.c | 62 ++++++++++++++------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_shrinker.c b/drivers/gpu/drm/xe/xe_shrinker.c
index 90244fe59b599..8a50fea09ef47 100644
--- a/drivers/gpu/drm/xe/xe_shrinker.c
+++ b/drivers/gpu/drm/xe/xe_shrinker.c
@@ -54,13 +54,14 @@ xe_shrinker_mod_pages(struct xe_shrinker *shrinker, long shrinkable, long purgea
 	write_unlock(&shrinker->lock);
 }
 
-static s64 __xe_shrinker_walk(struct xe_device *xe,
+static int __xe_shrinker_walk(struct xe_device *xe,
 			      struct ttm_operation_ctx *ctx,
 			      const struct xe_bo_shrink_flags flags,
-			      unsigned long to_scan, unsigned long *scanned)
+			      unsigned long to_scan, unsigned long *scanned,
+			      unsigned long *freed)
 {
 	unsigned int mem_type;
-	s64 freed = 0, lret;
+	s64 lret;
 
 	for (mem_type = XE_PL_SYSTEM; mem_type <= XE_PL_TT; ++mem_type) {
 		struct ttm_resource_manager *man = ttm_manager_type(&xe->ttm, mem_type);
@@ -82,7 +83,7 @@ static s64 __xe_shrinker_walk(struct xe_device *xe,
 			if (lret < 0)
 				return lret;
 
-			freed += lret;
+			*freed += lret;
 			if (*scanned >= to_scan)
 				break;
 		}
@@ -90,7 +91,7 @@ static s64 __xe_shrinker_walk(struct xe_device *xe,
 		xe_assert(xe, !IS_ERR(ttm_bo));
 	}
 
-	return freed;
+	return 0;
 }
 
 /*
@@ -99,40 +100,35 @@ static s64 __xe_shrinker_walk(struct xe_device *xe,
  * add writeback. This avoids stalls and explicit writebacks with light or
  * moderate memory pressure.
  */
-static s64 xe_shrinker_walk(struct xe_device *xe,
+static int xe_shrinker_walk(struct xe_device *xe,
 			    struct ttm_operation_ctx *ctx,
 			    const struct xe_bo_shrink_flags flags,
-			    unsigned long to_scan, unsigned long *scanned)
+			    unsigned long to_scan, unsigned long *scanned,
+			    unsigned long *freed)
 {
 	bool no_wait_gpu = true;
 	struct xe_bo_shrink_flags save_flags = flags;
-	s64 lret, freed;
+	int ret;
 
 	swap(no_wait_gpu, ctx->no_wait_gpu);
 	save_flags.writeback = false;
-	lret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned);
+	ret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned, freed);
 	swap(no_wait_gpu, ctx->no_wait_gpu);
-	if (lret < 0 || *scanned >= to_scan)
-		return lret;
+	if (ret || *scanned >= to_scan)
+		return ret;
 
-	freed = lret;
 	if (!ctx->no_wait_gpu) {
-		lret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned);
-		if (lret < 0)
-			return lret;
-		freed += lret;
-		if (*scanned >= to_scan)
-			return freed;
+		ret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned,
+					 freed);
+		if (ret || *scanned >= to_scan)
+			return ret;
 	}
 
-	if (flags.writeback) {
-		lret = __xe_shrinker_walk(xe, ctx, flags, to_scan, scanned);
-		if (lret < 0)
-			return lret;
-		freed += lret;
-	}
+	if (flags.writeback)
+		ret = __xe_shrinker_walk(xe, ctx, flags, to_scan, scanned,
+					 freed);
 
-	return freed;
+	return ret;
 }
 
 static unsigned long
@@ -214,7 +210,6 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 	bool runtime_pm;
 	bool purgeable;
 	bool can_backup = !!(sc->gfp_mask & __GFP_FS);
-	s64 lret;
 
 	nr_to_scan = sc->nr_to_scan;
 
@@ -225,12 +220,9 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 	/* Might need runtime PM. Try to wake early if it looks like it. */
 	runtime_pm = xe_shrinker_runtime_pm_get(shrinker, false, nr_to_scan, can_backup);
 
-	if (purgeable && nr_scanned < nr_to_scan) {
-		lret = xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
-					nr_to_scan, &nr_scanned);
-		if (lret >= 0)
-			freed += lret;
-	}
+	if (purgeable && nr_scanned < nr_to_scan)
+		xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
+				 nr_to_scan, &nr_scanned, &freed);
 
 	sc->nr_scanned = nr_scanned;
 	if (nr_scanned >= nr_to_scan || !can_backup)
@@ -242,10 +234,8 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 
 	shrink_flags.purge = false;
 
-	lret = xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
-				nr_to_scan, &nr_scanned);
-	if (lret >= 0)
-		freed += lret;
+	xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
+			 nr_to_scan, &nr_scanned, &freed);
 
 	sc->nr_scanned = nr_scanned;
 out:
-- 
2.53.0



