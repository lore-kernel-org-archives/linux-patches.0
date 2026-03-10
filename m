Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633CE4779A3;
	Tue, 10 Mar 2026 09:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133363; cv=none; b=U4Ly5Xqn34sAg6SVs3iOoC6435NLly3vMDnCX2ze9Gua1WoG5sNge5VD9mLu/2g9RjJFftnGzNWd+ghVAfTrYrMLA1UQ6qoWDJWczsSbrsT0FBx+nL7NOhBWbM+Q8rCofmXZO8uD/vYrM862nFTO2LLX3JGZw/PeMneHqoSkJtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133363; c=relaxed/simple;
	bh=gaTNqiFYKF2nQTOrGVWHvVkyMdmKXIWK06YEnqVPe+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAPAvlqeYWzOSKVBTMiPMI1gZr5NIYO3J0M5xXI8Q3B3kW0t5Q8H0WqnnMPiBcdUqLdoRsmXRjiQWQeqtdAa/W7vGbYpr6AMTnKf5k3hh2/bQluJfZXEnLPSLDzUvUgyZtr5chL2qTPFMJJ3I7Mw54s3RHVjkdDCtnxW5ibKBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCoelCow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCoelCow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B12C19423;
	Tue, 10 Mar 2026 09:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133363;
	bh=gaTNqiFYKF2nQTOrGVWHvVkyMdmKXIWK06YEnqVPe+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCoelCowOescjTZb+ha9AXWx+dsip+hx7+uNb1+zj2N0iXCT+gIjJ7Fe11yuxH95I
	 G6XWg4dkVG1R3xwR+l8Rc09XUpBpiTTvxlUZeVbwgc/cJm9ky+ulUA+qafa/OQIz8a
	 sJK4CA7uPY7rBNd0EM/w3y/1NwQSFP7MHHhjbhNk1O+zAigqvhOOeV9tlBelSX89Ph
	 jIIfVsUmHxCpHDg30P6lCbw0Vo826WLc1b1ZwS0eHjip4OOqn9/078xy2oGniiHUhe
	 jFBGq7YOcqATU7dBL8GYo961kN55KZMibZD/3VOcHIjrXinHyGWQBJ5J2d2Hi3Q4/j
	 Y8dF85xSep1wA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>,
	Daniel Gomez <da.gomez@samsung.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>,
	mcgrof@kernel.org,
	da.gomez@kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] module: Fix kernel panic when a symbol st_shndx is out of bounds
Date: Tue, 10 Mar 2026 05:01:39 -0400
Message-ID: <20260310090145.2709021-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit f9d69d5e7bde2295eb7488a56f094ac8f5383b92 ]

The module loader doesn't check for bounds of the ELF section index in
simplify_symbols():

       for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
		const char *name = info->strtab + sym[i].st_name;

		switch (sym[i].st_shndx) {
		case SHN_COMMON:

		[...]

		default:
			/* Divert to percpu allocation if a percpu var. */
			if (sym[i].st_shndx == info->index.pcpu)
				secbase = (unsigned long)mod_percpu(mod);
			else
  /** HERE --> **/		secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
			sym[i].st_value += secbase;
			break;
		}
	}

A symbol with an out-of-bounds st_shndx value, for example 0xffff
(known as SHN_XINDEX or SHN_HIRESERVE), may cause a kernel panic:

  BUG: unable to handle page fault for address: ...
  RIP: 0010:simplify_symbols+0x2b2/0x480
  ...
  Kernel panic - not syncing: Fatal exception

This can happen when module ELF is legitimately using SHN_XINDEX or
when it is corrupted.

Add a bounds check in simplify_symbols() to validate that st_shndx is
within the valid range before using it.

This issue was discovered due to a bug in llvm-objcopy, see relevant
discussion for details [1].

[1] https://lore.kernel.org/linux-modules/20251224005752.201911-1-ihor.solodrai@linux.dev/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

## Analysis

### 1. Commit Message Analysis
The commit message is clear and detailed: it fixes a **kernel panic**
(page fault) in `simplify_symbols()` when a symbol's `st_shndx` (ELF
section header index) is out of bounds. The commit includes a concrete
crash trace (`BUG: unable to handle page fault`, `Kernel panic - not
syncing: Fatal exception`). The bug was discovered via a real-world
trigger (llvm-objcopy bug) with a linked mailing list discussion.

