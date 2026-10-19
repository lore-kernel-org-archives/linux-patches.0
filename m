Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1284D55CE9D;
	Mon, 19 Oct 2026 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418242; cv=none; b=kaAakElWnOs4zyvD7t3hcEWQvxTgU9A4pTqmj2ihGKed/8R5b7aoYbvIWmvB7xbAv+JVMKpp6SEb0wVOfg4f6goO0deKMAOPEnxnvyhUbDeb1KX+JLi+9r9QwLeDo1DCPpHr/4IT0G6ja34Cl9gXju49dbSdIkihObcn5j8KXJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418242; c=relaxed/simple;
	bh=65ka5NLj7qBmHR1Dul7+BXrN2LLuMDb/js34FK9iAaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhDbfDyH2gBe5J0M6bPl7ahZm9N+szdB5Rek8MLxNSHveU2urklnUndv4Z6B3YMnvWvHiCYdXIE9Kt/91RhPgJpln7UZcd1LOHqHfV7rqQ6nLkFCn0g/i0HnOgtl6XPBbwYiY2e0RA45vf8K8NNCMcz37MxsfsHh1MPuZIa27hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyiSWVLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyiSWVLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04371F000C5;
	Mon, 19 Oct 2026 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418238;
	bh=trz5SfYV5vm9P02Or0GRkh4Zt0T/Tk7EYMHq2iQnOv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyiSWVLxuXa0ezjmXsoqxRVguwV22SM7mGSFwLQQBwelLJ5/aBONW9TsMRSu+1eHV
	 hiCKZAN0XFHO+lN5lFl/WtyG78/foG9FSLEI5cLfZ4mobV3nJ7He1uYoDUsTp7Vbcf
	 JFOOPJ9GW0rkUXRjkmVjUb0VvIY/6dRruvRboTfVYFUP99cl7TLvhR5MtcOfcM94gm
	 gnRNvGruJ3444CWraGXDasfwnSVzQYTOjM/1kUkb9Ij00iAD2DncA5ZQ19U4+E3/mi
	 Za6haZvOhry4qayj94Fgu8lB01AWdC0JKSRLpcBQ/gp96jQ4kRIRPjW0mNDD5BzFTw
	 YFi1oaYHGsA+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	bwarrum@linux.ibm.com,
	rituagar@linux.ibm.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] misc: ibmvmc: reject oversized inbound messages
Date: Mon, 19 Oct 2026 09:46:42 -0400
Message-ID: <20261019135441.1420968-111-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 18189e5d84aa0b3bc89189cba13b9105634cb6fb ]

ibmvmc_recv_msg() trusts the message length from the CRQ.

It passes that length directly to h_copy_rdma().

The destination buffer is only max_mtu bytes.

A larger length can overrun it before userspace reads the message.

Validate the CRQ length before issuing the RDMA copy.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624175139.7981-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4**. The change is a 7-line inbound length
check in `ibmvmc_recv_msg()` against a hypervisor-supplied CRQ size used
as an RDMA copy length.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[misc/ibmvmc] [reject] [drop inbound CRQ messages whose length
exceeds the receive buffer]**
- Subsystem: `misc: ibmvmc`
- Verb: **reject** — a defensive check, not a feature add
- Intent: stop oversized hypervisor messages from being RDMA-copied into
  a fixed buffer

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Yousef Alhouseen \<alhouseenyousef@gmail.com\>
  (author)
- **Link:** https://patch.msgid.link/20260624175139.7981-1-
  alhouseenyousef@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman \<gregkh@linuxfoundation.org\>
  (char-misc maintainer; applied the patch)
- **Fixes:** absent (expected for this review pipeline)
- **Cc: stable:** absent (expected; not a negative)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- No syzbot, bugzilla, or CVE tags
- No “Upstream commit” / Sasha Levin tags in the provided message
  (ignored even if present)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `ibmvmc_recv_msg()` takes `msg_len` from the CRQ and passes
  it straight to `h_copy_rdma()`.
- **Symptom:** destination buffer is only `max_mtu` / `buffer->size`
  bytes; a larger length can overrun it before userspace `read()`.
- **Root cause:** untrusted CRQ length used as copy size into a kernel
  DMA/heap buffer.
- **Version info:** none in the message. Driver itself dates to v4.18.
- **Failure mode:** kernel buffer overrun (memory corruption), not a
  userspace-visible errno.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not disguised.** The subject and body describe a bounds check.
