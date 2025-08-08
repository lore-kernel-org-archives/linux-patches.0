Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711AC25228C;
	Fri,  8 Aug 2025 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754674911; cv=none; b=u1Ssi5yGrlime1r2f1dKd4B3fpejZ1r4U7hEhCASPUhn2037tU7qQVDmWi0zCSaEBD0k2x6Cybpjqid9foPSPXFiYXGZftBaNqQGwDngvBsLDkXRGuteb7EtdKm3Fnmacn2s6y/xPrtYQbMeMkhY8Grhs239I+G7yRIodabEtDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754674911; c=relaxed/simple;
	bh=Szj//6lRoAJz5KpkNcWdWUHudsh4GXZI9PjVTU1aEUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mGnUoou7/ETV2cQITDDNyyUkeGlfHpWEZQy5btbNFE5KEjn/4zp7Oe5+jWDufnYNIIrQaowByB2+++NbSK1kT2WiuvyC98ghiMdUBKchnb+05cssnOVPkLhdc7JnKiVsXtNcK5cAP1eA5mL9T4Ysuuy475Jtyd8L/aRqsy1lsdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cukuPMnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cukuPMnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D722DC4CEED;
	Fri,  8 Aug 2025 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754674911;
	bh=Szj//6lRoAJz5KpkNcWdWUHudsh4GXZI9PjVTU1aEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cukuPMnI9/XAuBCgrCpIcK2Annyx0jIxGdiFJTOjlvFuBJBT327YxJ258fhV+NMSL
	 0CfDX+TRxWg3SoGg/THFeyDgD+tx8KQKi9yKgKy1PDcGMPPlkOWzoSomWzTBQ6FGmm
	 OEcjGbs6zptuZpiwq3GHaNFZePYx/hVFUGz35bwv+Csz2z5MhHG1eKlFBb2xMShbzx
	 27MiIBykscQ9BSyvZnJUxDzJItKmhJZSqnif8nSNqMnL3IZ7j3HH9M1mhns0B5clIG
	 uWvpW/vpR0HpO966OUxRbNO84UEmNkY5y5p6wa+EWCXKkxeboH1oUyYRyvyTdMAx23
	 Q6t8rLpvU9mxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.16-6.6] f2fs: check the generic conditions first
Date: Fri,  8 Aug 2025 13:41:42 -0400
Message-Id: <20250808174146.1272242-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808174146.1272242-1-sashal@kernel.org>
References: <20250808174146.1272242-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit e23ab8028de0d92df5921a570f5212c0370db3b5 ]

Let's return errors caught by the generic checks. This fixes generic/494 where
it expects to see EBUSY by setattr_prepare instead of EINVAL by f2fs for active
swapfile.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Fixes a real bug affecting users**: The commit fixes incorrect
   error code handling for swapfiles. When attempting to modify an
   active swapfile, f2fs was returning `-EINVAL` instead of the correct
   `-EBUSY` error code. This breaks userspace expectations and causes
   test failures in `generic/494`.

2. **Small and contained fix**: The change is minimal - it simply
   reorders the error checking sequence in `f2fs_setattr()` to call
   generic checks (`setattr_prepare`, `fscrypt_prepare_setattr`,
   `fsverity_prepare_setattr`) before f2fs-specific checks. The code
   movement involves only 12 lines being relocated within the same
   function.

## Technical Details

The commit moves three generic preparation calls from lines 1055-1065
(after f2fs-specific checks) to lines 1055-1065 (before f2fs-specific
checks). This ensures that:

- `setattr_prepare()` gets called first, which contains the
  `IS_SWAPFILE()` check that returns `-ETXTBSY` (which gets translated
  to `-EBUSY`)
- The generic VFS layer error codes are returned consistently with other
  filesystems
- F2fs-specific validation (like compression, pinned file checks) only
  happens after generic validation passes

## Risk Assessment

1. **Minimal regression risk**: The change only reorders existing checks
   without adding new logic or modifying the checks themselves. All the
   same validation still occurs, just in a different order.

2. **Follows stable tree rules**: This is a clear bugfix that:
   - Fixes incorrect error reporting to userspace
   - Makes f2fs behavior consistent with VFS expectations
   - Fixes a specific test case (`generic/494`) that validates correct
     swapfile handling
   - Has no feature additions or architectural changes

3. **Limited scope**: The change is confined to a single function in the
   f2fs subsystem and doesn't affect any other kernel components.

4. **Already reviewed**: The commit has been reviewed by a subsystem
   maintainer (Chao Yu) and merged by the f2fs maintainer (Jaegeuk Kim).

The incorrect error code could potentially confuse userspace
applications that rely on specific error codes to determine why an
operation failed. Returning `-EINVAL` (invalid argument) instead of
`-EBUSY` (resource busy) for an active swapfile is semantically
incorrect and breaks POSIX compliance expectations.

 fs/f2fs/file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 696131e655ed..bb3fd6a8416f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1047,6 +1047,18 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
+	err = setattr_prepare(idmap, dentry, attr);
+	if (err)
+		return err;
+
+	err = fscrypt_prepare_setattr(dentry, attr);
+	if (err)
+		return err;
+
+	err = fsverity_prepare_setattr(dentry, attr);
+	if (err)
+		return err;
+
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1065,18 +1077,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			return -EINVAL;
 	}
 
-	err = setattr_prepare(idmap, dentry, attr);
-	if (err)
-		return err;
-
-	err = fscrypt_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
-	err = fsverity_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
 	if (is_quota_modification(idmap, inode, attr)) {
 		err = f2fs_dquot_initialize(inode);
 		if (err)
-- 
2.39.5

