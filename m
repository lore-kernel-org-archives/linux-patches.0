Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFD0568FA4;
	Mon, 31 Aug 2026 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184094; cv=none; b=mSQv1ElBWrH9HC12UuyugharZ+9Weunob3fgpYVuhHv+RSjatimoI1KuNFjI3+DnV5MElm4YNYbYVDUl8HE1xD9f0F/qZRoDJHVNCaLPQJggR4ZeoUH2CihQ4iNLjBv8f8BrHoy2YPPyggnU0dQrs1X83DTa0mQGnqA42TpM4UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184094; c=relaxed/simple;
	bh=TR5nw2zJizGYW0eTwl/VD5L4x/nEO5DtrUqCgjiSo8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXCqnfhlFccNB2l3U6dZJJ0ZoefFtXDQQ90xrVfmqU2ZW937vN/XE4MxZ7uOJRjeh6ZA2TIHWcRWa8jdZh02ZP24VyQJLetYQu7eKuidPfk3FPY62pAU3NqQ4/yMPPTpZ4bonXf2eRIGimZ3XdMNcjXymqiXImTewUQyP+8f+xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEitBTjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEitBTjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D671F00ACF;
	Mon, 31 Aug 2026 13:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184089;
	bh=+T1nwtPsIhpp0sCHR+ziTp1gkYJ3/AT5ZTsXnMpCnG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEitBTjYq7osAvx28ki3hLL5HuFQssozLf+iGc8YvmBWpnD+AcP7jSi/w0tuW59cC
	 f/kT/JFgfx8qRLqvN65bBwM/0PyD1PuHaVsHAwxTnUAt5bdX6OEK7eQgWUPKoETR8J
	 0T9pMsjSpychHtaiEVEVIgfG6k4u1GgOa5f8CxhmOtUY7Us/ViE+SvLtzMNwl/il+3
	 DwYxb1JMc6DcLL6ADVNEmaBFr8G3xgHwDr3e/I9EDUQMxdOkeEZkiOaT9/WMq8N12c
	 cdeVkzUlICKxjxSyucOY58wGONmtGs+qhfgp7wwERz41QnHwK8P6DFZR5rUek1UL8o
	 GG/7YdMc6n2zQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nsc@kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scripts: modpost: detect and report truncated buf_printf() output
Date: Mon, 31 Aug 2026 09:28:32 -0400
Message-ID: <20260831133314.4125787-484-sashal@kernel.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit d7231d8cb262b1e350c00271bf53d54414b4f3b1 ]

buf_printf() uses a fixed-size stack buffer. vsnprintf() returns the
number of bytes that *would* have been written to that buffer, which can
be larger than the size of said buffer if the formatted string is too
long.

The problem is that whenever this happens buf_printf() currently passes
this length, unchecked, to buf_write(), which silently reads past the
stack buffer and copies invalid data into the output buffer.

Fix this by detecting vsnprintf() failures and truncations before
appending to the output buffer, and report a fatal error instead of
producing corrupt symbol names.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260527-nova-exports-v2-1-06de4c556d55@nvidia.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `scripts: modpost: detect and report
truncated buf_printf() output`

