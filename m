Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65401E487;
	Tue,  3 Feb 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130261; cv=none; b=m4dY8rzRHHRTGgeYI8eY+ji7aU+EhhO8hpYNLf4yvBn+sXfj9ks6ad/WMNfvbd0/4bjKPxqMjtouYTP5BoKJ5at/gaimUn23+K6qhyl7uXG0UTXRG5xBbDvHKcZsKXXWg8DHluNRCPAtRmp+XPCO1jol+L4ljV8xgDtCI03BslQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130261; c=relaxed/simple;
	bh=MKoCwYi1RrBQ6hoeiEAGrBsyg3Ub2Y5PnjlO3lrjJG8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=g6yB2suCj4mriRk6NI+J43L3ODMFkkbwP//NDEnU+O0nFfXoeqvsDk/5y+6Qq+tYbm5oktvzxtuWlgaW2uiKdl8Hb1lNHc9jTh+f7iNKASknCHTxQbzAGUuKMLVACpyOhnVlbXFMHn2SlgJ3NwtSd3SdANWV7XbTYiXnqRIztbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7tQ+sC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7tQ+sC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B93C16AAE;
	Tue,  3 Feb 2026 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770130261;
	bh=MKoCwYi1RrBQ6hoeiEAGrBsyg3Ub2Y5PnjlO3lrjJG8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=X7tQ+sC8WH8q+zPHayT9Z9Tt+NUD+Z1/M9ynO8WbmgknIEFC44n8Frguvjwis5aaa
	 m6aL1b67UwGK4gpYmO361ChGFwAAbOJk+JDI8OQTR7G9YvBdfIrVs9/KH9htuQSVsd
	 im7fcCRqmiMQhDeZzRNcaCmCI7g8RvZ+vzT2QDHE=
Subject: Patch "ksmbd: Fix race condition in RPC handle list access" has been added to the 6.6-stable tree
To: 1468888505@139.com,akendo@akendo.eu,gregkh@linuxfoundation.org,linkinjeon@kernel.org,patches@lists.linux.dev,senozhatsky@chromium.org,set_pte_at@outlook.com,sfrench@samba.org,stfrench@microsoft.com,tom@talpey.com,ysk@kzalloc.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 15:50:38 +0100
In-Reply-To: <20260202031739.515222-1-1468888505@139.com>
Message-ID: <2026020338-outright-disdain-58b6@gregkh>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Mon Feb  2 04:17:45 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 11:17:39 +0800
Subject: ksmbd: Fix race condition in RPC handle list access
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, ysk@kzalloc.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, akendo@akendo.eu, set_pte_at@outlook.com, linux-cifs@vger.kernel.org, stfrench@microsoft.com
Message-ID: <20260202031739.515222-1-1468888505@139.com>

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

queue-6.6/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.6/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.6/wifi-ath11k-add-srng-lock-for-ath11k_hal_srng_-in-monitor-mode.patch
queue-6.6/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
