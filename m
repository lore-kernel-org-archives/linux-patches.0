Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB14D4A4419;
	Mon, 31 Aug 2026 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183789; cv=none; b=t5RVRQGvtJHaJayLLlGOHcQxpzuPLRNPRnjbOOGxFCoPbP27GJRGAZl2pVbf+361Z27Vm6ljJMQNOGDU0AbQbnb1qDmUCj8nTXeZrHUPmERDMh/6qJGt/HWFqBeVSxlYTPPSM5Tt1kpryGobm5bxhvxITPx8ovyvW381hw4qrRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183789; c=relaxed/simple;
	bh=xstikX929/IDylXCPciXyPDe9vooOsgX0CTP/SkyteI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdrD7zHx3Pn7fCZy432NEqhw0AZoLC0tIuqMdfmOJyzMJJJnuBKZrkrTn0yw3M7GeS6x1UXzfbW8/bs390uNN9fIVgSJ0Up/JJZpdhWLHet/QYy9l0VPPPWGkU32Z4wQLAIJkdwbV7DocvtolD94/VNtq0klK4R0vdlZO/fS5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arpHFTzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arpHFTzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFFC1F00A3D;
	Mon, 31 Aug 2026 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183786;
	bh=F57cKwWOyxk6wWEiBw0cUMp8iuu++NR1laMxD6Lax4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arpHFTzDPX2CmFjYNzExp9yjKMtv2dF56Dl232pE+fqfmtPan6iABrFZ9gcbScShf
	 Nzx4VUzJx7VjXyC9gv1BZ9oVrS6pv8L6aG08G9FVZkGb+oUmB5HpSLCZJcErZ0G0Bk
	 SOqlbFoZuRfRM5+jEIPzZKCsasLutLqS6166lvPfhEQ5n5YCn24+QMTMoLXFbCtz0a
	 /wYuwCWtvviVANpO+x57B1OaOE0pazxZdWdogmMkJy2g0NIO0K7ldbK4MoSkzVtmBJ
	 L/QxEjuUIPZrJ9aLvEEP3sPfm9cZh1FAGok4MjEwWSKtpHWcE7ZtW0WpTe37TVWrd+
	 5Inclc1MlOumw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
	Paulo Alcantara <pc@manguebit.org>,
	hongao <hongao@uniontech.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfs: Fix DIO write retry for filesystems without a ->prepare_write()
Date: Mon, 31 Aug 2026 09:25:31 -0400
Message-ID: <20260831133314.4125787-303-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 64f04f9789237728be4e1836151848af350d1374 ]

Fix netfs_unbuffered_write() so that it doesn't re-issue a write twice when
the filesystem doesn't have a ->prepare_write().  The resetting of the
iterator and the call to netfs_reissue_write() should just be removed as
almost everything it does is done again when the loop it's in goes back to
the top.

It does, however, still need the IN_PROGRESS flag setting, so that (and the
stat inc) are moved out of the if-statement.

Further, the MADE_PROGRESS flags should be cleared and wreq->transferred
should be updated, so fix those too.

Reported-by: syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3c74b1f0c372e98efc32
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-16-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: hongao <hongao@uniontech.com>
cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Backport Analysis: `netfs: Fix DIO write retry for filesystems without
a ->prepare_write()`

