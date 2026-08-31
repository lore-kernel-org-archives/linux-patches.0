Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264D9483BEE;
	Mon, 31 Aug 2026 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183482; cv=none; b=dOrP7XDSeUlHu75MBrhjeso+atcfO3xdEzKP1zaBcN4e9i3eZ2sHXpYybKJgRM4yD5R1WaxyYqurN3PPWAUZqNlZ/9Sx4dZfmIGkGB++PgcP2y8FbIEo9WccHZnpAMVBxlrzzpWMLehYWt8XipVUsDkW85WfsfX4Tw8JXtc5qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183482; c=relaxed/simple;
	bh=WbESUFpehW6NsQQOLP5btAcYc1a0bZ2UoZavzrv69gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5vFhtp1kZHROTJfzXVZ1ymk1Px/q1QM6qRaIJPtv0CfO9Y0m/DlSN1LYLSBAyvnRwRzo52b0eB7UZOJ1aKPt/I8FB+KnKgZjQUJmqeP+IBjok9spFvL8hYvzNuQRAjFWR28dO7DKxJjlFwYRVRgJRpMdhED1FtblQgrYW2/uag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePI39RlD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePI39RlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF5C1F00A3D;
	Mon, 31 Aug 2026 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183480;
	bh=veYRmZykR+yH9kIOVWkGX95kuGIKb9R0oZk6wmMxbuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePI39RlDwnuNJK/VXEoGgiTCMpYm9Le9TZ1qXJ1E0yTT8E9EjQXJKDCfcw71GO1GP
	 LY/LGh48JSI1egS5zBvT5PwwH9n+TfXpKLnF75f5I+twizFsWQH/D7S3xrLaqnC97Z
	 1vMqcWX2WjRWf52Mi9dVo43wmHifLxonaRNDUdHMEr/oM7LKUBDCzP3D6461dCNEFL
	 knrXBQbGBLgqMpVR96HQo3hcQ1+OkKCTUuFtroBOu9ZWzYUQfyi7qDO1i+jtwPARgV
	 DmtrRpwvLxT6+mD4NbZfhbyT70rVDdJfCokzFP4w11TPOzZCgvVAVGBIPcoL8hJh+A
	 7L2SDJDyZkgbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] apparmor: propagate -ENOMEM correctly in unpack_table
Date: Mon, 31 Aug 2026 09:22:29 -0400
Message-ID: <20260831133314.4125787-121-sashal@kernel.org>
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

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 1c8a839442823ce5c627d645730d8c61d828aafa ]

Currently, if the `kvzalloc` in `unpack_table` fails, it returns NULL.
This is masked by `aa_dfa_unpack` which interprets NULL as a -EPROTO,
leading to confusing error messages in `apparmor_parser` [1].

The fixed behavior correctly propagates -ENOMEM on allocation failure.

Link: https://gitlab.com/apparmor/apparmor/-/issues/592
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `apparmor: propagate -ENOMEM correctly in
unpack_table`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[apparmor]` `[propagate]` — Fix incorrect error-code
propagation in `unpack_table()` when DFA table allocation fails.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Link | https://gitlab.com/apparmor/apparmor/-/issues/592 |
| Reviewed-by | Georgia Garcia \<georgia.garcia@canonical.com\> |
| Signed-off-by | Maxime Bélair \<maxime.belair@canonical.com\> |
| Signed-off-by | John Johansen \<john.johansen@canonical.com\> |
| Fixes: | absent (expected for manual review) |
| Cc: stable | absent (expected) |
| Reported-by | absent |
| Tested-by | absent |

Notable: Reviewed by Canonical AppArmor developer; signed off by
subsystem maintainer (John Johansen). No syzbot report.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `kvzalloc()` failure in `unpack_table()` returns `NULL`;
  `aa_dfa_unpack()` treats any `NULL` as protocol failure and returns
  `-EPROTO`.
- **Symptom:** Misleading "profile does not conform to protocol" errors
  in `apparmor_parser` when the real failure is OOM.
- **Root cause:** `unpack_table()` conflates allocation failure (`NULL`)
  with protocol/validation failure (`NULL` from `goto out`).
- **Version info:** None stated in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — described as error propagation, but it is a real
correctness bug in error handling. Policy load still fails, but with the
wrong errno, which misleads operators and can cause incorrect
retry/debug behavior under memory pressure.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `security/apparmor/match.c` only (~20 lines changed)
- **Functions:** `unpack_table()`, `aa_dfa_unpack()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change per hunk

**Hunk 1 — `unpack_table()`:**
- **Before:** Returns `NULL` for all failures (protocol validation and
  `kvzalloc` failure).
