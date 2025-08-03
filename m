Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D571F55FA;
	Sun,  3 Aug 2025 21:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256084; cv=none; b=tbnoSAgZxGa/5Kg3IK3rEW1Y6rfWrWUOoKcStRqdBVZtZDx3O5BijpTcRdyumdkVtDV+PsymP2fMzxbqc10fTuqyvL6616POnelC3n4ijQXYIBi8/59F4/iqRsmOXMrUUxpOKygLVa9ajrNIJhhyJ8pqOQhl36nga2zhtKqmdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256084; c=relaxed/simple;
	bh=Wjuh+88gIfpZbZvg0P+FC6E/yTVkpI+mgnaqh1NxZkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bFufm1VjBJkOUlf9Gmjkg3od0VHR1KBYzm+Jo7++l1g95lhWF69GslRv04Y67huaEr36expBMsoYoCLLzR8nTWlAvA2kaN3jhGdQqQBi9MMpEvsAWdoW9ywuAu7J5HbGkAUlu99+eLXBhmRAaYqsLv1srbtCAFhIdDm7x0cA5yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj8Qd/Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj8Qd/Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ED9C4CEF8;
	Sun,  3 Aug 2025 21:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256083;
	bh=Wjuh+88gIfpZbZvg0P+FC6E/yTVkpI+mgnaqh1NxZkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj8Qd/Xjlajv954bji5YCsh69Q8gJfCw/IFfn2H40G5G2SHdXBw/T/wNXInoBppeA
	 0bW8PXALvWaTmj1RqLaSY/c4Uqm1wUO00q+DyQktx8ol4A8Tysf0laLUkCh6WzTDn6
	 N6O9pnUsQvnPNGTVQkikvG80TwJCu04Dy0EATcJ5y91Vk9AcvhmdhWmqE2NjdF7GRu
	 U/6yjrxFKExqyBwzZfAfg+a+wAV4WZOs/CS7UF9p8GBo+spAWgHqzA/o7MWivy5188
	 /F0U4ZPOufpUVTDhl9GxG64tnB4ogbelp69JUd8aOpxuamQGek240sQXKSIYi0bYKH
	 sSblQm42rAbPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 22/23] securityfs: don't pin dentries twice, once is enough...
Date: Sun,  3 Aug 2025 17:20:29 -0400
Message-Id: <20250803212031.3547641-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 27cd1bf1240d482e4f02ca4f9812e748f3106e4f ]

incidentally, securityfs_recursive_remove() is broken without that -
it leaks dentries, since simple_recursive_removal() does not expect
anything of that sort.  It could be worked around by dput() in
remove_one() callback, but it's easier to just drop that double-get
stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear understanding of the issue. Let me analyze this:

**YES**

This commit should be backported to stable kernel trees. Here's the
extensive analysis:

## Analysis of the Double Dentry Reference Issue

The commit fixes a clear bug in securityfs where dentries are being
pinned twice:

1. **The Bug**: In `securityfs_create_dentry()` at line 162, there's a
   `dget(dentry)` call immediately after `d_instantiate(dentry, inode)`.
   This creates an extra reference count on the dentry that is never
   properly balanced.

2. **Impact on `securityfs_remove()`**: The traditional
   `securityfs_remove()` function does call `dput(dentry)` at line 309,
   which would balance the extra `dget()`. However, this only happens
   for the simple remove case.

3. **Critical Impact on `securityfs_recursive_remove()`**: The newly
   added `securityfs_recursive_remove()` function (added in commit
   7138679ff2a2) uses `simple_recursive_removal()` which expects normal
   dentry reference counting. The `simple_recursive_removal()` function
   in fs/libfs.c:
   - Takes its own reference with `dget(dentry)` at the beginning
   - Properly releases references with `dput()` calls throughout its
     execution
   - Does NOT expect the dentries to have extra references

4. **The Leak**: When `securityfs_recursive_remove()` is called, the
   extra reference from the `dget()` in `securityfs_create_dentry()` is
   never released because:
   - `simple_recursive_removal()` only releases the references it takes
   - The `remove_one()` callback only calls `simple_release_fs()` but
     doesn't do any `dput()`
   - This results in dentries being leaked with a refcount that never
     reaches zero

5. **Pattern Consistency**: Looking at similar filesystem
   implementations like debugfs (fs/debugfs/inode.c), they do NOT add an
   extra `dget()` after `d_instantiate()`. The pattern is simply:
  ```c
  d_instantiate(dentry, inode);
  return end_creating(dentry);
  ```
  No extra reference is taken.

6. **Backport Criteria Met**:
   - **Fixes a real bug**: Memory leak of dentries when using
     `securityfs_recursive_remove()`
   - **Small and contained**: Single-line removal in two locations
   - **No side effects**: Removing the extra `dget()` brings the code in
     line with standard VFS patterns
   - **Low regression risk**: The fix makes securityfs consistent with
     other similar filesystems
   - **Important for stability**: Memory leaks in kernel filesystem code
     can accumulate over time

The commit message clearly identifies this as a bug fix
("securityfs_recursive_remove() is broken without that - it leaks
dentries"), and the fix is minimal and correct. This makes it an ideal
candidate for stable backporting.

 security/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 3aa75fffa8c9..a90b043695d9 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -159,7 +159,6 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		inode->i_fop = fops;
 	}
 	d_instantiate(dentry, inode);
-	dget(dentry);
 	inode_unlock(dir);
 	return dentry;
 
@@ -306,7 +305,6 @@ void securityfs_remove(struct dentry *dentry)
 			simple_rmdir(dir, dentry);
 		else
 			simple_unlink(dir, dentry);
-		dput(dentry);
 	}
 	inode_unlock(dir);
 	simple_release_fs(&mount, &mount_count);
-- 
2.39.5

