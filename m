Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938F3D3CEC;
	Thu,  5 Mar 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725047; cv=none; b=VEmwX32JJUZx6AJw4aEJ/vjIXArUh8Qdd6MuK9oIY+OigsJ8YPAGfIZlbKFO77cSTQXQiilU1j99CiRU9m+igIeEiuduQn9ZQ4S0DVAXGphUtBW4MKc9y5z9mYkb3vGiFkoYJOyqNLh/KVXTkZPKOFZcKBYYOChTTbN6uukNyFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725047; c=relaxed/simple;
	bh=gtdfbBijqUhBdwEAgJ/XmjyU1cog7CX3srrrURFT14Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYsa2D0zC4ukgsxk5XfGRwtN9Kjgvz+vw0zUBjStGW2ktXEYX+7FfLV2t9Rju5jPQYn0VwkQP44382DbiEvvVxjCXWfa6NoWtywtxvPzf8q3psXDatbz0xPVaan46+6tQvw6ykcwUK3xF5PwWtLTOpnHQOcHagZjD3T7dF07b+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d78NbGRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d78NbGRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF4EC116C6;
	Thu,  5 Mar 2026 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725047;
	bh=gtdfbBijqUhBdwEAgJ/XmjyU1cog7CX3srrrURFT14Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d78NbGRrzdjaSnAICg9jLYPM56dlz9m0ThBwDgq8Nlm40mzdwlwgFibOzwhDsORA7
	 wL5btz4j0XS3GGkYWmBRtxXt5vPnpAu6UpTksGcWj2fOh/9sWTi+sTqnajWNmd0Le2
	 azCTQaDPCrYm8x+Qbg4dHfxi5yh1t6iLPdAQjUlK9gQs8RgECM8xg6vVi3nk2juJy7
	 Fdd1HL3rvXSWlXyqkfXfL5j0ViCqCsh7ms8yCEnNnB9hyUErut+bnc3sdMDbj1OHur
	 YCHipcIjBeRIx3Y5kJj6ydPpINPqi58jvqz6uL5Nh85q+ZehEt9J0R3N9h7n4S4lMo
	 /xnkUmX4JeJKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haocheng Yu <yuhaocheng035@gmail.com>,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] perf/core: Fix refcount bug and potential UAF in perf_mmap
Date: Thu,  5 Mar 2026 10:36:58 -0500
Message-ID: <20260305153704.106918-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haocheng Yu <yuhaocheng035@gmail.com>

[ Upstream commit 77de62ad3de3967818c3dbe656b7336ebee461d2 ]

Syzkaller reported a refcount_t: addition on 0; use-after-free warning
in perf_mmap.

The issue is caused by a race condition between a failing mmap() setup
and a concurrent mmap() on a dependent event (e.g., using output
redirection).

In perf_mmap(), the ring_buffer (rb) is allocated and assigned to
event->rb with the mmap_mutex held. The mutex is then released to
perform map_range().

If map_range() fails, perf_mmap_close() is called to clean up.
However, since the mutex was dropped, another thread attaching to
this event (via inherited events or output redirection) can acquire
the mutex, observe the valid event->rb pointer, and attempt to
increment its reference count. If the cleanup path has already
dropped the reference count to zero, this results in a
use-after-free or refcount saturation warning.

Fix this by extending the scope of mmap_mutex to cover the
map_range() call. This ensures that the ring buffer initialization
and mapping (or cleanup on failure) happens atomically effectively,
preventing other threads from accessing a half-initialized or
dying ring buffer.

Closes: https://lore.kernel.org/oe-kbuild-all/202602020208.m7KIjdzW-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Haocheng Yu <yuhaocheng035@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260202162057.7237-1-yuhaocheng035@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the race scenario. `perf_event_set_output()` acquires
`output_event->mmap_mutex` and then calls `ring_buffer_get()` which
increments the refcount. If the mmap_mutex was released after
`perf_mmap_rb()` set `event->rb` but before cleanup on `map_range()`
failure, another thread can observe `event->rb` and attempt to get the
ring buffer.

## Analysis

### 1. COMMIT MESSAGE ANALYSIS
The commit clearly describes a **race condition** leading to a **use-
after-free** and **refcount saturation warning** in `perf_mmap()`. It
was:
- **Reported by**: kernel test robot (syzkaller-like automated testing)
- **Signed-off by**: Peter Zijlstra (Intel), the perf subsystem
  maintainer
- **Link to report**: Provided via `Closes:` tag

### 2. CODE CHANGE ANALYSIS
The fix is **purely a scope change** - it extends the existing
`scoped_guard(mutex, &event->mmap_mutex)` to cover the `map_range()`
call and associated cleanup. Specifically:

**Before**: The mutex was released at line 7191 (closing brace of
`scoped_guard`), then `vm_flags_set()`, `mapped()` callback, and
`map_range()` all ran without the mutex. If `map_range()` failed and
`perf_mmap_close()` was called, a concurrent thread could race in
between.

**After**: All of `vm_flags_set()`, `mapped()`, `map_range()`, and
`perf_mmap_close()` (on failure) run inside the `scoped_guard`, closing
the race window.

The race scenario:
1. Thread A: acquires `mmap_mutex`, allocates rb, assigns `event->rb`,
   releases mutex
