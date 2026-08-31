Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54314A1DEB;
	Mon, 31 Aug 2026 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183709; cv=none; b=MN5yum7qqpVjfWQKC+a/i0lj7VZHUDB9QbTqsMkG2O2n6RuWybb/ShtpCSSIHGX1Vk2CFLUB2BTB90iHbz+EXTFMVds3hfZGWg7ZXhVyy7WwwETQKm32ujzqTfsA730i0k4cWhwe/kKXBgfHyZQDUe7gJ7VeBUrb0sKIBrnviAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183709; c=relaxed/simple;
	bh=+eJpnimL5yaekQdsaA9HO7wbnIc+Ma1yI1LBNnfYZIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usCLIQ3+XaEgOkUUJpJ9Te0Kh803JGJOszeSG6GjRdATo+VMSxUukdo1RCbSwDYD+ykESCSHNiph8Wh5G/M77MSGBQ2Faf9T41mLapMBQjgK2zkhpI/DNSijDgiby6N9cARotqX7lUPn51SikppwvIr6L/o3euj4PFsawbRI05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHM0d/SU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHM0d/SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528C21F00A3F;
	Mon, 31 Aug 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183706;
	bh=9RrjIxMMq22H6qcH5KABP0SzS8mkDlZEnFetbud6ZZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHM0d/SUtqNFfehX62o3CKgaMQKAHgUYFNZ+Hd2IucrfS7ImWpMslucy0kM4uQ3Pk
	 eSUkgRnsXa43zCn9PxnsVLrtZG1YcQj9KrcoOfP4IjqtEXZMaEFPMOO0bLO+KVCCu9
	 3HQqC869OT8nRhieexXVB69unlplTpEdegbvkNyZqLYcc+oR/Q7FsFlWJvsbKuQZ1c
	 OkcI6G6rURKEBNCkMmthZCg8AnKk0Hf8YKldTr11o5fhSdtm2QAnaErPjnKvLpBIi0
	 VVWvsVcnDxGmu1W1ONeb+UeD/W2JY6Mw94JnmPK/K+/yoMhxhAzS8EHlAJ3AX9tS9y
	 Mnzk46qsI3+uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wentao Liang <vulab@iscas.ac.cn>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: qrtr: fix node refcount leak on ctrl packet alloc failure
Date: Mon, 31 Aug 2026 09:24:44 -0400
Message-ID: <20260831133314.4125787-256-sashal@kernel.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 3b09ff54114566864eea59020f6b69c5bb325b9d ]

qrtr_send_resume_tx() calls qrtr_node_lookup() which takes a
reference on the returned node. If the subsequent call to
qrtr_alloc_ctrl_packet() fails due to memory allocation failure, the
function returns -ENOMEM without calling qrtr_node_release() to
release the node reference.

