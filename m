Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920F311960;
	Tue, 10 Feb 2026 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766287; cv=none; b=FT7l5GwljABsGksvmSlHhjAIhxnUirbI6R+7cOnnBEt5AJuW8hJ5FlE1aOcoDNmG1APEfITIwkEtKx4wqSED1ibp6EkRzXkjjf814t8N8UWiPYIz0hus6lPVZxBeC8zlpeZD1ByuBTez3oMPVHiN0q3qiSMgK5ro4UBH8d+Vhao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766287; c=relaxed/simple;
	bh=4Q38nV3N8Ns74G9RFUVss5/YKtfidd3QW6KdbU5LrNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADsvI65ZIpaTsQh0EZ52VXILDKJ3WCUqaCvwtKTuhyHrZFXfQWyPkExvnR1hAoLj452XxVzYghugIMmsxZMa0a+1mDlMI114YnnSMj7Ze/hy9a1aR69DakemSaZCg0433wVK+OrKlNfZ9/au0hp9YJb6mwdPN95abZeiaba4+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qI9jwf2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qI9jwf2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCB8C19425;
	Tue, 10 Feb 2026 23:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766287;
	bh=4Q38nV3N8Ns74G9RFUVss5/YKtfidd3QW6KdbU5LrNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI9jwf2JJy/mdzwsltCtk3kszlbzNFtRvwkyy3FEzOJ2mhLKNyNK8JJgTKkeIz/f+
	 qrlfgorez+KIEhftDE1rLZpEhiUbIAj1GzcK9CIO6f36pkUnqllpIZQaZl1WKpHw/v
	 mQ1EmaYRiBOb+B6MJ+foERZ412eZcy2T3BTQuji1okLl/yBBLcufZ94NX/C4QzhPU0
	 6Rnx061AllZkUDCLb35NThZkMzSLWN/P5NW3ft+TIV5+VN87m1b2uHPCDz49ar5a8D
	 VJiA+n157ApQHCqh1l/oe0DHfRglQQYMz0IlET8mRQhwub8puBTEmLmvZn6igAARqG
	 JObQEP4PBgTfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] dlm: fix recovery pending middle conversion
Date: Tue, 10 Feb 2026 18:30:48 -0500
Message-ID: <20260210233123.2905307-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 1416bd508c78bdfdb9ae0b4511369e5581f348ea ]

During a workload involving conversions between lock modes PR and CW,
lock recovery can create a "conversion deadlock" state between locks
that have been recovered.  When this occurs, kernel warning messages
are logged, e.g.

  "dlm: WARN: pending deadlock 1e node 0 2 1bf21"

  "dlm: receive_rcom_lock_args 2e middle convert gr 3 rq 2 remote 2 1e"

After this occurs, the deadlocked conversions both appear on the convert
queue of the resource being locked, and the conversion requests do not
complete.

Outside of recovery, conversions that would produce a deadlock are
resolved immediately, and return -EDEADLK.  The locks are not placed
on the convert queue in the deadlocked state.

To fix this problem, an lkb under conversion between PR/CW is rebuilt
during recovery on a new master's granted queue, with the currently
granted mode, rather than being rebuilt on the new master's convert
queue, with the currently granted mode and the newly requested mode.
The in-progress convert is then resent to the new master after
recovery, so the conversion deadlock will be processed outside of
the recovery context and handled as described above.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me provide my detailed analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject clearly says "fix" and the message describes a
concrete, reproducible bug:

- **Symptom**: During a workload involving conversions between lock
  modes PR (Protected Read) and CW (Concurrent Write), lock recovery
  creates a "conversion deadlock" state between recovered locks.
- **Visible effects**: Kernel warning messages (`"dlm: WARN: pending
  deadlock..."`) and permanently stuck lock conversions on the convert
  queue that never complete.
- **This affects clustered filesystem users** (GFS2, OCFS2) running on
  systems where DLM node recovery occurs during PR/CW conversion
  workloads.

The authors are **Alexander Aring** (Red Hat, DLM subsystem developer)
and **David Teigland** (the DLM maintainer who signs off all DLM
patches). This is authoritative.

