Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2623A1A3B;
	Sat, 17 Oct 2026 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260002; cv=none; b=Uxv3wosLuGkoyjWqZXxuepXuBGZf2GXSUra/s3rz/NNW0YgmOoVnS5tquYpVWaeHkn3Vuac4COEykAN8BymyrbAJO08Shi7o/cbdXMN3a58NZh+ppvh29UuxQxw9J5unwd84YuFkFqJeXSLZR8sVnFv7yx8KmlaOzj7aBtXFDiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260002; c=relaxed/simple;
	bh=Df+o00c0JKmQ8HUobYMAclT0OVqH83PgAxDVTJj+Diw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwR7+YNG00oIED2G7QrGc2g0PMGzUulnIZz9N+1fZaEQTUjDSLPf03PTxYU9cxMx5vXA+8GwJa0IS+iKtBaBDYFDHg6Qk+F8ErcBT84G0QW6UXwzQB20KZN0/SGsTqEVoS3ms6OZ6hBQOiSemwi0dc8Ws4haeRTmwTh/E4SRh6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIjR2LGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIjR2LGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B011F000C4;
	Sat, 17 Oct 2026 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260001;
	bh=UayWH7ct45xnkiUtE1z0/KCpujQ8z29o8zzbYWlkStY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIjR2LGQLgquxKxFEUmKq2pMogMEpguwI1QAwc5nXDBAHPeKCxAMQb6NUiAGM4PQT
	 KeIc6Qi3iop/TitNMZZsFguMSOPmJvp3edgz+BRHnXhAv20nM3uhISQXeCJbNH8sbK
	 Klcl0VH1ekBgm/kFYNFGs/nz+k+uvh5KO3blRjFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1399/1674] ksmbd: defer publishing granted locks to prevent UAF/double-free race
Date: Sat, 17 Oct 2026 18:01:11 +0200
Message-ID: <20261017160507.086135958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Dudnik <ilan.dudnik@safebreach.com>

[ Upstream commit 29f74f0f2e6df3b393b7b66e810136d0c64e3c59 ]

In smb2_lock(), mid-batch granted locks are published to connection-wide
(conn->lock_list) and file-wide (fp->lock_list) lists immediately upon
vfs_lock_file() success, while also remaining tracked on the stack-local
rollback_list.

If a subsequent element in the same SMB2_LOCK request array fails
validation or execution, the thread jumps to out: and walks
rollback_list to undo previously granted locks. However, because the
granted lock was already published to conn->lock_list, a concurrent
UNLOCK request on the same connection can find the lock object and
kfree() it before the rollback loop executes.

When the granting thread subsequently walks rollback_list, it
dereferences and frees the already-freed ksmbd_lock structure, resulting
in a Use-After-Free and Double-Free (on both ksmbd_lock and struct
file_lock).

Fix this by deferring the publication of granted locks to
conn->lock_list and fp->lock_list until after the entire array of lock
elements has been processed without error. Mid-batch grants remain
tracked exclusively on the request-local rollback_list until the whole
batch succeeds, eliminating the race window.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Ilan Dudnik <ilan.dudnik@safebreach.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ac0cb1df9f440..a3e23eb59eaa9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7814,16 +7814,10 @@ int smb2_lock(struct ksmbd_work *work)
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);
-				goto out2;
+				/* rollback_list may still hold earlier grants */
+				goto out;
 			} else if (!rc) {
 				list_add(&smb_lock->llist, &rollback_list);
-				smb_lock->conn = ksmbd_conn_get(work->conn);
-				spin_lock(&work->conn->llist_lock);
-				list_add_tail(&smb_lock->clist,
-					      &work->conn->lock_list);
-				list_add_tail(&smb_lock->flist,
-					      &fp->lock_list);
-				spin_unlock(&work->conn->llist_lock);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
 				locks_free_lock(flock);
@@ -7845,6 +7839,19 @@ int smb2_lock(struct ksmbd_work *work)
 	if (err)
 		goto out;
 
+	/* publish only once the whole batch has committed */
+	if (!list_empty(&rollback_list)) {
+		spin_lock(&work->conn->llist_lock);
+		list_for_each_entry(smb_lock, &rollback_list, llist) {
+			smb_lock->conn = ksmbd_conn_get(work->conn);
+			list_add_tail(&smb_lock->clist,
+				      &work->conn->lock_list);
+			list_add_tail(&smb_lock->flist,
+				      &fp->lock_list);
+		}
+		spin_unlock(&work->conn->llist_lock);
+	}
+
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -7872,15 +7879,6 @@ int smb2_lock(struct ksmbd_work *work)
 		}
 
 		list_del(&smb_lock->llist);
-		conn = smb_lock->conn;
-		spin_lock(&conn->llist_lock);
-		if (!list_empty(&smb_lock->flist))
-			list_del(&smb_lock->flist);
-		list_del(&smb_lock->clist);
-		smb_lock->conn = NULL;
-		spin_unlock(&conn->llist_lock);
-		ksmbd_conn_put(conn);
-
 		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
-- 
2.53.0



