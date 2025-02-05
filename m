Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745431519BF;
	Wed,  5 Feb 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768014; cv=none; b=mcqT6hfxbNNp6rdhG0BpQrBD9mvYVGT6dk9g+e170263Jxk4Q8q0OqWQJY3i21EhvLXZ3gOvOTtkIOZYPFqXl1d2j/emWibrcvlfbqEuAKpMzl8cQ+7BJzhJBnOb92+zRoIDXBGgHO1+X6fXgjuqP4+77a2GWuw62waAKSFoIWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768014; c=relaxed/simple;
	bh=rAKyGmigLr84BWmXp15RmllqIwyyxqAly/DtaBMk1BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rx8mU0i/bPqA7BIjzI1FIZ+rkLBqlA2FHTbZLpPTrD/0iqOTWbVqU2HTTJdP8KvnEgViMpE22qO3xAUXdaRPBKJIS9wwztsirrU21+HzRD3u8WZaW+dHU3u8UWtfDQKUT32BLV8FxSbW/u0gIj4ca8ksq3ID23STZkNp8iyMi4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1dyv03B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1dyv03B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EA9C4CED1;
	Wed,  5 Feb 2025 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768014;
	bh=rAKyGmigLr84BWmXp15RmllqIwyyxqAly/DtaBMk1BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1dyv03Bp0c3OJ1S2CzWXDchF1B90mBALupvd5hFoKrguEvTkBY598jGxb7CM+gsU
	 oKvCBwrm1Hj9fSIz/6ij2JUGLIMyYjLao908EuG71gZwzkREjXvQT2Rb9qyljl1zI5
	 +yma4rRHExfAUOfG3MLI7pU6LIykQSZMqOiu3VfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 542/590] Revert "SUNRPC: Reduce thread wake-up rate when receiving large RPC messages"
Date: Wed,  5 Feb 2025 14:44:57 +0100
Message-ID: <20250205134516.008794177@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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


