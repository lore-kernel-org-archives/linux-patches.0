Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493D3FFE;
	Tue, 23 Jan 2024 00:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970957; cv=none; b=eS1UPm5Q5MQGkkaEQUHnc96u0nIsJLiYgjnasIS7QL/qidBBV1t/WPnsVgE1UGCellBFLthBxnPX/AfonxSN5mlo5M0DLtqKKkp3x8I1YVxi4M6YVodPum6F9owKfBTiNNyb20SsS/9clTpCigp15jQU1TzWmFARvqr/7/zFU2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970957; c=relaxed/simple;
	bh=8A6d55sYxPzABNhgWFWTzbp2KA7u0YveM37NLL+x+LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0DcDIto1K7KxwdfZ1Frn8wN44cKl2htrbF/EaTZLfq0Z3POz9+O/M6OmNODnfSgfRw8yBQDztS/9qO1BQjIFa/ltAXffzca1/Za+A8qUNwJNyAIt8HXKrc/ixYWGHRy2a/YbZ1A6p8x8oE3RQuD5UPPXwRjQTuLzQuHz9zBSsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFZCID5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFZCID5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC8C43390;
	Tue, 23 Jan 2024 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970956;
	bh=8A6d55sYxPzABNhgWFWTzbp2KA7u0YveM37NLL+x+LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFZCID5JpWnTg5ik+gTEpg4Pwa15QFtt0PLbB0Hs4nl4aL8vhPD+Z3zHfGX5xoR6m
	 Ra0DQr8vS6jYxEWZvpzIw/s8H4hXpjZGAhqSlSkXYR287+1QmvJNNoKJayTCOjuBTZ
	 CXLtmnsKvjwKduh0AWtq4iEwKQBCS3go+OxyeXUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/417] sctp: support MSG_ERRQUEUE flag in recvmsg()
Date: Mon, 22 Jan 2024 15:55:17 -0800
Message-ID: <20240122235756.993769404@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4746b36b1abe11ca32987b2d21e1e770deab17cc ]

For some reason sctp_poll() generates EPOLLERR if sk->sk_error_queue
is not empty but recvmsg() can not drain the error queue yet.

This is needed to better support timestamping.

I had to export inet_recv_error(), since sctp
can be compiled as a module.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20231212145550.3872051-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a562c0a2d651 ("sctp: fix busy polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 1 +
 net/sctp/socket.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 347c3768df6e..c13b8ed63f87 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1642,6 +1642,7 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 #endif
 	return -EINVAL;
 }
+EXPORT_SYMBOL(inet_recv_error);
 
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e25dc1709131..da56832179f0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2098,6 +2098,9 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	pr_debug("%s: sk:%p, msghdr:%p, len:%zd, flags:0x%x, addr_len:%p)\n",
 		 __func__, sk, msg, len, flags, addr_len);
 
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
 	lock_sock(sk);
 
 	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
-- 
2.43.0



