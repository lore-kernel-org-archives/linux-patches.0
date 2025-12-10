Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198627A47F;
	Wed, 10 Dec 2025 07:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352000; cv=none; b=OzbyF4iwUuzoItcxxi67DkA7vskQA/SqOeQdc8rH7+I3pyC7EFH7+mwguJ/nmT6lSMuA/UPf1v/M9xD8EmkwEiQMMS9t5wTtBZjDOwxaa/wpqT9/CxM6NhslzCe7/kwDKy79Oj0VK8eesygRS6e0UNKyQNcP1J2kvS6RB/SKThg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352000; c=relaxed/simple;
	bh=farnGNvUZhA+66HxVOV+pxG3ILySs26IXoZgm1ygARM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcTyPl3y+yQY75siseHnxr0yA74oitHZSGOx0M3H5aogwWXq++91Ms/l+cl2hMyKZ2drv/6shCKqaWbmGK3U2vCqy+yNX82vHhN1YlDaSZTD4NH8KVlAG0isusEz5j61873k5ARjum3WG2gr9Dp5/66T2Bls/CRxcsxTnfv/mjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOBJ+BBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOBJ+BBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA4BC4CEF1;
	Wed, 10 Dec 2025 07:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352000;
	bh=farnGNvUZhA+66HxVOV+pxG3ILySs26IXoZgm1ygARM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOBJ+BBqUhU1tev2b8jQSxsuN88ehwldF3mvAeGH6XZiNKphrWhFvA6Z6Ws7uZsht
	 x15bTjfEXs0Bpa1cOJQ12d5YLH1z93GdByt1i1UfbYWlMdKRdvuFjE3BKG5lGf7Gm2
	 ZxDdBN/f65UpI5VbCDL9KNtbQ3rMjCfIJN6Xp2TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 04/60] ksmbd: ipc: fix use-after-free in ipc_msg_send_request
Date: Wed, 10 Dec 2025 16:29:34 +0900
Message-ID: <20251210072947.955740226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


