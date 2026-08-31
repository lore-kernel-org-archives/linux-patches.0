Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E70C471258;
	Mon, 31 Aug 2026 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184173; cv=none; b=oLv6nToyceUx5BBd2qcO6b2NUO5WTT/1gs4MRLqo3wrq7JRsvy9vG9wHh++5pOd9LjvzQNfZrPPhzdsDaJh/LvqLS9kWYfhc/995ea+7RT3W/Vo6I17IIyxupfhW1z1oHIcQKEYdE8zzyf9pavb9Q66a0bvwEZ/69ZNjs1NYdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184173; c=relaxed/simple;
	bh=maj71gLSTEZs/M0cVdDA3QZ9a3mo5d82Pd/9XOvqcuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkzCbVRF8vtP+vUYXexJIjv2f/7nKJOhdtc90rAaT8/86TUMztLKoNIPUfUn+alK9Eew7YJYubArXvH6ECgrtQDjFwmRzT8hBeVhpONLiSBXX9ut+Q7u6oV1zGO3muYnzKhGUACW+59mpuCJqbFvurwZfTg/UVKBIXo/PdEd1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6s9jtme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6s9jtme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F041F000E9;
	Mon, 31 Aug 2026 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184171;
	bh=KWH8q/+Nf3LEPl4TzZQQclYGb8veuIRW8X4vfBv1HmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6s9jtmeVpM01M3WzbUvMowGFAyMwh82ZyLtk6G4ZJDlDHp3CWJUCPvQ7LLgoTFC8
	 JjjaYXrW/Pc6E2Y9uOHJkymdHcoh1qt6rpOp+DX/SecXXhFw+tn/1KqNK3vap8TRk+
	 v9MJ++b6lMK7NyuzPxYOOkeozaoM5do/+vdzPQ7NqVlUTjapbpeva7xyxB2MA+XkNT
	 Cj31VmvkED1V9p8JwPtjjvqWPrwg4YuAFVcNF+9YY4GUw9EsdAgu4KpllDFZ3IE+B8
	 h8gATBZm9J20+ZGO8EkFKMTAU4IevDL9moftOYRJJ/PMRGW6Bl22yAWA4WEWoDaPVa
	 r77kR2vBzYmDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Muralidhara M K <muralidhara.mk@amd.com>,
	Muthusamy Ramalingam <muthusamy.ramalingam@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	naveenkrishna.chatradhi@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86/amd/hsmp: Clamp ioctl/send_message indices (Spectre v1)
Date: Mon, 31 Aug 2026 09:29:21 -0400
Message-ID: <20260831133314.4125787-533-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Muralidhara M K <muralidhara.mk@amd.com>

[ Upstream commit d20457b46eca76b9bb716dd31af591cad21607b5 ]

Although validate_message() checks msg_id, a mispredicted branch can
still allow speculative indexing into hsmp_msg_desc_table[]. Clamp
msg.msg_id with array_index_nospec() at entry to hsmp_ioctl_msg() so
downstream dereferences (including via is_get_msg() and
hsmp_send_message()) see a bounded index.

Similarly, hsmp_send_message() bounds-checks msg->sock_ind before
indexing hsmp_pdev.sock[], but a mispredicted branch can still
speculatively use the raw index (Spectre v1, CVE-2017-5753). Apply
array_index_nospec() after the check so every caller that reaches
hsmp_pdev.sock[] through this helper sees a clamped socket
index—including hsmp_ioctl_msg() and any other path that hands a
user-derived struct hsmp_message to hsmp_send_message().

