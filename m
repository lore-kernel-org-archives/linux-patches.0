Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED3E35A3AD;
	Mon,  4 May 2026 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903920; cv=none; b=taZe0/eYY3pVP9r6MbpnpqRFnqu0zbar6NT8ISJo1NZcl1DVVjOqi9ZvyKxt+gOxFuZk7LGHbRWnJ/ENGxHwQXQ/3/udGWY+stTDuIajAoTZfdLZkDzl1buDl7WSlPLpEGLWxfdaYs0p8wKD+yreOaRuLsaA+Zy2CrHXupUeTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903920; c=relaxed/simple;
	bh=xp620e8qRzOPnfS/q19ZoZpfrqWWIfA4U/ELnb8CQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci07EPzhu92R5yhb6J0CGg8WjiEWvkev7ER+c+F7sv946T1QA0w7DSpd01UNccUvidZErXHqi34ZOrILc/vvvnWrAbuXeh4qhqFMdLzqLlJZQkR/XvtzXYsJnKzqC7sl4Mpr9yiRh2d+bBDPfADr+up7w4GQmGq/4nqxhZtXwSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOzwsDs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOzwsDs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350A1C2BCB8;
	Mon,  4 May 2026 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903920;
	bh=xp620e8qRzOPnfS/q19ZoZpfrqWWIfA4U/ELnb8CQLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOzwsDs0EMhU3ZW5aZcQaXOCiaAiTjMZ0ifCqhrGQAh9dAd298kHI5wwjpXLXMLbb
	 EjohMXwIApdqpDGv+vughlIjBjaECRYZS6wNDlOOGKxhvlCaRdFDiMuAoibc/F2Nb+
	 Q18mHt1bK++p1pVJv3rbWUbKExHWWp6obn9y/pLE=
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
Subject: [PATCH 6.18 113/275] rxrpc: Fix re-decryption of RESPONSE packets
Date: Mon,  4 May 2026 15:50:53 +0200
Message-ID: <20260504135147.107529718@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -285,7 +285,6 @@
 	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
 	EM(rxrpc_conn_put_work,			"PUT work    ") \
 	EM(rxrpc_conn_queue_challenge,		"QUE chall   ") \
-	EM(rxrpc_conn_queue_retry_work,		"QUE retry-wk") \
 	EM(rxrpc_conn_queue_rx_work,		"QUE rx-work ") \
 	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
 	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -389,7 +389,6 @@ again:
 static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 {
 	struct sk_buff *skb;
-	int ret;
 
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
 		rxrpc_secure_connection(conn);
@@ -398,17 +397,8 @@ static void rxrpc_do_process_connection(
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
 


