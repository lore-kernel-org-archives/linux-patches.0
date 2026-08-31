Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525F53ECEC;
	Mon, 31 Aug 2026 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183950; cv=none; b=Bb0DXh/CK10oWKOWPBuCIQKTBuH9DyH2JzzhOoEAeToxWD6UPwwwJ0UK1z59LA58v+U09BcRbpzlqYAB0diOee7Nfwz7fo7tMIku+/tliJG5SgQBt2Ast8WAg3Th0YUnPNz0M1hXh69WB4gqRWz2qb67up8CnWzyKf2V1hsLSfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183950; c=relaxed/simple;
	bh=XlNxqSA133ZMrZnSfjO640y26Jdh3/XjLckUv6n/kqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceXnXsjehjMQ00Jv2eTw59NFNUwyrXgdNuf1QXGZFDskgIUpUWfvrMq72BFEYyvaDYKMf7qSH/yQaar7Nj2xemah4hHn/blAGMlHpxgTJB3sWd004NpopF6oRn/iIhiib85qNaHmG3W/7PVkTmCg8s+0tiwlGbkKPuLdaZl4mgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFjqMsAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFjqMsAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB3D1F00ACA;
	Mon, 31 Aug 2026 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183947;
	bh=5VuKC7elaBXrqqotHw05DBEnzKzZ+p6CwQxhm96PQH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFjqMsAn7aBlXCQUwqQBCDcqDgbwkL8GOFvIWE+HbkAJEmBtCape8SSEFjFsbjHxU
	 gL1FFlIyInYgBtiD31jQXrxbR2KvjXATGwtun0Q3DHvzv0SvoRmqIwH2ncbinniBOL
	 U1rftaep1yzsQo3cw9U4FB/2X49PYvihA/0K3rxPhxEAZ8Swt9tQ5omWGhSEIIlfFe
	 hFe+SMhqBeMdVRlGq9he0si+/ex6I1SpiFC8BPoWD4rxcEIpOOSzx568Jr9clphVkt
	 fM2Xc2vcffke6+zdEPTeO/IYOKOBvrFHoWGJN6RWWAoAC1HeR7zB1cM5DYWNZHfwoP
	 91Ik1gepoWe6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leo Yan <leo.yan@arm.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] bpftool: Pass host flags to bootstrap libbpf
Date: Mon, 31 Aug 2026 09:27:05 -0400
Message-ID: <20260831133314.4125787-397-sashal@kernel.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 9080b97689dbf8d2c338a9af97cd2b4a714f25bf ]

bpftool builds a bootstrap libbpf with HOSTCC, but the libbpf submake can
still inherit target build flags through CFLAGS. This can break cross
builds when host objects are compiled with target-only options.

