Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ED06155FD;
	Mon, 19 Oct 2026 14:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418653; cv=none; b=Q4dAPxk4WEKrev8JkhZQK3ewuNisCfcMUoqdg6to6uOWtCeMiLkXbHqawBwWKIUg0A6aYXAUAwBcA7C23l7aWMa6ORyNWXRgL2CpT8Ew1AB52shwap54HzpCeHVkzoECb7aXxEOa6P3zmZNn2mY+JTmllCnD7ZwQwKREgsbfRuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418653; c=relaxed/simple;
	bh=VbBkSARN/JD4yxRjBQ4TICaupMqWacbmGVaB5eDWjSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GjaAtOiDe76LuQKjUo0lfVc/llcn4fHNDGYzJHtCGs2jzxQf92ewW3nTFECbM2G670nUZPmoXBlM75n0xWsyU2cUPIUj0jGxBaXh2VlrCGFUO+BmipNfgZ/gCosrKFL2+L9cQxusJUaHAeTKANblRo0EWw4I6xPYnSFfVK3O9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Okq5Byyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Okq5Byyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0B91F000C9;
	Mon, 19 Oct 2026 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418650;
	bh=QWiDfVMVCaFUz1kFD0OIgw5hrbI95Ilr8io9OQQrYtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Okq5ByyqFOwr8IXJxvgggHJyCEQDLS4WBScXc/dW1bLguAfzvVpTxhIrAegQ/MBmI
	 nZKtWoVsJbLN4LDown1Yz3rfT6pcU4stUiX2OIWOJhhDDMO7zXDyau347m1ta2/EGn
	 NeyDA/3bH8GFKfG5wVth+GKnCBnLVmb68JXf3QcKqUglIjBZ42R9brWSQDnvFNRPIx
	 qbLxoZofx2Om2OfaNHNFEYpsHhlsVf3pHiok2cstHKChNRcBlRjpT0rnY2+HQvLMj3
	 Ab4sWJvNHk0YvYS3nvyba5uzYJ8OhaFADQYro1l6nLGvvy/DiuayjDCjCzCdU0mhsY
	 35ZgWrh3JfIsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] nvmet: passthru: fix OOB reads when parsing ns id descriptor list
Date: Mon, 19 Oct 2026 09:51:31 -0400
Message-ID: <20261019135441.1420968-400-sashal@kernel.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit bc7f75eba50012ed447654d8ce169ebaba695193 ]

nvmet_passthru_override_id_descs() walks a namespace identification
descriptor list populated from the underlying passthru controller's
Identify response, which is device reported. The loop advanced pos by
device controlled amounts (sizeof(*cur) + nidl) without checking that
the next descriptor header actually fits inside the buffer, so a
malicious device could push pos to within a few bytes of the buffer end
and cause cur->nidl, cur->nidt or the reserved field to be read past the
allocation.

Additionally, when a CSI descriptor lands exactly at the last valid
header offset, cur + 1 points one byte past the end of the buffer.
The unconditional memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN) could read
that out-of-bounds byte and copy it back to the initiator via
nvmet_copy_to_sgl(), leaking adjacent heap memory.

Bounds check both the descriptor header and the CSI value before
dereferencing them.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy descriptor
parser is present here; the fix is not. This is a small, obviously
correct OOB-read/info-leak fix in NVMe target passthrough.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[nvmet/passthru] [fix] [OOB reads when parsing namespace ID
descriptor list]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- Signed-off-by: Hari Mishal \<harimishal1@gmail.com\> (author)
- Signed-off-by: Keith Busch \<kbusch@kernel.org\> (NVMe maintainer,
  applied the patch)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable tags (absence is expected for this review pipeline)
- Ignore any pipeline “Upstream commit” / Sasha Levin markers — none
  were on the upstream commit itself

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `nvmet_passthru_override_id_descs()` walks a 4096-byte
  Identify NS descriptor list filled by the backend passthrough
  controller. The loop advances `pos` by `sizeof(*cur) + nidl` (`nidl`
  is device-controlled) without checking that the next descriptor header
  still fits in the buffer.
- **Symptom/failure:** OOB read of `cur->nidl` / `cur->nidt` / reserved
  past the allocation. If a CSI descriptor sits at the last valid header
  offset, `memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN)` reads one byte past
  the buffer and that byte can be copied to the initiator via
  `nvmet_copy_to_sgl()` — heap info leak.
- **Version info:** none in the message. Introducing code is from v5.19
  (see Phase 3).
- **Root cause:** missing bounds checks on descriptor header and CSI
  payload before dereference.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The subject and body describe a real
