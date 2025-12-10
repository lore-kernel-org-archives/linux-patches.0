Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D4303C81;
	Wed, 10 Dec 2025 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352159; cv=none; b=a7o+EYtw1JLk4wSeWkz8Wap3kmP4pzYCj98KvAoiY4lXLRoR0G4DvDpISh0JrOoLKzUabxFXvglC4HwhmznFQFP8Youi9HhlZVt8GNVVpq8rrEfyvEYItgosMF/AA3sZNcvJwFyTtEazY81rZ49Sr26VSNvFC2z2Homn5rwCkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352159; c=relaxed/simple;
	bh=5zysFCDzAt6873wtAewPic96DchaPhVyEN6KWMcTnk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sidZTjavu0KWWKtpJmhqVfCnRevAkJ5G3PuCsd8NHfEpI3N+AFvcJ0YcKN0fJqnclNayt5vi7vZcDZmw7Pd9hbYqBMqkAEQ/Z8lwsqKG0+bWs+XCKr92IQqSCiPz6+/7boHTbNqjt4G+jAAAeC4AQRXGbbDfDSO6YvvubmTerNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxcAa4tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxcAa4tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE88C4CEF1;
	Wed, 10 Dec 2025 07:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352159;
	bh=5zysFCDzAt6873wtAewPic96DchaPhVyEN6KWMcTnk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxcAa4tg8Kcu4HmFVma922x7WBEVkXrFCKRCSGXHGj3ZX9sTmzGf8P4r9rE1HSWtt
	 gmr2dY0NgnreY0nZEO0wYjBFlP14bxJhf7c3a1LUnsCOSOxRkuS5OV6b9sCZmG6PJl
	 6wur1QtJLFqMlTTp1/4jScRC5+IOxrAS2xGkYdtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 04/29] ksmbd: ipc: fix use-after-free in ipc_msg_send_request
Date: Wed, 10 Dec 2025 16:30:14 +0900
Message-ID: <20251210072944.491410534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -553,12 +553,16 @@ static void *ipc_msg_send_request(struct
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
@@ -567,7 +571,6 @@ static void *ipc_msg_send_request(struct
 		}
 	}
 out:
-	down_write(&ipc_msg_table_lock);
 	hash_del(&entry.ipc_table_hlist);
 	up_write(&ipc_msg_table_lock);
 	return entry.response;