This is an explicit memory-safety fix, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/misc/ibmvmc.c` — **+7 / −0**
- **Function:** `ibmvmc_recv_msg()`
- **Scope:** single-file, surgical, one conditional on the inbound path
- Commit: `18189e5d84aa0b3bc89189cba13b9105634cb6fb`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** after validating HMC state and buffer ownership,
  immediately `h_copy_rdma(msg_len, …, buffer->dma_addr_local)` with CRQ
  `msg_len`.
- **After:** if `msg_len > buffer->size`, log, drop the HMC lock, return
  `-1`. No RDMA, no `buffer->msg_len` update, no ownership transfer.
- **Path:** hypervisor inbound SIGNAL/CRQ handling (tasklet), not
  probe/init and not the userspace write path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** **(d) memory safety — buffer overflow / out-of-bounds
  DMA copy**
- **Mechanism:** CRQ `var3.msg_len` is a hypervisor-supplied `__be32`.
  Buffers are `kzalloc(ibmvmc.max_mtu)` and `buffer->size =
  ibmvmc.max_mtu` in `ibmvmc_add_buffer()`. Using `msg_len` as the
  `H_COPY_RDMA` length can write past that object.
- **Asymmetry verified:** `ibmvmc_write()` already rejects `count >
  ibmvmc.max_mtu` and copies with `min_t(..., vmc_buffer->size)`. Only
  the inbound HV path was unchecked.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. Compare untrusted length to the actual
  buffer size, same pattern as other error returns in this function
  (unlock + `return -1`).
- **Minimal:** 7 lines, no API/struct/lock-order changes.
- **Regression risk:** very low. Oversize messages are dropped instead
  of copied. No CRQ error reply is sent; that matches the existing
  invalid-state / wrong-owner paths. A buggy HV might stall that buffer;
  that is better than heap corruption.
- **Red flags:** none in the diff. No public `Reviewed-by`/`Acked-by`
  from the listed ibmvmc maintainers (they were CC’d; thread had no
  replies).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Unchecked `msg_len` → `h_copy_rdma()` is from **`0eca353e7ae75`**
  (“misc: IBM Virtual Management Channel Driver (VMC)”, Bryant G. Ly,
  2018).
- First appeared: **`v4.18-rc1`** (`git describe --contains
  0eca353e7ae75`).
- The hole is as old as the driver, not recent churn.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introducer is the original driver commit
above. That commit **is** an ancestor of HEAD (`git merge-base --is-
ancestor 0eca353e7ae75 HEAD`).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `fd62c1f591372` (“release send buffer on write errors”) — same author,
  same day, **outbound** leak; independent of this inbound check.
- `a503587751651` — named `vio_device_id` initializers; unrelated.
- This patch is **standalone** (b4: single `[PATCH]`, not `X/Y`).

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Author is **not** the ibmvmc maintainer (MAINTAINERS: Brad Warrum,
  Ritu Agarwal).
- Same author has a cluster of similar validation patches (`hpilo`,
  `bcm-vk`, `xilinx_sdfec`, `genwqe`). That is a “static-analysis / LLM
  sweep” pattern, not a field report.
- Greg Kroah-Hartman still applied this one to char-misc.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Uses existing `msg_len`, `buffer->size`,
`adapter->dev`, `hmc->lock`. Applies on the original 2018 function
shape. **Standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 18189e5d84aa0`: **https://patch.msgid.link/20260624175139.7
  981-1-alhouseenyousef@gmail.com**
- `b4 dig -a`: **v1 only** (2026-06-24). Applied version is that v1.
- `b4 mbox`: **1 message in the thread**. No public review, NAK, or “Cc:
  stable” on-list.