Reviewed-by: Muthusamy Ramalingam <muthusamy.ramalingam@amd.com>
Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>
Link: https://patch.msgid.link/20260612042610.1629037-7-muralidhara.mk@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `platform/x86/amd/hsmp: Clamp
ioctl/send_message indices (Spectre v1)`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)
**Commit under review:** `d5be735237be5` (upstream: `d20457b46eca`) —
present on `autosel` branch, **not** in current `HEAD`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject parse**
Record: `[platform/x86/amd/hsmp]` `[Clamp]` — Spectre v1 mitigation for
user-controlled array indices in HSMP ioctl/send_message paths.

**Step 1.2 — Tags**
Record:
- `Reviewed-by: Muthusamy Ramalingam <muthusamy.ramalingam@amd.com>`
  (AMD)
- `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (platform-drivers-x86 maintainer)
- `Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>` (author)
- `Link: https://patch.msgid.link/20260612042610.1629037-7-
  muralidhara.mk@amd.com`
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- `[Upstream commit d20457b46eca...]` marker present (pipeline artifact
  — ignored per instructions)

**Step 1.3 — Body analysis**
Record:
- **Bug:** After bounds checks on `msg_id` and `sock_ind`, a
  mispredicted branch (Spectre v1 / CVE-2017-5753) can still cause
  speculative indexing into `hsmp_msg_desc_table[]` and
  `hsmp_pdev.sock[]`, leaking kernel memory into cache.
- **Symptom:** Side-channel information disclosure (not a direct crash).
- **Root cause:** Missing `array_index_nospec()` after bounds checks on
  user-controlled indices.
- **Fix:** Clamp `msg.msg_id` in `hsmp_ioctl()` before downstream use;
  clamp `sock_ind` in `hsmp_send_message()` before socket array access.
- Note: commit message refers to `hsmp_ioctl_msg()` but the actual
  function is `hsmp_ioctl()` (verified in source).

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit Spectre v1 security fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **Files:** `drivers/platform/x86/amd/hsmp/hsmp.c` (+23 / -1)
- **Functions:** `hsmp_send_message()`, `hsmp_ioctl()`
- **Scope:** Single-file, surgical security fix

**Step 2.2 — Code flow changes**

| Hunk | Before | After |
|------|--------|-------|
| `hsmp_send_message()` | Bounds-check `sock_ind`, then directly index
`hsmp_pdev.sock[msg->sock_ind]` | After bounds check, `sock_ind =
array_index_nospec(msg->sock_ind, hsmp_pdev.num_sockets)` then index
with clamped value |
| `hsmp_ioctl()` | Bounds-check `msg_id`, then call `is_get_msg()` /
`hsmp_send_message()` with raw `msg_id` | After bounds check,
`msg.msg_id = array_index_nospec(msg.msg_id, HSMP_MSG_ID_MAX)` before
any table dereference |

Record: Both hunks affect the userspace ioctl hot path and the shared
`hsmp_send_message()` helper used by ioctl.

**Step 2.3 — Bug mechanism**
Record: **Memory safety / Spectre v1 speculative out-of-bounds read.**
User-supplied `msg_id` and `sock_ind` pass explicit bounds checks, but
CPU speculation can bypass those checks and index past array ends into
adjacent kernel memory. `array_index_nospec()` masks the index so
speculative execution cannot use out-of-range values.

**Step 2.4 — Fix quality**
Record: Fix is minimal, follows the established kernel Spectre-
mitigation pattern (`array_index_nospec` after bounds check). No new
locking or API changes. Regression risk is very low. Compiles
successfully in this tree without additional includes (verified).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Vulnerable ioctl/send_message logic dates to `91f410aa679a03`
("platform/x86: Add AMD system management interface", Feb 2022, first in
**v6.0**). Bounds checks on `sock_ind` added in `8e75dff56e003` (Oct
2024 refactor). Bug has been present since driver introduction.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3 — Related file history**
Record: Recent `hsmp.c` changes in this tree include timeout/semaphore
fixes (`784e48a82976e`, `f8afb12a2d750`) and `2c78fb287e1f4` (NULL check
for `metric_tbl_addr`). No prior Spectre/nospec fix for HSMP in `HEAD`.

**Step 3.4 — Author context**
Record: Muralidhara M K (AMD). Patch is part of v6 series "Family 1Ah
Model 50h-5Fh HSMP and metrics" but this specific commit only touches
existing ioctl/send paths — no dependency on new message IDs from other
series patches.