Since HOST_CFLAGS contains warning options that are not suitable for
building libbpf, use LIBBPF_BOOTSTRAP_CFLAGS with the warning options
removed to build the bootstrap libbpf. Clear EXTRA_CFLAGS so target
extra flags are not mixed into the host bootstrap libbpf build.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/20260602-tools_build_fix_zero_init_bpf_only-v2-1-c76e5250ea1c@arm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[bpftool] [Pass] Pass host flags to bootstrap libbpf — fix
bootstrap libbpf submake inheriting target build flags during cross-
compilation.`

**Step 1.2 — Tags**

| Tag | Value |
|-----|-------|
| Signed-off-by | Leo Yan \<leo.yan@arm.com\> |
| Acked-by | Quentin Monnet \<qmo@kernel.org\> (bpftool maintainer) |
| Link | https://lore.kernel.org/r/20260602-
tools_build_fix_zero_init_bpf_only-v2-1-c76e5250ea1c@arm.com |
| Signed-off-by | Alexei Starovoitov \<ast@kernel.org\> |

No Fixes:, Reported-by:, Tested-by:, or Cc: stable tags (expected for
manual review).

Record: Acked-by from bpf/bpftool maintainer. Part of `[PATCH bpf-next
v2 1/8]` series. No syzbot or user crash reports.

**Step 1.3 — Body analysis**

Record:
- **Bug:** bpftool builds bootstrap libbpf with `HOSTCC`, but the libbpf
  submake can still inherit target `CFLAGS`/`EXTRA_CFLAGS` from the
  parent make.
- **Symptom:** Cross-build failures when host objects are compiled with
  target-only compiler options.
- **Root cause:** Submake does not override inherited flags;
  `HOST_CFLAGS` warning options are also unsuitable for libbpf’s own
  warning setup.
- **Fix approach:** Pass `CFLAGS="$(LIBBPF_BOOTSTRAP_CFLAGS)"` (host
  flags with warnings stripped) and `EXTRA_CFLAGS=` to the bootstrap
  libbpf submake.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit build-system bug fix, not disguised
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

| File | Changes |
|------|---------|
| `tools/bpf/bpftool/Makefile` | +5 / -1 |

Functions/rules modified: `$(LIBBPF_BOOTSTRAP)` recipe, new
`LIBBPF_BOOTSTRAP_CFLAGS` variable.

Record: Single-file, surgical Makefile change. Scope: build-system only.

**Step 2.2 — Code flow change**

Hunk 1 — `$(LIBBPF_BOOTSTRAP)` recipe:
- **Before:** Submake invoked with `HOSTCC`/`HOSTLD`/`HOSTAR` and
  `ARCH=`/`CROSS_COMPILE=` cleared, but no explicit `CFLAGS` or
  `EXTRA_CFLAGS`.
- **After:** Submake gets explicit `CFLAGS="$(LIBBPF_BOOTSTRAP_CFLAGS)"`
  and `EXTRA_CFLAGS=`.

Hunk 2 — new variable:
- **Before:** No dedicated bootstrap libbpf CFLAGS.
- **After:** `LIBBPF_BOOTSTRAP_CFLAGS` = `HOST_CFLAGS` with `-W`,
  `-Wall`, `-Wextra`, `-Wformat`, `-Wformat-signedness` removed.

Record: Normal bootstrap libbpf build path during cross-compilation is
affected.

**Step 2.3 — Bug mechanism**

Record: **Build-system flag leakage.** Parent make exports/inherits
`CFLAGS` and `EXTRA_CFLAGS` into the libbpf submake.
`tools/lib/bpf/Makefile` uses `ifdef EXTRA_CFLAGS` to replace `CFLAGS`
entirely, and appends `$(CLANG_CROSS_FLAGS)`. Without explicit
overrides, target cross-compile flags reach host bootstrap objects.

**Step 2.4 — Fix quality**

Record: Fix is obviously correct, minimal, and follows the existing
pattern in `tools/bpf/resolve_btfids/Makefile` (`CROSS_COMPILE=""
CLANG_CROSS_FLAGS="" EXTRA_CFLAGS="$(HOSTCFLAGS)"`). Low regression risk
— Makefile-only, bootstrap path only.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `$(LIBBPF_BOOTSTRAP)` recipe dates to 2020–2023
(`ced846c65e8ff`, `8859b0da5aac2`, `c62dd8a58d19f`, `af0e26beaa693c`).
Cross-build partial fixes: `bdadbb44c90ae` (2021, clang cross),
`0b817059a8830` (2022, `HOSTAR`), `cc9b22dfa7358` (2024, `HOST_CFLAGS`
cleanup). Buggy gap (no explicit CFLAGS/`EXTRA_CFLAGS=` for libbpf
submake) has existed since bootstrap libbpf was introduced.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record: Related commits in this tree:
- `bdadbb44c90ae` — Enable cross-building with clang
- `0b817059a8830` — Fix bootstrapping during cross compilation (HOSTAR)
- `cc9b22dfa7358` — Clean up HOST_CFLAGS/HOST_LDFLAGS
- `8d86767be9c9b` — Add `-Wformat-signedness` (relevant to warning
  stripping)

On master, this commit is patch 1/8 of series
`tools_build_fix_zero_init_bpf_only`; patches 2–3 (`956841cbc3d77`,
`3f2fec5b02b6e`) further refine HOST_CFLAGS handling. Patches 4–8 touch
libbpf/selftests and are not prerequisites for this Makefile hunk.

**Step 3.4 — Author context**

Record: Leo Yan is an active Arm/tools contributor. Quentin Monnet
(bpftool maintainer) Acked-by.

**Step 3.5 — Dependencies**

Record: Commit applies cleanly to 6.18.44 (`git apply --check` passes).
Does not require `HOST_EXTRACFLAGS` (not present in this tree).
Standalone for the submake flag-leakage mechanism. Patch 2 from the same
series would improve completeness when `EXTRA_CFLAGS` contains target
flags (because in this tree `HOST_CFLAGS` is computed after
`EXTRA_CFLAGS` is appended to `CFLAGS`).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 9080b97689db` → https://patch.msgid.link/20260602-
tools_build_fix_zero_init_bpf_only-v2-1-c76e5250ea1c@arm.com. Lore page
blocked by bot protection; content verified via openwall mirror and
GitHub commit page.

