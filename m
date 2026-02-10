Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5AC2DC76F;
	Tue, 10 Feb 2026 23:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766296; cv=none; b=FCSnrKUrSqUr9/LhPatyAMAOKTgmPLsvaIgKisxRhmdrwHiWdc2Oh1SK6tKTkwI+1rjoTNY5q8HIsxJFbAFGCkXofWzu/yX3qOWnYKsps6vfv+hV7vQ/co+5H6rDHmWsLS1PIuq5SKyTSH6uYnhtIrVxUpkRHetP8gp995gLvnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766296; c=relaxed/simple;
	bh=G7lFiqCbS5JysXbiUO7LMjyUbMqhN7WZBgBKt2lUoqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i52OzcOZ4knS+uJqgUf4IXKV21tASLhk6VHMyMrwZpj8pBU44HcXrY0nZAwy2FUd7ccn8xEbiVICCWZDOWMJzMd5TXhOsjj1ZiWNaM40wu2qL59pl8rMWh1ng1D2Z/Ju5q093iQdL2IHLpSJ7oPcpSMVqix5oYKJZ8j+XFwYiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0TUXOj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0TUXOj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC73DC19423;
	Tue, 10 Feb 2026 23:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766295;
	bh=G7lFiqCbS5JysXbiUO7LMjyUbMqhN7WZBgBKt2lUoqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0TUXOj/TdVe3k8ZPheR5hPBuM3LvcJfTtXXne52xklNBHZTwPOosA+huprYkxR4z
	 RsxjpTU7Z/sFW+zByqFpv95nFHc2VO63QNTxVEHdVYL5ZpG15TEEUN8yVBSRPegULE
	 yDw1CS6BgrFN4yTH/NRWI18bJ+iHleP+RT7xIH7eUCGRz43rl/unvqijcbLvw1zSY6
	 K6ME7MJ/NnoeFqDiyU5NssEUq6fg2QKiL+X1+U4mRPBh5bpIVOHqFNoZX+FhqmXD76
	 pLLZd82YRmle0iEuljl/Fd19cnSo+5J82SBZyzkftbryYWSABicdD1hb3WUYOXi7Al
	 2AHl94IdDzGIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jeffrey Bencteux <jeff@bencteux.fr>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>,
	eparis@redhat.com,
	audit@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] audit: add fchmodat2() to change attributes class
Date: Tue, 10 Feb 2026 18:30:51 -0500
Message-ID: <20260210233123.2905307-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeffrey Bencteux <jeff@bencteux.fr>

[ Upstream commit 4f493a6079b588cf1f04ce5ed6cdad45ab0d53dc ]

fchmodat2(), introduced in version 6.6 is currently not in the change
attribute class of audit. Calling fchmodat2() to change a file
attribute in the same fashion than chmod() or fchmodat() will bypass
audit rules such as:

-w /tmp/test -p rwa -k test_rwa

The current patch adds fchmodat2() to the change attributes class.

Signed-off-by: Jeffrey Bencteux <jeff@bencteux.fr>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write up the full analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and explicit about the bug:

- **Problem**: `fchmodat2()`, introduced in kernel v6.6, was never added
  to the audit subsystem's "change attributes" (chattr) class. This
  means that any process calling `fchmodat2()` to change a file's
  permissions **completely bypasses audit rules** that monitor attribute
  changes (the `-p a` permission in audit rules, e.g., `-w /tmp/test -p
  rwa -k test_rwa`).

- **Impact**: This is a **security audit bypass**. Users who deploy
  audit rules to track attribute changes on sensitive files (a standard
  security and compliance practice) will miss `fchmodat2()` calls
  entirely. An attacker or any process using `fchmodat2()` instead of
  `chmod()`/`fchmodat()` can change file permissions without triggering
  any audit record.

- **Author**: Jeffrey Bencteux, signed off by Paul Moore (the audit
  subsystem maintainer), which is a strong indicator of correctness.

### 2. CODE CHANGE ANALYSIS

The patch is **3 lines** in a single file:

```c
#ifdef __NR_fchmodat2
__NR_fchmodat2,
#endif
```

Added to `include/asm-generic/audit_change_attr.h`, right after the
existing `__NR_fchmodat` entry. This is the header file that is
`#include`d by the `chattr_class[]` arrays across all architectures
(x86, sparc, s390, powerpc, parisc, alpha, and generic lib/audit.c +
compat_audit.c). These arrays define which syscall numbers are in the
"change attributes" audit class.

The mechanism is straightforward:
- The `audit_match_perm()` function in `kernel/auditsc.c` (line 167-169)
  checks if a syscall number (`ctx->major`) matches `AUDIT_CLASS_CHATTR`
  when the audit rule has `AUDIT_PERM_ATTR` set.
- Without `fchmodat2` in the `chattr_class[]` array,
  `audit_match_class(AUDIT_CLASS_CHATTR, __NR_fchmodat2)` returns 0, so
  the rule never fires for `fchmodat2()`.

Critically, `fchmodat2()` (defined in `fs/open.c` line 704-708) calls
the same `do_fchmodat()` function as `fchmodat()` (line 710-714). They
are functionally identical for attribute changes - the only difference
is `fchmodat2` adds a `flags` parameter. So there's no question that
`fchmodat2` belongs in the chattr class.

