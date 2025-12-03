Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA3C3446AB;
	Wed,  3 Dec 2025 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777853; cv=none; b=ip7GfHa4DZsTgpLNlVusA41G87TylhDT7j7ECUp7xISm0elwmtJUGDsQJ64+HqiE0wbNzqQwutLdLtM+lW/Rc7NCnFTEHzfmHN34Kqgtgsx8k7mE3ZibUjmDa3LFUU1UJHY/tP0kGQuSt9vBWtPgOmxHf7xx+v8ai9v2T9NerVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777853; c=relaxed/simple;
	bh=fsK8LqSW+Def1DtDXeN+qA4ESwvHWEgn59CYOIvVaqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7aI1/d7eZMV/fADyq7poKmZExr8I/cPnSsyzlktxGPNv7bH3jenP2SW9m4rAOyQk54KFLaqstmjXWhVTMDro9oxXoYDmbr3mp1ePqgz/z3TIVysjKUm72UUJjnoAN3loL8uTCE2vh1Zoc3fhY+o1E4/fuaBXpmdr0mXBi8nciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emuKrZ7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emuKrZ7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC299C4CEF5;
	Wed,  3 Dec 2025 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777853;
	bh=fsK8LqSW+Def1DtDXeN+qA4ESwvHWEgn59CYOIvVaqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emuKrZ7O85dVKzzR54DmKXLXpBq1ynCFhfCvSD5jOhQAquG7nzcNmn5KLSgbiRwQo
	 +uM2WMZLBQFeRkBhtAPSz6Ls23fuQVYvyxcOtMN3eqRgUTfIwJ6QrdQ0MruxvxkpP/
	 C7hg1VnT7ggP0QiwuFuBejkOHXyz0tzoHkpl8Cpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/392] net: call cond_resched() less often in __release_sock()
Date: Wed,  3 Dec 2025 16:24:44 +0100
Message-ID: <20251203152419.022432231@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 645860eace46d..b4e605ac79c9f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2716,23 +2716,27 @@ void __release_sock(struct sock *sk)
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