- Direct lore HTTP fetches returned **403**; thread content recovered
  via `b4 mbox`. Body matches the git commit.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`):
- To: Brad Warrum, Ritu Agarwal (ibmvmc maintainers)
- Cc: Arnd Bergmann, Greg Kroah-Hartman, linux-kernel
- **No on-list reply.** Vetting is Greg’s apply (commit date Fri Jul 17
  2026) plus later presence in this tree.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No external bug report.** No syzbot/bugzilla. Trigger is a CRQ
from the PowerVM hypervisor, not a syscall fuzzer. Web search did not
find a stable@ thread for this subject.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Sibling `fd62c1f591372` is a **different** write-path leak. This
inbound check does not depend on it.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search via WebFetch **403**.
**UNVERIFIED** whether stable@ already discussed this. Not used as a
YES/NO driver.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`ibmvmc_recv_msg()`** only. (semcode MCP not available; taken
from the hunk.)

Step 5.2: TRACE CALLERS
Record (grep):
- `ibmvmc_recv_msg()` ← `ibmvmc_crq_process()` on `VMC_MSG_SIGNAL` after
  `ibmvmc_validate_hmc_session()`
- `ibmvmc_crq_process()` ← `ibmvmc_handle_crq()` for CRQ `valid == 0x80`
- `ibmvmc_handle_crq()` ← `ibmvmc_task()` tasklet
- Tasklet runs on VIO/CRQ interrupt from the hypervisor
- **One inbound path.** Not a syscall, not process context from
  userspace.

Step 5.3: TRACE CALLEES
Record:
- `h_copy_rdma()` → `plpar_hcall_norets(H_COPY_RDMA, length, …)` —
  hypervisor copies `length` bytes into the local LIOBN at
  `buffer->dma_addr_local`
- `alloc_dma_buffer()` (setup): `kzalloc(size, GFP_ATOMIC)` +
  `dma_map_single(..., size, DMA_BIDIRECTIONAL)`
- On success the old code also sets `buffer->msg_len`, wakes
  `ibmvmc_read()`

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Reachable when CONFIG_IBMVMC and a `ibm,vmc` VIO device (PowerVM
  management LPAR).
- **Not** triggerable by unprivileged userspace. Userspace `read()`
  already caps `nbytes` at `ibmvmc.max_mtu` before `copy_to_user`.
- The overrun is the **kernel RDMA copy in**, not the later
  `copy_to_user`.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record:
- Outbound `ibmvmc_write()` already validates size.
- `ibmvmc_send_open()` RDMA uses trusted `buffer->size`.
- `ibmvmc_process_capabilities()` sets `ibmvmc.max_mtu =
  min(ibmvmc_max_mtu, HV max_mtu)` **without** re-clamping to `MIN_MTU`
  (4096). A small negotiated MTU makes `kzalloc` objects smaller than a
  page, which makes an oversized `H_COPY_RDMA` more dangerous inside a
  page-granular TCE map.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` → **7.3.0-rc4**
- Driver present: `drivers/misc/ibmvmc.c`, `CONFIG_IBMVMC` depends on
  `PPC_PSERIES`
- Pre-fix body confirmed via `git show
  18189e5d84aa0^:drivers/misc/ibmvmc.c`
- Bug present since **v4.18**; this checkout already contains the fix
  (`git merge-base --is-ancestor 18189e5d84aa0 HEAD`)
- Current `ibmvmc_recv_msg()` at lines 1662–1667 already has the check

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Surrounding `ibmvmc_recv_msg()` control flow is
unchanged since 2018 (hmc_index/buffer_id/state/owner checks, then
RDMA). No refactor of this function in this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This **is** the length-check fix; no earlier variant.
`fd62c1f591372` is a different write-path issue.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** `drivers/misc` — IBM Power Virtual Management Channel
- **Criticality:** **PERIPHERAL / IMPORTANT for PowerVM management
  LPARs** — not core mm/fs, but it is the HV management channel
  (`/dev/ibmvmc`) on those systems
- Status in MAINTAINERS: **Supported**

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Low churn. Functional ibmvmc changes in this file are sparse
(driver 2018, GFP_ATOMIC fix, strncpy, then these 2026 checks).
**Mature, long-lived code.**

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Config/platform-specific:** `CONFIG_IBMVMC` on `PPC_PSERIES`
with a VMC adapter. Typical users: PowerVM management partitions (IBM
Power servers), including LTS distros that ship this driver.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: hypervisor CRQ `VMC_MSG_SIGNAL` with `msg_len > buffer->size`
- Not a hot syscall path; not an unprivileged attack
- Realistic sources: firmware/PHYP bug, nested/mis-emulated VMC, or a
  compromised HV
- **UNVERIFIED:** whether production PHYP ever emits an oversized length

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** `H_COPY_RDMA` of untrusted length into a
  `kzalloc`/`dma_map_single` buffer of `buffer->size`
- If the copy proceeds past the object: **kernel heap / DMA overwrite →
  HIGH/CRITICAL**
- If the IOMMU rejects the extra range: hcall fails; old code still
  stamps `buffer->msg_len` / owner before checking `rc` (pre-existing).
  The new check also avoids that for the oversized case.
- **Severity: HIGH** (memory corruption if the copy is honored;
  important even as defense-in-depth against firmware)
- **Note:** IOMMU/TCE page rounding can still allow overflow **within
  the mapped page** when `buffer->size` is smaller than PAGE_SIZE
  (possible after capability negotiation).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** HIGH for ibmvmc users — prevents a kernel-side overrun on
  a message the driver already treats as data into a sized buffer.
  Cheap, local check.
- **Risk:** VERY LOW — 7 lines, error-path only, no locking/API change,
  matches existing reject style.
- **Ratio:** strongly favors taking the patch.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real bounds bug: untrusted CRQ length used as RDMA copy size into a
  max_mtu-sized kernel buffer
- Driver and bug exist since v4.18; this tree has that code
- 7-line, obviously correct check; no new API/feature
- Applied by the char-misc maintainer
- Outbound path already validated; this closes the inbound hole
- Failure mode is memory corruption, which stable is meant to take
- Applies cleanly; no prerequisites

