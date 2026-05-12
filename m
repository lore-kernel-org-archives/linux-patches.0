Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3033B1EE2;
	Tue, 12 May 2026 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607761; cv=none; b=QNz99Txeh60SGwsvCalLXI7ua9eqz/9aqwAVM6ifgwVPF3a2cdEmmFt+OAtGuaewfRamTEpUtmUSNCO9701RMFP++YF276aHmQ8mBp7GmsGqmPhEzkfhUAuAx9Q3byeo31H42eNb2TSQ37zoPlZAkw0YeDcn9slOK5S1Nn4vDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607761; c=relaxed/simple;
	bh=8UoSB76PEeOOzuX9KrFIbqYSlUZy7CMSdDiwdFpre/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER0wLECvEuQI65hwn8LfGXScn00qgltc0PZ2E53DQ9EOxaroYeU8d6e+dTParzS1dfJ8QdtZ76fAh5vPxRDstU9DF4w3hyoOStoeqq/IsUPiEOfpwUei75DT2dCODhpVrSwQihpo1kPAW4MLgJT4ycwzhXMPyPKlHZXpC1OvYdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGxMYeld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGxMYeld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018DCC2BCB0;
	Tue, 12 May 2026 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607761;
	bh=8UoSB76PEeOOzuX9KrFIbqYSlUZy7CMSdDiwdFpre/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGxMYeldTDl23u8Zw3nKfEZWzNIkaUZ1xQgUdn1ZcuAg/JzxB6PxomoAfji7zgSGt
	 wBlo7F+toPVQRZfdDGRGn+4cNUuI5Z2ATJmfdBShQmfqZwaDQz2n87a2GbP/qpTUNB
	 lO2FWcDlb+mdfa8tHGzEfqEEyk3Vm+kRzKaSDjhE=
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
	Jakub Kicinski <kuba@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/206] rxrpc: Fix conn-level packet handling to unshare RESPONSE packets
Date: Tue, 12 May 2026 19:37:58 +0200
Message-ID: <20260512173933.381706230@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 24481a7f573305706054c59e275371f8d0fe919f upstream.

The security operations that verify the RESPONSE packets decrypt bits of it
in place - however, the sk_buff may be shared with a packet sniffer, which
would lead to the sniffer seeing an apparently corrupt packet (actually
decrypted).

Fix this by handing a copy of the packet off to the specific security
handler if the packet was cloned.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Readd rxrpc_skb_put_response_copy which missed in bf20f46d94f1 in v6.12.86]
Stable-dep-of: aa54b1d27fe0 ("rxrpc: Also unshare DATA/RESPONSE packets when
paged frags are present")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  1 +
 net/rxrpc/conn_event.c       | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 9377acad0c5f9..63efc9e4e4102 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -146,6 +146,7 @@
 	EM(rxrpc_skb_put_jumbo_subpacket,	"PUT jumbo-sub") \
 	EM(rxrpc_skb_put_last_nack,		"PUT last-nack") \
 	EM(rxrpc_skb_put_purge,			"PUT purge    ") \
+	EM(rxrpc_skb_put_response_copy,		"PUT resp-cpy ") \
 	EM(rxrpc_skb_put_rotate,		"PUT rotate   ") \
 	EM(rxrpc_skb_put_unknown,		"PUT unknown  ") \
 	EM(rxrpc_skb_see_conn_work,		"SEE conn-work") \
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 82cc72123c9c9..6dcfaed1f7485 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -226,6 +226,33 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
 		rxrpc_notify_socket(call);
 }
 
+static int rxrpc_verify_response(struct rxrpc_connection *conn,
+				 struct sk_buff *skb)
+{
+	int ret;
+
+	if (skb_cloned(skb)) {
+		/* Copy the packet if shared so that we can do in-place
+		 * decryption.
+		 */
+		struct sk_buff *nskb = skb_copy(skb, GFP_NOFS);
+
+		if (nskb) {
+			rxrpc_new_skb(nskb, rxrpc_skb_new_unshared);
+			ret = conn->security->verify_response(conn, nskb);
+			rxrpc_free_skb(nskb, rxrpc_skb_put_response_copy);
+		} else {
+			/* OOM - Drop the packet. */
+			rxrpc_see_skb(skb, rxrpc_skb_see_unshare_nomem);
+			ret = -ENOMEM;
+		}
+	} else {
+		ret = conn->security->verify_response(conn, skb);
+	}
+
+	return ret;
+}
+
 /*
  * connection-level Rx packet processor
  */
@@ -253,7 +280,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		}
 		spin_unlock(&conn->state_lock);
 
-		ret = conn->security->verify_response(conn, skb);
+		ret = rxrpc_verify_response(conn, skb);
 		if (ret < 0)
 			return ret;
 
-- 
2.53.0



