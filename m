Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23C83B0AE0;
	Tue, 17 Mar 2026 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747179; cv=none; b=p4OV1JerO3IIiG/XQqYBFY/isKg1AqieilgyzUCnT3q+Pa23scriuYxDWdL4xgpYzAq8saPy+d3lZpsL6hc4hU8hT3sk0vOibHmmEjbQlwuuat+vhwIDTMV/OGwNgGCZxUF8ivxcNssZhZJ2D9C1w2kbjFY+WfBWcTbcIpj/qGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747179; c=relaxed/simple;
	bh=U99OdghIk6gLBl7juOwEtaGoB5/CrEuDPPyd6ff2MYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iVcfPyGs8kk4o0+wVM67ZOL3Bo6lfUhbQo1g9D6BXEFJxjZqfLfDWk7LMcvrPPBdoJdfdpa4uikAZIOraSA5xq9KSHbrVs9Dg4ms12MNcq71KQLf3bp/i2Ie2vJDg9aUES0vEmZKkmlTCpjhT3pcVmFYfeEUEhoV3ZhnQZwt+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUvgOfoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUvgOfoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAAEC4CEF7;
	Tue, 17 Mar 2026 11:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747179;
	bh=U99OdghIk6gLBl7juOwEtaGoB5/CrEuDPPyd6ff2MYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUvgOfohN2Z0USG2d4YLy7U96shHh0YxN8xq+EFnPERd4bqmNcvYONgxvC8cqs9jK
	 XnChw2X6jy2TwQWVs9ZFrfJFgQIfnWiCMhm8pgrxt4vc3DARqOakbFr0W/TZFY3Z4N
	 R8AMqu7vNiZrShDztZDkTXdmhx8hg5mMejdz7qqRoWrupFMZq7o+xSS8S+Jo9NClL/
	 EK9OQ4+rM+ASFmsLqPfm89Ro7ykG9IVNlYzQi340ui38EJbPo7wKJKwRdlC7/9wvhJ
	 jnvaer67qIhLA1xCtLwb7s+ozdXlT2/G8gz+HvkiqmxbEfzIdftu1QpH0LhBwL+KnR
	 Sb4COjgtJ8jYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] objtool/klp: Disable unsupported pr_debug() usage
Date: Tue, 17 Mar 2026 07:32:38 -0400
Message-ID: <20260317113249.117771-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e476bb277cf91b7ac3ea803ec78a4f0791bddec3 ]

Instead of erroring out on unsupported pr_debug() (e.g., when patching a
module), issue a warning and make it inert, similar to how unsupported
tracepoints are currently handled.

Reviewed-and-tested-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/3a7db3a5b7d4abf9b2534803a74e2e7231322738.1770759954.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Overview
This commit fixes objtool's `klp-diff` subcommand to handle `pr_debug()`
usage in livepatch modules targeting kernel modules. Previously,
encountering a `pr_debug()` static branch key (identified by
`__UNIQUE_ID_ddebug_` symbol name) would hit the generic "unsupported
static branch key" error path and fail. The fix adds a specific check
for these symbols and treats them like tracepoints — issuing a warning
and making them inert (skipping the entry) rather than erroring out.

### Code Change Analysis
The change is small and surgical — **7 lines of new code** that follow
an identical pattern already used for tracepoints:

```c
if (strstr(reloc->sym->name, "__UNIQUE_ID_ddebug_")) {
    WARN("%s: disabling unsupported pr_debug()",
         code_sym->name);
    ret = 1;
    continue;
}
```

This mirrors the existing tracepoint handling at lines 1396-1401 of the
current file. The logic is simple: detect the dynamic debug symbol,
warn, and skip it instead of failing.

### Bug Classification
This is a **build/tool fix**: Without it, objtool errors out with a
misleading "unsupported static branch key" error when building livepatch
modules that use `pr_debug()`. The `pr_debug()` static branch key lives
in the target module and can't be resolved via klp relocation, but
disabling it is harmless (the debug output simply won't work in the
patched function). This is the same reasoning used for tracepoints.

