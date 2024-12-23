Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E75F1AF0CE;
	Mon, 23 Dec 2024 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970040; cv=none; b=QT0EY6RTt93ZK3d7H9D5FzmPbUYTE038q2+A1UG1xiUsdJSnoYzw03Wban/Pt7rCMVCJWcVxKTltVCni1XIfC1skVEPz/PFDx2aYEhhR41tRojv7qDcxOEDJRZKxNKrazhQYcbATc6d5vGDyLPoeIo/N7XqnlLe7tL3D8/ME6Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970040; c=relaxed/simple;
	bh=E1UYldQU5bd7bDpcDwOn9Pes/LPKmJWuBtkQlVbLPeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaFxUihk5h74/xDPIk153o5BKo63VRA4x9iPXmwfeLXXKhuw45mhGD4WctCzj7TVmfxo3vnhOyQOs/SJjwmfrAgEIYfgXac8wX5BxSDFXxtYoAdrjISCOlBXN0c1QOdpoEyH7bjAKpIQ520+X9mUsj/cYSs3NY3wTHC6X164dSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBOOHoBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBOOHoBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E2BC4CED6;
	Mon, 23 Dec 2024 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970040;
	bh=E1UYldQU5bd7bDpcDwOn9Pes/LPKmJWuBtkQlVbLPeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBOOHoBhbfMsNBKfWslcXam4pzZa2QS3Kl79KxXpgxZ6vaDe543iZrMYv1/yK4+rT
	 YCeoGcv4eLQtjYjHr5Ae/+eIPQ/g38JIyVFo0b1tZ5EUbi9dO8yk6elDylP3Z2tn5k
	 fKUG01+t/KjRBGFJ54Vujtpi0X354zaW/PKnFzmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 127/160] smb: client: fix TCP timers deadlock after rmmod
Date: Mon, 23 Dec 2024 16:58:58 +0100
Message-ID: <20241223155413.693229180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

commit e9f2517a3e18a54a3943c098d2226b245d488801 upstream.

Commit ef7134c7fc48 ("smb: client: Fix use-after-free of network namespace.")
fixed a netns UAF by manually enabled socket refcounting
(sk->sk_net_refcnt=1 and sock_inuse_add(net, 1)).

The reason the patch worked for that bug was because we now hold
references to the netns (get_net_track() gets a ref internally)
and they're properly released (internally, on __sk_destruct()),
but only because sk->sk_net_refcnt was set.

Problem:
(this happens regardless of CONFIG_NET_NS_REFCNT_TRACKER and regardless
if init_net or other)

Setting sk->sk_net_refcnt=1 *manually* and *after* socket creation is not
only out of cifs scope, but also technically wrong -- it's set conditionally
based on user (=1) vs kernel (=0) sockets.  And net/ implementations
seem to base their user vs kernel space operations on it.

e.g. upon TCP socket close, the TCP timers are not cleared because
sk->sk_net_refcnt=1:
(cf. commit 151c9c724d05 ("tcp: properly terminate timers for kernel sockets"))

net/ipv4/tcp.c:
    void tcp_close(struct sock *sk, long timeout)
    {
    	lock_sock(sk);
    	__tcp_close(sk, timeout);
    	release_sock(sk);
    	if (!sk->sk_net_refcnt)
    		inet_csk_clear_xmit_timers_sync(sk);
    	sock_put(sk);
    }

Which will throw a lockdep warning and then, as expected, deadlock on
tcp_write_timer().

A way to reproduce this is by running the reproducer from ef7134c7fc48
and then 'rmmod cifs'.  A few seconds later, the deadlock/lockdep
warning shows up.

Fix:
We shouldn't mess with socket internals ourselves, so do not set
sk_net_refcnt manually.

Also change __sock_create() to sock_create_kern() for explicitness.

As for non-init_net network namespaces, we deal with it the best way
we can -- hold an extra netns reference for server->ssocket and drop it
when it's released.  This ensures that the netns still exists whenever
we need to create/destroy server->ssocket, but is not directly tied to
it.

Fixes: ef7134c7fc48 ("smb: client: Fix use-after-free of network namespace.")
Cc: stable@vger.kernel.org
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -987,9 +987,13 @@ clean_demultiplex_info(struct TCP_Server
 	msleep(125);
 	if (cifs_rdma_enabled(server))
 		smbd_destroy(server);
+
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
+
+		/* Release netns reference for the socket. */
+		put_net(cifs_net_ns(server));
 	}
 
 	if (!list_empty(&server->pending_mid_q)) {
@@ -1037,6 +1041,7 @@ clean_demultiplex_info(struct TCP_Server
 		 */
 	}
 
+	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server);
@@ -1713,6 +1718,8 @@ cifs_get_tcp_session(struct smb3_fs_cont
 
 	tcp_ses->ops = ctx->ops;
 	tcp_ses->vals = ctx->vals;
+
+	/* Grab netns reference for this server. */
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
 
 	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
@@ -1844,6 +1851,7 @@ smbd_connected:
 out_err_crypto_release:
 	cifs_crypto_secmech_release(tcp_ses);
 
+	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(tcp_ses));
 
 out_err:
@@ -1852,8 +1860,10 @@ out_err:
 			cifs_put_tcp_session(tcp_ses->primary_server, false);
 		kfree(tcp_ses->hostname);
 		kfree(tcp_ses->leaf_fullpath);
-		if (tcp_ses->ssocket)
+		if (tcp_ses->ssocket) {
 			sock_release(tcp_ses->ssocket);
+			put_net(cifs_net_ns(tcp_ses));
+		}
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
@@ -3111,20 +3121,20 @@ generic_ip_connect(struct TCP_Server_Inf
 		socket = server->ssocket;
 	} else {
 		struct net *net = cifs_net_ns(server);
-		struct sock *sk;
 
-		rc = __sock_create(net, sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &server->ssocket, 1);
+		rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
 		}
 
-		sk = server->ssocket->sk;
-		__netns_tracker_free(net, &sk->ns_tracker, false);
-		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
-		sock_inuse_add(net, 1);
+		/*
+		 * Grab netns reference for the socket.
+		 *
+		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
+		 * teardown.
+		 */
+		get_net(net);
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 		cifs_dbg(FYI, "Socket created\n");
@@ -3138,8 +3148,10 @@ generic_ip_connect(struct TCP_Server_Inf
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0)
+	if (rc < 0) {
+		put_net(cifs_net_ns(server));
 		return rc;
+	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3176,6 +3188,7 @@ generic_ip_connect(struct TCP_Server_Inf
 	if (rc < 0) {
 		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
 		trace_smb3_connect_err(server->hostname, server->conn_id, &server->dstaddr, rc);
+		put_net(cifs_net_ns(server));
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -3184,6 +3197,9 @@ generic_ip_connect(struct TCP_Server_Inf
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
 	return rc;
 }
 


