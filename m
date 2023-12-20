Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4620F48CD8;
	Wed, 20 Dec 2023 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pStGXRpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2892C433C7;
	Wed, 20 Dec 2023 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088999;
	bh=g6Ag4G7ibpkirfRl4Yx4G10d8Duqe5d2rm1Dgp3kFLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pStGXRpvUGeWdd/H7iDQS7zwNx/ei9Qc1KxwuHhxta5vfr5XlMkdrRwolGypZXGIk
	 aTjs+oqmez6L5IaxOSzIxbSEum4V+uhp4SJQ+sDV/+6oXGZnaVH+2UCFeDzH/WoOdd
	 quo5HirXTqYh1UNVl3V+EvaU4Jw3gw6ThJM/R0do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 134/159] ksmbd: fix race condition from parallel smb2 lock requests
Date: Wed, 20 Dec 2023 17:09:59 +0100
Message-ID: <20231220160937.581873917@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7040,10 +7040,6 @@ skip:
 
 				ksmbd_debug(SMB,
 					    "would have to wait for getting lock\n");
-				spin_lock(&work->conn->llist_lock);
-				list_add_tail(&smb_lock->clist,
-					      &work->conn->lock_list);
-				spin_unlock(&work->conn->llist_lock);
 				list_add(&smb_lock->llist, &rollback_list);
 
 				argv = kmalloc(sizeof(void *), GFP_KERNEL);
@@ -7075,9 +7071,6 @@ skip:
 
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
-					spin_lock(&work->conn->llist_lock);
-					list_del(&smb_lock->clist);
-					spin_unlock(&work->conn->llist_lock);
 					locks_free_lock(flock);
 
 					if (work->state == KSMBD_WORK_CANCELLED) {
@@ -7097,19 +7090,16 @@ skip:
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