**Local tree:** `v6.18.44` (6.18.y stable) — `VERSION = 6`, `PATCHLEVEL
= 18`, `SUBLEVEL = 44`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[netfs]` `[Fix]` — Correct DIO/unbuffered write retry when
the filesystem has no `->prepare_write()` hook.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com |
| Closes | https://syzkaller.appspot.com/bug?extid=3c74b1f0c372e98efc32
|
| Signed-off-by | David Howells \<dhowells@redhat.com\> |
| Link |
https://patch.msgid.link/20260625140640.3116900-16-dhowells@redhat.com |
| cc | Paulo Alcantara, hongao, ChenXiaoSong, netfs@lists.linux.dev,
linux-fsdevel@vger.kernel.org |
| Signed-off-by | Christian Brauner (Amutable) \<brauner@kernel.org\> |

**Notable patterns:** syzbot report (strong YES signal). No `Fixes:` tag
(expected for manual review). No `Cc: stable` tag (not a negative
signal).

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** On retry in `netfs_unbuffered_write()`, when
  `stream->prepare_write` is NULL, the code calls
  `netfs_reissue_write()` and then the loop iterates again and issues
  the write a second time.
- **Symptom:** Double write issuance, incorrect progress accounting
  (`wreq->transferred` not updated on partial retry), stale
  `NETFS_SREQ_MADE_PROGRESS` flag.
- **Root cause:** The retry path incorrectly mirrored `write_retry.c`’s
  `netfs_reissue_write()` pattern, but `netfs_unbuffered_write()`’s loop
  already re-issues at the top on the next iteration.
- **Version info:** None explicit; bug is tied to code introduced in
  6.18.y backports.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — despite “fix retry logic” wording, this is a real
memory-safety and correctness bug: syzbot reports KASAN slab-use-after-
free in `netfs_unbuffered_write()`, reachable from userspace `write()`
via 9p.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **Files:** `fs/netfs/direct_write.c` only (+6 / -10 lines, net −4)
- **Function:** `netfs_unbuffered_write()`
- **Scope:** Single-file surgical fix in retry path

### Step 2.2: Code flow change per hunk
**Record:**

| Hunk | Before → After |
|------|----------------|
| Partial transfer | `iov_iter_advance()` only → also `wreq->transferred
+= subreq->transferred` |
| Flag clearing | No `MADE_PROGRESS` clear →
`__clear_bit(NETFS_SREQ_MADE_PROGRESS, ...)` added |
| prepare_write branch | `if/else`: else calls `netfs_reset_iter()` +
`netfs_reissue_write()` → unified path: optional `prepare_write()`,
always set `IN_PROGRESS` + stat |

**Affected path:** Retry branch when `NETFS_SREQ_NEED_RETRY` is set
(error recovery during unbuffered/DIO writes).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness bug with memory safety consequences
  (UAF); also reference-counting/lifecycle corruption from double issue.
- **Mechanism:** `netfs_reissue_write()` calls `netfs_do_issue_write()`
  → `stream->issue_write()`. The loop then continues with `subreq` still
  non-NULL, skips `netfs_prepare_write()`, and calls
  `stream->issue_write(subreq)` again at line 134. This corrupts
  subrequest lifecycle and can free the subrequest while the loop still
  holds a pointer to it (matching syzbot’s alloc/free/read pattern).

### Step 2.4: Fix quality
**Record:** Obviously correct. The `prepare_write` path already worked
this way (set up state, loop back, issue once). The fix unifies the
no-`prepare_write` path to match. Minimal regression risk; no new APIs
or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- Retry infrastructure: `72d08d2839649` (upstream `a0b4c7a49137`, Feb
  2026) — “Fix unbuffered/DIO writes to dispatch subrequests in strict
  sequence”
- Buggy `else { netfs_reissue_write() }` branch: `a4d1b4ba9754b`
  (upstream `e9075e420a1e`, Mar 2026) — “Fix NULL pointer dereference in
  netfs_unbuffered_write() on retry”
- Both commits are ancestors of HEAD in this tree.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message. The bug was
introduced by `a4d1b4ba9754b`, which attempted to fix an earlier NULL
deref (syzbot `7227db0f`) but introduced the double-issue/UAF.

### Step 3.3: File history for related changes
**Record:** Recent `direct_write.c` history in this tree:
- `f0035858dfb23` — stream->front removal
- `a4d1b4ba9754b` — NULL deref fix (introduced this bug)
- `72d08d2839649` — sequential DIO write dispatch

Standalone fix; not part of a multi-commit dependency chain for this
tree.

### Step 3.4: Author's other commits
**Record:** David Howells is the netfs subsystem author. He authored
`72d08d2839649` (the retry loop) and this follow-up fix. Deepanshu
Kartikey authored the incomplete `a4d1b4ba9754b` fix.

### Step 3.5: Prerequisites
**Record:**
- **Required in tree:** `72d08d2839649` (retry loop) and `a4d1b4ba9754b`
  (if/else structure) — both present.
- **Fix commit `64f04f978923`:** NOT in HEAD.
- **Standalone:** Yes — only modifies existing retry path; cherry-pick
  applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- `b4 dig -c 64f04f978923`: found at
  https://patch.msgid.link/20260625140640.3116900-16-dhowells@redhat.com
- Subject: `[PATCH v3 15/15] netfs: Fix DIO write retry for filesystems
  without a ->prepare_write()`
- Part of a 15-patch netfs series; this patch is self-contained in
  `direct_write.c`.
- Lore page blocked by bot protection; could not read thread body.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC list includes David Howells, Christian
Brauner, Paulo Alcantara, Christoph Hellwig, netfs@lists.linux.dev,
linux-fsdevel@vger.kernel.org, syzbot address. Appropriate subsystem
coverage.

### Step 4.3: Bug report
**Record:** https://syzkaller.appspot.com/bug?extid=3c74b1f0c372e98efc32
- **Type:** KASAN: slab-use-after-free Read in `netfs_unbuffered_write`
- **Status:** Fixed upstream 2026/07/29
- **Priority:** high
- **Trigger:** `ksys_write` → `v9fs_file_write_iter` →
  `netfs_unbuffered_write_iter` → `netfs_unbuffered_write`
- **AI assessment:** Exploitable, unprivileged, userspace-triggerable
- **8 crashes** over ~75 days

### Step 4.4: Related patches/series
**Record:** Patch 15/15 of v3 netfs series. Other series patches (e.g.,
“Fix oops in write-retry from mis-resetting the subreq iterator”) are
NOT in this tree, but this patch does not depend on them — verified by
clean cherry-pick.

### Step 4.5: Stable mailing list
**Record:** Could not search lore stable list (bot protection). No
evidence against stable nomination.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `netfs_unbuffered_write()` (modified),
`netfs_reissue_write()` (no longer called from here on retry)

### Step 5.2: Callers
**Record:**
- `netfs_unbuffered_write_iter_locked()` ←
  `netfs_unbuffered_write_iter()`
- Callers of `netfs_unbuffered_write_iter()`:
  - `fs/9p/vfs_file.c` (no `prepare_write` — **affected**)
  - `fs/smb/client/file.c` (has `cifs_prepare_write` — uses
    `prepare_write` path, not affected by this specific bug)
  - `fs/netfs/buffered_write.c` (fallback path)

### Step 5.3: Callees in retry path
**Record:** `iov_iter_advance`, `retry_request` op, flag bit ops,
`netfs_get_subrequest`, optional `prepare_write`, then loop-top
`stream->issue_write()`.

### Step 5.4: Call chain / reachability
**Record:** `write(2)` → VFS → `v9fs_file_write_iter` →
`netfs_unbuffered_write_iter` → `netfs_unbuffered_write`. **Userspace-
reachable** on 9p mounts with O_DIRECT or unbuffered write paths.

### Step 5.5: Similar patterns
**Record:** `write_retry.c` correctly uses `netfs_reissue_write()`
outside a re-issue loop. `netfs_unbuffered_write()` has its own issue-
at-loop-top pattern — the bug was copying the wrong pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Lines 189–199 in `fs/netfs/direct_write.c` contain
the buggy `else { netfs_reissue_write(); }` branch. Introduced by
`a4d1b4ba9754b`, which is in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply.** `git cherry-pick --no-commit 64f04f978923`
succeeded with auto-merge on `fs/netfs/direct_write.c`.

### Step 6.3: Related fixes already present?
**Record:** `a4d1b4ba9754b` (incomplete NULL-deref fix) is present. Fix
`64f04f978923` is NOT present (`git merge-base --is-ancestor` returns
failure). No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/netfs/` — IMPORTANT. Shared library for network
filesystems (9p, CIFS, AFS, Ceph). Write path affects data integrity.

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y — multiple netfs fixes already
backported (UAF, deadlock, writeback fixes visible in recent log).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of network filesystems without `prepare_write` on the
upload stream — primarily **9p**. Config-dependent (9p + unbuffered/DIO
write + write retry).