OOB read / leak. The diff is only bounds checks.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/nvme/target/passthru.c` — **+9 / -0** (upstream: 9
  insertions)
- Function: `nvmet_passthru_override_id_descs()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** loop `for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos +=
  len)` sets `cur = data + pos`, then immediately reads `cur->nidl` /
  `cur->nidt`. No check that `pos + sizeof(*cur)` is in range. CSI path
  does `memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN)` with no payload-size
  check.
- **After:**
  1. If `pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE`, break (stop
     before OOB header read).
  2. On CSI, if `pos + sizeof(*cur) + NVME_NIDT_CSI_LEN >
     NVME_IDENTIFY_DATA_SIZE`, break (stop before OOB CSI byte read).
- Path: Identify CNS=NS_DESC_LIST success path when `clear_ids` is set.
  Fail-safe: truncated/malformed list → `csi_seen` stays false → buffer
  zeroed, CSI not echoed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** memory safety — out-of-bounds read + heap info leak
- **Mechanism:** device-controlled `nidl` can place `pos` so a 4-byte
  `struct nvme_ns_id_desc` (`nidt`, `nidl`, `__le16 reserved`) does not
  fit. `NVME_NIDT_CSI_LEN` is 1; with header at offset 4092, `cur + 1`
  is byte 4096 (one past a 4096-byte `kzalloc`). That byte can be
  returned to the initiator.

Verified sizes in this tree (`include/linux/nvme.h`):
- `struct nvme_ns_id_desc` = 4 bytes
- `NVME_NIDT_CSI_LEN` = 1
- `NVME_IDENTIFY_DATA_SIZE` = 4096

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: two `break`s before dereference.
- Minimal: no unrelated changes.
- Regression risk: low. Breaking on a truncated list skips CSI override;
  `clear_ids` already zeros the rest of the list. Compliant devices put
  CSI well inside 4096 bytes.
- Host-side parser later also checks `pos + sizeof(*cur) + cur->nidl`;
  this passthru patch does not check non-CSI body size, but non-CSI
  payloads are not read here — only used to advance `pos`. Next
  iteration’s header check still stops OOB. Not a blocker.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy function introduced by **`34ad61514c4c3`** (“nvmet: add a
  clear_ids attribute for passthru targets”, Alan Adamson, 2022-06-27).
- First appeared: **v5.19-rc2** (`git describe`:
  `v5.19-rc2-35-g34ad61514c4c3`).
- **In this tree:** yes (`git merge-base --is-ancestor 34ad61514c4c3
  HEAD` → yes). Blame on the local file still points every line of this
  function at that commit.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Bug introduced by `34ad61514c4c3`, which is in
this 6.12 tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Local recent history of `passthru.c` includes `e38dad438fc08` (clear
  EUID/NGUID/UUID on loop) — does not change this loop.
- Upstream: `bc7f75eba5001` is the latest change to this file on
  `origin/master`; **no follow-up** after it.
- Standalone, not “patch X/Y”. Sibling host fix `3c568b35a0d30` (“nvme:
  bound ns descriptor header and body to identify buffer”) is a parallel
  pattern in `drivers/nvme/host/core.c`, **not a prerequisite** for this
  passthru patch.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Author is not the subsystem maintainer. Related upstream work: host NS
  descriptor bounds (`3c568b35a0d30`) and FDP clamp (`29261f8bb4166`).
- Applied by **Keith Busch** (NVMe maintainer). Weight is from
  maintainer application + Christoph Hellwig review, not author
  identity.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Uses existing `NVME_IDENTIFY_DATA_SIZE`, `struct nvme_ns_id_desc`,
  `NVME_NIDT_CSI`, `NVME_NIDT_CSI_LEN` — all in this tree.
