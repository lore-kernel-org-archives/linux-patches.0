Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03361313E28;
	Wed,  3 Dec 2025 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776183; cv=none; b=eFDnIlP4+EQjHtvW/hhE+Oqm8WnTukEspviBCraFbgkE4qWEiXhbGsryPWNaOZbzeiZA2kI6aBTZmmBfOHXvCRO5ddg2vxjS0pk4hD8tjKnyEclqtFlxcZZ5kmA36fC1s5k4Xl1qyOQ33CCh3jkTnyk69gzywevtJ8RHAAUPgeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776183; c=relaxed/simple;
	bh=8M0XLEDYlfmWFrgLot2cLk7JsFN1UImey5q00fTnpWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVeTXUWijaJkchNwcbyChv1fcrjZPy5SqvbjjNGHqCGj9wqGU4qKOWVvg9fiVaYjmQH/plsBIRLUKQ6PiRnDZArcoZO1UPoLY5k6ShTzTA6FPP4vdEb78VifeZDtbqAqG12/kuWHBG2kGvu8yhUK1KrS4a349JcLuPctQH06CuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC88tryR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC88tryR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DFBC4CEF5;
	Wed,  3 Dec 2025 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776182;
	bh=8M0XLEDYlfmWFrgLot2cLk7JsFN1UImey5q00fTnpWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NC88tryR7eYVDL9ZNbFg6udhz5wxOhalImhEBbFrw6NjdxNN21tQwaTb8CqqTYl9W
	 hMGwICFrRmr+m1iSE3lirpYlaHTE681GHkY0v1mjJ+0mmvwsVnF9/4KLN+DN4emXB7
	 /F07YhDfBSfmlX7ZFXRU30oOXoq34WCsF/GKERNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/300] net: call cond_resched() less often in __release_sock()
Date: Wed,  3 Dec 2025 16:25:10 +0100
Message-ID: <20251203152404.549958540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 37f2a79c23b23..6c93381cf0bdf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2561,23 +2561,27 @@ void __release_sock(struct sock *sk)
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