Add qrtr_node_release(node) before returning on the allocation failure
path to properly release the reference.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260528080019.1176700-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: qrtr: fix node refcount leak on ctrl
packet alloc failure`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[net: qrtr]` `[fix]` — On `qrtr_alloc_ctrl_packet()`
allocation failure in `qrtr_send_resume_tx()`, release the node
reference acquired by `qrtr_node_lookup()` to avoid a refcount leak.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Alexander Lobakin `<aleksander.lobakin@intel.com>`,
  Manivannan Sadhasivam `<mani@kernel.org>` (QRTR maintainer)
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260528080019.1176700-1-vulab@iscas.ac.cn`
- **Cc: stable@vger.kernel.org:** — not present (expected)
- **Signed-off-by:** Wentao Liang (author), Jakub Kicinski (net
  maintainer merge); ignore pipeline SOB per instructions

**Notable patterns:** Two subsystem reviewers, including the QRTR
maintainer. No syzbot/fuzzer report.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `qrtr_send_resume_tx()` calls `qrtr_node_lookup()` (takes a
  ref) then `qrtr_alloc_ctrl_packet()`. On alloc failure it returns
  `-ENOMEM` without `qrtr_node_release(node)`.
- **Symptom:** Leaked `qrtr_node` reference; node cannot be fully torn
  down when its refcount should reach zero.
- **Version info:** None in message.
- **Root cause:** Missing cleanup on a single error path; success path
  already calls `qrtr_node_release(node)` at line 1021.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly labeled a refcount leak fix.
Straightforward error-path resource management bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `net/qrtr/af_qrtr.c` (+3 / −1 net)
- **Function:** `qrtr_send_resume_tx()`
- **Scope:** Single-file, surgical fix on one error path

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk (lines 1011–1013):**
  - **Before:** `if (!skb) return -ENOMEM;` — node ref leaked.
  - **After:** `if (!skb) { qrtr_node_release(node); return -ENOMEM; }`
    — ref balanced.
- **Path affected:** Error path in `qrtr_send_resume_tx()`, called from
  `qrtr_recvmsg()` when `cb->confirm_rx` is set (flow-control resume-
  tx).

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Reference counting / resource leak (error-path cleanup)
- **Mechanism:** `qrtr_node_lookup()` documents that callers must call
  `qrtr_node_release()`. The ENOMEM branch was the only exit after a
  successful lookup that skipped release. Each leak increments
  `node->ref` permanently for that failure, preventing
  `__qrtr_node_release()` from running when the node should otherwise be
  destroyed.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct; mirrors the `out_node:` pattern in
  `qrtr_sendmsg()` (lines 991–992).
- **Regression risk:** Very low — only runs on allocation failure, adds
  the symmetric `put` that was missing.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `qrtr_send_resume_tx()` introduced in `cb6530b99fafea` (2020-01-14,
  "net: qrtr: Move resume-tx transmission to recvmsg").
- Missing release on ENOMEM present since introduction.
- `qrtr_alloc_ctrl_packet()` call added in `f7dec6cb914c89`
  (2020-11-06).
- **Confirmed:** `cb6530b99fafea` is an ancestor of HEAD in this tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Multiple prior QRTR leak/refcount fixes in this tree:
- `44d807320000d` — refcount bug in `qrtr_recvmsg()` /
  `qrtr_send_resume_tx()` path (syzbot)
- `8a03dd925786b` — memory leak on `qrtr_tx_wait` failure
- `f2664bc4f0f35` — xarray migration to fix memory leak
- `ab269990ed581` — refcount saturation / UAF in `qrtr_port_remove`
- **Standalone:** Yes; no series dependency indicated.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No prior Wentao Liang commits in `net/qrtr/` in this tree.
Fix reviewed by QRTR maintainer (Mani) and net reviewer (Lobakin).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. All symbols (`qrtr_node_lookup`,
`qrtr_node_release`, `qrtr_alloc_ctrl_packet`) exist in this tree. Patch
applies cleanly to current `af_qrtr.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c <commit>` could not run — commit not present in
this checkout. WebFetch/curl to lore.kernel.org and patch.msgid.link
returned 403/bot-protection pages. **UNVERIFIED:** Review thread
content, stable nominations, NAKs.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** From commit message — Reviewed-by Manivannan Sadhasivam
(QRTR maintainer) and Alexander Lobakin. **UNVERIFIED:** Full recipient
list via `b4 dig -w`.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No Reported-by or bugzilla/syzbot link. Bug identified by
code inspection, not a filed crash report.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Appears standalone (single hunk, no "patch X/Y").
**UNVERIFIED:** Series context from lore.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Could not search lore (403). **UNVERIFIED.**

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `qrtr_send_resume_tx()` (modified). Related:
`qrtr_node_lookup()`, `qrtr_node_release()`, `qrtr_alloc_ctrl_packet()`.

### Step 5.2: TRACE CALLERS
**Record:**
- `qrtr_send_resume_tx()` called only from `qrtr_recvmsg()` at line 1074
  when `cb->confirm_rx` is true.
- `qrtr_recvmsg()` is the socket recv path (`recvmsg` syscall) for
  `AF_QIPCRTR`.
- `confirm_rx` is set during QRTR flow control when a data packet needs
  a resume-tx acknowledgment (see `qrtr_tx_wait()` /
  `qrtr_node_enqueue()`).

### Step 5.3: TRACE CALLEES
**Record:**
- `qrtr_node_lookup()` → `qrtr_node_acquire()` → `kref_get(&node->ref)`
- `qrtr_alloc_ctrl_packet()` → `alloc_skb(..., GFP_KERNEL)` — can return
  NULL under memory pressure
- `qrtr_node_release()` → `kref_put_mutex()` → may call
  `__qrtr_node_release()` (frees node, purges queues, destroys xarray)

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
`recvmsg()` → `qrtr_recvmsg()` → `qrtr_send_resume_tx()` →
`qrtr_node_lookup()` + `qrtr_alloc_ctrl_packet()`.
Reachable from userspace on systems with `CONFIG_QRTR` (Qualcomm IPC,
Android modem stacks, etc.). Trigger additionally requires memory
pressure at ctrl-packet allocation time.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `qrtr_sendmsg()` uses `out_node:` label to always call
`qrtr_node_release(node)` on all paths after lookup (lines 991–992),
including `-ENOMEM` from `sock_alloc_send_skb()`.
`qrtr_send_resume_tx()` was inconsistent — the fix aligns it with
established convention. Comment at line 387: *"callers must release with
qrtr_node_release()"*.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current code at lines 1007–1013:

```1007:1013:net/qrtr/af_qrtr.c
        node = qrtr_node_lookup(remote.sq_node);
        if (!node)
                return -EINVAL;

        skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
        if (!skb)
                return -ENOMEM;