### 2. CODE CHANGE ANALYSIS

The change is in `recover_convert_waiter()` in `fs/dlm/lock.c`. Here's
what changed:

**Before (buggy code introduced by f74dacb4):**

```5017:5035:fs/dlm/lock.c
        if (middle_conversion(lkb)) {
                log_rinfo(ls, "%s %x middle convert in progress",
__func__,
                         lkb->lkb_id);
                /* We sent this lock to the new master. The new master
will
   - tell us when it's granted.  We no longer need a reply, so
   - use a fake reply to put the lkb into the right state.
                 */
                hold_lkb(lkb);
                memset(ms_local, 0, sizeof(struct dlm_message));
                ms_local->m_type = cpu_to_le32(DLM_MSG_CONVERT_REPLY);
                ms_local->m_result =
cpu_to_le32(to_dlm_errno(-EINPROGRESS));
                ms_local->m_header.h_nodeid =
cpu_to_le32(lkb->lkb_nodeid);
                _receive_convert_reply(lkb, ms_local, true);
                unhold_lkb(lkb);
        } else if (lkb->lkb_rqmode >= lkb->lkb_grmode) {
                set_bit(DLM_IFL_RESEND_BIT, &lkb->lkb_iflags);
        }
```

**After (the fix):**

```c
        if (middle_conversion(lkb) || lkb->lkb_rqmode >=
lkb->lkb_grmode)
                set_bit(DLM_IFL_RESEND_BIT, &lkb->lkb_iflags);
```

### 3. BUG MECHANISM

The recovery sequence in `fs/dlm/recoverd.c` runs these steps in order:

1. **Line 218**: `dlm_recover_waiters_pre()` — handles lkbs waiting for
   replies from failed nodes
2. **Line 247**: `dlm_recover_locks()` — sends locks to new masters (via
   rcom)
3. **Line 270**: `dlm_recover_rsbs()` — calls `recover_conversion()` on
   flagged resources
4. **Line 320**: `dlm_recover_waiters_post()` — resends operations
   marked with RESEND bit

**The bug in the old code**: When `recover_convert_waiter` faked an
`-EINPROGRESS` reply for a middle conversion:
- `_receive_convert_reply()` → `__receive_convert_reply()` would handle
  the `-EINPROGRESS` case by calling `del_lkb(r, lkb)` + `add_lkb(r,
  lkb, DLM_LKSTS_CONVERT)`, moving the lkb to the **local convert
  queue**
- The lkb was also removed from the waiters list via
  `remove_from_waiters_ms()`
- When the lock was subsequently sent to the **new master** via rcom
  (step 2), it was sent as a converting lock
- `receive_rcom_lock_args()` on the new master placed it on the convert
  queue and set `RSB_RECOVER_CONVERT`
- If **two locks** had middle conversions (e.g., A: PR→CW, B: CW→PR),
  both ended up on the convert queue of the new master resource in a
  **deadlocked state**
- `recover_conversion()` couldn't resolve this; the normal `-EDEADLK`
  detection doesn't run during recovery
- Result: permanent deadlock, kernel warnings, stuck I/O

**How the fix resolves it**: By setting `DLM_IFL_RESEND_BIT` instead of
faking `-EINPROGRESS`:
- The lkb stays on the waiters list with its original granted status
  unchanged
- When sent to the new master via rcom, it's sent as a **granted lock**
  (not converting), placed on the **granted queue**
- No conversion deadlock can form during recovery
- After recovery, `dlm_recover_waiters_post()` finds the lkb (via
  `find_resend_waiter`), resets its state, and calls `_convert_lock()`
  to resend the conversion to the new master through **normal channels**
- If the conversion would deadlock, the normal code returns `-EDEADLK`
  immediately, preventing the stuck state

### 4. CLASSIFICATION

This is a **clear bug fix** — it fixes a conversion deadlock in DLM lock
recovery. There are no new features, APIs, or behavioral changes. The
fix actually **removes** complex code and replaces it with the simpler,
correct approach.

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed**: Net removal of ~17 lines; replaces ~20 lines with 2
  lines
