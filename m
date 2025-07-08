Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A7D1754B;
	Tue,  8 Jul 2025 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993303; cv=none; b=OkwtR+5yp0a2W/ZR/XIr3pkjd5kKB7nWyJ/Bu2RdhfUGs6Y+9YsPgZq6TJiQ1I5BYSub3vThZ4UfMwHHsN0lHPVj/cGKQIN12HE2UJvVh1Iw/wqkuA6jSYppXX6zkUljubSepzHFFCc1m4c85SCMwJ+/nUXrF8nH+FIBGYVoPEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993303; c=relaxed/simple;
	bh=fFGzvZ8o8iHs6Ar3bzxukvHxVGgDoUKunaQz6dPSxY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsJcSYPSUNmRmnLHDoejokG+GAFXTeDTrzNqNuuiNWZ2Ga9IGFJNz2rcZkp7q0pLVdt30aU899S8LsN5Zo4tXJC9AUW9n4DGEyMNwD4XIB2syK01JYo7WewskeaAKziiV0msygklpZxP4bo7kjrIbSpJG7+XrDNHXuzDS+5I23o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmdwAuEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmdwAuEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC989C4CEED;
	Tue,  8 Jul 2025 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993303;
	bh=fFGzvZ8o8iHs6Ar3bzxukvHxVGgDoUKunaQz6dPSxY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmdwAuEcK90zfX/ANVUv5d5WCXJkIkN6Gw1CM8lwCa5cj/oZien3qC/ZhayVI+2hM
	 YiUCeWwH90/b3Rq2L/0ZHNS3Oh3goGIKim4tgWqrp5ueYUunDnddVmVdBAh8ow4sB4
	 V+hDp4tQqHWiHFSdWOTMjDVjHQpey5aYcO6SOJjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	stable@kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 027/178] anon_inode: rework assertions
Date: Tue,  8 Jul 2025 18:21:04 +0200
Message-ID: <20250708162237.258186480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 1e7ab6f67824343ee3e96f100f0937c393749a8a upstream.

Making anonymous inodes regular files comes with a lot of risk and
regression potential as evidenced by a recent hickup in io_uring. We're
better of continuing to not have them be regular files. Since we have
S_ANON_INODE we can port all of our assertions easily.

Link: https://lore.kernel.org/20250702-work-fixes-v1-1-ff76ea589e33@kernel.org
Fixes: cfd86ef7e8e7 ("anon_inode: use a proper mode internally")
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@kernel.org
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c  |    9 +++++++--
 fs/libfs.c |    8 +++-----
 fs/namei.c |    2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -111,6 +111,9 @@ static inline void put_binfmt(struct lin
 
 bool path_noexec(const struct path *path)
 {
+	/* If it's an anonymous inode make sure that we catch any shenanigans. */
+	VFS_WARN_ON_ONCE(IS_ANON_FILE(d_inode(path->dentry)) &&
+			 !(path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC));
 	return (path->mnt->mnt_flags & MNT_NOEXEC) ||
 	       (path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC);
 }
@@ -894,13 +897,15 @@ static struct file *do_open_execat(int f
 	if (IS_ERR(file))
 		return file;
 
+	if (path_noexec(&file->f_path))
+		return ERR_PTR(-EACCES);
+
 	/*
 	 * In the past the regular type check was here. It moved to may_open() in
 	 * 633fb6ac3980 ("exec: move S_ISREG() check earlier"). Since then it is
 	 * an invariant that all non-regular files error out before we get here.
 	 */
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
-	    path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
 		return ERR_PTR(-EACCES);
 
 	err = exe_file_deny_write_access(file);
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1648,12 +1648,10 @@ struct inode *alloc_anon_inode(struct su
 	 */
 	inode->i_state = I_DIRTY;
 	/*
-	 * Historically anonymous inodes didn't have a type at all and
-	 * userspace has come to rely on this. Internally they're just
-	 * regular files but S_IFREG is masked off when reporting
-	 * information to userspace.
+	 * Historically anonymous inodes don't have a type at all and
+	 * userspace has come to rely on this.
 	 */
-	inode->i_mode = S_IFREG | S_IRUSR | S_IWUSR;
+	inode->i_mode = S_IRUSR | S_IWUSR;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 	inode->i_flags |= S_PRIVATE | S_ANON_INODE;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3464,7 +3464,7 @@ static int may_open(struct mnt_idmap *id
 			return -EACCES;
 		break;
 	default:
-		VFS_BUG_ON_INODE(1, inode);
+		VFS_BUG_ON_INODE(!IS_ANON_FILE(inode), inode);
 	}
 
 	error = inode_permission(idmap, inode, MAY_OPEN | acc_mode);


