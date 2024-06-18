Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC2D185E68;
	Tue, 18 Jun 2024 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715610; cv=none; b=J4q3Qd00nPiZ0/qPZFEH44DjmYz8WU7KSeCyp8/Uy1k2/xPBIojoo1l0XddOiv+yejkFJdBiARgQUdbAi2lrNUR8dPdRqUPTpudoDDcSBgmQ//dGi0SWhY7TIkMfqKfSG0vagq3KfDDBmRRvyfmTKwJYYagVxEedIB8e00c4qE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715610; c=relaxed/simple;
	bh=C8ICSqXCL6Th9dM0Pmt9lgeBfRIvz6eUQYzEjLJ8D4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYC1mSFGsVrQnBTaSqkz2TW6QkoSkArLW08UddIk1+Z2CpipiBT2jsk5HqMmVoWT9lqmeKSrsJp3lxyvmx7nPle6oBotPk8EeqQj2NOmt9LOngFpTuKziCRBOH3slAbrCIGSF98SOz3OOQsEhbelmT1F7qMfeX4huhcKVvlXOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5ED9DvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5ED9DvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1968CC3277B;
	Tue, 18 Jun 2024 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715609;
	bh=C8ICSqXCL6Th9dM0Pmt9lgeBfRIvz6eUQYzEjLJ8D4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5ED9DvCva4hzkYpPKMxE6ZyhXNjOyHP/xihpOzAKPvq9lZhxQspk/njMOEh5OQ2j
	 4UCtrQ2IDQf60OtF1idRNW1MaXlUgaOoC7BXtPml1y8wAzFmw5fOOLle7/RUHZkOd0
	 +vrfbUVJujTzq2O6YkJ5QJR9wy4xAs1K3aKeRpCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/770] fanotify: Split fsid check from other fid mode checks
Date: Tue, 18 Jun 2024 14:33:39 +0200
Message-ID: <20240618123421.396752258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 8299212cbdb01a5867e230e961f82e5c02a6de34 ]

FAN_FS_ERROR will require fsid, but not necessarily require the
filesystem to expose a file handle.  Split those checks into different
functions, so they can be used separately when setting up an event.

While there, update a comment about tmpfs having 0 fsid, which is no
longer true.

Link: https://lore.kernel.org/r/20211025192746.66445-7-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 846e2a661526c..6dd6a2e05f55d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1295,16 +1295,15 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	return fd;
 }
 
-/* Check if filesystem can encode a unique fid */
-static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
+static int fanotify_test_fsid(struct dentry *dentry, __kernel_fsid_t *fsid)
 {
 	__kernel_fsid_t root_fsid;
 	int err;
 
 	/*
-	 * Make sure path is not in filesystem with zero fsid (e.g. tmpfs).
+	 * Make sure dentry is not of a filesystem with zero fsid (e.g. fuse).
 	 */
-	err = vfs_get_fsid(path->dentry, fsid);
+	err = vfs_get_fsid(dentry, fsid);
 	if (err)
 		return err;
 
@@ -1312,10 +1311,10 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
 		return -ENODEV;
 
 	/*
-	 * Make sure path is not inside a filesystem subvolume (e.g. btrfs)
+	 * Make sure dentry is not of a filesystem subvolume (e.g. btrfs)
 	 * which uses a different fsid than sb root.
 	 */
-	err = vfs_get_fsid(path->dentry->d_sb->s_root, &root_fsid);
+	err = vfs_get_fsid(dentry->d_sb->s_root, &root_fsid);
 	if (err)
 		return err;
 
@@ -1323,6 +1322,12 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
 	    root_fsid.val[1] != fsid->val[1])
 		return -EXDEV;
 
+	return 0;
+}
+
+/* Check if filesystem can encode a unique fid */
+static int fanotify_test_fid(struct dentry *dentry)
+{
 	/*
 	 * We need to make sure that the file system supports at least
 	 * encoding a file handle so user can use name_to_handle_at() to
@@ -1330,8 +1335,8 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
 	 * objects. However, name_to_handle_at() requires that the
 	 * filesystem also supports decoding file handles.
 	 */
-	if (!path->dentry->d_sb->s_export_op ||
-	    !path->dentry->d_sb->s_export_op->fh_to_dentry)
+	if (!dentry->d_sb->s_export_op ||
+	    !dentry->d_sb->s_export_op->fh_to_dentry)
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -1500,7 +1505,11 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	}
 
 	if (fid_mode) {
-		ret = fanotify_test_fid(&path, &__fsid);
+		ret = fanotify_test_fsid(path.dentry, &__fsid);
+		if (ret)
+			goto path_put_and_out;
+
+		ret = fanotify_test_fid(path.dentry);
 		if (ret)
 			goto path_put_and_out;
 
-- 
2.43.0



