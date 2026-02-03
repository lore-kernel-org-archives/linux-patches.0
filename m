Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E7D3BFE4A;
	Tue,  3 Feb 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134384; cv=none; b=d1KJVugBNIpbfnRpY9BTZEYNRNBnrWvU1Zhar86KIubBI1akpi9ZfiIB3Uza0fIUJVhES5dMLkXaWejOQfRbtWdRer5xiiqj0GZ9N0Tvs4AIpglkYL4P07o8BblTwqMFvRNPqPhRs/pnnMucXLbZ9iadRd/z1JKHHsOjhU7jMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134384; c=relaxed/simple;
	bh=izP1eMLSYndP1DRQJCtPVQNg3QUMapqlwTwRIKYvYSo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=TGbwJMm0E8IIQPMaBMEHKqF03JcXlDNlTAbJA1n+TjZTx0YDw7/noCACgP4jLUqFtHjcGOEu1wt7lqhViofhsqq82oJ/JlOWkPdE3wxPem2ZuBCrJmudQ7wOliQg+Nyo4dKD2ROJvDm3eXNAYtHHMdtLqFBlSAaZyLTcD9EgzSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQDQL7Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQDQL7Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076D5C116D0;
	Tue,  3 Feb 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134383;
	bh=izP1eMLSYndP1DRQJCtPVQNg3QUMapqlwTwRIKYvYSo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=mQDQL7Z8CtOxyxQGd+Ax5wfk5RA2az4nRaUeZUJh5neMA1RqkQh1fX8gy+kGvbNfp
	 b7LXx/Cp576KH3mZlGILzvLO1ZkHVbILnKG5NS5NYFgOb9dct9KbCQA0zvwY7xBzQ9
	 EkAV40XlFaS3WeaWQZQCPr3COzwZJZuRqZpF0VFA=
Subject: Patch "ksmbd: Fix race condition in RPC handle list access" has been added to the 6.1-stable tree
To: 1468888505@139.com,akendo@akendo.eu,gregkh@linuxfoundation.org,linkinjeon@kernel.org,patches@lists.linux.dev,senozhatsky@chromium.org,set_pte_at@outlook.com,sfrench@samba.org,stfrench@microsoft.com,tom@talpey.com,ysk@kzalloc.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:08 +0100
In-Reply-To: <20260202031711.515125-1-1468888505@139.com>
Message-ID: <2026020308-joystick-skinning-092a@gregkh>
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

    ksmbd: Fix race condition in RPC handle list access

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-213018-greg=kroah.com@vger.kernel.org Mon Feb  2 04:17:53 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 11:17:11 +0800
Subject: ksmbd: Fix race condition in RPC handle list access
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, ysk@kzalloc.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, akendo@akendo.eu, set_pte_at@outlook.com, linux-cifs@vger.kernel.org, stfrench@microsoft.com
Message-ID: <20260202031711.515125-1-1468888505@139.com>

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit 305853cce379407090a73b38c5de5ba748893aee ]

The 'sess->rpc_handle_list' XArray manages RPC handles within a ksmbd
session. Access to this list is intended to be protected by
'sess->rpc_lock' (an rw_semaphore). However, the locking implementation was
flawed, leading to potential race conditions.

In ksmbd_session_rpc_open(), the code incorrectly acquired only a read lock
before calling xa_store() and xa_erase(). Since these operations modify
the XArray structure, a write lock is required to ensure exclusive access
and prevent data corruption from concurrent modifications.

Furthermore, ksmbd_session_rpc_method() accessed the list using xa_load()
without holding any lock at all. This could lead to reading inconsistent
data or a potential use-after-free if an entry is concurrently removed and
the pointer is dereferenced.

Fix these issues by:
1. Using down_write() and up_write() in ksmbd_session_rpc_open()
   to ensure exclusive access during XArray modification, and ensuring
   the lock is correctly released on error paths.
2. Adding down_read() and up_read() in ksmbd_session_rpc_method()
   to safely protect the lookup.

Fixes: a1f46c99d9ea ("ksmbd: fix use-after-free in ksmbd_session_rpc_open")
Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
Cc: stable@vger.kernel.org
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -104,29 +104,32 @@ int ksmbd_session_rpc_open(struct ksmbd_
 	if (!entry)
 		return -ENOMEM;
 
-	down_read(&sess->rpc_lock);
 	entry->method = method;
 	entry->id = id = ksmbd_ipc_id_alloc();
 	if (id < 0)
 		goto free_entry;
+
+	down_write(&sess->rpc_lock);
 	old = xa_store(&sess->rpc_handle_list, id, entry, GFP_KERNEL);
-	if (xa_is_err(old))
+	if (xa_is_err(old)) {
+		up_write(&sess->rpc_lock);
 		goto free_id;
+	}
 
 	resp = ksmbd_rpc_open(sess, id);
-	if (!resp)
-		goto erase_xa;
+	if (!resp) {
+		xa_erase(&sess->rpc_handle_list, entry->id);
+		up_write(&sess->rpc_lock);
+		goto free_id;
+	}
 
-	up_read(&sess->rpc_lock);
+	up_write(&sess->rpc_lock);
 	kvfree(resp);
 	return id;
-erase_xa:
-	xa_erase(&sess->rpc_handle_list, entry->id);
 free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);
-	up_read(&sess->rpc_lock);
 	return -EINVAL;
 }
 
@@ -144,9 +147,14 @@ void ksmbd_session_rpc_close(struct ksmb
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
+	int method;
 
+	down_read(&sess->rpc_lock);
 	entry = xa_load(&sess->rpc_handle_list, id);
-	return entry ? entry->method : 0;
+	method = entry ? entry->method : 0;
+	up_read(&sess->rpc_lock);
+
+	return method;
 }
 
 void ksmbd_session_destroy(struct ksmbd_session *sess)


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
queue-6.1/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.1/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.1/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.1/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
queue-6.1/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.1/sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
