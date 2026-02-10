Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADE219ABD8;
	Tue, 10 Feb 2026 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766310; cv=none; b=okxtBOAJqAcZxQmAklaOXrjlTz6LvtkKdR+LJJQhWHrOFKZDsIA0VaULLMd+dgz6AuIIy5+0I3BOLLxCyKDkk2RfZndT0UJokTJk1xx0zWexhyyOnM4OlufMzzx+E1vQ05vRopIdVqz5CcBVC7E6hjFPXcC3CUZ+4UH3bGsuvUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766310; c=relaxed/simple;
	bh=CvkOEkSV6WrAFnbR2AFy4KmtSgcVzkq/0jjIw2+XCrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL4MCi3Nh26P1XB9b6AHDC8UWbkN8fznpevrRVTZlrPXZsWypSPG5DN6X7asNZws56DD70mLXMk00cFNCH000rt9MXtqjNuL+XgziN3S9E0HBBUwnwufPV63Rwdy58ZismxI+nseBdDtIonHHm/E/j+ItmAjpohk6EnqQLtHNXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9vtVvcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9vtVvcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B3C19425;
	Tue, 10 Feb 2026 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766309;
	bh=CvkOEkSV6WrAFnbR2AFy4KmtSgcVzkq/0jjIw2+XCrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9vtVvcvbtFxnReABWR/vG9FLy08LwZlooaYvqWBUk1PS2Y1s1vLOQWnj1DuDfKqG
	 zXhaTpdL2SqxbTcTqKg9NEcfpfXNCfKA5tjqHhz9kD2Ws6ElZN+d9GJ35YkA7D3Xo9
	 TppxeM9B+yev06sQDivOmhLNV90d4aGR0euHZR3EKtsgYlAlbpzR5duAMSc3C2M0e8
	 9rheDU2pDWpJK51VATzeois+TxHuUHQ4gqZr13bWivK+eOxbTu0DSq+zf1BYLGzk51
	 mxcRZfaFJGR3oyrDfuGcONfxbYNm3HX6P8ifywNczpr7tJe4q2JF7bNDI8FPwEehq9
	 nXD29+o1GsPwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bhavik Sachdev <b.sachdev1904@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] statmount: permission check should return EPERM
Date: Tue, 10 Feb 2026 18:31:01 -0500
Message-ID: <20260210233123.2905307-16-sashal@kernel.org>
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

From: Bhavik Sachdev <b.sachdev1904@gmail.com>

[ Upstream commit fccbe38a5d06dbe44bcd89196fe1d2c2272a1f4a ]

Currently, statmount() returns ENOENT when caller is not CAP_SYS_ADMIN
in the user namespace owner of target mount namespace. This should be
EPERM instead.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Bhavik Sachdev <b.sachdev1904@gmail.com>
Link: https://patch.msgid.link/20251129091455.757724-2-b.sachdev1904@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the selftests don't check for a specific errno on the permission
path, so the change won't break tests.

Now let me summarize the analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear: `statmount()` returns the wrong errno code
(`ENOENT`) when a caller lacks `CAP_SYS_ADMIN` in the user namespace
owning the target mount namespace. The commit changes it to `EPERM`,
which is the standard POSIX errno for "operation not permitted."

The commit was suggested by Miklos Szeredi (a senior VFS maintainer),
authored by Bhavik Sachdev, and merged by Christian Brauner (the VFS
maintainer). This gives strong confidence in correctness.

### 2. CODE CHANGE ANALYSIS

This is a **one-line change**: `-ENOENT` to `-EPERM` on line 5783 of
`fs/namespace.c`.

The affected code path is in the `statmount()` syscall
(SYSCALL_DEFINE4):

```5781:5783:fs/namespace.c
        if (kreq.mnt_ns_id && (ns != current->nsproxy->mnt_ns) &&
            !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
                return -ENOENT;
```

The condition checks: Is the caller requesting a specific mount
namespace ID? If so, is it different from the caller's own mount
namespace? And does the caller lack `CAP_SYS_ADMIN` in that namespace's
user namespace? If all three conditions are true, this is a **permission
denial**, and `-ENOENT` ("No such file or directory") is semantically
incorrect. `-EPERM` ("Operation not permitted") is the correct error
code.