**Step 3.5 — Dependencies**
Record: **Standalone.** Applies cleanly (`git apply --check` passed). No
prerequisite commits required. `array_index_nospec` and
`include/linux/nospec.h` exist in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c d5be735237be5` found thread at
https://patch.msgid.link/20260612042610.1629037-7-muralidhara.mk@amd.com
— `[PATCH v6 6/8]`. Series revisions: v5 and v6 exist; committed version
matches v6. Full lore thread fetch blocked by Anubis bot protection
(could not read inline review text).

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows CC to `platform-driver-x86@vger.kernel.org`,
`linux-kernel@vger.kernel.org`, AMD reviewer, and Ilpo Järvinen.

**Step 4.3 — Bug report**
Record: N/A — no external bug report or syzbot link. Security issue
identified by code review in patch series context.

**Step 4.4 — Series context**
Record: Patch 6/8 in Family 1Ah HSMP series. The Spectre fix is
independent of patches 1–5 and 7–8 (new hardware messages/metrics). Safe
to backport alone.

**Step 4.5 — Stable list**
Record: Not searched on lore stable list (thread content unavailable).
No evidence against backport found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `hsmp_ioctl()`, `hsmp_send_message()`, `validate_message()`,
`is_get_msg()`

**Step 5.2 — Callers**
Record:
- `hsmp_ioctl()` — registered as `.unlocked_ioctl` / `.compat_ioctl` in
  `hsmp_fops`, exposed via misc device `/dev/hsmp` (mode **0644**)
- `hsmp_send_message()` — called from `hsmp_ioctl()`,
  `hsmp_msg_get_nargs()`, `hsmp_test()`, internal metric/proto paths,
  and `hwmon.c` (kernel-constructed messages with trusted indices)

**Step 5.3 — Callees**
Record: `copy_struct_from_user()`, `is_get_msg()` →
`hsmp_msg_desc_table[]`, `validate_message()` → `hsmp_msg_desc_table[]`,
`down_interruptible()`, `__hsmp_send_message()`

**Step 5.4 — Reachability**
Record: **Userspace-reachable.** Any local user can open `/dev/hsmp`
(world-readable/writable) and issue ioctl with crafted
`msg_id`/`sock_ind`. This is the primary attack surface.
`hsmp_send_message()` is also exported (`EXPORT_SYMBOL_NS_GPL`) for
other kernel modules.

**Step 5.5 — Similar patterns**
Record: Kernel has extensive precedent for `array_index_nospec` Spectre
fixes (e.g., `c2178ff1c70eb` ipv4/icmp, `f0e441be08a2e` drm/ioc32,
`1f5f94c6c6b2e` vhost/vdpa). No similar fix yet in
`drivers/platform/x86/`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code present?**
Record: **YES.** Current `HEAD` at
`drivers/platform/x86/amd/hsmp/hsmp.c` lines 213–215 and 308–338 contain
bounds checks without `array_index_nospec`. Driver present since v6.0;
fully present in 6.18.44.

**Step 6.2 — Backport complications**
Record: **Clean apply.** `git apply --check` succeeded. Patch compiles
(`make drivers/platform/x86/amd/hsmp/hsmp.o` succeeded). No conflicts
with recent hsmp changes in this tree.

**Step 6.3 — Fix already present?**
Record: **NO.** `grep array_index_nospec drivers/platform/x86/amd/hsmp/`
returns nothing on `HEAD`. Fix exists only on `autosel` branch
(`d5be735237be5`), not merged into current `HEAD`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `drivers/platform/x86/amd/hsmp` — AMD HSMP platform driver.
**Criticality: IMPORTANT** (peripheral driver, but security-sensitive
when `CONFIG_AMD_HSMP` is enabled on AMD EPYC/MI300A servers).

**Step 7.2 — Activity**
Record: Actively maintained — recent commits for protocol v7 messages,
telemetry sysfs, semaphore/timeout fixes in 6.16–6.18 timeframe.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Systems with `CONFIG_AMD_HSMP` / `CONFIG_AMD_HSMP_ACPI` /
`CONFIG_AMD_HSMP_PLAT` on AMD EPYC and MI300A platforms. Not universal,
but real production server hardware.

**Step 8.2 — Trigger conditions**
Record: Local user opens `/dev/hsmp` and issues ioctl with out-of-range
`msg_id` or `sock_ind` crafted to exploit branch misprediction.
**Unprivileged local users can trigger** (device mode 0644). Trigger
requires Spectre v1 exploitation techniques but the vulnerable code
pattern is confirmed present.

**Step 8.3 — Failure mode severity**
Record: **Speculative kernel memory disclosure** (Spectre v1 side
channel). Severity: **HIGH** from security perspective (CVE-2017-5753
class). No direct crash or data corruption, but information leak from
kernel to userspace.

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Closes a known Spectre v1 gadget on a world-accessible
  device node; aligns with established kernel security policy.
- **Risk:** Very low — 23 lines, standard `array_index_nospec` pattern,
  compiles and applies cleanly.
- **Ratio:** Strong benefit, minimal risk → backport warranted.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real Spectre v1 security vulnerability (CVE-2017-5753)
- User-controlled indices via ioctl on world-accessible `/dev/hsmp`
- Standard, obviously-correct mitigation pattern
- Small, single-file, standalone fix
- Reviewed by AMD engineer and platform-x86 maintainer
- Applies and compiles cleanly on 6.18.44
- Bug present since driver introduction (v6.0)
- Strong kernel precedent for identical fixes in stable

**AGAINST backport:**
- Limited to AMD HSMP-enabled systems (not all kernels/users)
- No syzbot report or user crash report (side-channel, hard to observe)
- Part of larger patch series (but this commit is self-contained)

**Unresolved:** Full lore review thread content unavailable (bot
protection). Does not affect technical assessment.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — standard
   `array_index_nospec`; compiles in this tree; reviewed by AMD +
   maintainer.
2. Fixes a real bug? **PASS** — Spectre v1 speculative OOB read on user-
   controlled indices.
3. Important issue? **PASS** — security vulnerability (information
   disclosure).
4. Small and contained? **PASS** — 23 lines, 1 file, 2 functions.
5. No new features/APIs? **PASS** — pure hardening, no behavior change
   for valid inputs.
6. Can apply to local tree? **PASS** — clean apply, successful compile
   on 6.18.44.

**Step 9.3 — Exception categories**
Record: N/A (security hardening, not device ID/quirk/build/doc
exception).

**Step 9.4 — Decision rationale**
This fix closes a Spectre v1 gadget in the AMD HSMP driver where local
users can pass crafted indices through a world-accessible ioctl
interface. The vulnerable code exists in Linux 6.18.44, the patch is
minimal and self-contained, and it follows the same pattern routinely
accepted for stable backports. The limited hardware scope does not
outweigh the security nature of the fix.

---

## Verification

- [Phase 1] Parsed commit `d5be735237be5` / upstream `d20457b46eca`:
  subject, tags, body; noted `hsmp_ioctl_msg` vs `hsmp_ioctl` naming
  discrepancy
- [Phase 2] Diff: +23/-1 in `hsmp.c`; two hunks in `hsmp_send_message()`
  and `hsmp_ioctl()`
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame`: vulnerable code
  from `91f410aa679a03` (v6.0)
