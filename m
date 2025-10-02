Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB27222564;
	Thu,  2 Oct 2025 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419045; cv=none; b=F88ETpbI+sTCBNc4pX0u3/QUA3HNRd3CaCH3FI11BWWIFf1kikkq1Qtr1ed0ImJYr/LF57bGd9zBnXrPrAIklO6JbdnJ3eCjEhbNEIrxneJP34bZ/8i1H39r3Dq6X6YXrCSKuH2zaWSr6UcfvjfIYk2LLdHUkCaSd48OeWHD2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419045; c=relaxed/simple;
	bh=VKXnQTNgHa3ZVm8ErfBbAUDvg6pqdD8f3rNGnhKo/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ub7MsCkKUv1EIi1od8ietz1LRD6NUYYg4dFpZgb39xFu9sXb5VCV/oUh4BJy35n1kAlSR1qXeBFft+vNK5SED+xv8a/yPoakG5LiL/sHp3Xb3dvupKbF90cLi2D56f5EkOnsPTRzPVbk1D7MMbl/3VOLD36bs3vCVqnpviwUtL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcPxW1p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcPxW1p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD67C4CEF4;
	Thu,  2 Oct 2025 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419044;
	bh=VKXnQTNgHa3ZVm8ErfBbAUDvg6pqdD8f3rNGnhKo/ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcPxW1p/vsa024MDhvQU3v0agg7dMo35hZTuqqha69epR/C/s9kAiz2duF9OGEkK3
	 4hymXGFk7n64JSlYADgTbBSchih+mM9xjqmmd82p/g/h71AV5uuv3UwQM5SFJbihBp
	 Hs5qByat6zK/gMXK/pn81rdcv8FFUGzfeEUljf1JYIPAcL7CdMq5n2zuJCrSAkKynV
	 utkP1miGEug/GCsG887q4ilY5n/QvgGXHiEwVLlX415pNHkzZRYGDfgQmWqqa8f2Kc
	 VXY3BgOaOuj8XPJUasveMgZ5nBKrxtLlAc9EjlMShRvnIzynNjqUsmzoOH8BQWGlFB
	 LKsiZeC70HqRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	rpeterso@redhat.com,
	cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.17-6.16] gfs2: Fix LM_FLAG_TRY* logic in add_to_queue
Date: Thu,  2 Oct 2025 11:30:01 -0400
Message-ID: <20251002153025.2209281-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 0c23e24164d83086e75581b0cf930f4e161636d6 ]

The logic in add_to_queue() for determining whether a LM_FLAG_TRY or
LM_FLAG_TRY_1CB holder should be queued does not make any sense: we are
interested in wether or not the new operation will block behind an
existing or future holder in the queue, but the current code checks for
ongoing locking or ->go_inval() operations, which has little to do with
that.

Replace that code with something more sensible, remove the incorrect
add_to_queue() function annotations, remove the similarly misguided
do_error(gl, 0) call in do_xmote(), and add a missing comment to the
same call in do_promote().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis Complete

**Backport Status: YES**

### Extensive Analysis and Reasoning:

#### 1. **Nature of the Bug**

This commit fixes fundamentally flawed logic in the GFS2 glock locking
subsystem's `add_to_queue()` function. The bug has existed since 2019
(commit d99724c3c36ae).

**The Problem:**
The old code checks for:
- `GLF_LOCK` flag (indicating an ongoing lock operation is in progress
  at fs/gfs2/glock.c:1496-1500)
- `GLF_INVALIDATE_IN_PROGRESS` flag (indicating go_sync/go_inval
  operations are running at fs/gfs2/glock.c:1502-1503)

**What it should check:**
Whether a LM_FLAG_TRY or LM_FLAG_TRY_1CB lock request will actually
block behind existing or future holders in the queue.

The commit message explicitly states: "the current code checks for
ongoing locking or ->go_inval() operations, which has little to do with
that" - meaning the logic is checking for the wrong conditions entirely.

#### 2. **Code Changes Analysis**

