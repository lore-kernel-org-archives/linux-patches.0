Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F630421EE2;
	Wed,  4 Feb 2026 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218320; cv=none; b=bUYEEFwA0/Yg8q4ivrd3GE7wUIbsNzfhB8lkDY6ANfW1gWaYU/DdLqnKVjyAPwkE29ZxiPOEptdPvP0ifv6N7G21XHq3oUxOhLH0JuBiSGzFPlSpx2SNHs+y4Hn3pn9dxGw25tKyoXlWmFJHVP1HV/ongWWZNmcYm4gWm4DO5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218320; c=relaxed/simple;
	bh=qX927nqQuolOy0OD5WATdC9XYHrT5ZmUbj9q8EIJjt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laH+DuP0hvAS4G+zfJSPuo7Cj4gULBd6ARvb6HsEX0pDpKj6KoZAYmXGT2DyVbjAN/3JZBZXK3+XwXnXTidv6cFhdDIi9OZP8UVGUxVoxIVvEcpFPUUlJuKxafc25bbIyfGWymXvsOCseYSCry8rD9s8r6FHcgOY2BKP9ZncyMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAArVy32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAArVy32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF8C2BCAF;
	Wed,  4 Feb 2026 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218319;
	bh=qX927nqQuolOy0OD5WATdC9XYHrT5ZmUbj9q8EIJjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAArVy32VPgthaOlfIHMRGsojb1/Hwx9h17T1RofbLMzv8mY3usp9XeKtkzGvcF3w
	 cZoNpsOAFqP8E1VskxwThZ4aePlaGe3CHlf0DOgpYkIaAo01dAhbAbX+n6omVx2k5L
	 FijwyzzXgNwVjOhLYErlBrSJ/KDWrj1d3h554Wdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.1 269/280] ksmbd: fix use-after-free in ksmbd_session_rpc_open
Date: Wed,  4 Feb 2026 15:40:43 +0100
Message-ID: <20260204143919.380141609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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