### 3. CLASSIFICATION

This is a **security bug fix** — specifically, an audit bypass. It is
NOT a new feature. The `fchmodat2` syscall already exists; this merely
ensures the audit subsystem correctly classifies it alongside the
equivalent `fchmodat` syscall.

This fits squarely into the category of fixes that are critical for
stable:
- Environments running Linux audit (virtually all enterprise
  deployments, compliance-regulated systems) are silently missing
  attribute change events
- This is a **compliance gap** (PCI-DSS, HIPAA, SOX, FedRAMP all require
  file integrity monitoring via audit)
- The `#ifdef __NR_fchmodat2` guard ensures it compiles safely on older
  architectures where the syscall might not be defined

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: 3 lines added, 1 file changed — the smallest possible change
- **Risk**: Near zero. The change only adds a syscall number to an
  existing list. The `#ifdef` guard protects against the case where
  `__NR_fchmodat2` is not defined. There is no behavioral change to any
  existing code path.
- **Could this break anything?**: No. Adding a new entry to the
  chattr_class array only means that `fchmodat2` syscalls will now
  correctly trigger audit rules with attribute-change permissions.
  There's no way this causes a regression — at worst, users would see
  additional (correct) audit records they were previously missing.

### 5. USER IMPACT

- **Who is affected**: Every single system running Linux audit with
  attribute-change monitoring rules on kernels 6.6+. This includes
  enterprise distributions (RHEL, SLES, Ubuntu), compliance-critical
  infrastructure, and security-sensitive deployments.
- **Severity**: HIGH — this is a silent security audit bypass. Users
  believe they are monitoring attribute changes, but `fchmodat2()` slips
  through undetected.
- **Real-world trigger**: glibc and other C libraries may route
  `chmod()`-like calls through `fchmodat2()` if available. The commit
  message explicitly gives an example of the audit rule being bypassed.

### 6. DEPENDENCY CHECK

- **fchmodat2 syscall exists in v6.6**: Confirmed — `__NR_fchmodat2` is
  defined as syscall 452 in `include/uapi/asm-generic/unistd.h` since
  v6.6.
- **Clean application to v6.6**: Confirmed — the context lines
  (`__NR_fchownat`, `__NR_fchmodat`, `#endif`, `#ifdef __NR_chown32`)
  are identical in v6.6's version of the file.
- **No other dependencies**: The patch is completely self-contained. It
  doesn't depend on any other commit. The `setxattrat`/`removexattrat`
  additions from commit 6140be90ec70c are in different positions in the
  file and don't affect the context.
- **Applicable to**: 6.6.y, 6.1.y (if fchmodat2 was backported there —
  it wasn't since fchmodat2 was introduced in 6.6), and all stable trees
  ≥6.6.

### 7. STABILITY INDICATORS

- Signed off by Paul Moore, the audit subsystem maintainer
- The pattern is well-established — the same file has entries for every
  attribute-changing syscall, each guarded by `#ifdef __NR_*`
- The commit is in the `security-next` tree, in the pipeline for
  mainline

### 8. COMPARISON WITH PRECEDENT

The same file has been modified before for identical reasons:
- `262fd3aad6110` ("audit: Modify a set of system calls in audit class
  definitions") — added syscalls to audit classes
- `af2951325bd6c` ("audit: make link()/linkat() match 'attribute change'
  predicate") — added `link`/`linkat` to the same class
- `6140be90ec70c` ("fs/xattr: add *at family syscalls") — added
  `setxattrat`/`removexattrat` to the same header

All of these follow the exact same pattern of adding a syscall number to
an audit class list.

### Summary

This is a textbook stable backport candidate:

1. **Obviously correct**: It adds 3 lines that are structurally
   identical to the existing `fchmodat` entry, guarded by `#ifdef`
2. **Fixes a real bug**: Silent audit bypass of attribute changes via
   `fchmodat2()`
3. **Security impact**: Allows processes to bypass audit monitoring —
   this is a security-relevant gap
4. **Small and contained**: 3 lines, 1 file, no behavioral side effects
5. **No new features**: Just ensures existing audit infrastructure
   correctly covers an existing syscall
6. **Applies cleanly to stable**: Context matches v6.6 exactly; no
   dependencies
7. **Signed off by subsystem maintainer**: Paul Moore (audit maintainer)

The fix addresses a security audit bypass that has existed since v6.6
(when `fchmodat2` was introduced) — roughly 2+ years of every stable
kernel silently failing to audit attribute changes made via
`fchmodat2()`. This is particularly critical for enterprise and
compliance-regulated environments.

**YES**

 include/asm-generic/audit_change_attr.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index cc840537885fb..ddd90bbe40dfc 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -26,6 +26,9 @@ __NR_fremovexattr,
 __NR_fchownat,
 __NR_fchmodat,
 #endif
+#ifdef __NR_fchmodat2
+__NR_fchmodat2,
+#endif
 #ifdef __NR_chown32
 __NR_chown32,
 __NR_fchown32,
-- 
2.51.0

