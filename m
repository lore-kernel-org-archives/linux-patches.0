Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECAF18A6A9;
	Wed,  5 Feb 2025 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768514; cv=none; b=TxdfpvwlBrMeviN/Ewwkkf3huwKJMlpSc9cGA4pOwZvl1YzSxhDWnrfOyowTT4+9GebHtNaOHPcSDWl0eRQtHRS539XrLnX9VyTclUWwKsPk+EoMZQjYPcPELLiyPVgHSXXjCfK5P2lXsCpIGoi1AYc27FM0oqIAVvjzDem9zxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768514; c=relaxed/simple;
	bh=hXyIybBsp44Yd+hWGVVDNxu+dJR+0bA7B6dOzUmd4bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozNNJxtlOHYWSbUOZPl0cuykDvOWR7NwzwCYHEagpsNK2HwO4d/VbECYQJxR7bU0I1oi59ke/9uJCilSYZ5gT8ZbGMIPlX7aO1FYyNiLZvSZOI+JWyB+TUjcN8DmxxbdutTAl/UaOPZdvU5hfg6I7uXkcDE0F3zGSJ3VOuDRO6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLT5Wo2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLT5Wo2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D7BC4CEDD;
	Wed,  5 Feb 2025 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768514;
	bh=hXyIybBsp44Yd+hWGVVDNxu+dJR+0bA7B6dOzUmd4bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLT5Wo2hSrTzKzTAKoivi2igNqBOmeVVAHnYNFMkPxYYD3WCmbpyUKUT0/HudF2HF
	 0Avma4GllxyHObrJkBh8Kk+ukp8H6z2VdIU42myLHKS0ZERvNocreAjP4eenj5Ml36
	 2VxVR515nJ5kkt/QD0fcohI1S0xoSW1ZQn17XdyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 578/623] Revert "SUNRPC: Reduce thread wake-up rate when receiving large RPC messages"
Date: Wed,  5 Feb 2025 14:45:20 +0100
Message-ID: <20250205134518.334644783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 966a675da844f1a764bb44557c21561cc3d09840 upstream.

I noticed that a handful of NFSv3 fstests were taking an
unexpectedly long time to run. Troubleshooting showed that the
server's TCP window closed and never re-opened, which caused the
client to trigger an RPC retransmit timeout after 180 seconds.

The client's recovery action was to establish a fresh connection
and retransmit the timed-out requests. This worked, but it adds a
long delay.

I tracked the problem to the commit that attempted to reduce the
rate at which the network layer delivers TCP socket data_ready
callbacks. Under most circumstances this change worked as expected,
but for NFSv3, which has no session or other type of throttling, it
can overwhelm the receiver on occasion.

I'm sure I could tweak the lowat settings, but the small benefit
doesn't seem worth the bother. Just revert it.

Fixes: 2b877fc53e97 ("SUNRPC: Reduce thread wake-up rate when receiving large RPC messages")
Cc: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1083,9 +1083,6 @@ static void svc_tcp_fragment_received(st
 	/* If we have more data, signal svc_xprt_enqueue() to try again */
 	svsk->sk_tcplen = 0;
 	svsk->sk_marker = xdr_zero;
-
-	smp_wmb();
-	tcp_set_rcvlowat(svsk->sk_sk, 1);
 }
 
 /**
@@ -1175,17 +1172,10 @@ err_incomplete:
 		goto err_delete;
 	if (len == want)
 		svc_tcp_fragment_received(svsk);
-	else {
-		/* Avoid more ->sk_data_ready() calls until the rest
-		 * of the message has arrived. This reduces service
-		 * thread wake-ups on large incoming messages. */
-		tcp_set_rcvlowat(svsk->sk_sk,
-				 svc_sock_reclen(svsk) - svsk->sk_tcplen);
-
+	else
 		trace_svcsock_tcp_recv_short(&svsk->sk_xprt,
 				svc_sock_reclen(svsk),
 				svsk->sk_tcplen - sizeof(rpc_fraghdr));
-	}
 	goto err_noclose;
 error:
 	if (len != -EAGAIN)


