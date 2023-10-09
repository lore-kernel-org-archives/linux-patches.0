Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E922D19464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5RZ0T1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578F1C433C8;
	Mon,  9 Oct 2023 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857178;
	bh=rD37c8OTgOyEicguaV8zP5NpyN9wTxxpemuw3GuQ57E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5RZ0T1T0SSSwRiZAyigFFbNnhitlfPvroWMnfUw7ysygWJTAye8sYuiGet7DyQS7
	 0YYKRC+MMTRhzJV0Q4OIkUO2HQzLPwmZBFAE5gMxc4MIa6iVf2ghqvbAGJpMT3y/xc
	 QL8OVD6u08fdibV1IfGVXLsYwgpxolRZpEBIZrCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 097/163] bpf: tcp_read_skb needs to pop skb regardless of seq
Date: Mon,  9 Oct 2023 15:01:01 +0200
Message-ID: <20231009130126.708524790@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 9b7177b1df64b8d7f85700027c324aadd6aded00 ]

Before fix e5c6de5fa0258 tcp_read_skb() would increment the tp->copied-seq
value. This (as described in the commit) would cause an error for apps
because once that is incremented the application might believe there is no
data to be read. Then some apps would stall or abort believing no data is
available.

However, the fix is incomplete because it introduces another issue in
the skb dequeue. The loop does tcp_recv_skb() in a while loop to consume
as many skbs as possible. The problem is the call is ...

  tcp_recv_skb(sk, seq, &offset)

... where 'seq' is:

  u32 seq = tp->copied_seq;

Now we can hit a case where we've yet incremented copied_seq from BPF side,
but then tcp_recv_skb() fails this test ...

 if (offset < skb->len || (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN))

... so that instead of returning the skb we call tcp_eat_recv_skb() which
frees the skb. This is because the routine believes the SKB has been collapsed
per comment:

 /* This looks weird, but this can happen if TCP collapsing
  * splitted a fat GRO packet, while we released socket lock
  * in skb_splice_bits()
  */

This can't happen here we've unlinked the full SKB and orphaned it. Anyways
it would confuse any BPF programs if the data were suddenly moved underneath
it.

To fix this situation do simpler operation and just skb_peek() the data
of the queue followed by the unlink. It shouldn't need to check this
condition and tcp_read_skb() reads entire skbs so there is no need to
handle the 'offset!=0' case as we would see in tcp_read_sock().

Fixes: e5c6de5fa0258 ("bpf, sockmap: Incorrectly handling copied_seq")
Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230926035300.135096-2-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 75f24b931a185..9cfc07d1e4252 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1618,16 +1618,13 @@ EXPORT_SYMBOL(tcp_read_sock);
 
 int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
-	u32 seq = tp->copied_seq;
 	struct sk_buff *skb;
 	int copied = 0;
-	u32 offset;
 
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
 
-	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+	while ((skb = skb_peek(&sk->sk_receive_queue)) != NULL) {
 		u8 tcp_flags;
 		int used;
 
@@ -1640,13 +1637,10 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 				copied = used;
 			break;
 		}
-		seq += used;
 		copied += used;
 
-		if (tcp_flags & TCPHDR_FIN) {
-			++seq;
+		if (tcp_flags & TCPHDR_FIN)
 			break;
-		}
 	}
 	return copied;
 }
-- 
2.40.1