- [Phase 3] `git log -20 -- drivers/platform/x86/amd/hsmp/hsmp.c`: no
  prior nospec fix in HEAD
- [Phase 3] `git merge-base --is-ancestor d5be735 HEAD`: commit NOT in
  HEAD; on `autosel` branch
- [Phase 4] `b4 dig -c d5be735237be5`: lore URL found, patch 6/8 of v6
  series
- [Phase 4] `b4 dig -a`: v5 and v6 revisions exist
- [Phase 4] `b4 dig -w`: platform-driver-x86@, AMD reviewer CC'd
- [Phase 4] WebFetch lore thread: blocked by Anubis (UNVERIFIED: inline
  reviewer stable nominations)
- [Phase 5] `grep hsmp_send_message`: ioctl path + kernel-internal
  callers identified
- [Phase 5] Read `hsmp.c:439-446`: misc device mode 0644 confirmed
- [Phase 5] Read `arch/x86/include/uapi/asm/amd_hsmp.h`: `HSMP_TEST=1`,
  `HSMP_MSG_ID_MAX`, `hsmp_msg_desc_table[]` confirmed
- [Phase 6] `grep array_index_nospec drivers/platform/x86/amd/hsmp/`: no
  matches on HEAD (bug present)
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 6] `make drivers/platform/x86/amd/hsmp/hsmp.o` with patch:
  compile succeeded