### 2. Code Change Analysis
The fix adds a **6-line bounds check** before the out-of-bounds array
access at line 1582:
```c
if (sym[i].st_shndx >= info->hdr->e_shnum) {
    pr_err(...);
    ret = -ENOEXEC;
    break;
}
```

Without this check, `info->sechdrs[sym[i].st_shndx]` can access memory
far beyond the allocated `sechdrs` array, causing a page fault and
kernel panic. Values like `SHN_XINDEX` (0xffff) or any corrupted value
>= `e_shnum` trigger this.

### 3. Bug Severity
- **Impact**: Kernel panic (crash) - the most severe possible outcome
- **Trigger**: Loading a module with an out-of-bounds `st_shndx` value,
  which can happen legitimately (SHN_XINDEX) or via corrupted/malicious
  ELF
- **Security angle**: This is an out-of-bounds read that could
  potentially be exploited for information disclosure or denial of
  service by anyone who can load kernel modules

### 4. Code History
The vulnerable code has existed since Linux 2.6.12 (2005), with the
specific `sechdrs` access pattern dating to Rusty Russell's 2010
refactoring. The bug is present in **every stable kernel tree**.

### 5. Fix Quality
- **Small and surgical**: 6 lines added, no lines removed, single file
  changed
- **Obviously correct**: Simple bounds check comparing `st_shndx`
  against `e_shnum`
- **Pattern consistent**: The `apply_relocations()` function right below
  (line 1597) already does equivalent validation with `infosec >=
  info->hdr->e_shnum`
- **Reviewed**: Has `Reviewed-by` from Daniel Gomez (Samsung) and Petr
  Pavlu (SUSE)
- **No side effects**: Returns `-ENOEXEC` on invalid module, which is
  the correct error

### 6. Backport Risk
- **Minimal**: The fix is a pure addition of a bounds check before
  existing code
- **No dependencies**: Standalone fix, no prerequisites
- **Clean backport**: The surrounding code is stable and unchanged for
  many years; this should apply cleanly to all stable trees

### 7. Stable Kernel Rules Compliance
- Obviously correct and tested: Yes (reviewed by two engineers, clear
  logic)
- Fixes a real bug: Yes (kernel panic)
- Important issue: Yes (crash/panic, potential security issue)
- Small and contained: Yes (6 lines, 1 file)
- No new features: Correct (pure safety check)

### Verification

- **git blame** confirmed the vulnerable line (`secbase =
  info->sechdrs[sym[i].st_shndx].sh_addr`) has existed since commit
  `49668688dd5a5f` by Rusty Russell (2010), with the overall pattern
  from `1da177e4c3f41` (2005)
- **Read of main.c:1570-1589** confirmed the fix is correctly placed
  before the array access in the `default` case
- **Read of main.c:1591-1598** confirmed `apply_relocations()` already
  validates section indices with the same pattern (`infosec >=
  info->hdr->e_shnum`)
- **git log** confirmed this fix commit is `6186212750892` merged
  2025-12-30
- **Explored** `is_core_symbol()` in kallsyms.c which has an equivalent
  `st_shndx >= shnum` check, confirming the pattern is well-established
- **git log** on stable tree versions confirmed the vulnerable code path
  exists in all current stable trees

This is a textbook stable backport candidate: a small, surgical fix for
a kernel panic caused by a missing bounds check on an array access, in
code that has been vulnerable for 20 years, with clear real-world
triggers (llvm-objcopy bug) and proper review.

**YES**

 kernel/module/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 710ee30b3beab..5bf456fad63e1 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1568,6 +1568,13 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			break;
 
 		default:
+			if (sym[i].st_shndx >= info->hdr->e_shnum) {
+				pr_err("%s: Symbol %s has an invalid section index %u (max %u)\n",
+				       mod->name, name, sym[i].st_shndx, info->hdr->e_shnum - 1);
+				ret = -ENOEXEC;
+				break;
+			}
+
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == info->index.pcpu)
 				secbase = (unsigned long)mod_percpu(mod);
-- 
2.51.0

