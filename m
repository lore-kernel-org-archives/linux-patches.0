Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E32D1C01;
	Wed, 11 Feb 2026 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813087; cv=none; b=Pmh7vanEEmlxV5fXt7on1ZWPfKEOjSNhf2/1QvmC0v1OuaoVA4Co6rr9opVi8tMdMwIf4QdgWOP4/caIV4WneC1p649L/VrsWeQhWZNBiRvvK+ENTHuKP+UUYDk/I1X5EzTuxKeaAIKjA8kzcfy5s8b35MT9jUF6I+BqlM8UR8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813087; c=relaxed/simple;
	bh=S01YWwzXnSTFccYY1JGvSdwhdM5Gwzpgl3owws/aWnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag02vGWTsxJcsUDastH/rioqusbwdZK310gBZJKAC8oYrHveIrWfr8is/lYLkKeLer4P9CrxtA8o5sdshSEZVYDc6j/iVpBqlnIfHu0/mWanJ2P7vXoejJ3cyHWQX/1pt9CMtemJorYv+QiAkvu40J7vJ92rjx8s3FUNG0S6thE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlXNdHlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlXNdHlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7779C19421;
	Wed, 11 Feb 2026 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813087;
	bh=S01YWwzXnSTFccYY1JGvSdwhdM5Gwzpgl3owws/aWnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlXNdHlKCkyyEHJ5RAHm+CUq0f+i+rUiF0gPLuc4Of9IAHZBvnMxkyh72m8HBZwU+
	 0yb3LbLCnKXuGwNDjYf2+VibM+PFyHu7C9uol3N7veHoaJ9jHObbqkEq9A0WYeQ4s7
	 cZuazG5faNrY1JDF2LTqjH4j5aZEu2EXcak21e7RJZ8ZyQR9os8OexzbKpkLobUvdY
	 b82pkbW4m1qFoQzI3Sv61W7b8rgPMPcpUNq+FRWkV2Fefkeeh5SD6Ur42ctGhuBmir
	 96qJxWiD145FDgE4gitzdhjeS4VwdUellHl0Xqpje0YD0Ys+fu74YwvqQh464RudCs
	 vIZHkvIpDicpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] ntfs: ->d_compare() must not block
Date: Wed, 11 Feb 2026 07:30:17 -0500
Message-ID: <20260211123112.1330287-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ca2a04e84af79596e5cd9cfe697d5122ec39c8ce ]

... so don't use __getname() there.  Switch it (and ntfs_d_hash(), while
we are at it) to kmalloc(PATH_MAX, GFP_NOWAIT).  Yes, ntfs_d_hash()
almost certainly can do with smaller allocations, but let ntfs folks
deal with that - keep the allocation size as-is for now.

Stop abusing names_cachep in ntfs, period - various uses of that thing
in there have nothing to do with pathnames; just use k[mz]alloc() and
be done with that.  For now let's keep sizes as-in, but AFAICS none of
the users actually want PATH_MAX.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Line 1263 confirms: `ntfs_dentry_ops` (which contains the `d_compare`
and `d_hash` callbacks) is only installed when `nocase` option is used.
This limits the impact to ntfs3 users with case-insensitive mode
enabled.

