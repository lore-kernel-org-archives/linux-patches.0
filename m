Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB919ABD8;
	Tue, 10 Feb 2026 23:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766311; cv=none; b=IN/sVXtZJwf8oSrwMt9J6WqQHXG4/hob6oPoMjA+Bwu/tNeQa7Ww5AERwBDjvKObTR15zs/0T2t4xmAO2qCfcA0y3TWumPvOxyMHpopfpxf13aLcO8ZkTHycsLk/rjjTYhhCNl9XhT3/poQS9WvX2EobwYUJTN5ID7BvPGq8G+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766311; c=relaxed/simple;
	bh=MgNuV77btrx43G0ydFkyKy6erseXeXfn63J80fZlm0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JgiLdyCsoDsUKIVxCq2Nc4YdejUS5wpM+ul738xotoDmGM0NbKPaP9ST3A39TcJULEJZaBFCMtGLZv8JJWf+g/HbHpfptto9zAU+D4Ej7cnCpzB8WyyANJ0/jYLn/cNrfRgVXFwsWW+stMYlPreyuH1ELza1pNSp8lixcWMMNBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdK65lKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdK65lKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22153C116C6;
	Tue, 10 Feb 2026 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766310;
	bh=MgNuV77btrx43G0ydFkyKy6erseXeXfn63J80fZlm0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdK65lKdA5w0yWcd78sq8TdTdZkpxG5ayvDFlAzsvKeN7Y2Mqi0WkuhHrh59H4rYv
	 pNJcxDuobJxz5bJNkUQG1hvZ3mkVAdL4FwWvX8krSnGc4oFSY1dD2c/n/osyIz4Z+s
	 uClhHMjuK8HU6N7K1EP67/uUYrpk87IPRq/CJ87H93LIPniTHc2tPFnt0MxwAOVcq5
	 KRWXeOAa9cDH7XP8juWWNABtULgs2Kr7l7MbQ49OJ7GFjHvRBVb6aS0K5fJ9Cab9zL
	 60AlHiHsYNKZ3dDR8s8Xew9y4mxzYNbJurQ3sZma9ge3VC/FAWmVrN5vA0bZZoFzJ3
	 sWIYcmv/xdSRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jeffrey Bencteux <jeff@bencteux.fr>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>,
	eparis@redhat.com,
	audit@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] audit: add missing syscalls to read class
Date: Tue, 10 Feb 2026 18:31:02 -0500
Message-ID: <20260210233123.2905307-17-sashal@kernel.org>
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

[ Upstream commit bcb90a2834c7393c26df9609b889a3097b7700cd ]

The "at" variant of getxattr() and listxattr() are missing from the
audit read class. Calling getxattrat() or listxattrat() on a file to
read its extended attributes will bypass audit rules such as:

-w /tmp/test -p rwa -k test_rwa

The current patch adds missing syscalls to the audit read class.

Signed-off-by: Jeffrey Bencteux <jeff@bencteux.fr>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me summarize the analysis.

## Analysis

### 1. Commit Message Analysis

The commit is clear: it adds `getxattrat` and `listxattrat` syscalls to
the audit "read" class. The commit message explains the concrete
consequence — calling these syscalls will **bypass** audit rules like
`-w /tmp/test -p rwa -k test_rwa`, which is a security monitoring gap.

### 2. Code Change Analysis

The change is only to `include/asm-generic/audit_read.h` — it adds 6
lines (two `#ifdef`-guarded entries). This file defines the
`read_class[]` array used by `audit_match_perm()` in `kernel/auditsc.c`
to determine whether a given syscall matches the "read" permission
class. The matching code:

```151:170:kernel/auditsc.c
static int audit_match_perm(struct audit_context *ctx, int mask)
{
        unsigned n;
        // ...
        if ((mask & AUDIT_PERM_READ) &&
             audit_match_class(AUDIT_CLASS_READ, n))
                return 1;
        // ...
}
```

Without `getxattrat` and `listxattrat` in the read class,
`audit_match_perm()` returns 0 for these syscalls when checking
`AUDIT_PERM_READ`, meaning audit watch rules with read (`r`) permission
never fire for these syscalls.

### 3. Root Cause — Omission in Original Syscall Introduction

The original commit `6140be90ec70c` ("fs/xattr: add *at family
syscalls") introduced all four `*xattrat` syscalls. It correctly added
`setxattrat` and `removexattrat` to `audit_change_attr.h` (the
attribute-change class), but **forgot** to add `getxattrat` and
`listxattrat` to `audit_read.h` (the read class). This is an
oversight/bug in the original commit.

### 4. Affected Stable Trees

- The `*xattrat` syscalls were introduced in **v6.13**.
- Stable trees **6.13.y through 6.18.y** all have these syscalls defined
  but are **missing** the audit read class entries.
- Stable trees **6.12.y and older** do not have the syscalls, so the
  `#ifdef` guards make this a safe no-op.
- I verified that 6.14.y has the syscalls AND is missing the audit
  entries, confirming the bug is present.

### 5. Security Impact

This is a **security audit bypass**. Linux audit is a critical security
feature used for:
- Compliance monitoring (PCI-DSS, HIPAA, SOX)
- Intrusion detection
- Forensics

The `getxattrat()` syscall can read security-relevant extended
attributes (like `security.selinux` labels) without triggering audit
rules. An attacker or unauthorized user could use
`getxattrat()`/`listxattrat()` instead of `getxattr()`/`listxattr()` to
enumerate or read extended attributes while evading audit monitoring.
This is a concrete bypass of security controls.

### 6. Fix Quality

- **Trivially small**: 6 lines added, no lines removed, no logic changes
- **Obviously correct**: Follows the exact same `#ifdef __NR_xxx /
  __NR_xxx, / #endif` pattern used by every other conditional entry in
  the file
- **Safe**: The `#ifdef` guards mean it compiles cleanly even if the
  syscall numbers don't exist
- **No dependencies**: This is a self-contained fix
- **Signed off by Paul Moore**: The audit subsystem maintainer
- **Zero risk of regression**: Adding entries to the read class array
  cannot break anything; it only makes the audit matching more complete

### 7. Risk vs Benefit

- **Risk**: Essentially zero. The change is trivially small, obviously
  correct, guarded by `#ifdef`, and touches only a static array
  initializer.
- **Benefit**: Closes a security audit bypass gap for all users of audit
  on kernels 6.13+.

**YES**

 include/asm-generic/audit_read.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/asm-generic/audit_read.h b/include/asm-generic/audit_read.h
index 7bb7b5a83ae2e..fb9991f53fb6f 100644
--- a/include/asm-generic/audit_read.h
+++ b/include/asm-generic/audit_read.h
@@ -4,9 +4,15 @@ __NR_readlink,
 #endif
 __NR_quotactl,
 __NR_listxattr,
+#ifdef __NR_listxattrat
+__NR_listxattrat,
+#endif
 __NR_llistxattr,
 __NR_flistxattr,
 __NR_getxattr,
+#ifdef __NR_getxattrat
+__NR_getxattrat,
+#endif
 __NR_lgetxattr,
 __NR_fgetxattr,
 #ifdef __NR_readlinkat
-- 
2.51.0

