Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D673CA48E;
	Thu,  5 Mar 2026 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725029; cv=none; b=EcgGtThBxsA0BLEQeXFOr3L2JPYBKFX9B88RPLLaVau+2sg47xfqyPHFu3nBeGWY2Fce/6puCnCkYmMbv8g88G2SctKwBvwfqdp+4F+cmyRw1XcWiEGgreVO3sQKacPFGQrrCZGyjpgS4v1whNBRQirFJMmaeI7FN4x94Wm9DoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725029; c=relaxed/simple;
	bh=iZDpdETZLDllpjy56lm2Peyx2QqMSzdTyXtzyd7RcwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L2IR340qd4gFAW1JJ+BiIXhE+BhEnMCdVs+pSIpamrjSX3MaM73L/kf79AQ4zeh8kwRU0HlQL15shC7fdBbWn1yjF9aNusUH887c23EncS2IqRdtQVseFZFNLdor+zWlWpJsWKC+GcY2S7RDUY6n8MPIla2cLsHwfJ0ueEAc8Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUdh/fnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUdh/fnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B1BC2BC87;
	Thu,  5 Mar 2026 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725028;
	bh=iZDpdETZLDllpjy56lm2Peyx2QqMSzdTyXtzyd7RcwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUdh/fnmUK46OVzdJCFuh8ewa5omP87apEIJ1WJY0IZH3a9DtrGDz1mvjNd4/P4TA
	 qHanBq+5xTao4nX9ie3r8J0fp3SDaM9+HAzhpYuHd1VUP+iOSyhNPfUpAM/lJuztS8
	 CUkqN6RiqmBcdJM2AT+B3vHAGj9ojamrrQnhGRJv5hETvtTEQWfEb3wUc080hKYbs2
	 3hr5ZP314HdZkO+1tA8twb1QL4vBjUv2995gKnVpoBP9VSSRh65P4VVFsK49cMP8Lp
	 fkFPbZBNAzB5IgHTuzpXOTQQ0onMD9WGyPd7HIfhDrzQaIGQglaj1BP4k0yu1juRAx
	 QGmMdnl7OIUhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david@kernel.org,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] unshare: fix unshare_fs() handling
Date: Thu,  5 Mar 2026 10:36:45 -0500
Message-ID: <20260305153704.106918-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6c4b2243cb6c0755159bd567130d5e12e7b10d9f ]

There's an unpleasant corner case in unshare(2), when we have a
CLONE_NEWNS in flags and current->fs hadn't been shared at all; in that
case copy_mnt_ns() gets passed current->fs instead of a private copy,
which causes interesting warts in proof of correctness]

> I guess if private means fs->users == 1, the condition could still be true.

Unfortunately, it's worse than just a convoluted proof of correctness.
Consider the case when we have CLONE_NEWCGROUP in addition to CLONE_NEWNS
(and current->fs->users == 1).

We pass current->fs to copy_mnt_ns(), all right.  Suppose it succeeds and
flips current->fs->{pwd,root} to corresponding locations in the new namespace.
Now we proceed to copy_cgroup_ns(), which fails (e.g. with -ENOMEM).
We call put_mnt_ns() on the namespace created by copy_mnt_ns(), it's
destroyed and its mount tree is dissolved, but...  current->fs->root and
current->fs->pwd are both left pointing to now detached mounts.

They are pinning those, so it's not a UAF, but it leaves the calling
process with unshare(2) failing with -ENOMEM _and_ leaving it with
pwd and root on detached isolated mounts.  The last part is clearly a bug.

There is other fun related to that mess (races with pivot_root(), including
the one between pivot_root() and fork(), of all things), but this one
is easy to isolate and fix - treat CLONE_NEWNS as "allocate a new
fs_struct even if it hadn't been shared in the first place".  Sure, we could
go for something like "if both CLONE_NEWNS *and* one of the things that might
end up failing after copy_mnt_ns() call in create_new_namespaces() are set,
force allocation of new fs_struct", but let's keep it simple - the cost
of copy_fs_struct() is trivial.

Another benefit is that copy_mnt_ns() with CLONE_NEWNS *always* gets
a freshly allocated fs_struct, yet to be attached to anything.  That
seriously simplifies the analysis...

FWIW, that bug had been there since the introduction of unshare(2) ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://patch.msgid.link/20260207082524.GE3183987@ZenIV
Tested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding of the bug and the fix. Let me
compile the analysis.

## Analysis

### What the Commit Fixes

This is a real bug in `unshare(2)` that has existed since its
introduction in 2006. The bug is in `unshare_fs()` at
`kernel/fork.c:3085`:

