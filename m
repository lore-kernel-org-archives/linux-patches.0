Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C28D377A92;
	Sat, 17 Oct 2026 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254969; cv=none; b=l22HuOgy5kHSInRhKCT/ufHfu9434ofyxebL8Qb5se2X8mNZ42iz875fWx2ufyZFRxrqdOl2zU3+VUeu5SIMTooviRjGimdKt2rdt/JFMNqRs3/fHtyv+hjmaaMJ5P58rgBx+BljJJvoUPO7uUibfZHStR1c+xfR7fhBZtsmYDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254969; c=relaxed/simple;
	bh=WfJbDqUxkv15YooguqNnU1aTFcpRPZc0Ei0haZ9vJN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7srcxkAjNHzlAh1q+CNgwN46CuXOZOFThBTJVLgJzvE1gFVKwX1TjbI/lliEU0dfAYUtV6y+UJCDSb7tPLHUSFk6hx7orV5WDeJNeT954prcmfafKDayq+kZHQTzY/Nzgo/qlnZTvMPaLgM0zIGMyHR+5W3sLA57Q2l+7xb8Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfO4lGX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfO4lGX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D421F000C4;
	Sat, 17 Oct 2026 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254967;
	bh=2JEV0wU2C7wzIIq+hglrTfniIKWwLkNtUezG5nfc0Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfO4lGX50uU5TQ/U41NyNjRDNWYomAPpjFwnfzYX42LDc/5QhCZYrKx8Lo5mD/rGR
	 hSLEhCtttvXEpyR4tmprN74IAns5EeGQbfd30SxX7so1Ms34JK0M8s4hxN0ScjwPKc
	 Yszp8Qxkm8L+6tEYUd29+c4D3g/EXVR/Bwkn/oVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 622/869] ksmbd: defer publishing granted locks to prevent UAF/double-free race
Date: Sat, 17 Oct 2026 17:57:43 +0200
Message-ID: <20261017160052.977152887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 951d3c4f861c4..e46b58a768c5d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7825,16 +7825,10 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -7856,6 +7850,19 @@ int smb2_lock(struct ksmbd_work *work)
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
 
@@ -7883,15 +7890,6 @@ int smb2_lock(struct ksmbd_work *work)
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