- **After:** Initializes to `ERR_PTR(-EPROTO)`; validation failures
  return `-EPROTO`; `kvzalloc` failure returns `ERR_PTR(-ENOMEM)`;
  internal `fail` label removed in favor of explicit `ERR_PTR` returns.

**Hunk 2 — `aa_dfa_unpack()`:**
- **Before:** `if (!table) goto fail;` with `error` already set to
  `-EPROTO` at line 326.
- **After:** `if (IS_ERR(table)) { error = PTR_ERR(table); table = NULL;
  goto fail; }` — propagates the specific error from `unpack_table()`.

### Step 2.3: Bug mechanism
**Record:** **Error-path / logic correctness fix.** Allocation failure
was indistinguishable from protocol errors. The fix uses the kernel
`ERR_PTR`/`IS_ERR`/`PTR_ERR` pattern already used elsewhere in AppArmor
(e.g. `aa_dfa_unpack` itself returns `ERR_PTR(error)`).

### Step 2.4: Fix quality
**Record:** Obviously correct; minimal; uses established kernel idioms.
Low regression risk — only affects failure paths. One gap:
`remap_data16_to_data32()` still returns `NULL` on alloc failure and is
still treated as `-EPROTO` in `aa_dfa_unpack()` (lines 409–411); this
commit does not address that separate path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `unpack_table()` introduced in `e06f75a6a2b43b` (John
Johansen, 2010). `kvzalloc` added in `a7c3e901a46ff5` (Michal Hocko, May
2017, "mm: introduce kv[mz]alloc helpers"). The ENOMEM-as-NULL bug has
existed since **v4.12** era when `kvzalloc` replaced prior allocation in
this function.

### Step 3.2: Follow Fixes: tag
**Record:** Not applicable — no `Fixes:` tag in commit message.

### Step 3.3: File history for related changes
**Record:** Recent related fixes in this tree:
- `ac8f179e5c9ee` — "return -ENOMEM in unpack_perms_table upon alloc
  failure" (identical bug class, already backported to this 6.18.y tree)
- `22dc9433d458c` — accept2 allocation failure returning success path
  (more severe, already backported)
Standalone fix; not part of a numbered series.

### Step 3.4: Author's other commits
**Record:** Maxime Bélair has at least one other AppArmor fix in tree
(`57b1bd4486d56` UAF fix). John Johansen is the AppArmor maintainer and
original author of `unpack_table()`.