When `unshare(CLONE_NEWNS | CLONE_NEWCGROUP)` is called with `fs->users
== 1`:
1. `unshare_fs()` skips allocating a new `fs_struct` (early return at
   line 3085)
2. `ksys_unshare()` passes `current->fs` directly to
   `create_new_namespaces()`
3. `copy_mnt_ns()` succeeds and **mutates** `current->fs->pwd` and
   `current->fs->root` to point into the new namespace
4. `copy_cgroup_ns()` fails (e.g., `-ENOMEM`)
5. Error unwind calls `put_mnt_ns()`, destroying the new namespace and
   dissolving its mount tree
6. **Result**: The process's `pwd` and `root` are left pointing to
   detached mounts

The process is left in a broken state — `unshare()` returns an error but
has silently corrupted the caller's filesystem context.

### The Fix

A single-line change adding `!(unshare_flags & CLONE_NEWNS) &&` to the
early-return condition. This forces allocation of a fresh `fs_struct`
whenever `CLONE_NEWNS` is set, ensuring `copy_mnt_ns()` never mutates
the live `current->fs`.

### Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes — authored by Al Viro (VFS
   maintainer), signed off by Christian Brauner (VFS maintainer), tested
   by Waiman Long (Red Hat). The logic is straightforward.

2. **Fixes a real bug**: Yes — a process can end up with pwd/root on
   detached mounts after a failed `unshare()`. This is a correctness bug
   that can break container runtimes and namespace tools.

3. **Important issue**: Yes — namespace operations are critical for
   containers (Docker, Kubernetes, LXC). A failed `unshare()` silently
   corrupting process state is serious.

4. **Small and contained**: Yes — a one-line change in a single file.

5. **No new features**: Correct — this only fixes error handling
   behavior.

6. **Applies cleanly**: The code at line 3085 (`if (fs->users == 1)`)
   has been unchanged since Al Viro's 2009 commit `498052bba55e`, so it
   should exist identically in all stable trees.

### Risk Assessment

**Risk: Very Low**
- The change only affects the `CLONE_NEWNS` path in `unshare()`
- The "cost" is an extra `copy_fs_struct()` allocation when
  `CLONE_NEWNS` is used with `fs->users == 1` — trivial overhead
- No behavioral change for the success path (the new fs_struct replaces
  the old one anyway)
- Only the failure path is meaningfully affected (preventing corruption)

### User Impact

**Impact: Medium-High**
- Affects any process calling `unshare(CLONE_NEWNS | <other_ns_flag>)`
  where a later namespace copy fails
- Container runtimes commonly use these flag combinations
- The bug has existed since Linux 2.6.16 (introduction of `unshare(2)`)
- Waiman Long's testing confirmed `copy_mnt_ns()` with `current->fs` was
  called 13 times during normal boot

### Verification

- **Read `kernel/fork.c:3077-3093`**: Confirmed the `unshare_fs()`
  function and the buggy `if (fs->users == 1)` early return at line 3085
- **Read `kernel/nsproxy.c:87-161`**: Confirmed
  `create_new_namespaces()` calls `copy_mnt_ns()` first (line 98), then
  `copy_cgroup_ns()` (line 123), with error unwind calling
  `put_mnt_ns()` (line 157) — confirming the failure scenario
- **Read `kernel/fork.c:3149-3150`**: Confirmed `CLONE_NEWNS` implies
  `CLONE_FS` (`unshare_flags |= CLONE_FS`), so `unshare_fs()` will
  always enter the main body when `CLONE_NEWNS` is set
- **git blame**: Confirmed the buggy line dates back to commit
  `498052bba55e` (Al Viro, 2009), itself a refactor of the original
  `unshare(2)` code from 2006
- **Mailing list (patch.msgid.link)**: Al Viro posted this as
  `[PATCH][RFC] bug in unshare(2) failure recovery`. Waiman Long tested
  and confirmed the fix eliminates the problematic code path. No
  objections raised.
- **git log --grep**: Found the fix as commit `6c4b2243cb6c0`

This is a clear, well-understood bug fix by the VFS maintainer with
testing confirmation from Red Hat. The fix is minimal (one line),
surgical, low-risk, and addresses a real correctness bug in a core
syscall that has existed for 20 years. It meets all stable kernel
criteria.

**YES**

 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8ec..68ccbaea7398a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3082,7 +3082,7 @@ static int unshare_fs(unsigned long unshare_flags, struct fs_struct **new_fsp)
 		return 0;
 
 	/* don't need lock here; in the worst case we'll do useless copy */
-	if (fs->users == 1)
+	if (!(unshare_flags & CLONE_NEWNS) && fs->users == 1)
 		return 0;
 
 	*new_fsp = copy_fs_struct(fs);
-- 
2.51.0