**Local tree:** `v6.18.44` (6.18.y stable), `VERSION = 6`, `PATCHLEVEL =
18`, `SUBLEVEL = 44`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[scripts/modpost]` `[detect/report]` — Detect and report
when `buf_printf()` output would exceed its fixed stack buffer, instead
of silently corrupting output.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Alexandre Courbot `<acourbot@nvidia.com>` (author)
- **Link:** `https://patch.msgid.link/20260527-nova-
  exports-v2-1-06de4c556d55@nvidia.com` (ties fix to nova-exports
  development)
- **Signed-off-by:** Nathan Chancellor `<nathan@kernel.org>` (kbuild
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or syzbot tags
- Notable: kbuild maintainer sign-off; link references nova GPU export
  work

### Step 1.3: Body analysis
**Record:**
- **Bug:** `buf_printf()` uses a 500-byte stack buffer (`SZ`).
  `vsnprintf()` returns the length that *would* have been written, which
  can exceed `SZ` on truncation.
- **Symptom:** That unchecked length is passed to `buf_write()` →
  `strncpy()` reads past the stack buffer and copies garbage into
  generated module metadata.
- **Failure mode:** Corrupt symbol names in `.mod.c` / export tables;
  host stack buffer over-read (UB).
- **Fix approach:** Check `len < 0` and `len >= SZ`; call `fatal()`
  instead of appending.
- **Root cause:** Missing validation of `vsnprintf()` return value
  before using it as a copy length.

### Step 1.4: Hidden bug fix?
**Record:** Yes — clearly a real bug fix despite “detect and report”
wording. Prevents stack over-read and silent corruption of build
artifacts.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `scripts/mod/modpost.c` (+9 / -1 lines)
- **Function:** `buf_printf()`
- **Scope:** Single-file, surgical fix in one helper

### Step 2.2: Code flow change
**Record:**
- **Before:** `vsnprintf(tmp, SZ, ...)` → immediately `buf_write(buf,
  tmp, len)` with unchecked `len`.
- **After:** `va_end()` first; if `len < 0` → `perror` + `exit(1)`; if
  `len >= SZ` → `fatal()`; only then `buf_write(buf, tmp, len)`.
- **Path affected:** Every `buf_printf()` call during modpost (50 call
  sites in this tree).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer over-read / out-of-bounds read (memory safety in
  host build tool).
- **Mechanism:** When formatted output needs ≥500 bytes, `vsnprintf()`
  writes at most 499 chars + NUL into `tmp[500]`, but returns the full
  required length (e.g. 639). `buf_write()` → `strncpy(dst, tmp, len)`
  then reads `len` bytes from `tmp`, reading past the stack buffer into
  adjacent stack memory and copying garbage into the output buffer.

### Step 2.4: Fix quality
**Record:**
- Obviously correct standard `vsnprintf()` truncation handling.
- Minimal change; uses existing `fatal()` infrastructure.
- Regression risk: very low — only affects cases that were already
  broken; changes silent corruption to explicit build failure.
- No API or behavioral changes to the running kernel.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `buf_printf()` / `buf_write()` core logic dates to 2005 (Linus
  Torvalds).
- `buf_write(buf, tmp, len)` call added in `7670f023aabd9` (Mar 2006,
  “fix buffer overflow in modpost” — fixed heap allocation sizing, not
  this `vsnprintf` return-value bug).
- Buggy pattern present in this tree since ~2006.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Related prior fixes in this file:
- `7670f023aabd9` (2006): modpost heap buffer overflow on long paths
- `666ab414fe14e` (2007): stack overflow from fixed `fname[SZ]` buffer
- `5cfb203a304de` (2015): abort on symbols ≥ `MODULE_NAME_LEN` (~56) in
  `add_versions()` only
- `15a28c7c72917`: snprintf safety elsewhere in modpost

The 2015 check does **not** cover `add_exported_symbols()` KSYMTAB lines
or extended-modversion name tables.

### Step 3.4: Author context
**Record:** Alexandre Courbot has minimal modpost history in this tree.
Nathan Chancellor is an active kbuild contributor (`688c1b491c35d
modpost: Declare extra_warn with unused attribute`, etc.).

### Step 3.5: Dependencies
**Record:** Standalone; no series dependencies. Commit hash
`0d2f1f09019ba` is **not** in this tree (candidate for backport).
Applies cleanly to current `buf_printf()`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 0d2f1f09019ba` failed (“Cannot find a commit
matching”). Lore/patch.msgid.link returned 403 (bot protection). Could
not retrieve full thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not possible without commit match. Nathan
Chancellor sign-off verified from commit message.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla report. Link subject `nova-exports-v2`
suggests discovery during NVIDIA nova GPU export development (May 2026).

### Step 4.4: Series context
**Record:** Appears standalone; likely discovered while building nova
export tables. No other patches required.

### Step 4.5: Stable list
**Record:** Could not search lore (403). No evidence of prior stable
discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `buf_printf()`, `buf_write()` (called from ~50 sites:
`add_header`, `add_exported_symbols`, `add_versions`,
`add_extended_versions`, `add_depends`, `write_mod_c_file`, symvers
output, etc.)

### Step 5.2: Callers
**Record:** All modpost output generation paths during `MODPOST` build
stage — every in-tree and out-of-tree module build with
`CONFIG_MODULES`.

