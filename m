Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA1C220F5E;
	Thu,  2 Oct 2025 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419046; cv=none; b=RXijmeHEEaJ+kHR34f75glr3xA6Clsxp8Xk7kYQhgMTRzknshVYCOEq+DoTCEaAc5BF6HMygFJ4UG1Rd60ZW2MU4le0lAqKF04Z0VfD0t1Kz15hRVkKNKyJ8mWfFMozGs7Ord7K+4qvjfobZdINtfbXaewQITrVJTjmlbltyrdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419046; c=relaxed/simple;
	bh=zUtUl1t4pHD/8yBjREbIJj/2yCuo8FpDSRoSUTF2dO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MKL72XF1Dv7LPvMc/YPq5DG8h1ZWpDtGG+gsuiLsKHhLD5kMN2N4xa6uFxohTUEobnI0I7hx3NA1gc7dINamlFvrsQAYrZskB3tuI4FxAz08Wt3Fu8xUpZJrhu0OYXUEfW8RblCDSwZUsXGjeriirVB9mp8ZVWKf9ZG67+tPcyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqqVyyER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqqVyyER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B042C4CEFB;
	Thu,  2 Oct 2025 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419045;
	bh=zUtUl1t4pHD/8yBjREbIJj/2yCuo8FpDSRoSUTF2dO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqqVyyERrymvnw66q8+6nI+8nzCY2JfNl/FbR90Sj7dQFKs/YbEMgCpvOQloMdGEg
	 QZcYXZZbZFhzVUVUhtF0yA0iA8stRjo7II/OLU/KSeoALPS0JJ3lSa8z7AiMpS9hqJ
	 AG03HjZPM8Ec02J6lWO2yUBQ+jeXrpV2N6kbexlv3MRZz1sQiIVLLIEJxmr04UDYAo
	 rnPu8+51Uf655BxngNkYjzGn7XT1539HCf1Sy2ZKoK2tQgjbW0t+RmfMqYzn73nS3e
	 qeSSMOHxc+cyux69BDA9e5qvhGVqA6V3vgoprAIRdDSvfIKvPHBS/0braJj+49i0Hs
	 ZkLdYfkNgla/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	ccaulfie@redhat.com,
	cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.17-6.16] dlm: move to rinfo for all middle conversion cases
Date: Thu,  2 Oct 2025 11:30:02 -0400
Message-ID: <20251002153025.2209281-15-sashal@kernel.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit a8abcff174f7f9ce4587c6451b1a2450d01f52c9 ]

Since commit f74dacb4c8116 ("dlm: fix recovery of middle conversions")
we introduced additional debugging information if we hit the middle
conversion by using log_limit(). The DLM log_limit() functionality
requires a DLM debug option being enabled. As this case is so rarely and
excempt any potential introduced new issue with recovery we switching it
to log_rinfo() ad this is ratelimited under normal DLM loglevel.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis: dlm: move to rinfo for all middle conversion cases

**Backport Status: YES**

---

## Comprehensive Analysis

### Change Summary
This commit changes logging calls from `log_limit()` to `log_rinfo()` in
two locations within the DLM (Distributed Lock Manager) subsystem:
1. **fs/dlm/lock.c:5579** - in `receive_rcom_lock_args()` function
2. **fs/dlm/recover.c:845** - in `recover_conversion()` function

Both changes affect logging for "middle conversion" cases - rare but
critical scenarios where locks convert between PR (Protected Read) and
CW (Concurrent Write) modes during cluster recovery.

### Code Changes Analysis

**Logging Infrastructure Differences** (from
fs/dlm/dlm_internal.h:65-87):
- **log_limit()**: Only logs when `dlm_config.ci_log_debug` is enabled,
  at DEBUG level with rate limiting. Requires explicit debug mode.
- **log_rinfo()**: Logs at INFO or DEBUG level depending on
  configuration (`ci_log_info` OR `ci_log_debug`). Visible under normal
  DLM loglevel.