- **Files changed**: 1 (`fs/dlm/lock.c`)
- **Function modified**: Only `recover_convert_waiter()`
- **Risk**: **Very low** — the fix simplifies the code and uses the same
  `DLM_IFL_RESEND_BIT` mechanism that is already used for normal up-
  conversions (REQUEST, LOOKUP, and non-middle CONVERT cases). The
  RESEND path via `dlm_recover_waiters_post()` → `_convert_lock()` is
  well-tested existing code.
- **Subsystem**: DLM (fs/dlm/) — critical for clustered filesystems

### 6. USER IMPACT

- **Who is affected**: Users of DLM-based clustered filesystems (GFS2,
  OCFS2) in production clusters
- **Severity**: **High** — when the bug triggers, lock conversions
  permanently hang, which would block I/O on clustered filesystems
- **Trigger**: PR↔CW conversions during node recovery (when a cluster
  node fails). This is a realistic scenario in production clusters.

### 7. DEPENDENCY CHECK

- **Requires f74dacb4** ("dlm: fix recovery of middle conversions"):
  This commit introduced the code being modified (the fake -EINPROGRESS
  approach). f74dacb4 entered mainline in v6.13-rc1 and is present in
  v6.13+ stable trees.
- **Does NOT require a8abcff1** ("dlm: move to rinfo for all middle
  conversion cases"): a8abcff1 only changed `log_limit` → `log_rinfo` in
  `receive_rcom_lock_args` and `recover_conversion`, not in
  `recover_convert_waiter`. The code being removed already used
  `log_rinfo` since f74dacb4.
- The patch should apply cleanly on any tree containing f74dacb4.

### 8. STABILITY INDICATORS

- Authored and signed-off by the DLM maintainers (Aring + Teigland)
- The fix simplifies code (reduction in complexity = lower regression
  risk)
- Uses existing well-tested RESEND mechanism
- The commit message thoroughly explains the problem and solution

### Summary

This is a clear-cut bug fix for a conversion deadlock in DLM lock
recovery that causes permanent hangs and kernel warnings. The fix is
small, surgical (net code removal), contained to a single function in a
single file, and uses existing well-tested mechanisms. It affects
production clustered filesystem users. The prerequisite commit
(f74dacb4) is in v6.13+ stable trees, so this fix is needed in those
same trees. The risk is very low — the fix actually simplifies the
recovery path.

**YES**

 fs/dlm/lock.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index be938fdf17d96..c01a291db401b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5014,25 +5014,8 @@ void dlm_receive_buffer(const union dlm_packet *p, int nodeid)
 static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				   struct dlm_message *ms_local)
 {
-	if (middle_conversion(lkb)) {
-		log_rinfo(ls, "%s %x middle convert in progress", __func__,
-			 lkb->lkb_id);
-
-		/* We sent this lock to the new master. The new master will
-		 * tell us when it's granted.  We no longer need a reply, so
-		 * use a fake reply to put the lkb into the right state.
-		 */
-		hold_lkb(lkb);
-		memset(ms_local, 0, sizeof(struct dlm_message));
-		ms_local->m_type = cpu_to_le32(DLM_MSG_CONVERT_REPLY);
-		ms_local->m_result = cpu_to_le32(to_dlm_errno(-EINPROGRESS));
-		ms_local->m_header.h_nodeid = cpu_to_le32(lkb->lkb_nodeid);
-		_receive_convert_reply(lkb, ms_local, true);
-		unhold_lkb(lkb);
-
-	} else if (lkb->lkb_rqmode >= lkb->lkb_grmode) {
+	if (middle_conversion(lkb) || lkb->lkb_rqmode >= lkb->lkb_grmode)
 		set_bit(DLM_IFL_RESEND_BIT, &lkb->lkb_iflags);
-	}
 
 	/* lkb->lkb_rqmode < lkb->lkb_grmode shouldn't happen since down
 	   conversions are async; there's no reply from the remote master */
-- 
2.51.0