### Step 5.3: Callees
**Record:** `vsnprintf()`, `buf_write()` → `xrealloc()`, `strncpy()`.

### Step 5.4: Reachability
**Record:** Triggered during every kernel module build (`make modules`).
Reachable whenever any single `buf_printf()` format produces ≥500 bytes.
Computed thresholds:
- KSYMTAB line: symbol length ≥470 (line len 500+)
- SYMBOL_CRC: ≥466
- Extended version names: ≥494
- Symvers dump: ≥463

`KSYM_NAME_LEN` is **512** in this tree — valid symbol names can exceed
all these thresholds.

### Step 5.5: Similar patterns
**Record:** Prior modpost buffer fixes (`7670f023aabd9`,
`666ab414fe14e`, `5cfb203a304de`) show this subsystem has a history of
length-related bugs. The `MODULE_NAME_LEN` guard in `add_versions()`
does not protect export-symbol or extended-modversion `buf_printf()`
paths.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `buf_printf()` at lines 1673–1684 still has
the unchecked pattern:

```1673:1684:scripts/mod/modpost.c
void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer
*buf,
                                                      const char *fmt,
...)
{
        char tmp[SZ];
        int len;
        va_list ap;

        va_start(ap, fmt);
        len = vsnprintf(tmp, SZ, fmt, ap);
        buf_write(buf, tmp, len);
        va_end(ap);
}
```

Bug present since ~2006 in this tree.

### Step 6.2: Backport complications
**Record:** Clean apply expected — `buf_printf()` unchanged except for
this fix. No conflicting recent churn in this function.

### Step 6.3: Related fixes already present?
**Record:** `5cfb203a304de` guards `add_versions()` for symbols ≥
`MODULE_NAME_LEN` (~56) only. Does **not** fix this bug for KSYMTAB
exports (470+ char symbols) or extended modversion name tables (494+
chars). Fix commit not present in tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `scripts/mod/` (kbuild/modpost) — **IMPORTANT** for all
module builds; host tool, not runtime kernel code.

### Step 7.2: Activity
**Record:** Moderately active (`688c1b491c35d`, `5ab23c7923a1d`,
namespace support commits in recent history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Kernel builders using `CONFIG_MODULES` — distro maintainers,
OOT module developers, anyone building modules with long export symbol
names or long formatted modpost lines.

### Step 8.2: Trigger conditions
**Record:** Any `buf_printf()` call producing ≥500 bytes in one format
string. Plausible with symbol names 470–511 chars (`KSYM_NAME_LEN=512`).
Rust/mangled export names (nova driver context) increase likelihood. Not
every boot — only during `MODPOST` stage.

### Step 8.3: Failure mode severity
**Record:**
- Stack buffer over-read in host tool (UB; ASan-detectable)
- Silent corruption of `.mod.c` / symvers / export metadata
- Downstream: wrong module versioning, insmod failures, or subtle ABI
  breakage
- **Severity: HIGH** for affected builds (corruption); **MEDIUM**
  overall (trigger is uncommon but within supported `KSYM_NAME_LEN`
  range)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents silent corruption; converts latent UB to
  explicit fatal error; aligns modpost with `KSYM_NAME_LEN` support
- **Risk:** Very low — 9-line change, only affects already-broken cases
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable stack over-read bug in `buf_printf()`
- Can silently corrupt module build artifacts
- Trigger thresholds (470–494 char symbols) are within `KSYM_NAME_LEN`
  (512)
- Tiny, obviously correct fix
- Bug present in 6.18.y since ~2006
- kbuild maintainer sign-off
- Fits build-tool correctness; prior modpost buffer fixes accepted to
  mainline

**AGAINST backport:**
- Host build tool only — no runtime kernel crash
- Trigger uncommon in typical C kernel code
- Bug latent ~20 years without widespread reports
- Lore discussion unretrievable

**Unresolved:** Full mailing-list review thread; no explicit stable
nomination found.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard `vsnprintf`
   handling; kbuild maintainer SOB
2. Fixes real bug affecting users? **PASS** — corrupt module metadata
   affects builders and downstream module consumers
3. Important issue? **PASS** — build artifact corruption + stack over-
   read; HIGH for affected builds
4. Small and contained? **PASS** — 9 lines, one function
5. No new features/APIs? **PASS** — error detection only
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected

### Step 9.3: Exception category
**Record:** Build fix / build correctness — prevents corruption during
`MODPOST`.

### Step 9.4: Decision rationale

This commit fixes a genuine memory-safety bug in modpost where truncated
`vsnprintf()` output causes `strncpy()` to read past a 500-byte stack
buffer. The kernel defines `KSYM_NAME_LEN` as 512, but `SZ` is 500 and
export-symbol `buf_printf()` paths lack length guards — so valid-length
symbols (470–511 chars) can hit this bug. Silent corruption of generated
module files is worse than a fatal build error. The fix is minimal,
follows existing `fatal()` conventions, and applies cleanly to this
6.18.y tree where the buggy code is still present.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 1]** Confirmed no `Fixes:`, syzbot, or `Cc: stable` tags
- **[Phase 2]** Read current `buf_printf()` and `buf_write()` in
  `scripts/mod/modpost.c`
