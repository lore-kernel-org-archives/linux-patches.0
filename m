Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB89208CA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0Xx8f94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD476C433C7;
	Mon,  6 Nov 2023 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277072;
	bh=m7kZxp9YJ+w1CFke/YjCqM+oYbSGYOT2IfPwhhCm+L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0Xx8f940uLlz8CGrbqklvqp0XrLDDuwrFMw3WsxdO6yP49JZZQUME8Ir6pvVSiPf
	 7ZRsFMFRdGhkCjllf9fdVLxEYbODyyV/qSFLkeXD1a1fwIwzfW7T84/6Ozr1B+Yoz/
	 6Zjq9o7tlU3+V2kyO5OWXA6jmLifWhcPlRrgQ4YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/128] tcp: cleanup tcp_remove_empty_skb() use
Date: Mon,  6 Nov 2023 14:02:45 +0100
Message-ID: <20231106130309.360557355@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 27728ba80f1eb279b209bbd5922fdeebe52d9e30 ]

All tcp_remove_empty_skb() callers now use tcp_write_queue_tail()
for the skb argument, we can therefore factorize code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 72377ab2d671 ("mptcp: more conservative check for zero probes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    | 2 +-
 net/ipv4/tcp.c       | 9 +++++----
 net/mptcp/protocol.c | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e93a48edf438c..3aee02ad0116b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -314,7 +314,7 @@ void tcp_shutdown(struct sock *sk, int how);
 int tcp_v4_early_demux(struct sk_buff *skb);
 int tcp_v4_rcv(struct sk_buff *skb);
 
-void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb);
+void tcp_remove_empty_skb(struct sock *sk);
 int tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2115a0e5c98f7..6dcb77a2bde60 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -953,8 +953,10 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
  * users.
  */
-void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
+void tcp_remove_empty_skb(struct sock *sk)
 {
+	struct sk_buff *skb = tcp_write_queue_tail(sk);
+
 	if (skb && TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
@@ -1107,7 +1109,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 	return copied;
 
 do_error:
-	tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
+	tcp_remove_empty_skb(sk);
 	if (copied)
 		goto out;
 out_err:
@@ -1429,8 +1431,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	return copied + copied_syn;
 
 do_error:
-	skb = tcp_write_queue_tail(sk);
-	tcp_remove_empty_skb(sk, skb);
+	tcp_remove_empty_skb(sk);
 
 	if (copied + copied_syn)
 		goto out;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 82b1583f709d3..b9613e02e2de1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1338,7 +1338,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
 		if (snd_una != msk->snd_nxt) {
-			tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
+			tcp_remove_empty_skb(ssk);
 			return 0;
 		}
 
@@ -1354,7 +1354,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 	copy = min_t(size_t, copy, info->limit - info->sent);
 	if (!sk_wmem_schedule(ssk, copy)) {
-		tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
+		tcp_remove_empty_skb(ssk);
 		return -ENOMEM;
 	}
 
-- 
2.42.0