**AGAINST backporting:**
- No user/syzbot report; author looks like a validation sweep
- No maintainer Ack; mailing list was a single unreplied patch
- Trigger is the hypervisor, not unprivileged userspace
- ibmvmc is PowerVM-management-specific, not universal
- IOMMU may already fail some oversize copies (does not make the missing
  check correct)

**UNRESOLVED:**
- Exact PHYP `H_COPY_RDMA` behavior past TCE bounds
- Whether stable@ already discussed this (lore HTTP 403)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — check is locally verifiable;
   merged by Greg KH. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — missing length check
   on inbound HV messages into a sized kernel buffer. Affects
   ibmvmc/PowerVM management guests.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   buffer/DMA overrun → memory corruption. Severity HIGH.
4. Small and contained? **PASS** — +7 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context matches; already the
   same code shape since 2018.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Not an ID/quirk/DT/build/docs exception.** It is a normal
small memory-safety fix.

Step 9.4: MAKE YOUR DECISION
This tree is **v7.3-rc4**. The buggy `ibmvmc_recv_msg()` path exists in
this lineage and the 7-line check is the right fix. It meets stable
rules: real overrun, small, no features, clean apply, very low
regression risk. Niche hardware and lack of a field report do not
outweigh a kernel buffer overrun check.

**What it solves for stable users:** PowerVM management guests no longer
DMA-copy an attacker- or firmware-chosen length into a max_mtu heap
buffer.

**Risk vs benefit:** near-zero risk, meaningful corruption prevention.

**Concerns:** none that block backport (no deps, no rework). Maintainer
silence and missing Fixes/stable tags are not reasons to drop it.

Verification:
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, lore Link; no
  Fixes/Reported-by/Cc:stable/syzbot
- [Phase 1] Body: CRQ length → `h_copy_rdma()` into max_mtu buffer
- [Phase 2] Diff: +7 lines in `ibmvmc_recv_msg()`; `if (msg_len >
  buffer->size)` then unlock/return
- [Phase 2] Confirmed `ibmvmc_add_buffer()` sets `buffer->size =
  ibmvmc.max_mtu` and `alloc_dma_buffer()` is `kzalloc(size)` +
  `dma_map_single(..., size)`
- [Phase 2] Confirmed `ibmvmc_write()` already rejects `count >
  ibmvmc.max_mtu`
- [Phase 3] `git blame` on pre-fix file: lines from `0eca353e7ae75`
  (v4.18-rc1)
- [Phase 3] `git merge-base --is-ancestor 0eca353e7ae75 HEAD` → yes
- [Phase 3] `git merge-base --is-ancestor 18189e5d84aa0 HEAD` → yes (fix
  is in this checkout)
- [Phase 3] `git log --oneline -20 -- drivers/misc/ibmvmc.c`: sibling
  write-path leak fix is independent
- [Phase 4] `b4 dig -c 18189e5d84aa0`: lore msgid 20260624175139.7981-1;
  v1 only
- [Phase 4] `b4 dig -w`: maintainers + Greg + lkml CC’d
- [Phase 4] `b4 mbox`: 1-message thread, no NAK/review replies
- [Phase 4] lore WebFetch/curl: 403 — discussion beyond b4 cache
  UNVERIFIED
- [Phase 5] grep callers: SIGNAL CRQ → tasklet; not userspace
- [Phase 5] `ibmvmc_read()` caps `nbytes` at `max_mtu` before
  `copy_to_user` — overflow is the RDMA in, not the read out
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Current file lines 1662–1667 contain the check
- [Phase 7] Kconfig `IBMVMC` depends on `PPC_PSERIES`; MAINTAINERS
  Supported
- [Phase 8] Trigger: HV CRQ; users: PowerVM management; severity HIGH if
  copy overruns kzalloc object
- UNVERIFIED: firmware H_COPY_RDMA vs TCE overlength; stable@ history

**YES**

 drivers/misc/ibmvmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index af84e94ec5f0e..b26ee0d3626f5 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1659,6 +1659,13 @@ static int ibmvmc_recv_msg(struct crq_server_adapter *adapter,
 		return -1;
 	}
 
+	if (msg_len > buffer->size) {
+		dev_err(adapter->dev, "Recv_msg: msg_len 0x%lx exceeds buffer size 0x%x\n",
+			msg_len, buffer->size);
+		spin_unlock_irqrestore(&hmc->lock, flags);
+		return -1;
+	}
+
 	/* RDMA the data into the partition. */
 	rc = h_copy_rdma(msg_len,
 			 adapter->riobn,
-- 
2.53.0

