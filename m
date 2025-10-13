Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A830AAD2;
	Mon, 13 Oct 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368664; cv=none; b=L5qAtOdPaPz45EZBU9DpQXofLzCYH4BbG11XGxCE7cfBOuf2v1kjrbdifgpMg9QwCjVVrkJfiGPgmpFGYrlUJZXCI6ube7R8gnhzVkGRI2vN1bXlzWjaxPAiLlUNn5kEPDrAi8lgW9eCDQfNiG5TUhsTc/D2TB1Jr5nZ4mq89C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368664; c=relaxed/simple;
	bh=0YZYuMZRTqljUxQV1k7DjQ8FTs/muD1Q2hdZX7GxBIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONKL+dIIqmoInbzXmwXRXNY8S4oRPbZ4Y9FgBHlVH+aWhJkyYp92BbF9Ttg3RCfKunqSfvhHxjqfRg/uQ3RnnScqD8s9wrC0nrlUPGEeEiJDUrQKJCigoKS2EUHhCju9EiI9u6Bxu0qZNyoZYs51ufylFAGONFqxA8f3rn/3V3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2gipGxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2gipGxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F52C4CEE7;
	Mon, 13 Oct 2025 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368663;
	bh=0YZYuMZRTqljUxQV1k7DjQ8FTs/muD1Q2hdZX7GxBIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2gipGxCtY9v6veDFFRJSlgy3HR5ILVrZgQog3F/TMzdhSY5i2DQKHOTpzqxqiADG
	 Fh+B+R2CTFsnisvZFO/Zjd4gC+fnUnkQUx6pAp8X5hG7wBc8MylO2SXewPOXUHV9Cs
	 wW6eSahLT/6scj7C+DV9wU3VgSSdjh1zrhZz2Q84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <ysk@kzalloc.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 239/262] ksmbd: Fix race condition in RPC handle list access
Date: Mon, 13 Oct 2025 16:46:21 +0200
Message-ID: <20251013144334.846356604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Yunseong Kim <ysk@kzalloc.com>

commit 305853cce379407090a73b38c5de5ba748893aee upstream.

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
 	old = xa_store(&sess->rpc_handle_list, id, entry, KSMBD_DEFAULT_GFP);
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