**Step 4.2 — Reviewers**

Record: CC list includes bpf maintainers (Starovoitov, Borkmann,
Nakryiko, Monnet, etc.). Acked-by: Quentin Monnet.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Failure mode described in
commit message and series cover letter (cross-build breakage).

**Step 4.4 — Series context**

Record: Series `[PATCH bpf-next v2 0/8] tools build: bpf: Append
EXTRA_CFLAGS and HOST_EXTRACFLAGS`. Patch 1 was added in v2 specifically
to fix bootstrap libbpf cross-build flag leakage. Other patches address
GCC 15 zero-init and broader EXTRA_CFLAGS infrastructure.

**Step 4.5 — Stable list**

Record: UNVERIFIED — could not search lore stable list (bot protection).
No evidence this was previously rejected for stable.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions/rules**

Record: `$(LIBBPF_BOOTSTRAP)` make rule; `LIBBPF_BOOTSTRAP_CFLAGS`
variable definition.

**Step 5.2 — Callers**

Record: `$(LIBBPF_BOOTSTRAP)` is a dependency of bootstrap bpftool
objects (`$(BOOTSTRAP_OBJS)`, `$(BPFTOOL_BOOTSTRAP)`). Triggered during
bpftool feature detection requiring bootstrap (e.g. `clang-bpf-co-re`)
and during cross-compiled bpf tools builds (`tools/bpf/Makefile`,
selftests).

**Step 5.3 — Callees**

Record: Submake into `tools/lib/bpf/` with `HOSTCC`. libbpf Makefile
reads `EXTRA_CFLAGS`, `CFLAGS`, `CLANG_CROSS_FLAGS`.

**Step 5.4 — Reachability**

Record: Reachable when building bpf tools in-tree during cross-
compilation (`make tools/bpf` or full tools install with cross
`CC`/`CROSS_COMPILE`). Not a syscall/runtime path; build-time only.

**Step 5.5 — Similar patterns**

Record: `tools/bpf/resolve_btfids/Makefile` already uses
`HOST_OVERRIDES` with `CROSS_COMPILE="" CLANG_CROSS_FLAGS=""
EXTRA_CFLAGS="$(HOSTCFLAGS)"` — same class of fix, already in this tree.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **YES.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Current `tools/bpf/bpftool/Makefile` lines
47–50 invoke libbpf bootstrap submake without explicit `CFLAGS` or
`EXTRA_CFLAGS=`. Commit `9080b97689db` is on `master`/`bpf-next` but
**not** in this 6.18.y checkout.

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git apply --check` succeeds with no
conflicts.

**Step 6.3 — Related fixes already present?**

Record: Prior cross-build fixes are present (`bdadbb44c90ae`,
`0b817059a8830`, `cc9b22dfa7358`), but none address libbpf submake
CFLAGS leakage. `LIBBPF_BOOTSTRAP_CFLAGS` not found in tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **tools/bpf/bpftool** — IMPORTANT for bpf tooling, PERIPHERAL
for kernel runtime.

**Step 7.2 — Activity**

Record: Actively maintained; recent Makefile changes in 6.18.y include
signing support, `-Wformat-signedness`, zstd linking.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users cross-compiling bpf tools (distro builders, embedded/ARM
developers). Does not affect already-built kernels or runtime behavior.

**Step 8.2 — Trigger conditions**

Record: Cross-compilation of bpftool with bootstrap libbpf build
(feature detection or explicit bootstrap target). Requires
`EXTRA_CFLAGS`/`CFLAGS` with target-specific options to leak. Common in
distro/SDK cross-build environments.

**Step 8.3 — Failure mode severity**

Record: **Compilation failure** during tools build — severity **MEDIUM**
(build breakage, not crash/corruption/security).

**Step 8.4 — Risk vs benefit**

| | Assessment |
|--|------------|
| Benefit | Prevents cross-build failures for bpftool; fills known gap
left by earlier cross-build fixes |
| Risk | Very low — 5-line Makefile change, bootstrap-only path |
| Ratio | Favorable for stable under build-fix exception |

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real, reproducible cross-build bug in existing code
- Build-fix exception category (stable-kernel-rules.rst)
- Small, surgical, maintainer-acked fix
- Applies cleanly to 6.18.44
- Precedent: `0b817059a8830` (similar bpftool cross-bootstrap fix) is in
  6.18.y history
- Matches established pattern in `resolve_btfids/Makefile`

**Evidence AGAINST:**
- Tools-only; no kernel runtime impact
- Part of 8-patch series; patch 2 would further improve
  `HOST_CFLAGS`/`EXTRA_CFLAGS` separation
- Only affects cross-compilation build paths
- No user crash reports or security implications

**Unresolved:** Full lore review thread unavailable (bot protection).
Whether patch 2 should accompany this for maximum `EXTRA_CFLAGS`
correctness in 6.18.y.

### Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — Acked-by maintainer;
follows existing resolve_btfids pattern |
| 2. Fixes real bug affecting users? | **PASS** — cross-build
compilation failure |
| 3. Important issue? | **PASS** (build-fix exception) — compilation
error, not crash/security |
| 4. Small and contained? | **PASS** — 5 lines, one file |
| 5. No new features/APIs? | **PASS** — Makefile build flags only |
| 6. Can apply to local tree? | **PASS** — clean apply verified |

**Exception category:** Build fix.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 9080b97689db`
- [Phase 2] Diff analysis: 5 lines added, 1 removed in
  `tools/bpf/bpftool/Makefile`
