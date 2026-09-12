Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112283C1F46;
	Sat, 12 Sep 2026 09:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203986; cv=none; b=n+6+EqSSADr1bArk/PrZdcE2hENAsXsDXhDfKSeWdFcWLed37FbjuztQ10KgCa3e8yZKi7Qep9ZHL8aHC93hD5GP1YDxMHJ2gdAxUAHckxlCeH/NbOsXf0aZHg+01kaMTTw2464P4t4WnPsK8BBkJNv7/bssUNtEpp+/+xktTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203986; c=relaxed/simple;
	bh=b75QQ7vBm4arOJB4HYuKidsBBFBiRg/2uiTk48DfEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbSBB9KMDGe/2e1ji0wGkxknbu5vNcAnR7Sa6uY1g28jkRH+Rtm5TAEEKSE+CmHq+gI6ouZXD0QZ0/kGqS4+IpgdPM07EwmZ7gRSWabrziurTeppiYFK/cfzvZaE0A3c73sIk5SVUC7/LssH1jf/I8I0u2ZCpGFueRLQWUMPE4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLD7Qfg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLD7Qfg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ADB1F000FF;
	Sat, 12 Sep 2026 09:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203985;
	bh=B8b2ygzwl501GtdZR705hmBdt4gJXQNNa5MVQ6yzoQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLD7Qfg5igaGoLMdMexK4c+lb56wQ7jnUiWVUxIbODjcC7tZJYXX5WrPw/vnp9Mpe
	 URoP/QNiDFlYTaFDWHA6WnVmSxUlp8Hin3Vq7/SjRkiwHgwly+4gHhJVM9yTaRgNzH
	 nXiofpM9BKs8j+x6UO7vHokd4k3P6oY3abAkzOKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1521/1815] ksmbd: defer publishing granted locks to prevent UAF/double-free race
Date: Sat, 12 Sep 2026 08:54:31 +0200
Message-ID: <20260912065724.708253962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b8714628e1fc5..5e99c48fa0dc4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8845,16 +8845,10 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -8876,6 +8870,20 @@ int smb2_lock(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lock_rsp));
 	if (err)
 		goto out;
+
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
 	if (!lock_replayed)
 		smb2_update_lock_sequence(work, fp, req);
 
@@ -8906,15 +8914,6 @@ int smb2_lock(struct ksmbd_work *work)
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
 		locks_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
-- 
2.53.0