- `git apply --check` of the upstream diff against this tree: **clean**.
- Can apply standalone. **No prerequisites.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c bc7f75eba5001` →
  https://patch.msgid.link/20260717144353.19436-1-harimishal1@gmail.com
- `b4 dig -a`: **v1 only** (single revision). Keith split the long line
  when applying (`if (pos + sizeof(*cur) + NVME_NIDT_CSI_LEN >`
  wrapped).
- `b4 dig -m /tmp/nvmet-oob.mbox`: full thread saved.
- Christoph Hellwig (20 Jul 2026): **“Overly long line here. Otherwise
  this looks sane.”** — no NAK.
- Keith Busch (10 Aug 2026): **“Thanks, applied to nvme-7.3 with fix to
  overly long line.”**
- No reviewer `Cc: stable` in the thread.
- WebFetch to lore.kernel.org returned **403**; discussion recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Hari Mishal, Christoph Hellwig, Sagi
Grimberg, Chaitanya Kulkarni, linux-nvme@lists.infradead.org, linux-
kernel@vger.kernel.org. Hellwig reviewed; Busch applied. Appropriate
NVMe maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by / syzbot / bugzilla. Found by code review (same
author class as the host parser bounds fix). Bug is still real from
reading the loop.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1. Related but independent: host `3c568b35a0d30`
(not in this tree). Not required to land this passthru fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org/stable via WebFetch returned
403. No stable discussion in the captured linux-nvme/lkml thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS IN THE DIFF**

Record: `nvmet_passthru_override_id_descs()` only.

**Step 5.2: TRACE CALLERS**

Record:
- Called from `nvmet_passthru_execute_cmd_work()` when Identify succeeds
  and `cns == NVME_ID_CNS_NS_DESC_LIST`.
- That work is used because `nvmet_parse_passthru_admin_cmd()` sets
  `req->execute = nvmet_passthru_execute_cmd` and `req->p.use_workqueue
  = true` for CNS CTRL/NS/NS_DESC_LIST.
- Reachable from an NVMe-oF initiator Identify command on a passthrough
  subsystem.

**Step 5.3: TRACE CALLEES**

Record: `kzalloc(4096)`, `nvmet_copy_from_sgl` (backend Identify data),
descriptor walk, `memset` + rebuild CSI, `nvmet_copy_to_sgl` (to
initiator), `kfree`. No new locks/allocators in the patch.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Userspace/admin enables `CONFIG_NVME_TARGET` +
  `CONFIG_NVME_TARGET_PASSTHRU`, exports a backend NVMe controller.
- Function only runs if `ctrl->subsys->clear_ids` is set. Default **1
  for loop** (`core.c`: “By default, set loop targets to clear IDS”);
  other transports via configfs `clear_ids`.
- Trigger: initiator Identify NS descriptor list. Backend-controlled
  bytes; initiator can receive leaked heap. Reachable from the fabrics
  initiator, not from an unprivileged syscall on the target without an
  NVMe-oF target setup.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same missing-bounds pattern in `nvme_identify_ns_descs()`
(`drivers/nvme/host/core.c`) in this tree. Upstream fixed it separately
(`3c568b35a0d30`). Confirms a systematic parser bug; this commit is the
target/passthru instance.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local `drivers/nvme/target/passthru.c` lines 53–64 are
the unbounded loop. `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`,
`make kernelversion` = **6.12.111**. Upstream fix `bc7f75eba5001` is
**not** an ancestor of HEAD. Bug since v5.19.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding function matches upstream pre-fix
(aside from later mainline kmalloc_obj churn, which is after this fix
and not in 6.12). `git apply --check` succeeded. Difficulty: clean
apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No commit with this subject in this tree. Host-side sibling
`3c568b35a0d30` also not in HEAD. No alternate fix for this passthru
loop.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **NVMe target passthrough** (`drivers/nvme/target/passthru.c`).
**IMPORTANT** for NVMe-oF target/passthru users (storage appliances,
loop testing), not core mm/VFS. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active. This 6.12 tree already has many nvmet stable-style fixes
(auth OOB, TCP PDU OOB, rdma leaks). Passthru file itself is relatively
mature since 2022.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Config-specific / driver-specific:** `CONFIG_NVME_TARGET=y/m`
and `CONFIG_NVME_TARGET_PASSTHRU=y`, and `clear_ids` enabled (default on
loop; optional elsewhere). Not all 6.12 users, but real production NVMe-
oF passthru and loop setups.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Identify NS descriptor list on a passthru namespace with `clear_ids`.
- Needs a backend that returns a truncated/malformed list (malicious or
  buggy NVMe device).
- Not a hot every-syscall path; realistic for passthru Identify.
- Unprivileged local user on the target: no, unless they are an
  initiator to that target. Remote initiator + malicious backend: yes,
  leak across the fabric.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- OOB read of header fields (KASAN / possible oops depending on slab).
- 1-byte heap leak to the initiator via Identify response.
- **Severity: HIGH** (memory safety + info leak). Not a universal panic,
  but security-class.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for passthru+clear_ids users — stops OOB read and
  initiator-visible leak. Same class as other nvmet bounds fixes already
  in this tree.
- **Risk:** very low — 9 lines, two bounds checks, fail-closed.
- **Ratio:** strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB read and heap leak, documented and confirmed in this tree’s
  code.
- Bug present since v5.19; fully present on 6.12.111.
- 9-line, obviously correct bounds checks; `git apply --check` clean.
- NVMe maintainer applied it; Christoph Hellwig: “looks sane.”
- No follow-up rework on `origin/master`.
- Fail-closed: malformed list just omits CSI, which matches `clear_ids`
  sanitizing.

**AGAINST:**
- Passthru is `default n`; needs `clear_ids`.
- No syzbot/CVE/Fixes/Cc: stable.
- Trigger is a malicious/buggy backend device, not a generic local
  syscall.
- Slightly weaker than the host parser (no `nidl` body check on skip).

**UNRESOLVED:**
- Stable list search (lore 403).
- No public reproducer beyond the described layout.

None of the against items outweigh a small, verified memory-safety fix
whose buggy code is in this tree.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — Hellwig + Busch; logic
   verified against struct sizes.
2. Fixes a real bug that affects users? **PASS** — OOB read/leak on
   Identify for passthru+clear_ids.
3. Important issue? **PASS** — HIGH: OOB read + heap leak to initiator.
4. Small and contained? **PASS** — 9 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply; code present; no
   missing deps.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
normal security/memory-safety bug fix.

**Step 9.4: MAKE YOUR DECISION**

Backport to this 6.12 tree. The parser the commit fixes is here, the
patch applies cleanly, and the failure is an OOB read that can leak heap
to an NVMe-oF initiator.

---

## What the commit solves (for this tree)

`nvmet_passthru_override_id_descs()` copies a 4096-byte Identify NS
descriptor list from the backend, walks it with device-controlled
strides, and may reconstruct a CSI descriptor for the initiator when
`clear_ids` is set. Without header/CSI bounds checks, a crafted list can
read past the allocation and send that byte to the initiator. On 6.12
this is the original 2022 loop; two range checks close it.

## Stable rules / risk vs benefit

Meets stable rules: real, important, small, no new API, applies here.
Benefit is stopping a leak/OOB on a path this tree already ships. Risk
is two `break`s on malformed input.

## Concerns

None that block backport. Host-side sibling `3c568b35a0d30` is a
separate candidate, not a dependency. `CONFIG_NVME_TARGET_PASSTHRU` is
optional; that narrows impact, not correctness.

---

## Verification

- [Phase 1] Parsed subject/body/tags from `git show bc7f75eba5001`;
  tags: two SOBs only.
- [Phase 2] Diff: +9 in `nvmet_passthru_override_id_descs()`; compared
  to local lines 53–64.
- [Phase 2] Sizes: `include/linux/nvme.h` — desc 4 bytes, CSI len 1,
  Identify size 4096.
- [Phase 3] `git blame -L 33,78 drivers/nvme/target/passthru.c` →
  `34ad61514c4c3`.
- [Phase 3] `git describe 34ad61514c4c3` → v5.19-rc2-35; `merge-base
  --is-ancestor 34ad61514c4c3 HEAD` → yes.
- [Phase 3] `merge-base --is-ancestor bc7f75eba5001 HEAD` → no (not in
  this tree).
- [Phase 3] `git log origin/master --oneline
  bc7f75eba5001..origin/master -- drivers/nvme/target/passthru.c` →
  empty (no follow-up).
- [Phase 3] `git show bc7f75eba5001 | git apply --check` → clean.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; lore URL; Hellwig “looks
  sane”; Busch applied to nvme-7.3.
- [Phase 4] WebFetch lore/patch.msgid.link: 403. Discussion from mbox,
  not WebFetch.
- [Phase 5] Callers: `nvmet_passthru_execute_cmd_work` ← Identify
  CNS_NS_DESC_LIST; parse path sets workqueue.
- [Phase 5] `clear_ids` default 1 for loop in
  `drivers/nvme/target/core.c:1457-1459`.
- [Phase 5] Host analog unbounded loop in this tree at
  `nvme_identify_ns_descs()`; upstream `3c568b35a0d30` not in HEAD.
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111; branch `pending-6.12`.
- [Phase 6] Local function matches pre-fix; origin/master post-fix
  matches this commit.
- [Phase 8] Failure: OOB read + 1-byte heap leak to initiator; HIGH.
- UNVERIFIED: lore.kernel.org/stable discussion (HTTP 403). Not used to
  drive the verdict.

**YES**

 drivers/nvme/target/passthru.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 0c361b1e35665..6d7469c94610e 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -53,13 +53,22 @@ static u16 nvmet_passthru_override_id_descs(struct nvmet_req *req)
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
+
 		if (cur->nidl == 0)
 			break;
+
 		if (cur->nidt == NVME_NIDT_CSI) {
+			if (pos + sizeof(*cur) + NVME_NIDT_CSI_LEN >
+						NVME_IDENTIFY_DATA_SIZE)
+				break;
+
 			memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN);
 			csi_seen = true;
 			break;
 		}
+
 		len = sizeof(struct nvme_ns_id_desc) + cur->nidl;
 	}
 
-- 
2.53.0

