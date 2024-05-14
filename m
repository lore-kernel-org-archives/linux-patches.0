Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A39313A272;
	Tue, 14 May 2024 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684706; cv=none; b=PfHwNyloVETKsuZGImIaXxfhK25312WrbKOM+mqUyPftJZmwxq7JbDfA3Ac/UbvqxLPZBb5bfm8RYHwuI7L2Zlzkw3qo0o+ykzKzhDSStwlHpb7FkCUoTuQfeQSay9+SSxWnJpL6raYu6tidaGeMDPCiqyXQwvMXY5mgBXOdG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684706; c=relaxed/simple;
	bh=8kpMxIrJDA6DxYiFDyetO7+SKkmYLjtZiz73OcnTT94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhRNYSPo45bOnN8xBFGKlt70fSIWHD9V9kxJbrfZq/JXdYC+XQ3MulHBjnUxljk8jVxdDp6Wp6eizRfQgcszKkNu7RWEVVzt+mcogyTujsRGaoOO7wxFwn0h6QbOnv3B42cOz9Gpl45hQz5yNkYTZ8xDRF+z1jrYwGaDvO1sAhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDXlSjOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDXlSjOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B9DC2BD10;
	Tue, 14 May 2024 11:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684706;
	bh=8kpMxIrJDA6DxYiFDyetO7+SKkmYLjtZiz73OcnTT94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDXlSjObojq/6p6DsdX+IjXw7k6eZ/ZvDTat8prhVtFR1qdUTkMwC/Rf47dWlvDI6
	 T4bhAvxjxZXMOJR/822jkaX5q81gq3qFSm7UioPb/woqaBin6ZwE3AHglReMtcFyuu
	 +PJPcYKDsN6jQdLO10yFhJ4/i5OQ1TVLsvQvuyTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/301] rxrpc: Clients must accept conn from any address
Date: Tue, 14 May 2024 12:15:49 +0200
Message-ID: <20240514101035.194141226@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