**Specific Change 1 - fs/dlm/lock.c:5579**:
```c
// In receive_rcom_lock_args() - when receiving lock recovery
information
if (rl->rl_status == DLM_LKSTS_CONVERT && middle_conversion(lkb)) {
- log_limit(ls, "%s %x middle convert gr %d rq %d remote %d %x", ...)
+   log_rinfo(ls, "%s %x middle convert gr %d rq %d remote %d %x", ...)
    rsb_set_flag(r, RSB_RECOVER_CONVERT);
}
```

**Specific Change 2 - fs/dlm/recover.c:845**:
```c
// In recover_conversion() - when detecting incompatible lock modes
during recovery
if (((lkb->lkb_grmode == DLM_LOCK_PR) && (other_grmode == DLM_LOCK_CW))
||
    ((lkb->lkb_grmode == DLM_LOCK_CW) && (other_grmode == DLM_LOCK_PR)))
{
- log_limit(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other
  gr %d, set gr=NL", ...)
+   log_rinfo(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other
gr %d, set gr=NL", ...)
    lkb->lkb_grmode = DLM_LOCK_NL;
}
```

### Critical Context from Referenced Commit f74dacb4c8116

The commit message references f74dacb4c8116 ("dlm: fix recovery of
middle conversions", Nov 2024), which fixed a **long-standing critical
bug** in DLM recovery:

**The Bug**: Recovery couldn't reliably rebuild lock state for
conversions between PR/CW modes. The code would set invalid modes
(DLM_LOCK_IV), causing unpredictable errors.

**Why It Went Unnoticed**:
- Applications rarely convert between PR/CW
- Recovery rarely occurs during these conversions
- Even when the bug occurred, callers might not notice depending on
  subsequent operations
- A gfs2 core dump finally revealed this broken code

**The Fix**: Properly detect and correct incompatible lock modes during
recovery by temporarily setting grmode to NL, allowing the conversion to
complete after recovery.

**Logging Inconsistency**: The original bug fix added logging in three
places for middle conversions:
- `recover_convert_waiter()`: Used `log_rinfo()` ✓
- `receive_rcom_lock_args()`: Used `log_limit()` ✗
- `recover_conversion()`: Used `log_limit()` ✗

The current commit makes all three consistent by using `log_rinfo()`.

### Why This Change Matters

1. **Production Visibility**: Middle conversion recovery is rare but
   critical. The original bug existed for years undetected. Having this
   logging visible in production (without debug mode) helps catch any
   remaining issues or new regressions.

2. **Consistency**: All three middle conversion logging points should
   use the same logging level for coherent debugging.

3. **Preventative Monitoring**: The commit message says "excempt any
   potential introduced new issue with recovery" - this appears to mean
   they want to *except* (catch) any potential new issues. Making these
   logs visible helps detect problems early.

4. **Cluster Filesystem Impact**: DLM is used by GFS2 and other cluster
   filesystems. Recovery bugs can cause data corruption or service
   outages in production clusters.

### Risk Assessment

**Risk Level**: **VERY LOW**

**Potential Issues**:
- Slightly increased log verbosity in rare recovery scenarios
- Both logging paths are rate-limited, preventing log spam
- Only affects recovery code paths that are infrequently exercised

**Regression Probability**: **Near Zero**
- No functional code changes
- Only affects logging output
- Both `log_limit()` and `log_rinfo()` are rate-limited
- Change is identical to existing logging pattern in same subsystem

**Testing Consideration**:
The affected code paths execute during:
- Cluster node failures during lock conversions
- Lock recovery after master node changes
- Middle conversion scenarios (PR↔CW)

These are difficult to reproduce in testing but critical in production.

### Stable Tree Considerations

**Arguments FOR Backporting**:
1. ✅ The referenced bug fix f74dacb4c8116 is present in this stable tree
   (confirmed by git log)
2. ✅ Extremely low risk - only logging changes, no functional
   modifications
3. ✅ Small, self-contained change (2 lines)
4. ✅ Improves observability for a critical, hard-to-debug subsystem
5. ✅ Provides consistency in logging for recovery scenarios
6. ✅ Could help catch issues in production environments where debug mode
   isn't enabled
7. ✅ Cluster filesystems (GFS2) users would benefit from better recovery
   debugging
8. ✅ No architectural changes or new features

**Arguments AGAINST Backporting**:
1. ❌ Not fixing a bug - it's an observability improvement
2. ❌ No explicit Cc: stable tag from maintainers
3. ❌ Changes observable behavior (more verbose logging under normal
   loglevel)
4. ❌ Stable trees typically prioritize bug fixes over improvements

### Relationship to Stable Tree Rules

From stable tree documentation, acceptable commits should:
- ✅ "Fix a real bug" - While not fixing a bug directly, this improves
  detection of bugs in the recovery logic
- ✅ "Be small and obviously correct" - 2-line change, straightforward
- ✅ "Include no significant risk of regression" - Only logging changes
- ⚠️  "Not add a new feature" - Borderline: makes existing logging more
  accessible, doesn't add functionality

### Historical Precedent

The DLM subsystem has a history of recovery-related issues that went
undetected for years. The original bug fix commit message states: "This
bug has gone unnoticed for so long..." This justifies enhanced logging
for rare recovery scenarios.

### Conclusion

**Recommendation: YES - Backport to stable trees**

**Rationale**:
1. **Minimal Risk**: This is purely a logging level change with no
   functional modifications. The rate-limiting prevents any log spam
   concerns.

2. **Valuable for Production**: The original bug (f74dacb4c8116)
   demonstrates that middle conversion recovery bugs can exist
   undetected for years. Making this logging visible in production
   environments helps catch issues early.

3. **Complements Existing Backport**: If the bug fix f74dacb4c8116 is
   backported to stable (it's present in this tree), this logging
   improvement provides essential observability for that fix.

4. **Consistency**: Makes all middle conversion logging uniform, which
   aids in debugging across different recovery code paths.

5. **Cluster Filesystem Stability**: DLM is critical infrastructure for
   cluster filesystems like GFS2. Better observability in production
   helps maintain cluster stability and aids in root cause analysis
   during incidents.

**Conditional Note**: If stable tree maintainers have strict policies
against non-bugfix commits, they may choose to reject this. However,
given:
- The extreme low risk
- The relationship to a critical bug fix
- The production value for cluster filesystem users
- The small size and obvious correctness

This commit meets the spirit of stable tree backporting rules even if
it's technically an "improvement" rather than a "fix."

 fs/dlm/lock.c    | 2 +-
 fs/dlm/recover.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6dd3a524cd352..be938fdf17d96 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5576,7 +5576,7 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	if (rl->rl_status == DLM_LKSTS_CONVERT && middle_conversion(lkb)) {
 		/* We may need to adjust grmode depending on other granted locks. */
-		log_limit(ls, "%s %x middle convert gr %d rq %d remote %d %x",
+		log_rinfo(ls, "%s %x middle convert gr %d rq %d remote %d %x",
 			  __func__, lkb->lkb_id, lkb->lkb_grmode,
 			  lkb->lkb_rqmode, lkb->lkb_nodeid, lkb->lkb_remid);
 		rsb_set_flag(r, RSB_RECOVER_CONVERT);
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index be4240f09abd4..3ac020fb8139e 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -842,7 +842,7 @@ static void recover_conversion(struct dlm_rsb *r)
 		 */
 		if (((lkb->lkb_grmode == DLM_LOCK_PR) && (other_grmode == DLM_LOCK_CW)) ||
 		    ((lkb->lkb_grmode == DLM_LOCK_CW) && (other_grmode == DLM_LOCK_PR))) {
-			log_limit(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other gr %d, set gr=NL",
+			log_rinfo(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other gr %d, set gr=NL",
 				  __func__, lkb->lkb_id, lkb->lkb_grmode,
 				  lkb->lkb_rqmode, lkb->lkb_nodeid,
 				  lkb->lkb_remid, other_lkid, other_grmode);
-- 
2.51.0