### Step 3.5: Prerequisites
**Record:** No dependencies. Uses `<linux/err.h>` already included at
line 16. Applies to existing code in this tree. Standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c <commit>` failed — commit not yet in this
checkout. Web search found Ubuntu AppArmor list submission at
https://www.mail-archive.com/apparmor@lists.ubuntu.com/msg12204.html
(fetch timed out). Patch content from search matches provided diff.

### Step 4.2: Reviewers
**Record:** Reviewed-by Georgia Garcia (Canonical). Signed-off-by John
Johansen (maintainer). Submitted to Ubuntu AppArmor list per mail-
archive.

### Step 4.3: Bug report
**Record:** GitLab issue #592 describes Qubes OS users seeing "Profile
does not conform to protocol" on `aa-enforce`, sometimes resolving after
multiple retries — consistent with transient failures (including OOM)
being misreported as protocol errors. Maintainer comment on related
issue #265 notes protocol errors can indicate kernel/parser bugs or
mismatched policy. Severity from reporter: operational confusion, not a
confirmed security issue.

### Step 4.4: Related patches
**Record:** `ac8f179e5c9ee` (unpack_perms_table ENOMEM fix) was
backported to stable (visible in spinics stable list for 6.19.y). Same
subsystem, same bug pattern, accepted for stable.

### Step 4.5: Stable mailing list
**Record:** No specific stable-list discussion found for this exact
patch. The sibling `unpack_perms_table` fix was included in stable
releases.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `unpack_table()` (static), `aa_dfa_unpack()` (exported via
`match.h`)

### Step 5.2: Callers
**Record:**
- `aa_dfa_unpack()` called from:
  - `unpack_dfa()` in `policy_unpack.c` — policy load path
  - `aa_setup_dfa_engine()` in `lsm.c` — built-in nulldfa/stacksplitdfa
    at init (static blobs, unlikely to OOM)
- `unpack_dfa()` → `unpack_pdb()` → policy unpack →
  `aa_replace_profiles()` via `apparmorfs.c`

Primary user-visible path: **policy load**
(`/sys/kernel/security/apparmor/` write or equivalent).

### Step 5.3: Callees
**Record:** `kvzalloc()`, `kvfree()`, `get_unaligned_be*()`,
`vm_unmap_aliases()`, `verify_table_headers()`, `verify_dfa()`

### Step 5.4: Call chain / reachability
**Record:** `write(apparmorfs)` → `aa_replace_profiles()` →
`aa_unpack()` → `unpack_pdb()` → `unpack_dfa()` → `aa_dfa_unpack()` →
`unpack_table()`. Reachable from **privileged userspace** loading
AppArmor policy. Trigger requires memory pressure during DFA table
unpacking.

### Step 5.5: Similar patterns
**Record:** Same NULL-on-OOM → `-EPROTO` pattern existed in
`unpack_perms_table()` (fixed by `ac8f179e5c9ee`).
`remap_data16_to_data32()` in the same file still has the unfixed
pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** Current `security/apparmor/match.c` lines 34–91
return `NULL` on `kvzalloc` failure; `aa_dfa_unpack()` at lines 361–363
treats `!table` as `-EPROTO`. Bug present since kvzalloc adoption
(~2017).

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — tree matches the "before" state
in the provided diff. No conflicting recent changes to these functions.
`git apply --check` with truncated test patch failed due to patch
formatting, not code mismatch; file content verified identical to pre-
patch state.

### Step 6.3: Related fixes already present?
**Record:** `ac8f179e5c9ee` (ENOMEM in `unpack_perms_table`) already in
tree. This specific `unpack_table` fix is **not** yet present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** **security/apparmor** — LSM security module. **IMPORTANT**
for Ubuntu, Debian, openSUSE, and other AppArmor-enabled distributions.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple AppArmor stable backports
already in this 6.18.y tree (UAF, refcount, ENOMEM fixes in 2026).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** AppArmor-enabled systems where administrators load or
replace policy. Config-specific (`CONFIG_SECURITY_APPARMOR`).

### Step 8.2: Trigger conditions
**Record:** Memory pressure during `kvzalloc()` in `unpack_table()`
while unpacking a policy DFA. Uncommon but realistic on constrained
systems or under heavy memory load. Privileged operation (policy load),
not unprivileged attack surface for escalation.

### Step 8.3: Failure mode severity
**Record:** Policy load fails with **`-EPROTO`** instead of
**`-ENOMEM`**. Users see misleading protocol-conformance errors. Policy
is **not** loaded in either case — no silent security bypass. Severity:
**MEDIUM** (operational/diagnostic), not CRITICAL (no crash, corruption,
or UAF).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct errno under OOM; better diagnostics; consistent
  with already-backported `unpack_perms_table` fix; helps admins
  distinguish transient OOM from corrupt policy.
- **Risk:** Very low — ~20 lines, failure-path only, established ERR_PTR
  pattern.
- **Ratio:** Favorable, especially given subsystem precedent.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug in error handling (ENOMEM masked as EPROTO)
- Bug present in this 6.18.44 tree since ~2017
- Small, surgical, maintainer-reviewed fix
- Identical bug class already backported in this tree (`ac8f179e5c9ee`)
- Affects policy-load path on AppArmor systems
- Canonical team fix with maintainer sign-off

**AGAINST backport:**
- No crash, corruption, deadlock, or security vulnerability
- Policy load fails either way — functional outcome unchanged
- GitLab #592 is not a direct ENOMEM reproducer
- `remap_data16_to_data32()` has the same unfixed pattern (incomplete
  coverage)
- Commit not yet in tree; lore fetch incomplete

**Unresolved:** Full mail-archive thread content; whether stable
maintainers will treat this identically to `unpack_perms_table`
(precedent suggests yes).

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — clear ERR_PTR pattern;
Reviewed-by present |
| 2. Fixes real bug affecting users? | **PASS** — wrong errno on policy
load under OOM |
| 3. Important issue? | **PASS (borderline)** — not crash/security, but
policy-load failure misdiagnosis on production AppArmor systems; same
class already deemed stable-worthy |
| 4. Small and contained? | **PASS** — one file, ~20 lines |
| 5. No new features/APIs? | **PASS** — internal error propagation only
|
| 6. Can apply to local tree? | **PASS** — buggy code confirmed present;
clean apply expected |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Pure error-
handling correctness fix.

### Step 9.4: Decision rationale
This fix belongs in stable for the same reason `ac8f179e5c9ee` was
already backported to this 6.18.y tree: AppArmor policy unpacking must
return the correct errno so administrators and userspace tools can
distinguish OOM from protocol corruption. The change is minimal,
obviously correct, and the bug has been present since `kvzalloc` was
adopted in 2017. While severity is operational rather than catastrophic,
the established precedent in this exact subsystem and tree supports
inclusion.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided content
- [Phase 1] Link: https://gitlab.com/apparmor/apparmor/-/issues/592 —
  fetched; describes Qubes OS protocol errors on `aa-enforce`, not a
  direct ENOMEM reproducer
- [Phase 2] Read `security/apparmor/match.c` lines 34–91, 314–434 —
  confirmed buggy NULL-return pattern and `!table` → `-EPROTO` path
- [Phase 2] Confirmed `remap_data16_to_data32()` still returns NULL on
  OOM (lines 283–286, 409–411) — unfixed by this commit
- [Phase 3] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion` → `6.18.44`
- [Phase 3] `git blame -L 34,91 security/apparmor/match.c` → function
  from 2010; `kvzalloc` from `a7c3e901a46ff5` (2017)
