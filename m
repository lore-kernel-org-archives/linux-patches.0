Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC4158DC5;
	Mon,  6 Jan 2025 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177211; cv=none; b=R0NIwQE3RvXgp2PvhWk4EETTrhT0s6cWl37s+P0imwsaPpifBtmNCspE2qYVfBMn06FJWS1j7E7hj5TZGipfCsJznp2KFogr6dkl3ItPIbIPfmaTZ+ngy8M7nz0AUfaBIxdoi9eZVIj+r0mKz5LLi3nw3QPedTH8pEGH5xvmMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177211; c=relaxed/simple;
	bh=o70mBOTK0JbdTufP6KmqctYlmYzWb7Z6goAbFbZBxKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpnavUMZbBYW3iDeIJFIXB9YEfI84wyUDVtAg84dxi5pGTp6cMM8gcvX82amQiXNdZ5Lhn7j5XFSzZCA3NZM49HGt2PxnitqFTkCZl8MLRV/05wtG9in4uXZ4rojjcKgRfTJCjd90Q0pEsbbISfHLpdmdUDOCVQ3zTrDINT+pLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILfaoFsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILfaoFsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB938C4CED2;
	Mon,  6 Jan 2025 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177211;
	bh=o70mBOTK0JbdTufP6KmqctYlmYzWb7Z6goAbFbZBxKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILfaoFsOjO0hvQN9tmZaj6ngloqwz5rHkIdWvHUEJkvr+xDlnvjTy8pNEpD14hu72
	 dsvgJHyC9z6XJKuGE5lOKCbcQMmPQJKrlh5DROv/56DzaYjvWZZsRWjFgNJIGjomB0
	 ZXPL2pGLf7lCm6VwnrjofQ9CNb7HpXOUMnEjjMNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/222] udf_rename(): only access the child content on cross-directory rename
Date: Mon,  6 Jan 2025 16:14:51 +0100
Message-ID: <20250106151153.892518783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 9d35cebb794bb7be93db76c3383979c7deacfef9 ]

We can't really afford locking the source on same-directory rename;
currently vfs_rename() tries to do that, but it will have to be
changed.  The logics in udf_rename() is lazy and goes looking for
".." in source even in same-directory case.  It's not hard to get
rid of that, leaving that behaviour only for cross-directory case;
that VFS can get locks safely (and will keep doing that after the
coming changes).

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6756af923e06 ("udf: Verify inode link counts before performing rename")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index b3f57ad2b869..0461a7b1e9b4 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -770,7 +770,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
 	struct udf_fileident_iter oiter, niter, diriter;
-	bool has_diriter = false;
+	bool has_diriter = false, is_dir = false;
 	int retval;
 	struct kernel_lb_addr tloc;
 
@@ -793,6 +793,9 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			if (!empty_dir(new_inode))
 				goto out_oiter;
 		}
+		is_dir = true;
+	}
+	if (is_dir && old_dir != new_dir) {
 		retval = udf_fiiter_find_entry(old_inode, &dotdot_name,
 					       &diriter);
 		if (retval == -ENOENT) {
@@ -880,7 +883,9 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 					cpu_to_lelb(UDF_I(new_dir)->i_location);
 		udf_fiiter_write_fi(&diriter, NULL);
 		udf_fiiter_release(&diriter);
+	}
 
+	if (is_dir) {
 		inode_dec_link_count(old_dir);
 		if (new_inode)
 			inode_dec_link_count(new_inode);
-- 
2.39.5