Let me now summarize the analysis.

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject is direct: "ntfs: ->d_compare() must not block."
Author Al Viro (VFS maintainer) clearly identifies the VFS contract
violation. The message explains the fix: replace `__getname()` (which
uses `GFP_KERNEL` - blocking) with `kmalloc(PATH_MAX, GFP_NOWAIT)` (non-
blocking) in `ntfs_d_compare()`. Additionally, the commit stops all
ntfs3 code from abusing `names_cachep` (the kernel's pathname cache),
replacing it with standard `kmalloc`/`kzalloc`.

### 2. CODE CHANGE ANALYSIS

The bug is in `ntfs_d_compare()` at `fs/ntfs3/namei.c:471`:

```439:503:fs/ntfs3/namei.c
static int ntfs_d_compare(const struct dentry *dentry, unsigned int
len1,
                          const char *str, const struct qstr *name)
{
        // ...
        uni1 = __getname();  // BUG: __getname() =
kmem_cache_alloc(names_cachep, GFP_KERNEL)
                             // GFP_KERNEL can SLEEP, but d_compare MUST
NOT BLOCK
```

**The bug mechanism:**
- `d_compare` is called from `__d_lookup_rcu_op_compare()` in
  `fs/dcache.c`, which runs during RCU-walk path lookup under
  `rcu_read_lock()`
- The VFS locking documentation
  (`Documentation/filesystems/locking.rst`, line 45) explicitly states:
  `d_compare: may block: no`
- `__getname()` expands to `kmem_cache_alloc(names_cachep, GFP_KERNEL)`
  (line 2541 of `include/linux/fs.h`)
- `GFP_KERNEL` = `__GFP_RECLAIM | __GFP_IO | __GFP_FS` - this **can
  sleep** to reclaim memory
- Sleeping under `rcu_read_lock()` can cause: RCU stalls, soft lockups,
  and with `CONFIG_DEBUG_ATOMIC_SLEEP`, BUG/warnings

**The fix changes:**

| Function | Before | After | Critical? |
|----------|--------|-------|-----------|
| `ntfs_d_compare` | `__getname()` (GFP_KERNEL, blocks) |
`kmalloc(PATH_MAX, GFP_NOWAIT)` | **YES - the core bug** |
| `ntfs_d_hash` | `kmem_cache_alloc(names_cachep, GFP_NOWAIT)` |
`kmalloc(PATH_MAX, GFP_NOWAIT)` | Cleanup (already non-blocking) |
| `ntfs_lookup` | `__getname()` | `kmalloc(PATH_MAX, GFP_KERNEL)` |
Cleanup (can block) |
| `ntfs_rename` | `__getname()` | `kmalloc(PATH_MAX, GFP_KERNEL)` |
Cleanup (can block) |
| `ntfs_readdir` | `__getname()` | `kmalloc(PATH_MAX, GFP_KERNEL)` |
Cleanup (can block) |
| `ntfs_set_label` | `__getname()` | `kmalloc(PATH_MAX, GFP_KERNEL)` |
Cleanup (can block) |
| `ntfs_create_inode` | `kmem_cache_zalloc(names_cachep)` |
`kzalloc(PATH_MAX)` | Cleanup |
| `ntfs_link_inode` | `kmem_cache_zalloc(names_cachep)` |
`kzalloc(PATH_MAX)` | Cleanup |
| `ntfs_unlink_inode` | `kmem_cache_zalloc(names_cachep)` |
`kzalloc(PATH_MAX)` | Cleanup |
| `ntfs_get_acl` | `__getname()` | `kmalloc(PATH_MAX, GFP_KERNEL)` |
Cleanup (can block) |

### 3. CLASSIFICATION

This is a **bug fix** - specifically a **sleeping in atomic context**
bug. It violates a documented VFS contract. The `d_compare` callback is
invoked during RCU-walk path lookup, which is a non-blocking context.
Using `GFP_KERNEL` allocation there is fundamentally wrong.

The prior commit `589996bf8c459` ("ntfs3: Change to non-blocking
allocation in ntfs_d_hash") was reported by **syzbot** and fixed the
exact same class of bug in `ntfs_d_hash` but missed `ntfs_d_compare`.
This commit completes that fix.

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 5 (all in fs/ntfs3/)
- **Lines changed**: ~40 lines, all mechanical substitutions
- **Risk**: Very low. The changes are:
  - `__getname()` -> `kmalloc(PATH_MAX, GFP_KERNEL)`: Functionally
    identical since `__getname()` IS `kmem_cache_alloc(names_cachep,
    GFP_KERNEL)` and `names_cachep` is size PATH_MAX. `kmalloc` for size
    PATH_MAX (4096) will use the slab allocator with a 4k slab, so
    behavior is essentially the same.
  - `__getname()` -> `kmalloc(PATH_MAX, GFP_NOWAIT)`: Critical fix for
    `d_compare`, changes blocking to non-blocking.
  - `kmem_cache_alloc/free(names_cachep)` -> `kmalloc`/`kfree`:
    Functionally equivalent, just uses generic slab instead of a
    specific slab cache.
  - `kmem_cache_zalloc(names_cachep)` -> `kzalloc()`: Functionally
    equivalent.

### 5. USER IMPACT

**Who is affected**: Users of the ntfs3 filesystem with the `nocase`
mount option who access files with non-ASCII characters in their names.

**Trigger scenario**: When memory pressure forces `GFP_KERNEL` to invoke
reclaim/IO/FS callbacks while inside `d_compare` under
`rcu_read_lock()`.

**Severity**: HIGH - sleeping in RCU read-side critical section can
cause:
- Soft lockups and RCU stalls
- Potential deadlock if memory reclaim needs to complete RCU grace
  period
- `BUG()` with `CONFIG_DEBUG_ATOMIC_SLEEP` enabled

### 6. STABILITY INDICATORS

- **Author**: Al Viro - the Linux VFS maintainer, one of the most
  trusted kernel developers
- The same class of bug was already reported by syzbot for `d_hash`
  (commit 589996bf8c459)
- The fix is mechanically simple - substituting allocation functions

### 7. DEPENDENCY CHECK

The commit has mild dependencies for backporting:
- In `inode.c`, the pre-patch code depends on `a8a3ca23bbd9d`
  ("Initialize allocated memory before use") which changed `__getname()`
  to `kmem_cache_zalloc(names_cachep)`. If this isn't in a target stable
  tree, the inode.c hunks need minor adjustment.
- However, the **critical fix** (`ntfs_d_compare` in `namei.c`) is self-
  contained and applies cleanly to any kernel that has the `nocase`
  option (introduced in `a3a956c78efa`, ~6.2).

### Conclusion

This commit fixes a real, documented VFS contract violation:
`ntfs_d_compare()` sleeps (using `GFP_KERNEL`) in an atomic/RCU context
where sleeping is explicitly forbidden. This is the same class of bug
that syzbot already caught for `ntfs_d_hash`. The fix is from Al Viro
(VFS maintainer), is mechanically simple, low risk, and fixes a bug that
can cause soft lockups and RCU stalls. The non-critical cleanup parts
(stopping `names_cachep` abuse) are functionally equivalent and carry
essentially zero regression risk. While the commit touches 5 files,
every change is a simple allocation function substitution with no
behavioral change except the critical GFP_KERNEL -> GFP_NOWAIT in
`d_compare`. The commit may need minor adjustments for older stable
trees due to intermediate commits, but the core fix is straightforward.

**YES**

 fs/ntfs3/dir.c    |  5 ++---
 fs/ntfs3/fsntfs.c |  4 ++--
 fs/ntfs3/inode.c  | 13 ++++++-------
 fs/ntfs3/namei.c  | 17 ++++++++---------
 fs/ntfs3/xattr.c  |  5 ++---
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index b98e95d6b4d99..cf038d713f507 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -423,8 +423,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	/* Allocate PATH_MAX bytes. */
-	name = __getname();
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
@@ -502,7 +501,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 
 out:
 
-	__putname(name);
+	kfree(name);
 	put_indx_node(node);
 
 	if (err == 1) {
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 5f138f7158357..bd67ba7b50153 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2627,7 +2627,7 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 	u32 uni_bytes;
 	struct ntfs_inode *ni = sbi->volume.ni;
 	/* Allocate PATH_MAX bytes. */
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 
 	if (!uni)
 		return -ENOMEM;
@@ -2671,6 +2671,6 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 		err = _ni_write_inode(&ni->vfs_inode, 0);
 
 out:
-	__putname(uni);
+	kfree(uni);
 	return err;
 }
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0a9ac5efeb67c..edfb973e4e82e 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1281,7 +1281,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	new_de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1702,7 +1702,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
-	__putname(new_de);
+	kfree(new_de);
 	kfree(rp);
 
 out1:
@@ -1723,7 +1723,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1737,7 +1737,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 
 	err = ni_add_name(ntfs_i(d_inode(dentry->d_parent)), ni, de);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -1760,8 +1760,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 	if (ntfs_is_meta_file(sbi, ni->mi.rno))
 		return -EINVAL;
 
-	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1797,7 +1796,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 
 out:
 	ni_unlock(ni);
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 3b24ca02de614..b2af8f695e60f 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -68,7 +68,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 				  u32 flags)
 {
 	struct ntfs_inode *ni = ntfs_i(dir);
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 	struct inode *inode;
 	int err;
 
@@ -85,7 +85,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-		__putname(uni);
+		kfree(uni);
 	}
 
 	/*
@@ -303,8 +303,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 			return err;
 	}
 
-	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -349,7 +348,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	ni_unlock(ni);
 	ni_unlock(dir_ni);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -407,7 +406,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -429,7 +428,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -468,7 +467,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -498,7 +497,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index c93df55e98d07..f3bb2c41c000f 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -556,8 +556,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(is_bad_ni(ni)))
 		return ERR_PTR(-EINVAL);
 
-	/* Allocate PATH_MAX bytes. */
-	buf = __getname();
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -588,7 +587,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 
-	__putname(buf);
+	kfree(buf);
 
 	return acl;
 }
-- 
2.51.0

