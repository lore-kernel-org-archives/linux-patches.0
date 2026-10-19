Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D6E501F24;
	Mon, 19 Oct 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418099; cv=none; b=grHRnqRnGp4Cql27YPZ4K3uhqONzQWqIF/lZ2nTxR22pn8aKGHqfNL0/YAu5OBbzNxEyfyoaEbakhvcMTgByEGfvlBLUo8om6rCJQS5RZB1fL+0UKzLSGlojRZiIfrMdQycdrnOvbRxLbpYv+qZYwwLBwNTfD8TYPXk4GJlwr6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418099; c=relaxed/simple;
	bh=NVetNNEzOAHuseoFgEMvq38N3+QCRz8vPEa6tSnFy2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seK6N2sPbIHdz9s9ecgRnz/cCU9DAYwLGNOTw34Fbxz2iOF9QRypvhKxopfQCF4G/aVdtKwKucGiiWiRm0kf1QSLWJCEwnSFyfgtLhbNHGurcffB+nZT1BEGDkxfZ7st3viGgB9nnw+qiVEhsm468Ko4V9GVOFdiDttDNYS0DS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9CCz0e9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9CCz0e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FBA1F000C5;
	Mon, 19 Oct 2026 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418095;
	bh=naQpsq1oOIaJNCMfkoIcYYTRo5AJT7ecBXQg43SNO7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9CCz0e9kh38vtJRn+633Vm7VOYrZDAnWSFw58ZiJDtIJr9RoZEk7TmtpUb1vOtpE
	 HO2BZr76h86hGvJGIjN1MIPEF631t+zgiAD7es+o5G3a/lyZ3PNmYIR33psYLGlONJ
	 Cfugvk8tn+Q/vM0GuYRyMZ4J6LEH6Hxwfg6PIQqwkUD/W15jD+xborH8CcdMDzy5/f
	 8KvDdVytC4oxaJoQcHR6A9TDjSdh7CVb4m9PVHCCvtFEASX/A3GOJ+++TeN2YD7UlG
	 btis2qwQ/wbLRKO5zHBR0u8BNWJOLUHhyrirjDQ+8YKxZ8RQJ9ezqHqOxQWrw9XkTK
	 1vPGXZwrbfWZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] libbpf: Skip bpf_object__probe_loading() when BPF token is in use
Date: Mon, 19 Oct 2026 09:45:00 -0400
Message-ID: <20261019135441.1420968-9-sashal@kernel.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit d262a25d8b58b697b2a1a2fe4b0078446cc00e11 ]

bpf_object__probe_loading() tries to load trivial SOCKET_FILTER and
TRACEPOINT programs to verify the BPF environment works.  When a
BPF token is in use with restricted program type permissions, these
probe loads may fail because the token does not allow the specific
program types, even though BPF loading is perfectly functional.