- [Phase 7] Read `drivers/platform/x86/amd/hsmp/Kconfig`: AMD_HSMP
  targets EPYC/MI300A
- [Phase 8] Device mode 0644: unprivileged local access confirmed

**YES**The background lookups are done and match what we already used in
the review:

- **Commit hash:** `d5be735237be5` — `platform/x86/amd/hsmp: Clamp
  ioctl/send_message indices (Spectre v1)`
- **`hsmp.c` history:** ioctl/send paths go back to the original HSMP
  driver (`91f410aa679a03`, v6.0); recent churn is mostly refactors,
  protocol v7, and timeout/semaphore fixes
- **Fix in tree:** not in current `HEAD` (6.18.44); only on `autosel`

Verdict for this tree is still **YES** — small Spectre v1 hardening on
`/dev/hsmp`, applies and builds cleanly.

 drivers/platform/x86/amd/hsmp/hsmp.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/hsmp/hsmp.c b/drivers/platform/x86/amd/hsmp/hsmp.c
index 19f82c1d30905..008a02ace4842 100644
--- a/drivers/platform/x86/amd/hsmp/hsmp.c
+++ b/drivers/platform/x86/amd/hsmp/hsmp.c
@@ -202,6 +202,7 @@ static int validate_message(struct hsmp_message *msg)
 int hsmp_send_message(struct hsmp_message *msg)
 {
 	struct hsmp_socket *sock;
+	unsigned int sock_ind;
 	int ret;
 
 	if (!msg)
@@ -212,7 +213,15 @@ int hsmp_send_message(struct hsmp_message *msg)
 
 	if (!hsmp_pdev.sock || msg->sock_ind >= hsmp_pdev.num_sockets)
 		return -ENODEV;
-	sock = &hsmp_pdev.sock[msg->sock_ind];
+
+	/*
+	 * Sanitize sock_ind after the bounds check.  A mispredicted branch can
+	 * still let the CPU speculatively use msg->sock_ind as an index into
+	 * hsmp_pdev.sock[] (Spectre v1, CVE-2017-5753), including for callers
+	 * other than hsmp_ioctl_msg() that pass a user-derived socket index.
+	 */
+	sock_ind = array_index_nospec(msg->sock_ind, hsmp_pdev.num_sockets);
+	sock = &hsmp_pdev.sock[sock_ind];
 
 	ret = down_interruptible(&sock->hsmp_sem);
 	if (ret < 0)
@@ -308,6 +317,19 @@ long hsmp_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (msg.msg_id < HSMP_TEST || msg.msg_id >= HSMP_MSG_ID_MAX)
 		return -ENOMSG;
 
+	/*
+	 * Sanitize the user-controlled msg_id against speculative
+	 * execution.  The bounds check above retires the out-of-range
+	 * case with -ENOMSG, but a mispredicted branch can still let the
+	 * CPU speculatively use msg_id as an index into
+	 * hsmp_msg_desc_table[] (here and in validate_message() /
+	 * is_get_msg() called downstream via hsmp_send_message()), and
+	 * pull arbitrary kernel memory into the cache (Spectre v1,
+	 * CVE-2017-5753).  Clamp once into msg.msg_id so every downstream
+	 * dereference sees the sanitized value.
+	 */
+	msg.msg_id = array_index_nospec(msg.msg_id, HSMP_MSG_ID_MAX);
+
 	switch (fp->f_mode & (FMODE_WRITE | FMODE_READ)) {
 	case FMODE_WRITE:
 		/*
-- 
2.53.0

