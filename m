Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E392759F4E5;
	Mon, 19 Oct 2026 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418368; cv=none; b=lVmgkS8mDTq1d6Sx12hyu6cY4ad42Udg+kH+1m7uHC1rtXR5Hew1ME1jiLOmmYQCXghsWmZVgVreLkMsm1+tAJ6y/9NW0ebQIJYvvVa5ZNl0UMSlOk4wuAC0IhyAw+nlczBm27Gfpb7TZY65hoUBAgnd04OhHwcJy4ZDDLfsQu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418368; c=relaxed/simple;
	bh=LmtkZ2SV1/chEwC4xhQ3CvS+sPilx0UDFXeyUOFAGrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h70IXBOggBIEjGbi4sFvXzSxjowm+pLBNHYSIRwgK6clpq6XxtlSEfhZggBVW/VDs4lizZUTHCKjulh+GhIFiCifK/8quEUKVPjSHOmU7WLWZpRy3tz2Tx9WZ55vveMgmwXvxoet66CzcJQc2fHph9K9MhlS7LiFCChzda0DLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJcgu4J+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJcgu4J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775D51F000C8;
	Mon, 19 Oct 2026 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418365;
	bh=dfaSzENZdtWDtRhEiA8zAhs3rBjmvEZNAHYLn8XcjZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJcgu4J+o66k+IW1Zoio421HZIen1v1j/QJpuUDyBdNoNDYQaIqeiSgG9YDyCiFPj
	 nIqcy0YA+MPYiVxY2Cr9HoMzE7k4UrW6qfQm/OEn54NV+sGVhBUEcDVffTA1m0E0Rv
	 ou01qVcRZ/aMQyF5DCEcw/cwqMPPeAplLCKKsbKFRyvVRb6c7rJ3lGdBCL7eYFaAHD
	 Ve2fxoMg33wpE2tilOIS2dF2VZhf3pPmnA/LwgsUmJQKgQ6mlfqAcY6sCTWtSQHe0A
	 7Oayg3ZjUVp1PkuOu8yfrv0BSvyGb5NVr2rhc4a11Zdf4Qum6YpHP8asHp4HeBR+RV
	 xDkOyJa7zA7ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xixin Liu <liuxixin@kylinos.cn>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hare@suse.de,
	axboe@kernel.dk,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison
Date: Mon, 19 Oct 2026 09:48:07 -0400
Message-ID: <20261019135441.1420968-196-sashal@kernel.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 3a6d89836ab09d53f4c32c57588689a378ce4363 ]

DH-HMAC-CHAP authentication compares HMAC response digests with memcmp().
Standard memcmp() may stop at the first differing byte, which can leak
timing information to a remote attacker and allow incremental recovery
of the expected digest.

Use crypto_memneq() for constant-time comparison on both the host path
that validates the controller Success1 response and the target path that
validates the host Reply digest.  Other memcmp() uses in the NVMe auth
code (e.g. fixed string prefix checks) are not security-sensitive and
are left unchanged.

Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`, `f0100363d8c37`). The
commit under review is `3a6d89836ab09` (“nvme-auth: use crypto_memneq
for DH-HMAC-CHAP response comparison”). It is already an ancestor of
HEAD (landed in v7.3-rc1). That does not decide the backport question;
the decision below is on technical merit and whether the bug exists in
this lineage.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[nvme-auth]** **[use]** Replace `memcmp()` with
`crypto_memneq()` when comparing DH-HMAC-CHAP HMAC response digests.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by: Hannes Reinecke <hare@kernel.org>` (author of the
  original NVMe in-band auth code)
- `Reviewed-by: Christoph Hellwig <hch@lst.de>`
- `Link:` — none in the commit
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>` (author)
- `Signed-off-by: Keith Busch <kbusch@kernel.org>` (NVMe maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` if present; it is not in
  this commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** DH-HMAC-CHAP compares HMAC response digests with `memcmp()`,
  which can return at the first differing byte.