- [Phase 3] `git blame` on lines 47–50: bootstrap recipe from 2020–2023
  commits
- [Phase 3] `git log --oneline master -- tools/bpf/bpftool/Makefile`:
  found series commits 9080b97, 956841c, 3f2fec5
- [Phase 3] `git show bdadbb44c90ae`, `0b817059a8830`, `cc9b22dfa7358`:
  prior cross-build fixes confirmed
- [Phase 3] `git apply --check` on 9080b97689db: **passes cleanly**
- [Phase 4] `b4 dig -c 9080b97689db`: lore URL found; full thread
  UNVERIFIED (bot block)
- [Phase 4] openwall mirror: confirmed patch content and series context
  (v2 1/8)
- [Phase 5] Read `tools/lib/bpf/Makefile` lines 73–87, 101:
  `EXTRA_CFLAGS`/`CLANG_CROSS_FLAGS` inheritance confirmed
- [Phase 5] Read `tools/bpf/resolve_btfids/Makefile` line 19–20:
  analogous HOST_OVERRIDES pattern confirmed
- [Phase 5] Read `tools/scripts/Makefile.include` lines 100–117:
  `CLANG_CROSS_FLAGS` added to `CFLAGS` when `CROSS_COMPILE` set
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] `grep LIBBPF_BOOTSTRAP_CFLAGS`: not in tree (fix absent)
- [Phase 6] Read current `tools/bpf/bpftool/Makefile` lines 47–50,
  84–92: buggy code confirmed
- [Phase 6] `git cat-file -t 9080b97689db`: commit exists on master/bpf-
  next, not in current HEAD
- [Phase 7] `grep HOST_EXTRACFLAGS tools/`: not present (patch 3
  infrastructure absent)
- [Phase 8] `git log stable/linux-6.18.y --grep="cross" --
  tools/bpf/bpftool/Makefile`: `0b817059a8830` in stable history

This is a valid, low-risk build fix for a real cross-compilation failure
in bpftool that exists in Linux 6.18.44 and applies cleanly.

**YES**

 tools/bpf/bpftool/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index fd43e5ea63f38..4b6670bad86e7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -47,7 +47,8 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
 $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
 		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR:/=) prefix= \
-		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" $@ install_headers
+		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" \
+		CFLAGS="$(LIBBPF_BOOTSTRAP_CFLAGS)" EXTRA_CFLAGS= $@ install_headers
 
 $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
 	$(call QUIET_INSTALL, $@)
@@ -92,6 +93,9 @@ HOST_CFLAGS := $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),\
 		$(subst $(CLANG_CROSS_FLAGS),,$(CFLAGS)))
 HOST_LDFLAGS := $(LDFLAGS)
 
+# Remove warnings for libbpf bootstrap build
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+
 INSTALL ?= install
 RM ?= rm -f
 
-- 
2.53.0

