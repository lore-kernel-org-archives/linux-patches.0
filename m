Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E53C1988;
	Tue,  3 Feb 2026 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134410; cv=none; b=ZHtwu1gExCYrSFkkyXXfWLAgtAAiJTlyHcycRAwKp/wpGKFBlnJiUJl2mgXuVTU9XdGWWOxfuHW/FhUAtx/77U2+1k1GGOUGEPVtqiOmF7BqzauxsuISuekXRLyP6s3OTQjHy1nSs9Dh+DTgHWVU8mBLt4ChvxLuL+0h6l+rmQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134410; c=relaxed/simple;
	bh=LoLt3v0dhdP4FPlor9Yj0E9wWO56b//9KaBP2kyWPgY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=WqaB5ePXJeyyChXazIjXXEvNKZPZ65G/hbIZZ4CbyRnXDiAs4kixjdBXVwrF5x9YxH9YZzJEOxHb8TR+sxZMdwyVjquvuMatYdQen4MEJrgqxbi3pfNERr5X/G3IzJT0uL9UoxhtwFXHjUdpxHRWq6lCg7maIXr+NBZ6/QRz/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKhcqq90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKhcqq90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BFCC16AAE;
	Tue,  3 Feb 2026 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134409;
	bh=LoLt3v0dhdP4FPlor9Yj0E9wWO56b//9KaBP2kyWPgY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=nKhcqq90wQBkzZTis99xWliFRySRSY8nqhB+zWRlY3S8d61EF3QPxZZZ1gicFA6zd
	 nTYMXrKg4My1uIZy7Yqpe0SgQlQq7ayPJlJRB1r46vWQ4Ak2uGDXev1g2jreCAyGZF
	 JCQJw0gxLkK+/iumd2zrm/A6zArsW227mboj7lk4=
Subject: Patch "ksmbd: fix use-after-free in ksmbd_session_rpc_open" has been added to the 6.1-stable tree
To: 1468888505@139.com,akendo@akendo.eu,gregkh@linuxfoundation.org,linkinjeon@kernel.org,norbert@doyensec.com,patches@lists.linux.dev,senozhatsky@chromium.org,set_pte_at@outlook.com,sfrench@samba.org,stfrench@microsoft.com,tom@talpey.com,ysk@kzalloc.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:09 +0100
In-Reply-To: <20260202031550.514894-1-1468888505@139.com>
Message-ID: <2026020308-negligee-passover-a6ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ksmbd: fix use-after-free in ksmbd_session_rpc_open

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Mon Feb  2 04:15:55 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 11:15:50 +0800
Subject: ksmbd: fix use-after-free in ksmbd_session_rpc_open
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, linkinjeon@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, norbert@doyensec.com, ysk@kzalloc.com, sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, akendo@akendo.eu, set_pte_at@outlook.com, linux-cifs@vger.kernel.org, stfrench@microsoft.com
Message-ID: <20260202031550.514894-1-1468888505@139.com>

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a1f46c99d9ea411f9bf30025b912d881d36fc709 ]

A UAF issue can occur due to a race condition between
ksmbd_session_rpc_open() and __session_rpc_close().
Add rpc_lock to the session to protect it.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ KSMBD_DEFAULT_GFP is introduced by commit 0066f623bce8 ("ksmbd: use __GFP_RETRY_MAYFAIL")
 after linux-6.13. Here we still use GFP_KERNEL. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |   20 ++++++++++++++------
 fs/smb/server/mgmt/user_session.h |    1 +
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -59,10 +59,12 @@ static void ksmbd_session_rpc_clear_list
 	struct ksmbd_session_rpc *entry;
 	long index;
 
+	down_write(&sess->rpc_lock);
 	xa_for_each(&sess->rpc_handle_list, index, entry) {
 		xa_erase(&sess->rpc_handle_list, index);
 		__session_rpc_close(sess, entry);
 	}
+	up_write(&sess->rpc_lock);
 
 	xa_destroy(&sess->rpc_handle_list);
 }
@@ -92,7 +94,7 @@ int ksmbd_session_rpc_open(struct ksmbd_
 {
 	struct ksmbd_session_rpc *entry, *old;
 	struct ksmbd_rpc_command *resp;
-	int method;
+	int method, id;
 
 	method = __rpc_method(rpc_name);
 	if (!method)
@@ -102,26 +104,29 @@ int ksmbd_session_rpc_open(struct ksmbd_
 	if (!entry)
 		return -ENOMEM;
 
+	down_read(&sess->rpc_lock);
 	entry->method = method;
-	entry->id = ksmbd_ipc_id_alloc();
-	if (entry->id < 0)
+	entry->id = id = ksmbd_ipc_id_alloc();
+	if (id < 0)
 		goto free_entry;
-	old = xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	old = xa_store(&sess->rpc_handle_list, id, entry, GFP_KERNEL);
 	if (xa_is_err(old))
 		goto free_id;
 
-	resp = ksmbd_rpc_open(sess, entry->id);
+	resp = ksmbd_rpc_open(sess, id);
 	if (!resp)
 		goto erase_xa;
 
+	up_read(&sess->rpc_lock);
 	kvfree(resp);
-	return entry->id;
+	return id;
 erase_xa:
 	xa_erase(&sess->rpc_handle_list, entry->id);
 free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);
+	up_read(&sess->rpc_lock);
 	return -EINVAL;
 }
 
@@ -129,9 +134,11 @@ void ksmbd_session_rpc_close(struct ksmb
 {
 	struct ksmbd_session_rpc *entry;
 
+	down_write(&sess->rpc_lock);
 	entry = xa_erase(&sess->rpc_handle_list, id);
 	if (entry)
 		__session_rpc_close(sess, entry);
+	up_write(&sess->rpc_lock);
 }
 
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
@@ -404,6 +411,7 @@ static struct ksmbd_session *__session_c
 	sess->sequence_number = 1;
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
+	init_rwsem(&sess->rpc_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -63,6 +63,7 @@ struct ksmbd_session {
 	rwlock_t			tree_conns_lock;
 
 	atomic_t			refcnt;
+	struct rw_semaphore		rpc_lock;
 };
 
 static inline int test_session_flag(struct ksmbd_session *sess, int bit)


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
queue-6.1/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.1/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.1/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.1/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
queue-6.1/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.1/sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