- **Symptom/failure mode:** Timing leak of how far the computed HMAC
  matches the expected digest; a remote attacker could try to recover
  the expected digest incrementally.
- **Version information:** none in the message. Keith later said on-list
  it was applied “for 7.2”; `git merge-base --is-ancestor` shows it is
  **not** in `v7.2` and **is** in `v7.3-rc1`.
- **Root cause (author):** variable-time comparison of authentication
  MAC material.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit security/correctness
change: secret MAC comparison must be constant-time. The remaining
`memcmp()` uses (string prefixes, GUIDs) are called out as non-sensitive
and left alone.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/nvme/host/auth.c`: +2 / −1 (`#include <crypto/utils.h>`;
  `memcmp` → `crypto_memneq` in `nvme_auth_process_dhchap_success1`)
- `drivers/nvme/target/fabrics-cmd-auth.c`: +2 / −1 (same include;
  `memcmp` → `crypto_memneq` in `nvmet_auth_reply`)
- **Scope:** two-file surgical fix, 4 insertions, 2 deletions. No API,
  Kconfig, or data-structure changes.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Host (`nvme_auth_process_dhchap_success1`):** after `data->hl ==
  chap->hash_len` and `data->rvalid`, the host used to
  `memcmp(chap->response, data->rval, data->hl)`. Now
  `crypto_memneq(...)`. Failure still sets
  `NVME_AUTH_DHCHAP_FAILURE_FAILED` and returns `-ECONNREFUSED`.
- **Target (`nvmet_auth_reply`):** after computing the expected host
  HMAC into `response`, the target used to `memcmp(data->rval, response,
  data->hl)`. Now `crypto_memneq(...)`. Failure still frees `response`
  and returns `NVME_AUTH_DHCHAP_FAILURE_FAILED`.
- Affected path: authentication success/reply validation only, not
  probe/init/error-unrelated code.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety / crypto side channel]** Variable-time
`memcmp()` on HMAC digests. `crypto_memneq()` (`include/crypto/utils.h`)
is documented as “Compare two areas of memory without leaking timing
information” and returns 0 if equal, 1 otherwise — same boolean sense as
`if (memcmp(...))`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct and minimal. Length `data->hl` is already
checked against `chap->hash_len` on the host path. Return-value polarity
matches. Regression risk is very low: same control flow, slightly more
work per compare (HMAC length is 32–64 bytes). No new locks, APIs, or
userspace ABI.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Host `memcmp`: introduced in `f50fff73d620cd` (“nvme: implement In-
  Band authentication”, Hannes Reinecke, 2022). **In `v6.0`**, not in
  `v5.19`.
- Target `memcmp`: introduced in `db1312dd95488b` (“nvmet: implement
  basic In-Band Authentication”). Same merge window, **v6.0**.