### Step 8.2: Trigger conditions
**Record:** Write subrequest marked `NETFS_SREQ_NEED_RETRY` during
unbuffered/DIO write when `stream->prepare_write == NULL`. Syzbot
reproduces via `write()` syscall. Unprivileged users can trigger on
accessible 9p mounts.

### Step 8.3: Failure mode severity
**Record:**
- KASAN slab-use-after-free (syzbot-confirmed) — **CRITICAL** (crash,
  potential security)
- Double write issuance — **CRITICAL** (data corruption risk)
- Incorrect `wreq->transferred` — **HIGH** (wrong offsets, potential
  corruption)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — fixes syzbot UAF, prevents double-write and
  progress accounting errors on a common netfs code path.
- **Risk:** VERY LOW — ~10-line change, mirrors existing `prepare_write`
  path behavior.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- syzbot-reported, reproducible KASAN UAF
- Userspace-triggerable via `write()` on 9p
- High priority, assessed exploitable
- Small, surgical, obviously correct fix
- Bug exists in this 6.18.44 tree (introduced by prior stable backport
  `a4d1b4ba9754b`)
- Applies cleanly
- Fixes real data-integrity and crash bugs

**AGAINST backport:**
- Part of a 15-patch series (but this patch is self-contained)
- Only affects filesystems without `prepare_write` (primarily 9p, not
  CIFS/AFS)

