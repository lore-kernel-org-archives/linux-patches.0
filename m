Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC4129D06;
	Tue, 14 May 2024 10:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682713; cv=none; b=N6VMpsbM+d9TcE9rLlO+ew01ppO3RpXHe0W+mRkyq6QcBnTbrYAGNbHjpmRDR/snmC5Q1cAxQnxzklyU5IuUEtCBX5kG8twreESSIsLpFpUVe3XnkR+0Mvn72a3X/iR2uIYnYizT1ToMf4fEZ7C2LKqg1rLMhdjSqVxynep/DBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682713; c=relaxed/simple;
	bh=WgSDYBxn8FNRfC9gVOoj6bkEuXTlHgaJUztt/4j7INE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXMSs5LnrXUdJwUrtAVoIlhda2kV7LUlHywSiSS4aZkpmBd17Lt9DgBvzRBPI4aAa2I0Ehn7UtGHci7/Od0lgquBl5alcrd6ZBEdY01TJevbhs9LQpbsfXD4lWJxwdbWvUhmQt74tXYU/mj43dS4lRcrPXSdpvMKdB8xNTm+hd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgZDhmM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgZDhmM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA4AC2BD10;
	Tue, 14 May 2024 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682713;
	bh=WgSDYBxn8FNRfC9gVOoj6bkEuXTlHgaJUztt/4j7INE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgZDhmM9OdwPFUCemPpGZjJ+8Sc3uJSeez3o9wEyzmi8dh1UPqzVRHEwGMUgbYQtZ
	 b3ZnSJ3pHkOwuAUdq+F7QqQhwxqsyjyr310u4fR4yYED/tEaQTU4W8DdncpMAWSfkc
	 CzTZmExSRLnjGVuP5TI5w0aqhXz5gdGJmR2reF0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 076/336] rxrpc: Clients must accept conn from any address
Date: Tue, 14 May 2024 12:14:40 +0200
Message-ID: <20240514101041.474982715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Altman <jaltman@auristor.com>

[ Upstream commit 8953285d7bd63c12b007432a9b4587fa2fad49fb ]

The find connection logic of Transarc's Rx was modified in the mid-1990s
to support multi-homed servers which might send a response packet from
an address other than the destination address in the received packet.
The rules for accepting a packet by an Rx initiator (RX_CLIENT_CONNECTION)
were altered to permit acceptance of a packet from any address provided
that the port number was unchanged and all of the connection identifiers
matched (Epoch, CID, SecurityClass, ...).

This change applies the same rules to the Linux implementation which makes
it consistent with IBM AFS 3.6, Arla, OpenAFS and AuriStorFS.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Jeffrey Altman <jaltman@auristor.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Link: https://lore.kernel.org/r/20240419163057.4141728-1-marc.dionne@auristor.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_object.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index df8a271948a1c..7aa58129ae455 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -118,18 +118,13 @@ struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_local *lo
 	switch (srx->transport.family) {
 	case AF_INET:
 		if (peer->srx.transport.sin.sin_port !=
-		    srx->transport.sin.sin_port ||
-		    peer->srx.transport.sin.sin_addr.s_addr !=
-		    srx->transport.sin.sin_addr.s_addr)
+		    srx->transport.sin.sin_port)
 			goto not_found;
 		break;
 #ifdef CONFIG_AF_RXRPC_IPV6
 	case AF_INET6:
 		if (peer->srx.transport.sin6.sin6_port !=
-		    srx->transport.sin6.sin6_port ||
-		    memcmp(&peer->srx.transport.sin6.sin6_addr,
-			   &srx->transport.sin6.sin6_addr,
-			   sizeof(struct in6_addr)) != 0)
+		    srx->transport.sin6.sin6_port)
 			goto not_found;
 		break;
 #endif
-- 
2.43.0