**In `add_to_queue()` (lines 1442-1540):**
- **OLD:** Complex, error-prone logic with two separate
  `list_for_each_entry` loops checking `try_futile`, `GLF_LOCK`, and
  `GLF_INVALIDATE_IN_PROGRESS`
- **NEW:** Clean extraction into `gfs2_should_queue_trylock()` helper
  that:
  1. Checks if current holder exists and `may_grant()` would fail →
     don't queue
  2. Checks if any non-try lock exists in the queue → don't queue
  3. Otherwise → queue the try lock

This is semantically correct: a try lock should fail immediately if it
would block behind a non-try lock.

**In `do_xmote()` (line 716):**
- Removes the `do_error(gl, 0)` call that was failing try locks when
  GLF_INVALIDATE_IN_PROGRESS was set
- The commit message calls this "similarly misguided"

**In `do_promote()` (line 502):**
- Just adds a clarifying comment `/* Fail queued try locks */` to
  document why `do_error(gl, 0)` is called there

**Function annotation removal:**
- Removes incorrect `__releases/__acquires` annotations from
  `add_to_queue()` - the new logic doesn't drop/reacquire the lock

#### 3. **User Impact and Severity**

This bug affects GFS2 filesystem users, particularly in clustered
storage environments where GFS2 is commonly deployed. The incorrect
logic can cause:

1. **Incorrect lock failures:** Try locks fail when they shouldn't,
   causing operations to unnecessarily retry or fail
2. **Incorrect lock queueing:** Try locks get queued when they should
   fail immediately, leading to unexpected blocking behavior
3. **Deadlock potential:** Wrong lock ordering due to incorrect try-lock
   handling
4. **Performance degradation:** Unnecessary lock failures and retries

**Historical Context:**
- The flawed logic was introduced in 2019 (d99724c3c36ae)
- In 2022, commit c412a97cf6c52 added more TRY lock usage in
  `gfs2_inode_lookup()` for UNLINKED inodes, making this bug more
  frequently triggered
- The bug has existed for ~6 years before being fixed

#### 4. **Follow-up Commits**

Commit bddb53b776fb7 ("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS")
immediately follows this fix and states:

> "it was originally used to indicate to add_to_queue() that the
->go_sync() and ->go_invalid() operations were in progress, but as we
have established in commit 'gfs2: Fix LM_FLAG_TRY* logic in
add_to_queue', add_to_queue() has no need to know."

This confirms that:
1. The GLF_INVALIDATE_IN_PROGRESS check in add_to_queue() was wrong
2. The original 2019 commit d99724c3c36ae was based on flawed analysis
3. The serialization actually happens via GLF_LOCK, not
   GLF_INVALIDATE_IN_PROGRESS

**Recommendation:** The follow-up commit bddb53b776fb7 should also be
backported to complete the cleanup.

#### 5. **Regression Risk Assessment**

**LOW RISK:**
- ✅ No reverts found in git history
- ✅ No "Fixes:" tags pointing to this commit
- ✅ Changes confined to GFS2 filesystem subsystem
- ✅ Code is cleaner and more understandable after the fix
- ✅ Logic is semantically correct based on lock queue theory
- ✅ Authored by GFS2 maintainer Andreas Gruenbacher
- ✅ Reviewed by Andrew Price (GFS2 co-maintainer)

**The new logic is simpler and more correct:**
```c
// New helper function clearly expresses intent:
static bool gfs2_should_queue_trylock(struct gfs2_glock *gl, struct
gfs2_holder *gh)
{
    // Check if blocked by current holder
    if (current_gh && !may_grant(gl, current_gh, gh))
        return false;

    // Check if any non-try lock is waiting
    list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
        if (!test_bit(HIF_HOLDER, &gh2->gh_iflags) &&
            !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
            return false;
    }
    return true;
}
```

#### 6. **Stable Tree Criteria Compliance**

✅ **Fixes important bug:** Incorrect locking logic affecting clustered
filesystems
✅ **Small and contained:** ~47 lines changed, single file, single
subsystem
✅ **No architectural changes:** Fixes existing logic, doesn't add
features
✅ **Minimal regression risk:** No known issues, clean implementation
✅ **Affects real users:** GFS2 is used in production clustered
environments

