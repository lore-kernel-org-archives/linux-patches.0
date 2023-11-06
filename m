Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61263208CA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT9A7crW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF65EC433C7;
	Mon,  6 Nov 2023 13:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277069;
	bh=7h6c470TrNzm/Rvpp93aPVaN760bVjhOko6uRGHROfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT9A7crW7hGU1XzM/JMDtd+LoMqK4EQIVs9q69FzGyt0cH7FLvv8U8H3iZkcfMki0
	 41ruZJ+BvBnmwjR6VUZL5mplb7ULOkprJUP4RbKYU3L0msW+ax0uxyk7ofMyYMpw8K
	 A3DqdrJJDYAEo3f8x8YCNeBhZIjlwZ+1NJuSN67g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/128] tcp: remove dead code from tcp_sendmsg_locked()
Date: Mon,  6 Nov 2023 14:02:44 +0100
Message-ID: <20231106130309.319444675@linuxfoundation.org>
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

[ Upstream commit 3ded97bc41a1e76e1e72eeb192331c01ceacc4bc ]

TCP sendmsg() no longer puts payload in skb head, we can remove
dead code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 72377ab2d671 ("mptcp: more conservative check for zero probes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a91cf000bb61b..2115a0e5c98f7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1330,14 +1330,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		/* Where to copy to? */
-		if (skb_availroom(skb) > 0 && !zc) {
-			/* We have some space in skb head. Superb! */
-			copy = min_t(int, copy, skb_availroom(skb));
-			err = skb_add_data_nocache(sk, skb, &msg->msg_iter, copy);
-			if (err)
-				goto do_fault;
-		} else if (!zc) {
+		if (!zc) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
@@ -1437,7 +1430,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 do_error:
 	skb = tcp_write_queue_tail(sk);
-do_fault:
 	tcp_remove_empty_skb(sk, skb);
 
 	if (copied + copied_syn)
-- 
2.42.0



