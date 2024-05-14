Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E695219E7;
	Tue, 14 May 2024 11:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687761; cv=none; b=V0VICp7f048EVNy9BW2tFDATk8pyyCZSgNFL2F7NXmtoWJqBpYeXwfCEfQOpHTGyaZqYKtfM58JzR2l2l0B7OBou4rYEsGadfJyS/hTUYN5Bf6rfFPABZfvg0vBlhE8jbaEYcciM1oANUjqIxvSYyBTzqyemhlb867/i85crjKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687761; c=relaxed/simple;
	bh=mOVxdWbQMqWzPIn/juc9XiWijfzMtNMi7qvChB72KFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1y2ZS018bx3tdYxXXOqojE7HMiJOEx1KS03zSBR4dPD7rbTRntvXvFW7uh8tpfh7IQ99EN+5QZVwgJhyggCK/H1Ks8kzPxjrHf/Xc4pxjfkZ9cwegWsR2zHYGpZ0x23aGw734r6Y3N6nz0UQLA/CmVIbGCIeO7KrD7cx4kC5lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcIGMNHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcIGMNHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F3C2BD10;
	Tue, 14 May 2024 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687761;
	bh=mOVxdWbQMqWzPIn/juc9XiWijfzMtNMi7qvChB72KFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcIGMNHFTItUEh+n895wkwnNQq+BCDe+Q/5ShO54Vu/AAVxlumLqOiPnnPyuVJanB
	 MgyRjeNHd4Mwm95tbxUXOZoSpcq+0ZTsNzlc/lD/iyNr50sF6liFrwsYC5cLrJmhbK
	 zOaP7WpOnhKqV7fCAVCdAoLNDCEL+/xKzfg8bYdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/168] bpf, sockmap: TCP data stall on recv before accept
Date: Tue, 14 May 2024 12:19:53 +0200
Message-ID: <20240514101010.276076986@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit ea444185a6bf7da4dd0df1598ee953e4f7174858 ]

A common mechanism to put a TCP socket into the sockmap is to hook the
BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program
that can map the socket info to the correct BPF verdict parser. When
the user adds the socket to the map the psock is created and the new
ops are assigned to ensure the verdict program will 'see' the sk_buffs
as they arrive.

Part of this process hooks the sk_data_ready op with a BPF specific
handler to wake up the BPF verdict program when data is ready to read.
The logic is simple enough (posted here for easy reading)

 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
	struct socket *sock = sk->sk_socket;

	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
		return;
	sock->ops->read_skb(sk, sk_psock_verdict_recv);
 }

The oversight here is sk->sk_socket is not assigned until the application
accepts() the new socket. However, its entirely ok for the peer application
to do a connect() followed immediately by sends. The socket on the receiver
is sitting on the backlog queue of the listening socket until its accepted
and the data is queued up. If the peer never accepts the socket or is slow
it will eventually hit data limits and rate limit the session. But,
important for BPF sockmap hooks when this data is received TCP stack does
the sk_data_ready() call but the read_skb() for this data is never called
because sk_socket is missing. The data sits on the sk_receive_queue.

Then once the socket is accepted if we never receive more data from the
peer there will be no further sk_data_ready calls and all the data
is still on the sk_receive_queue(). Then user calls recvmsg after accept()
and for TCP sockets in sockmap we use the tcp_bpf_recvmsg_parser() handler.
The handler checks for data in the sk_msg ingress queue expecting that
the BPF program has already run from the sk_data_ready hook and enqueued
the data as needed. So we are stuck.

To fix do an unlikely check in recvmsg handler for data on the
sk_receive_queue and if it exists wake up data_ready. We have the sock
locked in both read_skb and recvmsg so should avoid having multiple
runners.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230523025618.113937-7-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e3a9477293ce4..89204004eeb5e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -195,6 +195,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 
 	lock_sock(sk);
+
+	/* We may have received data on the sk_receive_queue pre-accept and
+	 * then we can not use read_skb in this context because we haven't
+	 * assigned a sk_socket yet so have no link to the ops. The work-around
+	 * is to check the sk_receive_queue and in these cases read skbs off
+	 * queue again. The read_skb hook is not running at this point because
+	 * of lock_sock so we avoid having multiple runners in read_skb.
+	 */
+	if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+		tcp_data_ready(sk);
+		/* This handles the ENOMEM errors if we both receive data
+		 * pre accept and are already under memory pressure. At least
+		 * let user know to retry.
+		 */
+		if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+			copied = -EAGAIN;
+			goto out;
+		}
+	}
+
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
-- 
2.43.0