- The buggy comparison has been in tree for many years.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commits above are the
functional equivalent. Both are ancestors of this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent work on these files is auth bounds-checking, hashing
updates, and secure-channel concatenation. This commit is standalone
(subject is not `N/M`). No prerequisite refactor is required for the
two-line swap plus include.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Xixin Liu is a contributor, not the NVMe auth maintainer. Weight
comes from **Reviewed-by Hannes Reinecke** (original auth author) and
**Christoph Hellwig**, applied by **Keith Busch**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Depends only on `crypto_memneq()` / `<crypto/utils.h>`. In this
tree, `include/crypto/utils.h` exists (`c616fb0cbae8`, 2023) and
`CONFIG_CRYPTO` selects `CRYPTO_LIB_UTILS` (`lib/crypto/memneq.c`).
`NVME_AUTH` already `select CRYPTO`. Standalone on this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 3a6d89836ab09` → https://patch.msgid.link/0001.nvme-auth-
  memneq.1781751816.git.liuxixin@kylinos.cn
- `b4 dig -a`: **v1 only** (no v2/v3). Applied as submitted.
- Thread (mbox): Christoph: “Looks good” + Reviewed-by. Hannes:
  Reviewed-by. No NAK, no stable discussion, no requested changes.
- Keith (2026-09-15): applied earlier; pointed at `3a6d89836ab09`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc included `linux-nvme@lists.infradead.org`,
Keith Busch, Jens Axboe, Christoph Hellwig, Sagi Grimberg, Chaitanya
Kulkarni, Hannes Reinecke. Right maintainers were on the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No `Reported-by`, bugzilla, or syzbot. This is code-audit /
crypto-hygiene, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Cover was `[PATCH v1 0/1]` / `[PATCH v1 1/1]` — single patch.
Precedent in this tree: `ksmbd: Compare MACs in constant time`
(`c5794709bc910`, had `Cc: stable`); `scsi: target: Use constant-time
crypto_memneq() for CHAP digests` (`cf14fc2be8688`); TPM/SMB client
similar replacements.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** on lore.kernel.org/stable (WebFetch 403,
WebSearch failed). The original NVMe thread never mentions `stable@`.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `nvme_auth_process_dhchap_success1`, `nvmet_auth_reply`.
Includes only otherwise.

**Step 5.2: TRACE CALLERS**

Record:
- `nvme_auth_process_dhchap_success1` ← `nvme_queue_auth_work` in
  `drivers/nvme/host/auth.c` (DH-HMAC-CHAP Success1 after AUTH_RECEIVE).
  Queued from connect / `dhchap_auth_work` / sysfs re-auth.
- `nvmet_auth_reply` ← `nvmet_execute_auth_send` when the DH-HMAC-CHAP
  step is Reply. `nvmet_execute_auth_send` is the fabrics AUTH_SEND
  execute handler (`drivers/nvme/target/fabrics-cmd.c`).

**Step 5.3: TRACE CALLEES**

Record: Target computes expected HMAC via `nvmet_auth_host_hash()` (HMAC
over challenge `dhchap_c1`, transformed host key, etc.), then compares.
Host compares precomputed `chap->response` to controller `rval`. No
allocation/locking change in the hunks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Reachable from the network** on an NVMe-oF target with
`CONFIG_NVME_TARGET_AUTH`. An unauthenticated remote host sending
AUTH_SEND Reply hits `nvmet_auth_reply`. Host path is hit when
connecting with in-band auth / bidirectional controller auth. Not a
syscall smash; it is the authentication protocol itself.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: After this commit, no remaining `memcmp` of HMAC material in
`drivers/nvme/host/auth.c` or `drivers/nvme/target/fabrics-cmd-auth.c`.
Other NVMe `memcmp` uses are prefix/GUID/debugfs checks, which the
commit correctly left alone.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes, in this lineage since v6.0. This checkout already contains
the fix (`crypto_memneq` at `drivers/nvme/host/auth.c:365` and
`drivers/nvme/target/fabrics-cmd-auth.c:189`). The pre-fix `memcmp` is
in `3a6d89836ab09^`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply on this tree** (already applied). Include is
`<crypto/utils.h>`, which this 7.3 tree has. For much older stables the
header was `crypto/algapi.h`; that is not a problem **here**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This *is* the fix in this tree. No earlier alternate memneq
conversion on these files.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: NVMe over Fabrics in-band authentication
(`drivers/nvme/host/auth.c`, `drivers/nvme/target/fabrics-cmd-auth.c`).
**IMPORTANT** for NVMe-oF deployments that enable auth; not core mm/VFS.
Configs: `NVME_HOST_AUTH` / `NVME_TARGET_AUTH` (help text “If unsure,
say N”), both select `NVME_AUTH`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (recent OOB/auth bounds fixes on the same
files). Auth itself has been stable in design since 2022.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Config-specific (`NVME_HOST_AUTH` / `NVME_TARGET_AUTH`) and only
during DH-HMAC-CHAP. Target comparison is the access-control check for
remote hosts.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every in-band auth exchange that validates an HMAC response.
Target path: remote peer during AUTH_SEND Reply. Host path:
bidirectional controller auth when `rvalid` is set. Unprivileged remote
initiator can hit the target compare if the subsystem is enabled.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Timing side channel on authentication MACs.** Severity
**HIGH** as a security defect (auth protocol using variable-time
compare). Practical “byte-by-byte recover the static secret” is weaker
than the commit text implies: `nvmet_auth_host_hash()` HMACs a per-
session challenge (`dhchap_c1`), so the expected digest is not a stable
value across attempts. Same caveat as the SCSI CHAP memneq patch. It is
still the wrong primitive for MAC compare; ksmbd’s analogous change was
`Cc: stable`.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record: **Benefit: high** for NVMe-oF auth users (closes a real class of
crypto bug on a remote-facing check). **Risk: very low** (4 insertions,
same branches, standard helper). Ratio strongly favors applying it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real crypto bug: `memcmp` on HMAC responses in DH-HMAC-CHAP
- Remote-facing target auth path
- 4-line, obviously correct replacement with the kernel’s constant-time
  helper
- Reviewed by Hannes Reinecke and Christoph Hellwig; applied by Keith
  Busch
- Bug present since v6.0; `crypto_memneq` already available here
- Same pattern as other MAC compares that stable has taken (e.g. ksmbd)
- No new feature/API; no locking/ABI change

**AGAINST:**
- Optional Kconfig (default N)
- No CVE/syzbot/user report
- Incremental digest recovery is harder than the message states because
  HMAC input includes a unique challenge
- No in-thread `Cc: stable`

**UNRESOLVED:**
- Whether stable@ ever discussed this (lore stable search failed)
- Practical remote exploitability over NVMe-oF (network jitter)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — polarity of `crypto_memneq`
   matches `memcmp`; reviewed by auth author and NVMe core reviewers; in
   mainline since 7.3-rc1.
2. Fixes a real bug that affects users? **PASS** — wrong comparison
   primitive on live HMAC auth; users with NVMe-oF in-band auth are
   affected.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   security (timing leak on authentication MAC), HIGH.
4. Small and contained? **PASS** — 2 files, +4/−2.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — already applied;
   `<crypto/utils.h>` and `CRYPTO_LIB_UTILS` are present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a small
security fix, which is in-scope for stable on its own.

**Step 9.4: MAKE YOUR DECISION**

This is a small, maintainer-reviewed security fix for NVMe-oF DH-HMAC-
CHAP: the host Success1 path and the target Reply path compared HMAC
digests with `memcmp()`. That can leak match length. `crypto_memneq()`
is the established kernel helper; control flow is unchanged. The code
has existed since v6.0, applies cleanly here, and does not need extra
commits.

Even if full incremental recovery of a static digest is unlikely because
each HMAC includes a fresh challenge, stable trees should not leave
authentication MACs on a variable-time compare. Risk is negligible;
benefit is closing a real crypto-hygiene hole on a network-facing auth
check.

### What problem it solves and why it matters
DH-HMAC-CHAP is NVMe-oF in-band authentication. The target decides
whether the host’s Reply HMAC is correct; the host (when bidirectional)
decides whether the controller’s Success1 HMAC is correct. Using
`memcmp()` can stop at the first mismatch and leak timing. Stable users
who enable this optional auth still need that check to be constant-time.

### Stable rules
The patch is obviously correct, tiny, already reviewed, and does not add
features. It fixes a security issue, not a style nit.

### Risk vs benefit
Very low regression risk versus a meaningful security improvement for
NVMe-oF auth. Header/`CRYPTO_LIB_UTILS` dependencies are already
satisfied in this 7.3 tree.

### Concerns
Exploitability is weaker than a static-secret `memcmp` leak; feature is
optional. Neither outweighs applying a 4-line, standard crypto fix.

Verification:
- [Phase 1] Parsed commit `3a6d89836ab09`: no Fixes/Reported-
  by/Cc:stable; Reviewed-by Hannes Reinecke and Christoph Hellwig; SOB
  Keith Busch
- [Phase 2] Diff: +`#include <crypto/utils.h>` and
  `memcmp`→`crypto_memneq` in `nvme_auth_process_dhchap_success1` and
  `nvmet_auth_reply` (+4/−2)
