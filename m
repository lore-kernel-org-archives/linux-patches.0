Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45746E00B;
	Tue, 21 Jul 2026 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659522; cv=none; b=TDGQ7X3fjMg/XQgH+6gp3WCLCW3ITqGzprxtatSUUuPEvlCCubdDTFPV4Oe5/uCAPz8Ufe3FkO5YvJd5w+2Mxr7i3EEal4DUtgwgBuGkpuZ1iSf44qop2NDFK7wUoz3nJhaj5JlCp1QdFSHPwtNCMECV/6xkufy77YM9N2ztRPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659522; c=relaxed/simple;
	bh=6fsorrEjUbYg/l/tfgv8E0HSy5Xd2QsGCspHVIaBE8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyTLRbfdBuKcDjdQqddPLje4hGbBZ5sxSDBwNsJsPvEAnCQoHrsyClzCJq2Dw0WyOUzYC03KK/HSfSI2j5/JIzkh6TTLPCW3SXRvVGimqLdx8n/QaoFFEl84RKBkeFcvKTfTsGKCSWY6TYaQ+zJ1NkbXkniH0uQJzljtCnIfciE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzVlupa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzVlupa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D52E1F00A3D;
	Tue, 21 Jul 2026 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659520;
	bh=y7pXRF7JPoudWl9RJb6qxfD8eVy193ZYKR6d8ckU+8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzVlupa7dYyhcSDE90uyGFlvLcfQg1bWMuk9qirmNvAvM6Pj4aMEGagmrcnq3rKrP
	 bkYq84FBKxDvqv0j/h4nodcjkSrQRAtBB3tJHVJXKIULVZCmKz5cnP+4VhSmGGq0IY
	 HyaPe//3N3YmW3N8xM+JAPfD6Hd4b6z5qqsXQfVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1552/1611] ksmbd: track the connection owning a byte-range lock
Date: Tue, 21 Jul 2026 17:27:48 +0200
Message-ID: <20260721152550.363936239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c1016dd1d8b2bcd1158bbaabe94a31bb7e7431fb ]

SMB2_LOCK adds each granted byte-range lock to both the file lock list
and the lock list of the connection which handled the request.  The
final close and durable handle paths, however, remove the connection
list entry while holding fp->conn->llist_lock.

With SMB3 multichannel, the connection handling the LOCK request can be
different from the connection which opened the file.  The entry can
therefore be removed under a different spinlock from the one protecting
the list it belongs to.  A concurrent traversal can then access freed
struct ksmbd_lock and struct file_lock objects.

Record the connection owning each lock's clist entry and hold a
reference to it while the entry is linked.  Use that connection and its
llist_lock for unlock, rollback, close, and durable preserve.  Durable
reconnect assigns the new connection as the owner when publishing the
locks again.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c   |   10 ++++++++--
 fs/smb/server/vfs_cache.c |   23 +++++++++++++++++------
 fs/smb/server/vfs_cache.h |    1 +
 3 files changed, 26 insertions(+), 8 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7660,9 +7660,11 @@ int smb2_lock(struct ksmbd_work *work)
 						nolock = 0;
 						list_del(&cmp_lock->flist);
 						list_del(&cmp_lock->clist);
+						cmp_lock->conn = NULL;
 						spin_unlock(&conn->llist_lock);
 						up_read(&conn_list_lock);
 
+						ksmbd_conn_put(conn);
 						locks_free_lock(cmp_lock->fl);
 						kfree(cmp_lock);
 						goto out_check_cl;
@@ -7797,6 +7799,7 @@ skip:
 				goto out2;
 			} else if (!rc) {
 				list_add(&smb_lock->llist, &rollback_list);
+				smb_lock->conn = ksmbd_conn_get(work->conn);
 				spin_lock(&work->conn->llist_lock);
 				list_add_tail(&smb_lock->clist,
 					      &work->conn->lock_list);
@@ -7851,11 +7854,14 @@ out:
 		}
 
 		list_del(&smb_lock->llist);
-		spin_lock(&work->conn->llist_lock);
+		conn = smb_lock->conn;
+		spin_lock(&conn->llist_lock);
 		if (!list_empty(&smb_lock->flist))
 			list_del(&smb_lock->flist);
 		list_del(&smb_lock->clist);
-		spin_unlock(&work->conn->llist_lock);
+		smb_lock->conn = NULL;
+		spin_unlock(&conn->llist_lock);
+		ksmbd_conn_put(conn);
 
 		locks_free_lock(smb_lock->fl);
 		if (rlock)
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -391,10 +391,14 @@ static void __ksmbd_close_fd(struct ksmb
 	 * there are not accesses to fp->lock_list.
 	 */
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		if (!list_empty(&smb_lock->clist) && fp->conn) {
-			spin_lock(&fp->conn->llist_lock);
-			list_del(&smb_lock->clist);
-			spin_unlock(&fp->conn->llist_lock);
+		struct ksmbd_conn *conn = smb_lock->conn;
+
+		if (conn) {
+			spin_lock(&conn->llist_lock);
+			list_del_init(&smb_lock->clist);
+			smb_lock->conn = NULL;
+			spin_unlock(&conn->llist_lock);
+			ksmbd_conn_put(conn);
 		}
 
 		list_del(&smb_lock->flist);
@@ -1086,9 +1090,15 @@ static bool session_fd_check(struct ksmb
 	up_write(&ci->m_lock);
 
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		spin_lock(&conn->llist_lock);
+		struct ksmbd_conn *lock_conn = smb_lock->conn;
+
+		if (!lock_conn)
+			continue;
+		spin_lock(&lock_conn->llist_lock);
 		list_del_init(&smb_lock->clist);
-		spin_unlock(&conn->llist_lock);
+		smb_lock->conn = NULL;
+		spin_unlock(&lock_conn->llist_lock);
+		ksmbd_conn_put(lock_conn);
 	}
 
 	fp->conn = NULL;
@@ -1209,6 +1219,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	}
 
 	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
+		smb_lock->conn = ksmbd_conn_get(conn);
 		spin_lock(&conn->llist_lock);
 		list_add_tail(&smb_lock->clist, &conn->lock_list);
 		spin_unlock(&conn->llist_lock);
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -32,6 +32,7 @@ struct ksmbd_session;
 
 struct ksmbd_lock {
 	struct file_lock *fl;
+	struct ksmbd_conn *conn;
 	struct list_head clist;
 	struct list_head flist;
 	struct list_head llist;


