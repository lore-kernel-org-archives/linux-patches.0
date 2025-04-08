Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C44B1EA65;
	Tue,  8 Apr 2025 12:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116678; cv=none; b=CjhCvXpfQ7CKCHXBonk38CPwy/OnW8yA3pyyzV5ZtA9ESPtdUkeqA1TCrgkg7bl6eG3EsgaBpFvoQflprYFJManSec4wko8+0icllMAjNGpU5dxUY9WcFpBRBm1+cqw/cAA0XPA/fEslozFCmzt4MDDi+gGnGyBITOtTJC3xTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116678; c=relaxed/simple;
	bh=bv2LOopFjEgQQlD6nx9yAEnHgmJorNqgYoO2Rsql7mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr4II4J/+5yBFZQGN18r6S1oUOVWQNHUMcNDhHluexi8Wu2lrpCwdyjBJFCU0s+oLlS6ZipHEm5gvw62Zlwsmo5c5Mzkm5Gsw2quwdoD+7I4qeHMQSFsZMOLEPp/EK//EyZqyA1VAe+lw1jfYjMonrfC1z4tpwYOHI8oJCTdmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9BYW2rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9BYW2rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284BCC4CEE5;
	Tue,  8 Apr 2025 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116677;
	bh=bv2LOopFjEgQQlD6nx9yAEnHgmJorNqgYoO2Rsql7mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9BYW2rx5TXe7E6lcVsom0De7qKmOqIiLsDUmV9NkQLB0q7FKxhmZbaKl0BmXbsdb
	 HGz7efAh2L03wYx/cmbTtGL7oAszLGHTBqdjLlvjyVlHAD3bSUqm2fGfX6WzDRz8lH
	 A4Z338oHBGbi+uici+VIDL6k2uCCUfkHu/DQnBz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/423] smb: client: Fix netns refcount imbalance causing leaks and use-after-free
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104851.060376972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wang Zhaolong <wangzhaolong1@huawei.com>

[ Upstream commit 4e7f1644f2ac6d01dc584f6301c3b1d5aac4eaef ]

Commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
namespace.") attempted to fix a netns use-after-free issue by manually
adjusting reference counts via sk->sk_net_refcnt and sock_inuse_add().

However, a later commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock
after rmmod") pointed out that the approach of manually setting
sk->sk_net_refcnt in the first commit was technically incorrect, as
sk->sk_net_refcnt should only be set for user sockets. It led to issues
like TCP timers not being cleared properly on close. The second commit
moved to a model of just holding an extra netns reference for
server->ssocket using get_net(), and dropping it when the server is torn
down.

But there remain some gaps in the get_net()/put_net() balancing added by
these commits. The incomplete reference handling in these fixes results
in two issues:

1. Netns refcount leaks[1]

The problem process is as follows:

```
mount.cifs                        cifsd

cifs_do_mount
  cifs_mount
    cifs_mount_get_session
      cifs_get_tcp_session
        get_net()  /* First get net. */
        ip_connect
          generic_ip_connect /* Try port 445 */
            get_net()
            ->connect() /* Failed */
            put_net()
          generic_ip_connect /* Try port 139 */
            get_net() /* Missing matching put_net() for this get_net().*/
      cifs_get_smb_ses
        cifs_negotiate_protocol
          smb2_negotiate
            SMB2_negotiate
              cifs_send_recv
                wait_for_response
                                 cifs_demultiplex_thread
                                   cifs_read_from_socket
                                     cifs_readv_from_socket
                                       cifs_reconnect
                                         cifs_abort_connection
                                           sock_release();
                                           server->ssocket = NULL;
                                           /* Missing put_net() here. */
                                           generic_ip_connect
                                             get_net()
                                             ->connect() /* Failed */
                                             put_net()
                                             sock_release();
                                             server->ssocket = NULL;
          free_rsp_buf
    ...
                                   clean_demultiplex_info
                                     /* It's only called once here. */
                                     put_net()
```

When cifs_reconnect() is triggered, the server->ssocket is released
without a corresponding put_net() for the reference acquired in
generic_ip_connect() before. it ends up calling generic_ip_connect()
again to retry get_net(). After that, server->ssocket is set to NULL
in the error path of generic_ip_connect(), and the net count cannot be
released in the final clean_demultiplex_info() function.

2. Potential use-after-free

The current refcounting scheme can lead to a potential use-after-free issue
in the following scenario:

```
 cifs_do_mount
   cifs_mount
     cifs_mount_get_session
       cifs_get_tcp_session
         get_net()  /* First get net */
           ip_connect
             generic_ip_connect
               get_net()
               bind_socket
	         kernel_bind /* failed */
               put_net()
         /* after out_err_crypto_release label */
         put_net()
         /* after out_err label */
         put_net()
```

In the exception handling process where binding the socket fails, the
get_net() and put_net() calls are unbalanced, which may cause the
server->net reference count to drop to zero and be prematurely released.

To address both issues, this patch ties the netns reference counting to
the server->ssocket and server lifecycles. The extra reference is now
acquired when the server or socket is created, and released when the
socket is destroyed or the server is torn down.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=219792

Fixes: ef7134c7fc48 ("smb: client: Fix use-after-free of network namespace.")
Fixes: e9f2517a3e18 ("smb: client: fix TCP timers deadlock after rmmod")
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d327f31b317db..8b8475b4e2627 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -316,6 +316,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
+		put_net(cifs_net_ns(server));
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -3138,8 +3139,12 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		/*
 		 * Grab netns reference for the socket.
 		 *
-		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
-		 * teardown.
+		 * This reference will be released in several situations:
+		 * - In the failure path before the cifsd thread is started.
+		 * - In the all place where server->socket is released, it is
+		 *   also set to NULL.
+		 * - Ultimately in clean_demultiplex_info(), during the final
+		 *   teardown.
 		 */
 		get_net(net);
 
@@ -3155,10 +3160,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0) {
-		put_net(cifs_net_ns(server));
+	if (rc < 0)
 		return rc;
-	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3204,9 +3207,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
-	if (rc < 0)
-		put_net(cifs_net_ns(server));
-
 	return rc;
 }
 
-- 
2.39.5