- [Phase 2] `include/crypto/utils.h`: `crypto_memneq` returns 0 if
  equal, 1 otherwise — matches `if (memcmp(...))`
- [Phase 3] `git blame` on parent: host memcmp from `f50fff73d620cd`
  (v6.0); target from `db1312dd95488b` (v6.0)
- [Phase 3] `git merge-base --is-ancestor f50fff73d620cd v6.0` yes;
  `v5.19` no
- [Phase 3] No Fixes tag to follow
- [Phase 3] Standalone 1/1 series; `NVME_AUTH` selects `CRYPTO`;
  `CRYPTO` selects `CRYPTO_LIB_UTILS`
- [Phase 4] `b4 dig -c 3a6d89836ab09`: lore msgid `0001.nvme-auth-
  memneq.1781751816.git.liuxixin@kylinos.cn`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: linux-nvme plus
  Busch/Axboe/Hellwig/Grimberg/Kulkarni/Reinecke
- [Phase 4] mbox: Christoph “Looks good”; Hannes Reviewed-by; no NAK;
  Keith: applied as `3a6d89836ab09`
- [Phase 4] WebFetch lore 403; WebSearch failed; stable-list discussion
  UNVERIFIED
- [Phase 5] Callers: host auth workqueue; target
  `nvmet_execute_auth_send` ← fabrics AUTH_SEND (remote)
