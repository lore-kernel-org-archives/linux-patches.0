Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE418207DE2;
	Sun,  3 Aug 2025 21:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256188; cv=none; b=UwYooMXdDxCqKlJiB5iMYUwh7ORRhQhwtRmdg79dPPNSJF3BYgNi7U45jBpChXe2jbCseXvT1+w95Pz5aH5JVt5zWiSoNAla5RXMWSK41HtYC2NgwjPg0UxcR9CZIE2z1Ia33VkBWHRYDHFDe53uQtzp6wncrj9mMBxD1QYGaFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256188; c=relaxed/simple;
	bh=ypW0rxu6CPke5sHwiG6FaiHwUEHIiqglPxR7OI4ZONk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEAZzr7SS1U5eRV4krs7uuRAYh9Dr5Pe56e7UtoTO78j3DEZMFmLQU81GUz2oGuwmcMZqsJTx+v2EO0PeOZp1xrCjpZ3iEDKqGteeeZbwARMXDBPY6ivAugnPUlVuF3aoDG1c6Apyn0g05dUdAOlm7atzkXK1FniVndpIi2esMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qh3cHfN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qh3cHfN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C901C4CEEB;
	Sun,  3 Aug 2025 21:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256188;
	bh=ypW0rxu6CPke5sHwiG6FaiHwUEHIiqglPxR7OI4ZONk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh3cHfN80s8GVViOxEyMwwf6PpCsiUsFwdxJmISH4ghyxrZuRPGeH4a1y8CWJpONz
	 /FNpWJ94uz2Zy5FbVIjDuySgDUU6yiAqTQ3mW69SOVMrPSD3orpb3XMKCrt3t7zQ2f
	 vcO+XZe+4538A3/fsIkZ2cno1eMFoiAfy/hMjKMyPVPk5xQPx+paU8nMrsSirdApZ6
	 f15Il9a+FUesXYiUsHACWyNAlkF8jX6j/Iai8p0yD+oOEq7sAx3lCezipExWcjkjj8
	 jqWYAqP7Y+E12R/MiOBXq69Nh7avbpwTORZQTaMJU452WkDdvc+/Zz+ZRaGeNdgMr5
	 Su7KLBtWQD4zQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/11] securityfs: don't pin dentries twice, once is enough...
Date: Sun,  3 Aug 2025 17:22:41 -0400
Message-Id: <20250803212242.3549318-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212242.3549318-1-sashal@kernel.org>
References: <20250803212242.3549318-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
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
index 6c326939750d..e6e07787eec9 100644
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

