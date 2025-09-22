Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2B222590;
	Mon, 22 Sep 2025 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570106; cv=none; b=R2esMIcCxrH0PWrMDgMhdL96vcukcG+eT6a2koffkkHgCxqRpJpOE2bqCK2HIdqR+NEMT1xj1uCXo+A9UtSc02ng+VbYGMAsro/VSAfuABtVkfQ+wfaqTn//Q1nI90Pe63oelK1O60El1n6lbh5tbv0n077a39gv24OljklJkqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570106; c=relaxed/simple;
	bh=KIh6z2VMbWgG8w9CBvf+lF3QW73HaHYrEQ2bYjRsx3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARNsaIoWWTcS1Wrlek4fJIh4YWFTazThDY2ke6tvPmUVDmFXgeRqvnxD6DhsJVgj4glITYzQPpUbKynBI2oT2xqJY+b1nrvoZli7yrAAFCnGS68RbVIlospKpoGj49fzQ8vqBeQN4Ejrnrj3tYvOTiV/ZlDj0JGN9rLmjP4Dqi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6O6WNhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6O6WNhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E85C4CEF0;
	Mon, 22 Sep 2025 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570106;
	bh=KIh6z2VMbWgG8w9CBvf+lF3QW73HaHYrEQ2bYjRsx3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6O6WNhJVDg2v0np8JlpU0ubDPAzGes6exGMj+u+muFE8pqjfZPOTb0Wz54XmqPb0
	 L/0/mlRF6N3RpwaqwaF25R/fiOyaxJMdSJIGoBq0m+tVxE9JjPLt1dmh2f13BhEcST
	 4DWC9WKIlX8Jix/AZalC62OMpcOhxx66zENwTxwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 020/149] rxrpc: Fix untrusted unsigned subtract
Date: Mon, 22 Sep 2025 21:28:40 +0200
Message-ID: <20250922192413.385918783@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2429a197648178cd4dc930a9d87c13c547460564 ]

Fix the following Smatch static checker warning:

   net/rxrpc/rxgk_app.c:65 rxgk_yfs_decode_ticket()
   warn: untrusted unsigned subtract. 'ticket_len - 10 * 4'

by prechecking the length of what we're trying to extract in two places in
the token and decoding for a response packet.

Also use sizeof() on the struct we're extracting rather specifying the size
numerically to be consistent with the other related statements.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lists.infradead.org/pipermail/linux-afs/2025-September/010135.html
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/2039268.1757631977@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxgk_app.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/rxgk_app.c b/net/rxrpc/rxgk_app.c
index df684b5a85314..30275cb5ba3e2 100644
--- a/net/rxrpc/rxgk_app.c
+++ b/net/rxrpc/rxgk_app.c
@@ -54,6 +54,10 @@ int rxgk_yfs_decode_ticket(struct rxrpc_connection *conn, struct sk_buff *skb,
 
 	_enter("");
 
+	if (ticket_len < 10 * sizeof(__be32))
+		return rxrpc_abort_conn(conn, skb, RXGK_INCONSISTENCY, -EPROTO,
+					rxgk_abort_resp_short_yfs_tkt);
+
 	/* Get the session key length */
 	ret = skb_copy_bits(skb, ticket_offset, tmp, sizeof(tmp));
 	if (ret < 0)
@@ -195,22 +199,23 @@ int rxgk_extract_token(struct rxrpc_connection *conn, struct sk_buff *skb,
 		__be32 token_len;
 	} container;
 
+	if (token_len < sizeof(container))
+		goto short_packet;
+
 	/* Decode the RXGK_TokenContainer object.  This tells us which server
 	 * key we should be using.  We can then fetch the key, get the secret
 	 * and set up the crypto to extract the token.
 	 */
 	if (skb_copy_bits(skb, token_offset, &container, sizeof(container)) < 0)
-		return rxrpc_abort_conn(conn, skb, RXGK_PACKETSHORT, -EPROTO,
-					rxgk_abort_resp_tok_short);
+		goto short_packet;
 
 	kvno		= ntohl(container.kvno);
 	enctype		= ntohl(container.enctype);
 	ticket_len	= ntohl(container.token_len);
 	ticket_offset	= token_offset + sizeof(container);
 
-	if (xdr_round_up(ticket_len) > token_len - 3 * 4)
-		return rxrpc_abort_conn(conn, skb, RXGK_PACKETSHORT, -EPROTO,
-					rxgk_abort_resp_tok_short);
+	if (xdr_round_up(ticket_len) > token_len - sizeof(container))
+		goto short_packet;
 
 	_debug("KVNO %u", kvno);
 	_debug("ENC  %u", enctype);
@@ -285,4 +290,8 @@ int rxgk_extract_token(struct rxrpc_connection *conn, struct sk_buff *skb,
 	 * also come out this way if the ticket decryption fails.
 	 */
 	return ret;
+
+short_packet:
+	return rxrpc_abort_conn(conn, skb, RXGK_PACKETSHORT, -EPROTO,
+				rxgk_abort_resp_tok_short);
 }
-- 
2.51.0



