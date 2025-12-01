Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8A72BE655;
	Mon,  1 Dec 2025 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588526; cv=none; b=bnb+uuEruvrZz/Hc8GE3pLmwFEFe7EuHEu8yjvax4wyr5IWk0C/4R+ZNGZdYXlJbceZlMZppJgXka4Ig9KNhnpwyoAf3FUUyfvucLHRTfdu+FofuemIOikdnFoCuPEflYSzDKcQURWeex+6inOJ/rfqa6msjaOH3XxgTlqez0pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588526; c=relaxed/simple;
	bh=zl698v5vXjSUWjnbK/kswfbRs9JBmhQlMpAteQ0BH6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im+pXz5bLJBjVvkqFGVozle0iqVrMtV4kmnK27ZzPyu/eBQjWk7bs5eCDC7Mhp8HXwl751lxe9eUzGSgv+7/RL9yGLGII1IGmMHYMNydWrxIFYaxIus0ewz6b8fuTVtJfsChguJaSnMIAO9imzrlxjQcqswSWBFtPaA2mQaIA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdHFWMCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdHFWMCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CA7C4CEF1;
	Mon,  1 Dec 2025 11:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588526;
	bh=zl698v5vXjSUWjnbK/kswfbRs9JBmhQlMpAteQ0BH6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdHFWMCWR2+nSV230ATb6/qjWgar9sMiC+ng+Guxk8FvA5OjU6XppFk1oo3qQD7dU
	 g5dmMMyPv/zi90aZs4xzVQ9bXk9K2UF8vNfw5sGq+9ROTBNENP2wrIWF6wVonBJIzW
	 3FxZw8j5+JgnKtD6z/sWz7xIqrJr/fg/iCAoyEhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/187] net: call cond_resched() less often in __release_sock()
Date: Mon,  1 Dec 2025 12:23:06 +0100
Message-ID: <20251201112244.049486681@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 16c610162d1f1c332209de1c91ffb09b659bb65d ]

While stress testing TCP I had unexpected retransmits and sack packets
when a single cpu receives data from multiple high-throughput flows.

super_netperf 4 -H srv -T,10 -l 3000 &

Tcpdump extract:

 00:00:00.000007 IP6 clnt > srv: Flags [.], seq 26062848:26124288, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 61440
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26124288:26185728, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [P.], seq 26185728:26243072, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 57344
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26243072:26304512, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [.], seq 26304512:26365952, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 61440
 00:00:00.000007 IP6 clnt > srv: Flags [P.], seq 26365952:26423296, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 57344
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26423296:26484736, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [.], seq 26484736:26546176, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [P.], seq 26546176:26603520, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 57344
 00:00:00.003932 IP6 clnt > srv: Flags [P.], seq 26603520:26619904, ack 1, win 66, options [nop,nop,TS val 651464844 ecr 3100753141], length 16384
 00:00:00.006602 IP6 clnt > srv: Flags [.], seq 24862720:24866816, ack 1, win 66, options [nop,nop,TS val 651471419 ecr 3100759716], length 4096
 00:00:00.013000 IP6 clnt > srv: Flags [.], seq 24862720:24866816, ack 1, win 66, options [nop,nop,TS val 651484421 ecr 3100772718], length 4096
 00:00:00.000416 IP6 srv > clnt: Flags [.], ack 26619904, win 1393, options [nop,nop,TS val 3100773185 ecr 651484421,nop,nop,sack 1 {24862720:24866816}], length 0

After analysis, it appears this is because of the cond_resched()
call from  __release_sock().

When current thread is yielding, while still holding the TCP socket lock,
it might regain the cpu after a very long time.

Other peer TLP/RTO is firing (multiple times) and packets are retransmit,
while the initial copy is waiting in the socket backlog or receive queue.

In this patch, I call cond_resched() only once every 16 packets.

Modern TCP stack now spends less time per packet in the backlog,
especially because ACK are no longer sent (commit 133c4c0d3717
"tcp: defer regular ACK while processing socket backlog")

Before:

clnt:/# nstat -n;sleep 10;nstat|egrep "TcpOutSegs|TcpRetransSegs|TCPFastRetrans|TCPTimeouts|Probes|TCPSpuriousRTOs|DSACK"
TcpOutSegs                      19046186           0.0
TcpRetransSegs                  1471               0.0
TcpExtTCPTimeouts               1397               0.0
TcpExtTCPLossProbes             1356               0.0
TcpExtTCPDSACKRecv              1352               0.0
TcpExtTCPSpuriousRTOs           114                0.0
TcpExtTCPDSACKRecvSegs          1352               0.0

After:

clnt:/# nstat -n;sleep 10;nstat|egrep "TcpOutSegs|TcpRetransSegs|TCPFastRetrans|TCPTimeouts|Probes|TCPSpuriousRTOs|DSACK"
TcpOutSegs                      19218936           0.0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250903174811.1930820-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index a737cea1835f3..6660032866e7d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2456,23 +2456,27 @@ void __release_sock(struct sock *sk)
 	__acquires(&sk->sk_lock.slock)
 {
 	struct sk_buff *skb, *next;
+	int nb = 0;
 
 	while ((skb = sk->sk_backlog.head) != NULL) {
 		sk->sk_backlog.head = sk->sk_backlog.tail = NULL;
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		do {
+		while (1) {
 			next = skb->next;
 			prefetch(next);
 			WARN_ON_ONCE(skb_dst_is_noref(skb));
 			skb_mark_not_on_list(skb);
 			sk_backlog_rcv(sk, skb);
 
-			cond_resched();
-
 			skb = next;
-		} while (skb != NULL);
+			if (!skb)
+				break;
+
+			if (!(++nb & 15))
+				cond_resched();
+		}
 
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
-- 
2.51.0



