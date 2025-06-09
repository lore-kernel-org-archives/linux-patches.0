Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B617E0;
	Mon,  9 Jun 2025 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476819; cv=none; b=ZK9S+qOY09WLmH3UjKMGdY1ltVEURzgO+w54E1iG0FvtzAjFzjIepaum0bctpBPAQA9nHzQHFV8M/zKRMyIFpILUTNjM658QFEHI0WFs1AdXY1eSgfhhVMUtmRnwAfY0pvVa9N9UCi+pFkntHqahVHu89AoyEjt9j6YSlIhOrgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476819; c=relaxed/simple;
	bh=4xgaNV/25Sr/6yY7vJhhNXhnqW3+Pt0AiV/ZUqM58gE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyFQ7R21Guwg8AX05CKMoi4g6668CbQJSa1UWy0JKg7Z0O3LaSCcT5eHs5LiuC9uFXk9iHTiRmj7vEsjXDRHW41s5AXkWTIUD3ljJj2+LmoB05lNA5Q0EOQx/uTqckc0C/3lnp54UuC9aSplh4w1x8nJ5OdPr7lGvtMZ91UmTwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFLBMo0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFLBMo0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19403C4CEED;
	Mon,  9 Jun 2025 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476819;
	bh=4xgaNV/25Sr/6yY7vJhhNXhnqW3+Pt0AiV/ZUqM58gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFLBMo0HaGb3bx7MOrE9pSIbkft90hMgha7rlsBZJVU0611gat6KdQOw523CxVEOz
	 c95py1l3Bi22fxoXd9ll4wXWgg+/ubKAOWLJDrP28FQjuoBOg5S36e09kDO82Q4+3n
	 ZhMQgLu0WQ5nTXzFlOu3f09mkcKaDz7AfjifDh+Vj7Vq7pPS/8WeK4rUSCiSpVwOUx
	 XIYOYb/KM38Nys8a7Cg9c5LDW6yBGnNz4jJLWcYAbXU7kOfKd+LXMixq8brTGZAAOy
	 rbWRGnk/9ETEaXDLeo9aspUe22b4rVXGl8NczMDxMI3OdaByxA38hjpbwAtpjdky9o
	 AIoSBuY/A854g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Lin.Cao" <lincao12@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	dakr@kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.6 04/18] drm/scheduler: signal scheduled fence when kill job
Date: Mon,  9 Jun 2025 09:46:38 -0400
Message-Id: <20250609134652.1344323-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134652.1344323-1-sashal@kernel.org>
References: <20250609134652.1344323-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: "Lin.Cao" <lincao12@amd.com>

[ Upstream commit 471db2c2d4f80ee94225a1ef246e4f5011733e50 ]

When an entity from application B is killed, drm_sched_entity_kill()
removes all jobs belonging to that entity through
drm_sched_entity_kill_jobs_work(). If application A's job depends on a
scheduled fence from application B's job, and that fence is not properly
signaled during the killing process, application A's dependency cannot be
cleared.

This leads to application A hanging indefinitely while waiting for a
dependency that will never be resolved. Fix this issue by ensuring that
scheduled fences are properly signaled when an entity is killed, allowing
dependent applications to continue execution.

Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250515020713.1110476-1-lincao12@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **This is a Critical Bug Fix**

The commit fixes a serious bug where applications can hang indefinitely
when they depend on scheduled fences from killed jobs. The specific
change adds a single line:

```c
+       drm_sched_fence_scheduled(job->s_fence, NULL);
```

This line signals the scheduled fence when killing a job, which was
previously missing and caused the hang.

### 2. **Clear User-Visible Impact**

From the commit message:
- Application A's job depends on a scheduled fence from Application B's
  job
- When Application B is killed, the fence was not properly signaled
- This causes Application A to hang indefinitely waiting for a
  dependency that will never resolve

This is a real-world scenario that affects system stability and user
experience.

### 3. **Minimal and Safe Change**

The fix is:
- **One line addition** - extremely minimal change
- **Well-contained** - only affects the job kill path
- **No API/ABI changes** - just adds a missing fence signal
- **No new features** - purely fixes existing broken behavior

### 4. **Comparison with Similar Commits**

Looking at the historical commits provided:

**Similar Commit #1 (Backported: YES)** - "drm/scheduler: fix fence ref
counting"
- Fixed dependency fence leaks when processes were killed
- Added proper fence reference management
- Similar in nature: fixing fence handling in the kill path

This commit shares key characteristics:
- Fixes fence handling bugs in entity kill path
- Prevents resource leaks/hangs
- Minimal, targeted fix

The other similar commits (NOT backported) were either:
- Large architectural changes (Commit #3 - complete rework of dependency
  handling)
- Feature additions (Commit #4 - new error handling logic)
- Less critical fixes (Commit #5 - memleak in uncommon path)

### 5. **Risk Assessment**

**Low Risk**:
- The change only affects the error/kill path, not normal operation
- Signaling a fence with NULL is a valid operation indicating no
  hardware execution
- The `drm_sched_fence_finished()` call immediately after still signals
  completion with error
- No changes to data structures or algorithms

### 6. **Follows Stable Kernel Rules**

According to stable kernel rules, this commit qualifies because it:
- ✓ Fixes a real bug that affects users (application hangs)
- ✓ Is already in Linus's tree (has proper Link: tag)
- ✓ Is small and self-contained (1 line)
- ✓ Has been reviewed (Reviewed-by: tag present)
- ✓ Doesn't introduce new features
- ✓ Has clear problem description and solution

### 7. **Technical Details**

The fix ensures proper fence signaling order:
1. `drm_sched_fence_scheduled(job->s_fence, NULL)` - signals that the
   job was "scheduled" (even though it won't run)
2. `drm_sched_fence_finished(job->s_fence, -ESRCH)` - signals completion
   with error

This allows dependent jobs waiting on the scheduled fence to proceed and
handle the error appropriately, preventing indefinite hangs.

## Conclusion

This commit is an ideal candidate for stable backporting. It fixes a
serious user-visible bug (application hangs) with a minimal, well-
understood change that follows the established fence signaling pattern
in the DRM scheduler. The fix is similar in nature to previous commits
that were successfully backported, and the risk of regression is very
low since it only affects the error handling path.

 drivers/gpu/drm/scheduler/sched_entity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 53130a50584ca..eed3b8bed9e40 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -167,6 +167,7 @@ static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
+	drm_sched_fence_scheduled(job->s_fence, NULL);
 	drm_sched_fence_finished(job->s_fence, -ESRCH);
 	WARN_ON(job->s_fence->parent);
 	job->sched->ops->free_job(job);
-- 
2.39.5

