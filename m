Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EC782D62;
	Mon,  8 Apr 2024 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582728; cv=none; b=VpfW/Fr9L3siOjWMWiNoEMcIrEA/xDiTzCCdQ4iMHgDp716bHmUINwng5tSPBxg0InEflpUtRTB+z1iIZwSBhWWbhIUjQ/Pxjs1g0RsN+JIZ+lg0mn46MnjsRV3xGDfw3xvobr6CGz6jFtLvH6WLkdzxYQB28hCd5ofL4wrsAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582728; c=relaxed/simple;
	bh=kWTC9hWVLwjHPH6+Uq5I0/DyGz+ksvnMPs94yirdalU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiQ+Yh8qZNEvj8r1HysqnSSuU1kOrEZvtZeMT3KFX4RWUBu8LrObE2uN+j8VMsJXz32uwwj78qJUltMg35iNSQlRd4T1NaVPImCrWHDoHO60/FWVjMiAe4poHdMF2B2iqdFGyt0Nj96/uy0AAl3iqXJXij9FUFLNOKW+NOsDrS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx0AA4cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx0AA4cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A1EC433F1;
	Mon,  8 Apr 2024 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582728;
	bh=kWTC9hWVLwjHPH6+Uq5I0/DyGz+ksvnMPs94yirdalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx0AA4cM04F6jFEBJxNppwhWnzl2xW0FA6Hcde30EjUNqlg1/5Xg79/0/QyGyHLmj
	 4x3Bb5IQp/L0y9lKh9baashYwV8RQVZrG9xb7b8sjM8+Axhd8z5vimJH8B8Y2cYerf
	 KeH6m8HsWng7QYd09RXKy7+0fcWtMhzKy2sjZ3S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 171/690] fanotify: Split fsid check from other fid mode checks
Date: Mon,  8 Apr 2024 14:50:37 +0200
Message-ID: <20240408125405.759940555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/notify/fanotify/fanotify_user.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 20b743b05b997..8cf8e63a2c3e8 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1300,16 +1300,15 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
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
 
@@ -1317,10 +1316,10 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
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
 
@@ -1328,6 +1327,12 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
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
@@ -1335,8 +1340,8 @@ static int fanotify_test_fid(struct path *path, __kernel_fsid_t *fsid)
 	 * objects. However, name_to_handle_at() requires that the
 	 * filesystem also supports decoding file handles.
 	 */
-	if (!path->dentry->d_sb->s_export_op ||
-	    !path->dentry->d_sb->s_export_op->fh_to_dentry)
+	if (!dentry->d_sb->s_export_op ||
+	    !dentry->d_sb->s_export_op->fh_to_dentry)
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -1505,7 +1510,11 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
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