2. Thread B: acquires `mmap_mutex`, sees valid `event->rb`, calls
   `ring_buffer_get()` (refcount increment)
3. Thread A: `map_range()` fails, calls `perf_mmap_close()` which drops
   refcount to 0
4. Thread B: now holds a reference to a freed ring buffer → UAF

### 3. CLASSIFICATION
- **Bug type**: Race condition → use-after-free / refcount corruption
- **Severity**: HIGH - UAF is a security-class bug (exploitable from
  userspace via perf syscall)
- **Subsystem**: perf/core - widely used, security-sensitive subsystem

### 4. SCOPE AND RISK
- **Size**: 1 file, 38 lines changed (19 insertions, 19 deletions) -
  essentially indentation changes moving code into the existing
  scoped_guard block
- **Risk**: LOW - the fix simply holds a mutex for longer, covering
  operations that logically should have been protected. The only risk is
  holding the mutex across `map_range()`, but `map_range()` doesn't take
  any conflicting locks.
- **Regression potential**: Minimal - holding a mutex slightly longer
  might theoretically increase contention, but `perf_mmap()` is not a
  hot path (called during mmap setup, not during data collection)

### 5. USER IMPACT
- perf is used by virtually all Linux deployments for profiling
- The race can be triggered from userspace with concurrent mmap
  operations
- Found by automated fuzzing (kernel test robot), meaning it's reachable

### 6. DEPENDENCIES
- **Requires**: `scoped_guard` for mmap_mutex (commit d23a6dbc0a717, in
  v6.18+) - **present in 6.19.y**
- **Requires**: `map_range()` and `perf_mmap_close()` on failure path
  (commit f74b9f4ba63ff, in v6.17+) - **present in 6.19.y**
- For older stable trees (6.17.y, 6.12.y, etc.), this would need
  adaptation since the `scoped_guard` pattern and `map_range()` function
  may not exist. The underlying race exists but the fix would need to be
  written differently.

### 7. STABILITY
- Signed-off by Peter Zijlstra, the perf maintainer
- Already merged into mainline (v7.0 merge window)
- Clean, minimal change with clear logic

### Verification

- **git log showed** commit 77de62ad3de39 exists and is authored by
  Haocheng Yu, signed by Peter Zijlstra (Intel) - **verified**
- **git merge-base** confirmed the commit is NOT yet in the 6.19.y
  stable tree (HEAD = v6.19.6) - **verified**
- **git merge-base** confirmed prerequisite d23a6dbc0a717 (scoped_guard)
  IS in 6.19.y - **verified**
- **git merge-base** confirmed prerequisite f74b9f4ba63ff (map_range
  fail handling) IS in 6.19.y - **verified**
- **Read of current perf_mmap()** (lines 7145-7215) confirmed the race
  window: scoped_guard closes at line 7191, then map_range() at line
  7210 is unprotected - **verified**
- **Read of perf_event_set_output()** (lines 13320-13389) confirmed
  concurrent path: acquires mmap_mutex, calls ring_buffer_get() on
  output_event's rb - **verified as concurrent accessor**
- **git show --stat** confirmed 1 file changed, 19 insertions/19
  deletions - **verified minimal scope**
- **git tag --contains** confirmed scoped_guard was first in v6.18,
  map_range fix first in v6.17 - older stable trees would need different
  backport approach - **verified**

### Conclusion

This is a textbook stable backport candidate:
- Fixes a **use-after-free** race condition (security-class bug)
- Found by automated testing (reproducible)
- Signed off by the subsystem maintainer
- Minimal, surgical fix (scope extension of existing mutex)
- Low regression risk
- Applies cleanly to 6.19.y (prerequisites present)
- Core subsystem (perf) with broad user impact

**YES**

 kernel/events/core.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 69c56cad88a89..c0bb657e28e31 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7188,28 +7188,28 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			ret = perf_mmap_aux(vma, event, nr_pages);
 		if (ret)
 			return ret;
-	}
 
-	/*
-	 * Since pinned accounting is per vm we cannot allow fork() to copy our
-	 * vma.
-	 */
-	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &perf_mmap_vmops;
+		/*
+		 * Since pinned accounting is per vm we cannot allow fork() to copy our
+		 * vma.
+		 */
+		vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
+		vma->vm_ops = &perf_mmap_vmops;
 
-	mapped = get_mapped(event, event_mapped);
-	if (mapped)
-		mapped(event, vma->vm_mm);
+		mapped = get_mapped(event, event_mapped);
+		if (mapped)
+			mapped(event, vma->vm_mm);
 
-	/*
-	 * Try to map it into the page table. On fail, invoke
-	 * perf_mmap_close() to undo the above, as the callsite expects
-	 * full cleanup in this case and therefore does not invoke
-	 * vmops::close().
-	 */
-	ret = map_range(event->rb, vma);
-	if (ret)
-		perf_mmap_close(vma);
+		/*
+		 * Try to map it into the page table. On fail, invoke
+		 * perf_mmap_close() to undo the above, as the callsite expects
+		 * full cleanup in this case and therefore does not invoke
+		 * vmops::close().
+		 */
+		ret = map_range(event->rb, vma);
+		if (ret)
+			perf_mmap_close(vma);
+	}
 
 	return ret;
 }
-- 
2.51.0

