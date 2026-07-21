Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51D6326D44;
	Tue, 21 Jul 2026 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655539; cv=none; b=cJhuZjxj5L4f87AnSkUl8a4Ro39cMKXtfvZIiFVaCwgaYxqtYKK6BkNKPgFk2ZH/BEehR7NoEjlBdDKl3oG6lVDkuaOv9HwkJeEV6jqB7D4UCGnf+OAxYnjMCFoXSeUXL61Gc2N3XBm+00iDly8XNsKwusAAwYZj3Pbha35E2kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655539; c=relaxed/simple;
	bh=0y/S2dTBNIrSY2yG51akDWqqTKCsA8LNBrjK5cRSbRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0Z9WMG4tj4TKmDYO7P9Q/OJsrdwBWiO+czNL+LBpH9GVW9HP9DmpQR5vruC9jGSg3/TURPrDTDlmfRE4HPWQhN/6UrAj4fuYpNjLAmY5Ut8pVI506HgVv7615VXvpvP1MgK8cDf/7k+7Vz/VLqYrLssT3FDSGIvlyFiTxf0eMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVq/2pSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVq/2pSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7E51F000E9;
	Tue, 21 Jul 2026 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655538;
	bh=ZJ9gYLCl5UCE7pMg6owABQnsYjVFD1og0C6+L1VlyLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVq/2pStyHQrbugrttUmHCVYuwMJWcIkfbkp8y1PiQ0CIlLVydWujDabKep+AkkQ0
	 FE7pJiCUWUPWBTiqizg4b9tA8rvDxTqjr4Vj8AMpGoD/ab+sucGJc//KYERirGkHSs
	 V5GyQ7Aw1p1v1rOdBIHkGPK7VzggvVH9GWKRYqpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0045/1611] rxrpc: Fix oob challenge leak in cleanup after notification failure
Date: Tue, 21 Jul 2026 17:02:41 +0200
Message-ID: <20260721152515.837606986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 092275882aec4a70ba55c3efb66fff947c81656a upstream.

Fix rxrpc_notify_socket_oob() to return an indication of failure in the
event that it failed to queue a packet and fix rxrpc_post_challenge() to
clean up the connection ref in such an event.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-8-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    4 ++--
 net/rxrpc/conn_event.c  |    9 +++++++--
 net/rxrpc/oob.c         |    7 +++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1355,9 +1355,9 @@ static inline struct rxrpc_net *rxrpc_ne
 }
 
 /*
- * out_of_band.c
+ * oob.c
  */
-void rxrpc_notify_socket_oob(struct rxrpc_call *call, struct sk_buff *skb);
+bool rxrpc_notify_socket_oob(struct rxrpc_call *call, struct sk_buff *skb);
 void rxrpc_add_pending_oob(struct rxrpc_sock *rx, struct sk_buff *skb);
 int rxrpc_sendmsg_oob(struct rxrpc_sock *rx, struct msghdr *msg, size_t len);
 
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -436,7 +436,7 @@ static bool rxrpc_post_challenge(struct
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_call *call = NULL;
 	struct rxrpc_sock *rx;
-	bool respond = false;
+	bool respond = false, queued = false;
 
 	sp->chall.conn =
 		rxrpc_get_connection(conn, rxrpc_conn_get_challenge_input);
@@ -472,8 +472,13 @@ static bool rxrpc_post_challenge(struct
 	}
 
 	if (call)
-		rxrpc_notify_socket_oob(call, skb);
+		queued = rxrpc_notify_socket_oob(call, skb);
 	rcu_read_unlock();
+	if (call && !queued) {
+		rxrpc_put_connection(conn, rxrpc_conn_put_challenge_input);
+		sp->chall.conn = NULL;
+		return false;
+	}
 
 	if (!call)
 		rxrpc_post_packet_to_conn(conn, skb);
--- a/net/rxrpc/oob.c
+++ b/net/rxrpc/oob.c
@@ -32,11 +32,12 @@ struct rxrpc_oob_params {
  * Post an out-of-band message for attention by the socket or kernel service
  * associated with a reference call.
  */
-void rxrpc_notify_socket_oob(struct rxrpc_call *call, struct sk_buff *skb)
+bool rxrpc_notify_socket_oob(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_sock *rx;
 	struct sock *sk;
+	bool queued = false;
 
 	rcu_read_lock();
 
@@ -49,6 +50,7 @@ void rxrpc_notify_socket_oob(struct rxrp
 			skb->skb_mstamp_ns = rx->oob_id_counter++;
 			rxrpc_get_skb(skb, rxrpc_skb_get_post_oob);
 			skb_queue_tail(&rx->recvmsg_oobq, skb);
+			queued = true;
 
 			trace_rxrpc_notify_socket(call->debug_id, sp->hdr.serial);
 			if (rx->app_ops)
@@ -56,11 +58,12 @@ void rxrpc_notify_socket_oob(struct rxrp
 		}
 
 		spin_unlock_irq(&rx->recvmsg_lock);
-		if (!rx->app_ops && !sock_flag(sk, SOCK_DEAD))
+		if (queued && !rx->app_ops && !sock_flag(sk, SOCK_DEAD))
 			sk->sk_data_ready(sk);
 	}
 
 	rcu_read_unlock();
+	return queued;
 }
 
 /*