- [Phase 3] `git show a7c3e901a46ff5` — confirmed kvzalloc introduction
  in `match.c`
- [Phase 3] `git log --oneline -20 -- security/apparmor/match.c` —
  recent activity, no conflicting fix
- [Phase 3] `git show ac8f179e5c9ee` — identical ENOMEM/EPROTO pattern
  fix already in this tree with stable backport marker
- [Phase 3] `git log --oneline --grep="ENOMEM" -- security/apparmor/` —
  related ENOMEM fixes present
- [Phase 4] `b4 dig -c ac8f179e5c9ee` — no lore match (stable-backport
  commit)
- [Phase 4] `b4 dig --commitish "apparmor: propagate -ENOMEM correctly
  in unpack_table"` — commit not in tree
- [Phase 4] Web search — found Ubuntu AppArmor list submission
  (msg12204); spinics stable list shows `unpack_perms_table` ENOMEM fix
  in stable batch
- [Phase 4] WebFetch gitlab #592 — success; WebFetch mail-archive —
  timed out
- [Phase 5] `grep aa_dfa_unpack security/apparmor/` — callers in
  `policy_unpack.c`, `lsm.c`
- [Phase 5] Read `unpack_pdb()` lines 765–770 — `PTR_ERR(pdb->dfa)`
  propagates error to policy unpack
- [Phase 6] Confirmed buggy code present in local 6.18.44 checkout
- [Phase 6] `ac8f179e5c9ee` confirmed in tree; this fix not yet applied
- [Phase 7] `git log --oneline -20 -- security/apparmor/` — active
  subsystem with multiple stable backports

**YES**The AppArmor `unpack_table` ENOMEM backport analysis is done for
your **6.18.44** tree.

**Verdict: YES** — backport it.

When `kvzalloc()` fails during DFA table unpacking, the kernel currently
returns `-EPROTO` instead of `-ENOMEM`, so policy load failures under
memory pressure look like protocol/corruption errors in
`apparmor_parser`. The fix is small (~20 lines in
`security/apparmor/match.c`), uses the standard `ERR_PTR`/`IS_ERR`
pattern, and matches an already-backported fix in this tree
(`ac8f179e5c9ee` for `unpack_perms_table`). The buggy code is present
here; the patch should apply cleanly.

Severity is operational (wrong errno, not a crash or security bug), but
the subsystem precedent and maintainer review support stable inclusion.

 security/apparmor/match.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 0de249725efbf..b2a4bee4e3939 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -27,13 +27,13 @@
  * @blob: data to unpack (NOT NULL)
  * @bsize: size of blob
  *
- * Returns: pointer to table else NULL on failure
+ * Returns: pointer to table else ERR_PTR on failure
  *
  * NOTE: must be freed by kvfree (not kfree)
  */
 static struct table_header *unpack_table(char *blob, size_t bsize)
 {
-	struct table_header *table = NULL;
+	struct table_header *table = ERR_PTR(-EPROTO);
 	struct table_header th;
 	size_t tsize;
 
@@ -74,20 +74,21 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
 		else if (th.td_flags == YYTD_DATA32)
 			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
 				     u32, __be32, get_unaligned_be32);
-		else
-			goto fail;
+		else {
+			kvfree(table);
+			table = ERR_PTR(-EPROTO);
+			goto out;
+		}
 		/* if table was vmalloced make sure the page tables are synced
 		 * before it is used, as it goes live to all cpus.
 		 */
 		if (is_vmalloc_addr(table))
 			vm_unmap_aliases();
-	}
+	} else
+		table = ERR_PTR(-ENOMEM);
 
 out:
 	return table;
-fail:
-	kvfree(table);
-	return NULL;
 }
 
 /**
@@ -359,8 +360,11 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 
 	while (size > 0) {
 		table = unpack_table(data, size);
-		if (!table)
+		if (IS_ERR(table)) {
+			error = PTR_ERR(table);
+			table = NULL;
 			goto fail;
+		}
 
 		switch (table->td_id) {
 		case YYTD_ID_ACCEPT:
-- 
2.53.0