- [Phase 5] `nvmet_auth_host_hash` HMACs `dhchap_c1` (per-session
  challenge) — verified in `drivers/nvme/target/auth.c`
- [Phase 5] No leftover HMAC `memcmp` in the two auth files
- [Phase 6] `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 3a6d89836ab09 HEAD` yes; not
  in `v7.2`; yes in `v7.3-rc1`
- [Phase 6] Local files already use `crypto_memneq` at the two call
  sites
- [Phase 8] Failure mode: timing leak on auth MAC compare; severity HIGH
  (security); trigger: NVMe-oF in-band auth
- UNVERIFIED: practical remote exploitability; whether stable@ already
  discussed the patch

**YES**

 drivers/nvme/host/auth.c               | 3 ++-
 drivers/nvme/target/fabrics-cmd-auth.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 8f3ccb317e4de..9d73713d6f828 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -9,6 +9,7 @@
 #include <linux/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/dh.h>
+#include <crypto/utils.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-auth.h>
@@ -381,7 +382,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 		return 0;
 
 	/* Validate controller response */
-	if (memcmp(chap->response, data->rval, data->hl)) {
+	if (crypto_memneq(chap->response, data->rval, data->hl)) {
 		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
 			__func__, chap->qid, (int)chap->hash_len, data->rval);
 		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 35bf1a2357d49..5b010318286e4 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -10,6 +10,7 @@
 #include <linux/nvme-auth.h>
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
+#include <crypto/utils.h>
 #include "nvmet.h"
 
 static void nvmet_auth_expired_work(struct work_struct *work)
@@ -187,7 +188,7 @@ static u8 nvmet_auth_reply(struct nvmet_req *req, void *d, u32 tl)
 		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
 	}
 
-	if (memcmp(data->rval, response, data->hl)) {
+	if (crypto_memneq(data->rval, response, data->hl)) {
 		pr_info("ctrl %d qid %d host response mismatch\n",
 			ctrl->cntlid, req->sq->qid);
 		pr_debug("ctrl %d qid %d rval %*ph\n",
-- 
2.53.0

