Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4343FF1D8;
	Fri, 15 May 2026 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860800; cv=none; b=Y02yG7WX+2XVLoMGvKCpsZPe0z/N+YvJr6kcEgAFt1YLTv1gwb6P8f+jXwFmcpehMylHm8zwwS4s33cE+rvvDn+SscWY/8sq0rpVeSZ9y20lGAh/F1ZjupJjyHE0CmYp5fKDrNDRpcz/hkvxemVy71GAkt3Qsgq89T7eO8IuuwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860800; c=relaxed/simple;
	bh=yiSE3nBo3PHMFv+Q/T70B08wO/QgPBahZKV6YWITQNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QppDbvI6REHq4X1NM+Icizoi2kJMQ3TYDKY32j5ix8URqWZXBbGCi12ArEec7Nr6mGaYX2WqT0rZBTuvIW9/JwT9AZNfztcevQ0EyyjTcoxg++z21xcjcq8fPqCY0wI0kdbNhUBFFToAKYjF3gtzPA/LtVp0/gL9r2TtbGbpd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfiB12qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfiB12qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6587C2BCB0;
	Fri, 15 May 2026 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860800;
	bh=yiSE3nBo3PHMFv+Q/T70B08wO/QgPBahZKV6YWITQNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfiB12qaLpRN3lwTB2zoLyp69nzR2BSLfPfmdbgAeXbyEYh3kRaR7M4XjK3nArH0h
	 O2DWBQb4aZkIanF8pNZQgBqHepjjQLwl0ewN034cAcSdhnMYarpvhLTyRJzO72LuVN
	 QKVFf5URABMYUzOvIXPvW6P9Efb52C2iuImh+DOg=
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
Subject: [PATCH 6.6 067/474] rxrpc: Fix re-decryption of RESPONSE packets
Date: Fri, 15 May 2026 17:42:56 +0200
Message-ID: <20260515154716.493017072@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 0422e7a4883f25101903f3e8105c0808aa5f4ce9 upstream.

If a RESPONSE packet gets a temporary failure during processing, it may end
up in a partially decrypted state - and then get requeued for a retry.

Fix this by just discarding the packet; we will send another CHALLENGE
packet and thereby elicit a further response.  Similarly, discard an
incoming CHALLENGE packet if we get an error whilst generating a RESPONSE;
the server will send another CHALLENGE.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260422161438.2593376-4-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260423200909.3049438-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    1 -
 net/rxrpc/conn_event.c       |   14 ++------------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -232,7 +232,6 @@
 	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
 	EM(rxrpc_conn_put_work,			"PUT work    ") \
 	EM(rxrpc_conn_queue_challenge,		"QUE chall   ") \
-	EM(rxrpc_conn_queue_retry_work,		"QUE retry-wk") \
 	EM(rxrpc_conn_queue_rx_work,		"QUE rx-work ") \
 	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
 	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -344,7 +344,6 @@ again:
 static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 {
 	struct sk_buff *skb;
-	int ret;
 
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
 		rxrpc_secure_connection(conn);
@@ -353,17 +352,8 @@ static void rxrpc_do_process_connection(
 	 * connection that each one has when we've finished with it */
 	while ((skb = skb_dequeue(&conn->rx_queue))) {
 		rxrpc_see_skb(skb, rxrpc_skb_see_conn_work);
-		ret = rxrpc_process_event(conn, skb);
-		switch (ret) {
-		case -ENOMEM:
-		case -EAGAIN:
-			skb_queue_head(&conn->rx_queue, skb);
-			rxrpc_queue_conn(conn, rxrpc_conn_queue_retry_work);
-			break;
-		default:
-			rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
-			break;
-		}
+		rxrpc_process_event(conn, skb);
+		rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
 	}
 }
 


