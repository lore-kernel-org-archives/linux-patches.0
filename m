Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101181C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC2FC433EF;
	Wed, 28 Dec 2022 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246004;
	bh=P3WyXf/dSs53dEmUuSCUh+K09nP3kH1MZb9L2SNHszw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dG1BsAit6QfTr+WsLwwV3OXb7evyBHfavpPLfRwK3K6SyB6Xxoulv0Nua9nuQfa+6
	 17XpYUBxKceE9hPLIQ01LvKx/UbZKUM2Nfh2o0eipPNbjUGsfcBXdYv2TlrxITcrb2
	 /iaE2CXv7oTA72ByzS4YYjzXdpneJRRk5aWFAKC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changheon Lee <darklight2357@icloud.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0930/1146] net: stream: purge sk_error_queue in sk_stream_kill_queues()
Date: Wed, 28 Dec 2022 15:41:09 +0100
Message-Id: <20221228144355.544126930@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3 ]

Changheon Lee reported TCP socket leaks, with a nice repro.

It seems we leak TCP sockets with the following sequence:

1) SOF_TIMESTAMPING_TX_ACK is enabled on the socket.

   Each ACK will cook an skb put in error queue, from __skb_tstamp_tx().
   __skb_tstamp_tx() is using skb_clone(), unless
   SOF_TIMESTAMPING_OPT_TSONLY was also requested.

2) If the application is also using MSG_ZEROCOPY, then we put in the
   error queue cloned skbs that had a struct ubuf_info attached to them.

   Whenever an struct ubuf_info is allocated, sock_zerocopy_alloc()
   does a sock_hold().

   As long as the cloned skbs are still in sk_error_queue,
   socket refcount is kept elevated.

3) Application closes the socket, while error queue is not empty.

Since tcp_close() no longer purges the socket error queue,
we might end up with a TCP socket with at least one skb in
error queue keeping the socket alive forever.

This bug can be (ab)used to consume all kernel memory
and freeze the host.

We need to purge the error queue, with proper synchronization
against concurrent writers.

Fixes: 24bcbe1cc69f ("net: stream: don't purge sk_error_queue in sk_stream_kill_queues()")
Reported-by: Changheon Lee <darklight2357@icloud.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/stream.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/stream.c b/net/core/stream.c
index 75fded8495f5..516895f48235 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,6 +196,12 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
+	/* Next, the error queue.
+	 * We need to use queue lock, because other threads might
+	 * add packets to the queue without socket lock being held.
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
+
 	/* Next, the write queue. */
 	WARN_ON_ONCE(!skb_queue_empty(&sk->sk_write_queue));
 
-- 
2.35.1