### 3. BUG MECHANISM

This is a **wrong errno** bug introduced by commit `71aacb4c8c3d` ("fs:
Allow statmount() in foreign mount namespace") in v6.11-rc1. The
original author used `-ENOENT` for both "namespace doesn't exist" and
"you don't have permission", but these are semantically different
conditions that userspace needs to distinguish.

**Internal inconsistency**: The inner `do_statmount()` function (line
5572-5574) already correctly returns `-EPERM` for a different permission
check (`!is_path_reachable(...) && !ns_capable_noaudit(...)`). The outer
syscall returning `-ENOENT` for the same type of permission check is
inconsistent.

**Impact on userspace**: A userspace program calling `statmount()` on a
foreign mount namespace without sufficient privileges receives `ENOENT`,
which it would naturally interpret as "the mount namespace doesn't
exist." This misleads debugging and prevents proper error handling. A
container runtime or monitoring tool, for example, would think the
namespace is gone rather than that it lacks the right credentials —
leading to potentially wrong recovery actions.

### 4. SCOPE AND RISK

- **Scope**: Single-line change, single file (`fs/namespace.c`)
- **Risk**: Extremely low. This only changes an error code on a failure
  path. No logic is altered. No new code paths are created.
- **Potential concern**: If any userspace program checked `errno ==
  ENOENT` specifically after `statmount()` to handle permission
  failures, it would need to be updated. However, no such code exists in
  kernel selftests, and relying on ENOENT for permission denial would be
  poor practice.

### 5. STABLE TREE APPLICABILITY

The buggy code was introduced in **v6.11-rc1** and exists in stable
branches **6.11.y** through **6.19.y**. I confirmed the exact same code
(with `-ENOENT`) exists at the same location in both
`stable/linux-6.11.y` and `stable/linux-6.12.y`. The patch applies
trivially with no dependencies.

**Note**: `listmount()` (line 5943-5945) has the same bug (`-ENOENT`
instead of `-EPERM` for the same permission check). The commit being
analyzed only fixes `statmount()`, not `listmount()`. The Link URL
contains `757724-2` suggesting this was patch 2 of a series; patch 1
likely fixes `listmount()`. However, each fix is independent - fixing
`statmount()` alone is valuable even without the companion `listmount()`
fix.

### 6. CLASSIFICATION

This is a **bug fix** — returning incorrect errno values from syscalls
is a well-understood class of bug that affects userspace programs' error
handling. It is:
- Small and surgical (one line)
- Obviously correct (EPERM is the right code for permission denial)
- Low risk (only changes a failure path's error code)
- Fixes a real userspace-visible issue (misleading errno)

### 7. CONCERNS

- **No companion fix for listmount()**: The same bug exists in
  `listmount()` but this commit only addresses `statmount()`. Ideally
  both should be backported together.
- **UAPI change**: This technically changes the behavior of a syscall
  (different errno), which is visible to userspace. However, since the
  previous value was incorrect and misleading, this is a correction, not
  a regression.

### 8. VERDICT

This is a clear, minimal, correct bug fix to a syscall's error handling.
It returns the correct standard POSIX errno (`EPERM`) instead of a
misleading one (`ENOENT`) when a permission check fails. It's a one-line
change with zero risk of regression, authored with involvement from
senior VFS maintainers (Miklos Szeredi suggesting, Christian Brauner
merging). It applies cleanly to all affected stable trees (6.11+).

**YES**

 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c58674a20cad5..f6879f282daec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5780,7 +5780,7 @@ SYSCALL_DEFINE4(statmount, const struct mnt_id_req __user *, req,
 
 	if (kreq.mnt_ns_id && (ns != current->nsproxy->mnt_ns) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
-		return -ENOENT;
+		return -EPERM;
 
 	ks = kmalloc(sizeof(*ks), GFP_KERNEL_ACCOUNT);
 	if (!ks)
-- 
2.51.0

