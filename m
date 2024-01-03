Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9BA1C698;
	Wed,  3 Jan 2024 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIBJ8dc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9520C433C8;
	Wed,  3 Jan 2024 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301240;
	bh=hnz082Mm9Qypwkc3zmZgpxJ0SSClDk+qvR1QJnVaCJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIBJ8dc2NS6dGC5MheuyaIyjuO13lxF8SekqVv+ggDfANgtotjJq83TTOeLF8QE4l
	 6RfJ/BB0qGRrjttwX+J4Jpa8gbkS0Di71JZ9jeojdOhl/DE5mYSLkvPTb6SbyIwDBn
	 AuKDp1K2p0hVWsT+Y0oWqqOTg+OJ7qEqXPj+JLjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/100] ksmbd: fix race condition from parallel smb2 lock requests
Date: Wed,  3 Jan 2024 17:54:36 +0100
Message-ID: <20240103164903.119983473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 75ac9a3dd65f7eab4d12b0a0f744234b5300a491 ]

There is a race condition issue between parallel smb2 lock request.

                                            Time
                                             +
Thread A                                     | Thread A
smb2_lock                                    | smb2_lock
                                             |
 insert smb_lock to lock_list                |
 spin_unlock(&work->conn->llist_lock)        |
                                             |
                                             |   spin_lock(&conn->llist_lock);
                                             |   kfree(cmp_lock);
                                             |
 // UAF!                                     |
 list_add(&smb_lock->llist, &rollback_list)  +

This patch swaps the line for adding the smb lock to the rollback list and
adding the lock list of connection to fix the race issue.

Reported-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e8c779fa354ca..a76529512acfb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7038,10 +7038,6 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_debug(SMB,
 					    "would have to wait for getting lock\n");
-				spin_lock(&work->conn->llist_lock);
-				list_add_tail(&smb_lock->clist,
-					      &work->conn->lock_list);
-				spin_unlock(&work->conn->llist_lock);
 				list_add(&smb_lock->llist, &rollback_list);
 
 				argv = kmalloc(sizeof(void *), GFP_KERNEL);
@@ -7073,9 +7069,6 @@ int smb2_lock(struct ksmbd_work *work)
 
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
-					spin_lock(&work->conn->llist_lock);
-					list_del(&smb_lock->clist);
-					spin_unlock(&work->conn->llist_lock);
 					locks_free_lock(flock);
 
 					if (work->state == KSMBD_WORK_CANCELLED) {
@@ -7095,19 +7088,16 @@ int smb2_lock(struct ksmbd_work *work)
 				}
 
 				list_del(&smb_lock->llist);
-				spin_lock(&work->conn->llist_lock);
-				list_del(&smb_lock->clist);
-				spin_unlock(&work->conn->llist_lock);
 				release_async_work(work);
 				goto retry;
 			} else if (!rc) {
+				list_add(&smb_lock->llist, &rollback_list);
 				spin_lock(&work->conn->llist_lock);
 				list_add_tail(&smb_lock->clist,
 					      &work->conn->lock_list);
 				list_add_tail(&smb_lock->flist,
 					      &fp->lock_list);
 				spin_unlock(&work->conn->llist_lock);
-				list_add(&smb_lock->llist, &rollback_list);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
 				goto out;
-- 
2.43.0