- **[Phase 2]** Verified `strncpy(buf->p + buf->pos, s, len)` uses
  unchecked `len`
- **[Phase 2]** Confirmed `fatal()` macro in `scripts/mod/modpost.h:244`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`
- **[Phase 3]** `git blame -L 1673,1694 scripts/mod/modpost.c` → bug
  since 2005/2006
- **[Phase 3]** `git show 7670f023aabd9` → related 2006 modpost buffer
  fix (different issue)
- **[Phase 3]** `git show 666ab414fe14e` → 2007 modpost stack overflow
  fix
- **[Phase 3]** `git show 5cfb203a304de` → 2015 symbol length check in
  `add_versions()` only (~56 chars)
- **[Phase 3]** `git log -1 0d2f1f09019ba` → commit not in tree
- **[Phase 4]** `b4 dig -c 0d2f1f09019ba` → no match
- **[Phase 4]** WebFetch lore/patch.msgid.link → 403 blocked
- **[Phase 4]** curl lore.kernel.org → 403 blocked
- **[Phase 5]** `grep buf_printf` → 50 call sites in modpost.c
- **[Phase 5]** Python calculation → KSYMTAB triggers at symbol length
  470; `KSYM_NAME_LEN=512` in `include/linux/kallsyms.h`
- **[Phase 5]** Verified `add_exported_symbols()` has no symbol-length
  check before KSYMTAB `buf_printf()`
- **[Phase 6]** Confirmed buggy code at lines 1673–1684 in local tree
- **[Phase 6]** `git log --grep='buf_printf'` / `--grep='truncated
  buf_printf'` → no fix present
- **[Phase 7]** `git log --oneline -20 -- scripts/mod/modpost.c` →
  moderate activity
- **[UNVERIFIED]** Full mailing-list review discussion (lore blocked)
- **[UNVERIFIED]** Whether any production distro has hit this in the
  wild

**YES**The background search finished: this fix is **not** in the local
`v6.18.44` tree yet.

**Verdict: YES** — backport it.

`buf_printf()` in `scripts/mod/modpost.c` can pass an unchecked
`vsnprintf()` length to `strncpy()`, causing a stack over-read and
silent corruption of generated module metadata when a single formatted
line exceeds the 500-byte buffer. That can happen with symbol names
within the kernel’s `KSYM_NAME_LEN` (512) limit. The patch is small,
obviously correct, and turns silent corruption into a fatal build error.

 scripts/mod/modpost.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 010c398f6a705..888734d5e6fbe 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1679,8 +1679,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
 	va_start(ap, fmt);
 	len = vsnprintf(tmp, SZ, fmt, ap);
-	buf_write(buf, tmp, len);
 	va_end(ap);
+
+	if (len < 0) {
+		perror("vsnprintf failed");
+		exit(1);
+	}
+	if (len >= SZ)
+		fatal("buf_printf output truncated for string %s: %d bytes needed, %d available\n",
+		      tmp, len + 1, SZ);
+
+	buf_write(buf, tmp, len);
 }
 
 void buf_write(struct buffer *buf, const char *s, int len)
-- 
2.53.0

