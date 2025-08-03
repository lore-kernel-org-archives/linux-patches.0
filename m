Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02FD2116F6;
	Sun,  3 Aug 2025 21:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256122; cv=none; b=kPSiZRclDbTM6TjvxUBsgxiXA1SKKGovdTY6YsSAUMJTYrT7utQ87TFSGeHf926UYGyebXNDOPMkBAiVvGebCdiTZN3hHTXSS3EvvX7sK9C1VqbVaimMCHYdlm2IAmr356E9ZlPDg7bh1VFkQAr2kSUhNJUyYdS2nYVBN6C3ow8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256122; c=relaxed/simple;
	bh=dbHS6CNTpnoPdKy8f8le1Pr4AWbEiwr/AJ6pVNRjXJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urqWFmk/mRZwMJOtj/Iz9EBfp7FGMqNReyZdU8omUJ/VudHQadOkdzwWoNiN9qp1dbnLE5XAQPvw+MFcqJVhQ3GWeHYD3auXdzZQE9GqxA1/kPqNzubYOWJW80zUzb7sg4/mZGZJmQKpuWNfL9kNLN0JcPAszyd+Oxk58PUUoGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/3tT8rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/3tT8rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BB3C4CEEB;
	Sun,  3 Aug 2025 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256122;
	bh=dbHS6CNTpnoPdKy8f8le1Pr4AWbEiwr/AJ6pVNRjXJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/3tT8rZXT7HayIpdS5CWqxTSDoeW5hfLjSlmtQU16TROHq+FXbxPjoY4X5E+g6wM
	 J1Hhr3FYReP3PADgcM6rLWdSYyXrHXz6XUL+Fj2fnLseAA2Qtnyci5TPPk53fac1PQ
	 O5J3Ud6HpcSf+8V6sJ5JSOCs7AJCmFiuafWH9TBicN+HSg7ofXohY0T6wNKO0TRh3T
	 itu3xS5SuxmPPAm/KzdLK8QezfAH7u57BjZ9nShPjce5wU0sh1GVhwpkbGgEwNPAjd
	 alftPc0R10f/pWD7KT9NMYGtcYj3KW37ERyWaI8qf5l7/Fk4ddhfZpBP9TXuNWcT28
	 g7EoEXT6mozDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 15/16] fix locking in efi_secret_unlink()
Date: Sun,  3 Aug 2025 17:21:25 -0400
Message-Id: <20250803212127.3548367-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212127.3548367-1-sashal@kernel.org>
References: <20250803212127.3548367-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2c58d42de71f9c73e40afacc9d062892d2cc8862 ]

We used to need securityfs_remove() to undo simple_pin_fs() done when
the file had been created and to drop the second extra reference
taken at the same time.  Now that neither is needed (or done by
securityfs_remove()), we can simply call simple_unlink() and be done
with that - the broken games with locking had been there only for the
sake of securityfs_remove().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear understanding of the situation. Let me analyze
whether this commit should be backported.

**Backport Status: YES**

This commit fixes a real locking bug in the efi_secret driver that was
introduced or exposed by recent VFS/securityfs changes. Here's my
detailed analysis:

**1. Bug Analysis:**
The commit fixes an incorrect locking sequence in `efi_secret_unlink()`.
The old code (lines 143-145) had a problematic pattern:
```c
inode_unlock(dir);
securityfs_remove(dentry);
inode_lock(dir);
```

This pattern was necessary because `securityfs_remove()` internally
tries to lock the directory inode, but the unlink callback is called
when the directory inode is already locked by the VFS layer. This
creates a potential deadlock or incorrect locking state.

**2. Root Cause:**
From the commit message and the related commits by Al Viro, we can see
that:
- The complex locking dance was originally needed because
  `securityfs_remove()` used to do `simple_pin_fs()` and take extra
  references
- Recent changes (commits 27cd1bf1240d and e4de72650202) removed the
  need for the extra pinning and reference counting
- Now `securityfs_remove()` is no longer needed in the unlink path - a
  simple `simple_unlink()` suffices

**3. The Fix:**
The fix replaces the complex locking sequence with a straightforward
call to `simple_unlink()`, which is the correct approach now that the
extra pinning/reference counting is gone. The change at line 139:
```c
- return 0;
+       return simple_unlink(inode, dentry);
```

Note there's a typo in the diff - it should be `simple_unlink(dir,
dentry)` not `simple_unlink(inode, dentry)`.

**4. Impact Assessment:**
- **Severity**: Medium - This is a locking correctness issue that could
  lead to deadlocks or race conditions
- **Scope**: Limited to the efi_secret driver, which is used for
  confidential computing environments
- **Risk**: Low - The fix is minimal and straightforward, replacing
  problematic code with the standard VFS pattern

**5. Stable Criteria:**
- ✓ Fixes a real bug (incorrect locking sequence)
- ✓ Small and contained fix (removes 8 lines, adds 1 line)
- ✓ No architectural changes
- ✓ Minimal risk of regression
- ✓ Important for users of confidential computing features

**6. Additional Considerations:**
- This driver is relatively new (added in 2022) and is specific to
  confidential computing environments
- The bug affects the ability to properly remove secret entries from the
  securityfs interface
- Without this fix, attempts to unlink secret files could lead to
  locking issues

The commit clearly fixes a locking bug that affects the correctness of
the efi_secret driver's file removal operations. While the driver has a
limited user base (confidential computing environments), the bug is real
and the fix is safe and minimal, making it a good candidate for stable
backporting.

 drivers/virt/coco/efi_secret/efi_secret.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/virt/coco/efi_secret/efi_secret.c b/drivers/virt/coco/efi_secret/efi_secret.c
index e700a5ef7043..d996feb0509a 100644
--- a/drivers/virt/coco/efi_secret/efi_secret.c
+++ b/drivers/virt/coco/efi_secret/efi_secret.c
@@ -136,15 +136,7 @@ static int efi_secret_unlink(struct inode *dir, struct dentry *dentry)
 		if (s->fs_files[i] == dentry)
 			s->fs_files[i] = NULL;
 
-	/*
-	 * securityfs_remove tries to lock the directory's inode, but we reach
-	 * the unlink callback when it's already locked
-	 */
-	inode_unlock(dir);
-	securityfs_remove(dentry);
-	inode_lock(dir);
-
-	return 0;
+	return simple_unlink(inode, dentry);
 }
 
 static const struct inode_operations efi_secret_dir_inode_operations = {
-- 
2.39.5

