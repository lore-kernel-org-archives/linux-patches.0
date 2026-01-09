Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83841334C24;
	Fri,  9 Jan 2026 12:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961423; cv=none; b=LQWjK8xio+DS5hORzf+ZB2d+iuooIjMFWIkCyh32wmjWlmSttXFRVLzrdsbfP2CXSbTqjz28Subr4QUfpb4WVqWQODmr6HdoRZKL9hMDWXDiWLxH0/KVeYeuebmEy1xU7lpDQmlngknz4HTSxitWE3x5V7GjCH9pxmwV1ofsSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961423; c=relaxed/simple;
	bh=cCwwqwdXMQ0j1tfCTuhCiAdD8k0bYoEgP+iMDcvsT54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh7Ba9oJ02ufA5qOlUL9xHO8kr4RQpU41nCKxgncZBSuAGx7/y38ZDgHwIkQIrj3RPyaHjwaAuuLya5qZN1CUrrjfJ7nNud0b062/eI9nAnYcUKPCW3Ix2By3JyL6JQx9VSYlH0f0Q01c27GsFp93vxa4SuWRSRBBvQeLqJNgy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdGq3n0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdGq3n0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0106EC4CEF1;
	Fri,  9 Jan 2026 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961423;
	bh=cCwwqwdXMQ0j1tfCTuhCiAdD8k0bYoEgP+iMDcvsT54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdGq3n0y5zKHO0Kqagd5ZV46KljJuSOk20wXH8Pza2JWIlux7R/hLKa13pyJL0DYB
	 iGJk+LsdNmW5Z0BY6v11/Pusx1eKzP97j3x1bXothDw/z660Ja5PLvyZKueTazWuRG
	 21lZH8OvaUyFVbcmcLfgd89ugXVVZQUD7sTtFthI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 010/634] ksmbd: ipc: fix use-after-free in ipc_msg_send_request
Date: Fri,  9 Jan 2026 12:34:48 +0100
Message-ID: <20260109112117.817079190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Qianchang Zhao <pioooooooooip@gmail.com>

commit 1fab1fa091f5aa97265648b53ea031deedd26235 upstream.

ipc_msg_send_request() waits for a generic netlink reply using an
ipc_msg_table_entry on the stack. The generic netlink handler
(handle_generic_event()/handle_response()) fills entry->response under
ipc_msg_table_lock, but ipc_msg_send_request() used to validate and free
entry->response without holding the same lock.

Under high concurrency this allows a race where handle_response() is
copying data into entry->response while ipc_msg_send_request() has just
freed it, leading to a slab-use-after-free reported by KASAN in
handle_generic_event():

  BUG: KASAN: slab-use-after-free in handle_generic_event+0x3c4/0x5f0 [ksmbd]
  Write of size 12 at addr ffff888198ee6e20 by task pool/109349
  ...
  Freed by task:
    kvfree
    ipc_msg_send_request [ksmbd]
    ksmbd_rpc_open -> ksmbd_session_rpc_open [ksmbd]

Fix by:
- Taking ipc_msg_table_lock in ipc_msg_send_request() while validating
  entry->response, freeing it when invalid, and removing the entry from
  ipc_msg_table.
- Returning the final entry->response pointer to the caller only after
  the hash entry is removed under the lock.
- Returning NULL in the error path, preserving the original API
  semantics.

This makes all accesses to entry->response consistent with
handle_response(), which already updates and fills the response buffer
under ipc_msg_table_lock, and closes the race that allowed the UAF.

Cc: stable@vger.kernel.org
Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -517,12 +517,16 @@ static void *ipc_msg_send_request(struct
 	up_write(&ipc_msg_table_lock);
 
 	ret = ipc_msg_send(msg);
-	if (ret)
+	if (ret) {
+		down_write(&ipc_msg_table_lock);
 		goto out;
+	}
 
 	ret = wait_event_interruptible_timeout(entry.wait,
 					       entry.response != NULL,
 					       IPC_WAIT_TIMEOUT);
+
+	down_write(&ipc_msg_table_lock);
 	if (entry.response) {
 		ret = ipc_validate_msg(&entry);
 		if (ret) {
@@ -531,7 +535,6 @@ static void *ipc_msg_send_request(struct
 		}
 	}
 out:
-	down_write(&ipc_msg_table_lock);
 	hash_del(&entry.ipc_table_hlist);
 	up_write(&ipc_msg_table_lock);
 	return entry.response;