```

Bug present since v5.5-era introduction; long predates 6.18 branch.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Clean apply expected — 3-line change, no surrounding churn
in this function. Recent `af_qrtr.c` history shows other qrtr fixes but
not conflicting edits to this hunk.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** The fix commit is **not** in this tree. Related
refcount/leak fixes (`44d807320000d`, `8a03dd925786b`, etc.) are present
but address different bugs. No duplicate fix for this specific ENOMEM
path.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** `net/qrtr` — Qualcomm Router (IPC) socket
family. **Criticality:** IMPORTANT — not universal core networking, but
critical for Qualcomm/Android/embedded platforms using QRTR for modem
and coprocessor IPC.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active maintenance — multiple qrtr leak/refcount fixes in
recent history of this tree (`ab269990ed581`, `f2664bc4f0f35`,
`22100a8f73d4a`, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Config-specific** — users with `CONFIG_QRTR` enabled
(Qualcomm platforms, some Android kernels, embedded IPC). Not all
generic Linux servers, but a real production population.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- Receive QRTR message with `confirm_rx` set (normal flow-control path
  under load).
- `qrtr_alloc_ctrl_packet()` fails (`GFP_KERNEL` allocation under memory
  pressure).
- Return value of `qrtr_send_resume_tx()` is ignored by caller — leak is
  silent.
- **Likelihood:** Moderate under memory pressure on busy QRTR links; not
  every boot, but realistic on constrained embedded systems.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Permanent refcount leak per triggering event →
  `qrtr_node` and associated resources (`rx_queue`, `qrtr_tx_flow`
  xarray) cannot be freed when the node should be torn down.
- **Severity:** **MEDIUM-HIGH** — not an immediate oops, but a kernel
  resource leak that can accumulate and block node cleanup. Precedent:
  similar QRTR leak fixes have been accepted to stable in this
  subsystem.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents node refcount leaks on a real error path in
  recvmsg-driven flow control; aligns with documented API contract.
- **Risk:** Very low — 3 lines, error-path only, matches existing
  `qrtr_sendmsg()` pattern.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real, verifiable refcount leak on documented error path
- Bug in tree since 2020; affects 6.18.44
- Small (3 lines), obviously correct
- Reviewed by QRTR maintainer + net reviewer
- Matches established `qrtr_sendmsg()` cleanup pattern
- Subsystem history of similar leak fixes backported
- Reachable from userspace `recvmsg()` on QRTR-enabled systems

**AGAINST backport:**
- Requires memory pressure to trigger (not every workload)
- QRTR is platform-specific, not universal
- No syzbot/user crash report attached

**UNRESOLVED:**
- Lore thread content and any explicit stable nomination (fetch blocked)
- Whether fix is already merged to mainline in a commit hash not in this
  tree

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — symmetric
   `qrtr_node_release()` on error path; reviewed by maintainers (no
   Tested-by).
2. Fixes a real bug affecting users? **PASS** — refcount leak on QRTR
   recvmsg resume-tx path.
3. Important issue? **PASS** — resource leak preventing node teardown
   (MEDIUM-HIGH; stable accepts QRTR leak fixes).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix exception via resource-leak category.

### Step 9.4: DECISION RATIONALE
This is a clear error-path refcount leak in `qrtr_send_resume_tx()` that
has existed since the function was introduced. The fix is minimal,
follows the same pattern as `qrtr_sendmsg()`, and is endorsed by the
QRTR maintainer. While the trigger requires memory pressure and QRTR is
platform-specific, the QRTR subsystem has a well-established pattern of
backporting similar leak and refcount fixes to stable trees, and this
tree (`6.18.44`) contains the buggy code without the fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read current `net/qrtr/af_qrtr.c` lines 998–1024,
  387–402, 548–571, 930–995; confirmed leak and fix pattern
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; Makefile → 6.18.44
- **[Phase 3]** `git blame -L 998,1025 net/qrtr/af_qrtr.c` → bug since
  `cb6530b99fafea` (2020)
- **[Phase 3]** `git merge-base --is-ancestor cb6530b99fafea HEAD` →
  ancestor confirmed
- **[Phase 3]** `git log --oneline -20 -- net/qrtr/af_qrtr.c` → related
  fixes listed
- **[Phase 3]** `git show 44d807320000d` → prior syzbot refcount fix in
  same call chain
- **[Phase 3]** `git show 8a03dd925786b` → precedent for QRTR leak fixes
- **[Phase 4]** `b4 dig -h` → requires `-c COMMITISH`; commit not in
  tree, could not run
- **[Phase 4]** WebFetch lore.kernel.org + curl raw → 403/bot
  protection; thread content **UNVERIFIED**
- **[Phase 4]** No mbox file for this patch found in workspace
- **[Phase 5]** `grep qrtr_send_resume_tx` → single caller at line 1074
- **[Phase 5]** `grep confirm_rx` in `net/qrtr/` → flow-control path
  documented
- **[Phase 6]** Confirmed buggy ENOMEM path at lines 1011–1013 without
  release
- **[Phase 6]** `git log --grep="fix node refcount leak"` → not in tree
- **[Phase 7]** `git log --grep="qrtr.*leak"` → active QRTR leak-fix
  history in tree
- **[Phase 8]** Assessed trigger (memory pressure + confirm_rx recvmsg)
  and leak severity from `kref`/`__qrtr_node_release` code

**YES**The background git searches finished and match what the analysis
already used:

- **Commit search:** The candidate fix (`fix node refcount leak on ctrl
  packet alloc failure`) is **not** in this `v6.18.44` tree. A related
  prior fix was found: `44d807320000d` (syzbot refcount bug in
  `qrtr_recvmsg()` / `qrtr_send_resume_tx()`).
- **Related fixes:** This tree already has several QRTR leak/refcount
  fixes (`ab269990ed581`, `44d807320000d`, `f2664bc4f0f35`,
  `8a03dd925786b`, etc.), supporting backport of this small error-path
  leak fix.

**Verdict for this tree: YES** — the buggy ENOMEM path without
`qrtr_node_release()` is still present at lines 1011–1013 of
`net/qrtr/af_qrtr.c`.

 net/qrtr/af_qrtr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index fcd24a7df3f00..1f40496d84a33 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1009,8 +1009,10 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
 		return -EINVAL;
 
 	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (!skb)
+	if (!skb) {
+		qrtr_node_release(node);
 		return -ENOMEM;
+	}
 
 	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
 	pkt->client.node = cpu_to_le32(cb->dst_node);
-- 
2.53.0