**Unresolved:** Could not read full lore review thread (bot protection).
Does not affect decision — syzbot evidence is sufficient.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — syzbot tested prior
NULL-deref fix; this is author's correction of that approach |
| 2. Fixes real bug affecting users? | **PASS** — syzbot UAF, 8 crashes
|
| 3. Important issue? | **PASS** — CRITICAL (UAF, data corruption) |
| 4. Small and contained? | **PASS** — single file, ~10 lines |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — verified clean cherry-pick |

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not a quirk/ID/DT/doc exception.

### Step 9.4: Decision rationale
This 6.18.y tree contains the buggy retry path from `a4d1b4ba9754b` but
not the corrective fix. The bug causes slab-use-after-free (syzbot-
confirmed, high priority, userspace-triggerable on 9p) and double write
issuance. The fix is minimal, applies cleanly, and corrects a regression
introduced by a prior stable backport. This is exactly the kind of
follow-up fix stable trees need.

---

## Verification

- **[Phase 1]** Parsed commit message and tags; confirmed syzbot
  Reported-by and Closes link
- **[Phase 2]** Read `fs/netfs/direct_write.c` lines 94–205; confirmed
  retry loop double-issue path
- **[Phase 2]** Read `netfs_reissue_write()` in
  `fs/netfs/write_issue.c:240-257`; confirms it calls
  `netfs_do_issue_write()`
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame -L 163,200`: retry code from `72d08d2839649`,
  buggy else from `a4d1b4ba9754b`
- **[Phase 3]** `git show a4d1b4ba9754b`: introduced
  `netfs_reissue_write()` in else branch
- **[Phase 3]** `git show 72d08d2839649`: introduced sequential DIO
  write retry loop
- **[Phase 3]** `git merge-base --is-ancestor`: both prerequisites in
  HEAD; fix `64f04f978923` NOT in HEAD
- **[Phase 4]** `b4 dig -c 64f04f978923`: found lore URL, patch v3 15/15
- **[Phase 4]** `b4 dig -w`: confirmed maintainer CC list
- **[Phase 4]** WebFetch syzbot bug page: KASAN UAF, high priority,
  exploitable, 8 crashes, v9p trigger via `ksys_write`
- **[Phase 5]** `grep netfs_unbuffered_write_iter`: callers in 9p, SMB,
  netfs buffered_write
- **[Phase 5]** `grep prepare_write fs/9p`: no matches — 9p lacks
  `prepare_write`
- **[Phase 5]** `grep prepare_write fs/smb`, `fs/afs`: both have
  `prepare_write` set
- **[Phase 6]** Confirmed buggy else branch at `direct_write.c:189-199`
- **[Phase 6]** `git cherry-pick --no-commit 64f04f978923`: clean apply
  (exit 0)
- **[Phase 8]** Syzbot stack trace: UAF at `netfs_unbuffered_write` via
  `v9fs_file_write_iter` + `ksys_write`

**YES**

 fs/netfs/direct_write.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index f9ab69de3e298..c2873ecbeceb6 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -166,13 +166,16 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		 */
 		subreq->error = -EAGAIN;
 		trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-		if (subreq->transferred > 0)
+		if (subreq->transferred > 0) {
 			iov_iter_advance(&wreq->buffer.iter, subreq->transferred);
+			wreq->transferred += subreq->transferred;
+		}
 
 		if (stream->source == NETFS_UPLOAD_TO_SERVER &&
 		    wreq->netfs_ops->retry_request)
 			wreq->netfs_ops->retry_request(wreq, stream);
 
+		__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 		__clear_bit(NETFS_SREQ_BOUNDARY, &subreq->flags);
 		__clear_bit(NETFS_SREQ_FAILED, &subreq->flags);
@@ -186,17 +189,10 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 
 		netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
 
-		if (stream->prepare_write) {
+		if (stream->prepare_write)
 			stream->prepare_write(subreq);
-			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-			netfs_stat(&netfs_n_wh_retry_write_subreq);
-		} else {
-			struct iov_iter source;
-
-			netfs_reset_iter(subreq);
-			source = subreq->io_iter;
-			netfs_reissue_write(stream, subreq, &source);
-		}
+		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
+		netfs_stat(&netfs_n_wh_retry_write_subreq);
 	}
 
 	netfs_unbuffered_write_done(wreq);
-- 
2.53.0