#### 7. **Similar Backport Precedent**

GFS2 locking fixes have historically been backported to stable trees:
- "gfs2: Fix potential glock use-after-free on unmount"
- "gfs2: Fix use-after-free in gfs2_glock_shrink_scan"
- "gfs2: fix a deadlock on withdraw-during-mount"
- "gfs2: Fix missed wakeups in find_insert_glock"

This commit follows the same pattern: fixes incorrect locking behavior
with contained, low-risk changes.

### **Final Recommendation: YES - Backport to Stable**

This is a well-understood bug fix addressing fundamentally incorrect
lock queueing logic that has existed since 2019. The fix is clean,
reviewed, and has no known regressions. GFS2 users in clustered
environments will benefit from correct try-lock behavior.

**Note:** Consider also backporting the follow-up commit bddb53b776fb7
("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS") to complete the cleanup
of the flawed GLF_INVALIDATE_IN_PROGRESS mechanism.

 fs/gfs2/glock.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b6fd1cb17de7b..49c5631c083fe 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -502,7 +502,7 @@ static bool do_promote(struct gfs2_glock *gl)
 			 */
 			if (list_is_first(&gh->gh_list, &gl->gl_holders))
 				return false;
-			do_error(gl, 0);
+			do_error(gl, 0); /* Fail queued try locks */
 			break;
 		}
 		set_bit(HIF_HOLDER, &gh->gh_iflags);
@@ -713,7 +713,6 @@ __acquires(&gl->gl_lockref.lock)
 		if (test_and_set_bit(GLF_INVALIDATE_IN_PROGRESS,
 				     &gl->gl_flags))
 			return;
-		do_error(gl, 0); /* Fail queued try locks */
 	}
 	gl->gl_req = target;
 	set_bit(GLF_BLOCKING, &gl->gl_flags);
@@ -1462,6 +1461,24 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 	va_end(args);
 }
 
+static bool gfs2_should_queue_trylock(struct gfs2_glock *gl,
+				      struct gfs2_holder *gh)
+{
+	struct gfs2_holder *current_gh, *gh2;
+
+	current_gh = find_first_holder(gl);
+	if (current_gh && !may_grant(gl, current_gh, gh))
+		return false;
+
+	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh2->gh_iflags))
+			continue;
+		if (!(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
+			return false;
+	}
+	return true;
+}
+
 static inline bool pid_is_meaningful(const struct gfs2_holder *gh)
 {
         if (!(gh->gh_flags & GL_NOPID))
@@ -1480,27 +1497,20 @@ static inline bool pid_is_meaningful(const struct gfs2_holder *gh)
  */
 
 static inline void add_to_queue(struct gfs2_holder *gh)
-__releases(&gl->gl_lockref.lock)
-__acquires(&gl->gl_lockref.lock)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	struct gfs2_holder *gh2;
-	int try_futile = 0;
 
 	GLOCK_BUG_ON(gl, gh->gh_owner_pid == NULL);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		GLOCK_BUG_ON(gl, true);
 
-	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
-			struct gfs2_holder *current_gh;
-
-			current_gh = find_first_holder(gl);
-			try_futile = !may_grant(gl, current_gh, gh);
-		}
-		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
-			goto fail;
+	if ((gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) &&
+	    !gfs2_should_queue_trylock(gl, gh)) {
+		gh->gh_error = GLR_TRYFAILED;
+		gfs2_holder_wake(gh);
+		return;
 	}
 
 	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
@@ -1512,15 +1522,6 @@ __acquires(&gl->gl_lockref.lock)
 			continue;
 		goto trap_recursive;
 	}
-	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
-		if (try_futile &&
-		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
-fail:
-			gh->gh_error = GLR_TRYFAILED;
-			gfs2_holder_wake(gh);
-			return;
-		}
-	}
 	trace_gfs2_glock_queue(gh, 1);
 	gfs2_glstats_inc(gl, GFS2_LKS_QCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_QCOUNT);
-- 
2.51.0