Fix by skipping the probe when a token FD is present: BPF token
creation itself proves the kernel has a working BPF subsystem.
Real BPF issues will be caught during actual program and map loading.

Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260610145059.113412-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real libbpf load-path bug in this 6.18 tree: restricted BPF
tokens make `bpf_object__probe_loading()` fail even when the actual
programs would load. The change is small, already present in the
matching 6.18 code, and is worth backporting.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[libbpf] [Skip] Skip bpf_object__probe_loading() when BPF
  token is in use`
- Subsystem: `libbpf` (userspace library in `tools/lib/bpf/`)
- Verb “Skip” is a workaround/fix for a false-negative probe, not a
  feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>` (author)
  - `Signed-off-by: Andrii Nakryiko <andrii@kernel.org>` (libbpf/BPF
    maintainer)
  - `Link: https://lore.kernel.org/bpf/20260610145059.113412-2-
    chenyuan_fl@163.com`
  - No `Fixes:`, `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`,
    or `Cc: stable` in the committed message (absence of Fixes/Cc-stable
    is expected here)
  - Mailing-list review did include `Acked-by: Mykyta Yatsenko
    <yatsenko@meta.com>` (not copied into the final commit text)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `bpf_object__probe_loading()` loads dummy `SOCKET_FILTER`
    and `TRACEPOINT` programs. With a BPF token whose allowed program
    types exclude those, the probe fails even though real loads would
    work.
  - **Symptom:** `bpf_object__load()` / `bpf_object__prepare()` returns
    an error and warns that BPF/RLIMIT_MEMLOCK is broken. In-tree token
    selftests (`obj_priv_map`, `obj_priv_prog`, freplace, implicit-
    token, struct_ops BTF cases) hit this.
  - **Cover letter (v3):** same probe can also drop the token path and
    then break later loads (struct_ops + global data: `fd X is not
    pointing to valid bpf_map`).
  - **Root cause:** probe uses hardcoded program types and passes
    `obj->token_fd`.
  - **Fix:** skip the probe when `token_fd` is set; creating the token
    already proves BPF syscalls work.
  - **Versions:** no version list in the message. BPF tokens exist since
    ~6.9; this 6.18 tree has them.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a disguised cleanup. It is an explicit functional fix for
  a false probe failure. Skipping the probe is the fix, not a refactor.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - File: `tools/lib/bpf/libbpf.c` — 3 insertions, 7 deletions
  - Function: `bpf_object__probe_loading()`
  - Scope: single-file surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Before:** After `bpf_object_prepare_token()`, probe always runs
    (except `gen_loader`). It passes `token_fd` / `BPF_F_TOKEN_FD` into
    dummy `SOCKET_FILTER` then `TRACEPOINT` loads. Either failure aborts
    object prepare/load.
  - **After:** If `obj->token_fd` is set, return 0 immediately (same as
    `gen_loader`). Dummy loads no longer use token opts (`NULL` opts).
  - **Path:** initialization/prepare of every `bpf_object` load, not a
    rare error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - **Category:** logic/correctness (false failure in a capability
    probe)
  - **Mechanism:** probe assumes `SOCKET_FILTER` or `TRACEPOINT` is
    allowed. Restricted tokens are the whole point of BPF token
    delegation. Probe failure is treated as “BPF is unavailable,” so
    legitimate objects never load.
  - Not UAF/leak/race/overflow.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - Obviously correct: token creation already used `bpf_token_create()`.
    Real map/prog errors still happen in the real load path.
  - Minimal: one extra skip condition; dummy loads drop unused token
    opts.
  - `bpf_prog_load(..., NULL)` is valid: `OPTS_VALID` treats NULL as OK;
    `OPTS_GET` falls back to 0. Same as empty opts when `token_fd == 0`.
  - Regression risk is low. Skipping `bump_rlimit_memlock()` in this
    function is fine: `bpf_prog_load()` still calls it, and tokens imply
    6.9+ with memcg BPF accounting.
  - Residual gap: series patch 2 (feature probes using hardcoded types)
    is **not** in this tree. This patch still stands alone for the
    probe_loading hard-fail.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record:
  - Probe itself: Stanislav Fomichev, 2018 (`47eff61777c7`).
  - Token opts in the probe: `6b434b61b4d9e` (“libbpf: Wire up BPF token
    support at BPF object level”), Andrii Nakryiko, 2024-01-23 (kernel
    ~6.9).
  - Buggy pattern has been in this 6.18 line since the branch, not a
    post-6.18 introduction.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag (Mykyta asked for one; it was never added).
  The introducing commit is `6b434b61b4d9e`, which **is** in this tree
  (`git merge-base --is-ancestor` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record:
  - `f9bceaa59c5c4` already skips this probe for light skeleton
    (`gen_loader`); this patch extends that idea to tokens.
  - `1315c28ed8095` split load into `bpf_object__prepare()` / load;
    probe now runs from `bpf_object_prepare()`.
  - Series patch 2 (“fetch probeable prog type from token”) is **not**
    in this tree.
  - Standalone: Andrii said this was the only v2 patch that should land
    on its own.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Yuan Chen has another libbpf fix here (`aa485e8789d56`, NULL
  deref in `btf_dump__free`). Not the libbpf maintainer. Applied by
  Andrii Nakryiko.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Needs `obj->token_fd` and `bpf_object__probe_loading()`, both
  present. No new helpers. Applies standalone. Patch 2 is a related but
  separate feature-probe issue.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c d262a25d8b58`:
    https://patch.msgid.link/20260610145059.113412-2-chenyuan_fl@163.com
  - Revisions:
    - v1 (2026-05-29): selftest workaround — add
      SOCKET_FILTER/TRACEPOINT to token tests
    - v2 (2026-06-04): 3 patches; this skip plus selftest ARRAY map plus
      feature-probe skip
    - `[PATCH bpf]` (2026-06-09): this patch alone after Andrii asked to
      resend it
    - v3 (2026-06-10): 2 patches; this skip plus smarter feature probes
      — **this is what landed**
  - Review:
    - Mykyta: skip is correct; making the probe token-aware would be
      worse. `Acked-by`.
    - Andrii: this is the only v2 patch that should apply; resend it
      alone.
    - Mykyta on the bpf-tree resend: retarget **bpf-next**, add a Fixes
      tag, include Acks. No NAK.
  - No reviewer `Cc: stable`. bpf-next targeting is a process note, not
    a statement that the bug is absent from 6.18.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: Recipients included Andrii Nakryiko, Alexei Starovoitov,
  Daniel Borkmann, Eduard Zingerman, Mykyta Yatsenko,
  `bpf@vger.kernel.org`. Right maintainers. Applied by Andrii.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Trigger is in-tree
  `tools/testing/selftests/bpf/prog_tests/token.c`: `obj_priv_map`
  (QUEUE map only), `obj_priv_prog` (XDP only), freplace, implicit-token
  struct_ops. Author hit failing tests; v1 tried widening token
  permissions instead of fixing libbpf.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: v3 2/2 is the feature-probe follow-up (`features.c`). Not
  required for this skip to be correct. Not in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search returned HTTP 403. UNVERIFIED
  whether stable@ discussed this. No in-tree evidence of a prior
  rejection.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `bpf_object__probe_loading()` only.

**Step 5.2: TRACE CALLERS**
- Record: Single caller, `bpf_object_prepare()` (`libbpf.c` ~8705),
  which is called from:
  - `bpf_object_load()` if state `< OBJ_PREPARED`
  - public `bpf_object__prepare()`
- Every normal `bpf_object__load()` / skeleton load goes through this
  after token setup.

**Step 5.3: TRACE CALLEES**
- Record: `bump_rlimit_memlock()`, `bpf_prog_load()`, `close()`,
  `pr_warn()`. After the skip, those are not used when a token is
  present.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace, reachable from any app using in-tree
  libbpf/bpftool/selftests with a BPF token (explicit `bpf_token_path`
  or implicit `/sys/fs/bpf`). Not a kernel oops path. Unprivileged user-
  namespace workloads with delegated tokens are the intended users.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Same skip already exists for `obj->gen_loader`.
  `tools/lib/bpf/features.c` still hardcodes probe program types with
  `token_fd` — that is series patch 2, still open in this tree.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record:
  - Local tree: `v6.18.53` (`Makefile` 6.18.53, `git describe HEAD` =
    `v6.18.53-5049-g0f0bdc2b0dffb`), branch `autosel`.
  - `v6.18:tools/lib/bpf/libbpf.c` has the pre-fix probe: token opts +
    `SOCKET_FILTER`/`TRACEPOINT`.
  - Pre-fix hunk md5 matches `v6.18` exactly.
  - Kernel BPF token (`kernel/bpf/token.c`, `35f96de04127d`) is in 6.18.
  - Bug introduced ~6.9 (`6b434b61b4d9e`), well before 6.18.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: Clean apply. Context around `bpf_object__probe_loading()`
  matches 6.18. No refactor in the way.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No other skip of this probe for tokens. No equivalent feature-
  probe fix. Token selftests still omit SOCKET_FILTER/TRACEPOINT for
  `obj_priv_*`, so they still depend on this libbpf change.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `tools/lib/bpf` — IMPORTANT, not CORE kernel. Used by bpftool,
  selftests, and distro in-tree libbpf. BPF tokens are the supported
  unprivileged/container path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Active (recent libbpf mmap/percpu/relocation fixes). Token
  wiring itself has been stable since 6.9; this is a late correctness
  fix, not churn in brand-new code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: Config/driver-specific in the BPF-token sense: users of libbpf
  object load with a token whose allowed types exclude SOCKET_FILTER
  **and** TRACEPOINT. That includes the in-tree token selftests and
  container/user-ns setups that delegate only XDP, struct_ops, maps,
  etc.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: Trigger is common for token users: every
  `bpf_object__load()`/`prepare()`. Not a race. Unprivileged tasks in a
  delegated user ns can hit it; that is the token design.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: Object load/prepare fails outright with a misleading “Couldn't
  load trivial BPF program” warning. Not a kernel oops/corruption.
  **Severity: MEDIUM-HIGH** for token users (feature completely
  unusable), **LOW** for everyone else (`token_fd == 0` path is
  unchanged).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** Restricted-token libbpf loads work; in-tree token tests
    can pass; matches the token least-privilege model.
  - **Risk:** Very low (net −4 lines, one extra early return).
  - **Ratio:** Strongly favorable for 6.18.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, reproducible false failure on every object load with a
  restricted token
- In-tree selftests exercise exactly this (XDP-only, map-only,
  struct_ops-only tokens)
- Buggy code is in 6.18; tokens are in 6.18
- 10-line, obviously correct skip; same pattern as `gen_loader`
- Acked by Mykyta Yatsenko; applied by Andrii Nakryiko
- Clean apply; no new API
- Andrii treated this patch as independently landable

AGAINST:
- Userspace libbpf, not a kernel oops/UAF/deadlock
- No `Cc: stable`; reviewers asked for bpf-next (process, not “bug
  absent from 6.18”)
- Series patch 2 (feature probes) is still missing; some
  struct_ops+global-data cases may still fail
- Specialized to BPF token users, not all machines

UNRESOLVED:
- Stable@ thread search failed (HTTP 403)
- Cover-letter claim that a failed probe “drops the token reference” in
  the kernel was not independently verified; the libbpf-level hard-fail
  is verified from code and tests

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — skip is the same idea as
   `gen_loader`; reviewed/acked; tests exist
2. Fixes a real bug that affects users? **PASS** — object load fails for
   valid token configs
3. Important issue? **PASS** (MEDIUM-HIGH for token users) — complete
   load failure, not theoretical; fits “oh, that's not good”
4. Small and contained? **PASS** — 3/7 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — 6.18 source matches the pre-
   image

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: None (not a device ID, quirk, DT, build, or docs fix).
  Qualifies as a normal small bugfix.

**Step 9.4: DECISION**

6.18 ships BPF tokens and this probe. Without the skip, libbpf treats a
least-privilege token as “BPF does not work” and aborts prepare/load.
That is a real, user-visible break for the token feature and for in-tree
tests, with a tiny, maintainer-reviewed fix and negligible regression
risk.

### What the commit solves for this tree
Restricted BPF tokens cannot load objects through libbpf because a dummy
SOCKET_FILTER/TRACEPOINT probe is not in the token’s allow-list.
Skipping the probe when a token FD exists restores load/prepare for
those objects.

### Stable rules / risk
Meets the written rules: small, obviously correct, real bug, no new API,
applies cleanly to 6.18. Benefit is restoring a supported 6.18 feature;
risk is an extra early return on a userspace probe.

### Concerns
Feature-probe hardcoded types (series patch 2) remain in this tree, so
some token+global-data cases may still be incomplete. That does not
remove the standalone value of stopping probe_loading from failing the
whole load.

Verification:
- [Phase 1] Parsed tags: author Yuan Chen; SOB Andrii Nakryiko; lore
  link; no Fixes/Reported-by/Cc-stable in the commit
- [Phase 2] Diff: `tools/lib/bpf/libbpf.c`,
  `bpf_object__probe_loading()`, +3/−7; skip on `obj->token_fd`; dummy
  loads use NULL opts
- [Phase 2] Confirmed `OPTS_VALID(NULL)` is true in `libbpf_internal.h`
- [Phase 3] Blame: token opts added in `6b434b61b4d9e` (2024-01-23);
  ancestor of this tree
- [Phase 3] No Fixes tag; introducing commit present; patch 2 not in
  this tree
- [Phase 4] `b4 dig -c d262a25d8b58`: lore
  https://patch.msgid.link/20260610145059.113412-2-chenyuan_fl@163.com
- [Phase 4] `b4 dig -a`: v1 selftest workaround → v2 series → bpf-only
  resend → v3 1/2 (landed)
- [Phase 4] `b4 dig -w`: bpf maintainers on Cc
- [Phase 4] mbox: Mykyta Acked-by; Andrii asked to land this patch
  alone; later asked bpf-next + Fixes tag
- [Phase 5] Only caller is `bpf_object_prepare()` ← `bpf_object_load()`
  and `bpf_object__prepare()`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.53; `v6.18`
  file matches pre-fix hunk md5
- [Phase 6] Token selftests in this tree still use XDP-only / map-only
  tokens without SOCKET_FILTER/TRACEPOINT
- [Phase 8] Failure mode: userspace object load abort, not kernel oops;
  severity MEDIUM-HIGH for token users
- UNVERIFIED: stable@ mailing-list discussion (lore 403); kernel “drops
  token reference” cover-letter claim

**YES**

 tools/lib/bpf/libbpf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b21d2f842579f..1aaf2bdf26857 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5070,12 +5070,8 @@ bpf_object__probe_loading(struct bpf_object *obj)
 		BPF_EXIT_INSN(),
 	};
 	int ret, insn_cnt = ARRAY_SIZE(insns);
-	LIBBPF_OPTS(bpf_prog_load_opts, opts,
-		.token_fd = obj->token_fd,
-		.prog_flags = obj->token_fd ? BPF_F_TOKEN_FD : 0,
-	);
 
-	if (obj->gen_loader)
+	if (obj->gen_loader || obj->token_fd)
 		return 0;
 
 	ret = bump_rlimit_memlock();
@@ -5084,9 +5080,9 @@ bpf_object__probe_loading(struct bpf_object *obj)
 			errstr(ret));
 
 	/* make sure basic loading works */
-	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, &opts);
+	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0)
-		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, &opts);
+		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0) {
 		ret = errno;
 		pr_warn("Error in %s(): %s. Couldn't load trivial BPF program. Make sure your kernel supports BPF (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough value.\n",
-- 
2.53.0