### Applicability to Stable Trees
The file `tools/objtool/klp-diff.c` was **introduced in v6.19** (commit
`dd590d4d57ebe`, September 2025). This means:
- Older stable trees (6.6.y, 6.1.y, 5.15.y, etc.) **do not contain this
  file** — the patch is irrelevant for them.
- For **6.19.y stable**, this is a relevant fix that prevents a tool
  error for livepatch developers.

### Stable Criteria Assessment
- **Fixes a real bug**: Yes — objtool incorrectly rejects valid
  livepatch modules that use `pr_debug()`.
- **Obviously correct and tested**: Yes — reviewed and tested by Song
  Liu (Meta's livepatch maintainer). The pattern exactly mirrors
  existing tracepoint handling.
- **Small and contained**: Yes — 7 lines of new code in one file,
  following an existing pattern.
- **No new features**: Correct — this makes existing functionality work
  correctly, not adding new capability.
- **Risk**: Very low — the check is specific to `__UNIQUE_ID_ddebug_`
  symbols, and the behavior (warn + skip) matches the existing
  tracepoint handling.

### Author and Review
Josh Poimboeuf is the objtool maintainer and one of the key livepatch
developers. Song Liu provided "Reviewed-and-tested-by", confirming both
code correctness and functional testing.

### Verification
- Read `tools/objtool/klp-diff.c` at lines 1310-1420 to confirm the
  current state lacks the pr_debug() check and to verify the existing
  tracepoint handling pattern the fix mirrors.
- Verified via git log that `klp-diff.c` was introduced in commit
  `dd590d4d57ebe` in v6.19 — the file does not exist in older stable
  trees.
- Confirmed the current repo is at v6.19.8 and does not yet contain this
  fix.
- The fix adds the check between the tracepoint check (line 1396) and
  the generic error (line 1403), which is the correct location.
- The commit was authored by Josh Poimboeuf (objtool maintainer) and
  reviewed/tested by Song Liu (livepatch maintainer) — high confidence
  in correctness.

### Risk vs. Benefit
- **Benefit**: Fixes a real build-time error that prevents creating
  livepatch modules containing `pr_debug()` calls.
- **Risk**: Minimal — small, pattern-following change in a build tool,
  with maintainer review and testing.

This is a small, well-tested fix for a real functional issue in
objtool's livepatch support. It only applies to 6.19.y stable (the file
doesn't exist in older trees), but for that version it prevents a
legitimate build error.

**YES**

 tools/objtool/klp-diff.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 9f1f4011eb9cd..4691f423fca5c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1334,18 +1334,18 @@ static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
  * be applied after static branch/call init, resulting in code corruption.
  *
  * Validate a special section entry to avoid that.  Note that an inert
- * tracepoint is harmless enough, in that case just skip the entry and print a
- * warning.  Otherwise, return an error.
+ * tracepoint or pr_debug() is harmless enough, in that case just skip the
+ * entry and print a warning.  Otherwise, return an error.
  *
- * This is only a temporary limitation which will be fixed when livepatch adds
- * support for submodules: fully self-contained modules which are embedded in
- * the top-level livepatch module's data and which can be loaded on demand when
- * their corresponding to-be-patched module gets loaded.  Then klp relocs can
- * be retired.
+ * TODO: This is only a temporary limitation which will be fixed when livepatch
+ * adds support for submodules: fully self-contained modules which are embedded
+ * in the top-level livepatch module's data and which can be loaded on demand
+ * when their corresponding to-be-patched module gets loaded.  Then klp relocs
+ * can be retired.
  *
  * Return:
  *   -1: error: validation failed
- *    1: warning: tracepoint skipped
+ *    1: warning: disabled tracepoint or pr_debug()
  *    0: success
  */
 static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym)
@@ -1400,6 +1400,13 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 				continue;
 			}
 
+			if (strstr(reloc->sym->name, "__UNIQUE_ID_ddebug_")) {
+				WARN("%s: disabling unsupported pr_debug()",
+				     code_sym->name);
+				ret = 1;
+				continue;
+			}
+
 			ERROR("%s+0x%lx: unsupported static branch key %s.  Use static_key_enabled() instead",
 			      code_sym->name, code_offset, reloc->sym->name);
 			return -1;
-- 
2.51.0

