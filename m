Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16BD9460;
	Mon, 29 Dec 2025 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024963; cv=none; b=NA64gN6QIUo1FcFNzXR1l3WQTkb+eVDDuUBmlEjM5Vlt+ba2xua8KyUY43KHb1Fp3HJQZN5a5hiWXKKMqtxLj+Hwj06j7rk+ZrA1Ipyaj93aHM9V0bGoBpzYGz3/7rkLkhTnMeorS18cOFFtDGmFd9BnZAZ7QMdwd0Qv0iW2ItE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024963; c=relaxed/simple;
	bh=j1Ywu3N2TJKTt+58cZIsiFB7/zz5KkrUq1GNi0GCQKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYMYvqK/cMuPQvhcqhhWLYVHHSTfI+lkGRdmWKgOYqqRP5hdnJB3JuYLCbRDliWeolT73Es+HynKmdrvJZGRm7LRLKZkPxks/CVvDuHL3tyBgvj4f5Hk4Wnni3yI+79qOrnUiLCs+kJgbNX+aSc1xWC02fkNm2RvOACTzPs1Fp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smFNP22p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smFNP22p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF0C4CEF7;
	Mon, 29 Dec 2025 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024962;
	bh=j1Ywu3N2TJKTt+58cZIsiFB7/zz5KkrUq1GNi0GCQKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smFNP22pqDlO06WbMm1/PlEQk39cyJt82iz0r1ldw9olmZvUqMmqd5KVPPbdYTD0B
	 kPkB0TVZG6YhW1Cj/pnZHFLTyKnZ+eIqBiNAFpqb4kdXqMSGk8xvuZ1t2OEYA5TA1Q
	 csm1j/CEsOqd0Y7fvb3pyiLgIkdCd1TXOgDz8YW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/430] ksmbd: vfs: fix race on m_flags in vfs_cache
Date: Mon, 29 Dec 2025 17:07:27 +0100
Message-ID: <20251229160726.025276596@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianchang Zhao <pioooooooooip@gmail.com>

[ Upstream commit 991f8a79db99b14c48d20d2052c82d65b9186cad ]

ksmbd maintains delete-on-close and pending-delete state in
ksmbd_inode->m_flags. In vfs_cache.c this field is accessed under
inconsistent locking: some paths read and modify m_flags under
ci->m_lock while others do so without taking the lock at all.

Examples:

 - ksmbd_query_inode_status() and __ksmbd_inode_close() use
   ci->m_lock when checking or updating m_flags.
 - ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete() and ksmbd_fd_set_delete_on_close()
   used to read and modify m_flags without ci->m_lock.

This creates a potential data race on m_flags when multiple threads
open, close and delete the same file concurrently. In the worst case
delete-on-close and pending-delete bits can be lost or observed in an
inconsistent state, leading to confusing delete semantics (files that
stay on disk after delete-on-close, or files that disappear while still
in use).

Fix it by:

 - Making ksmbd_query_inode_status() look at m_flags under ci->m_lock
   after dropping inode_hash_lock.
 - Adding ci->m_lock protection to all helpers that read or modify
   m_flags (ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete(), ksmbd_fd_set_delete_on_close()).
 - Keeping the existing ci->m_lock protection in __ksmbd_inode_close(),
   and moving the actual unlink/xattr removal outside the lock.

This unifies the locking around m_flags and removes the data race while
preserving the existing delete-on-close behaviour.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 88 +++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce89049..6ef116585af64 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -112,40 +112,62 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 
 	read_lock(&inode_hash_lock);
 	ci = __ksmbd_inode_lookup(dentry);
-	if (ci) {
-		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
-			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
-		atomic_dec(&ci->m_count);
-	}
 	read_unlock(&inode_hash_lock);
+	if (!ci)
+		return ret;
+
+	down_read(&ci->m_lock);
+	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
+	else
+		ret = KSMBD_INODE_STATUS_OK;
+	up_read(&ci->m_lock);
+
+	atomic_dec(&ci->m_count);
 	return ret;
 }
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	struct ksmbd_inode *ci = fp->f_ci;
+	int ret;
+
+	down_read(&ci->m_lock);
+	ret = (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	up_read(&ci->m_lock);
+
+	return ret;
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags |= S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	down_write(&ci->m_lock);
+	ci->m_flags |= S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags &= ~S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	down_write(&ci->m_lock);
+	ci->m_flags &= ~S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
 void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 				  int file_info)
 {
-	if (ksmbd_stream_fd(fp)) {
-		fp->f_ci->m_flags |= S_DEL_ON_CLS_STREAM;
-		return;
-	}
+	struct ksmbd_inode *ci = fp->f_ci;
 
-	fp->f_ci->m_flags |= S_DEL_ON_CLS;
+	down_write(&ci->m_lock);
+	if (ksmbd_stream_fd(fp))
+		ci->m_flags |= S_DEL_ON_CLS_STREAM;
+	else
+		ci->m_flags |= S_DEL_ON_CLS;
+	up_write(&ci->m_lock);
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -257,27 +279,41 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	struct file *filp;
 
 	filp = fp->filp;
-	if (ksmbd_stream_fd(fp) && (ci->m_flags & S_DEL_ON_CLS_STREAM)) {
-		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
-		err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
-					     &filp->f_path,
-					     fp->stream.name,
-					     true);
-		if (err)
-			pr_err("remove xattr failed : %s\n",
-			       fp->stream.name);
+
+	if (ksmbd_stream_fd(fp)) {
+		bool remove_stream_xattr = false;
+
+		down_write(&ci->m_lock);
+		if (ci->m_flags & S_DEL_ON_CLS_STREAM) {
+			ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
+			remove_stream_xattr = true;
+		}
+		up_write(&ci->m_lock);
+
+		if (remove_stream_xattr) {
+			err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
+						     &filp->f_path,
+						     fp->stream.name,
+						     true);
+			if (err)
+				pr_err("remove xattr failed : %s\n",
+				       fp->stream.name);
+		}
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
+		bool do_unlink = false;
+
 		down_write(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			up_write(&ci->m_lock);
-			ksmbd_vfs_unlink(filp);
-			down_write(&ci->m_lock);
+			do_unlink = true;
 		}
 		up_write(&ci->m_lock);
 
+		if (do_unlink)
+			ksmbd_vfs_unlink(filp);
+
 		ksmbd_inode_free(ci);
 	}
 }
-- 
2.51.0



