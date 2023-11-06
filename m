Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72CE200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FnslwhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520F6C433C8;
	Mon,  6 Nov 2023 13:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699275966;
	bh=l4MxhmhEWiMLs+LbkvR3wAlC/H2pdSFYpuoNNjsLPyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FnslwhVhOsHAjfz/iy697nCn6RF/RGh10acIYHOO6hmypHGXZngXUwXJluhvOZkP
	 FIZnSielX6eU203AbfSf2c8MYNR+kt/QLzrO6INu6F+d0VxtGIm7wLlxF4OWtmaGm2
	 8s+OwI/ots97GZuXV6x3X08wM6pm7RWfFPBQyX4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Chen <fred.chenchen03@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/48] tcp: fix wrong RTO timeout when received SACK reneging
Date: Mon,  6 Nov 2023 14:02:58 +0100
Message-ID: <20231106130258.109864930@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fred Chen <fred.chenchen03@gmail.com>

[ Upstream commit d2a0fc372aca561556e765d0a9ec365c7c12f0ad ]

This commit fix wrong RTO timeout when received SACK reneging.

When an ACK arrived pointing to a SACK reneging, tcp_check_sack_reneging()
will rearm the RTO timer for min(1/2*srtt, 10ms) into to the future.

But since the commit 62d9f1a6945b ("tcp: fix TLP timer not set when
CA_STATE changes from DISORDER to OPEN") merged, the tcp_set_xmit_timer()
is moved after tcp_fastretrans_alert()(which do the SACK reneging check),
so the RTO timeout will be overwrited by tcp_set_xmit_timer() with
icsk_rto instead of 1/2*srtt.

Here is a packetdrill script to check this bug:
0     socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+0    bind(3, ..., ...) = 0
+0    listen(3, 1) = 0

// simulate srtt to 100ms
+0    < S 0:0(0) win 32792 <mss 1000, sackOK,nop,nop,nop,wscale 7>
+0    > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 7>
+.1    < . 1:1(0) ack 1 win 1024

+0    accept(3, ..., ...) = 4

+0    write(4, ..., 10000) = 10000
+0    > P. 1:10001(10000) ack 1

// inject sack
+.1    < . 1:1(0) ack 1 win 257 <sack 1001:10001,nop,nop>
+0    > . 1:1001(1000) ack 1

// inject sack reneging
+.1    < . 1:1(0) ack 1001 win 257 <sack 9001:10001,nop,nop>

// we expect rto fired in 1/2*srtt (50ms)
+.05    > . 1001:2001(1000) ack 1

This fix remove the FLAG_SET_XMIT_TIMER from ack_flag when
tcp_check_sack_reneging() set RTO timer with 1/2*srtt to avoid
being overwrited later.

Fixes: 62d9f1a6945b ("tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN")
Signed-off-by: Fred Chen <fred.chenchen03@gmail.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 491c16d8e9ddc..e65daf71a52d7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2069,16 +2069,17 @@ void tcp_enter_loss(struct sock *sk)
  * restore sanity to the SACK scoreboard. If the apparent reneging
  * persists until this RTO then we'll clear the SACK scoreboard.
  */
-static bool tcp_check_sack_reneging(struct sock *sk, int flag)
+static bool tcp_check_sack_reneging(struct sock *sk, int *ack_flag)
 {
-	if (flag & FLAG_SACK_RENEGING &&
-	    flag & FLAG_SND_UNA_ADVANCED) {
+	if (*ack_flag & FLAG_SACK_RENEGING &&
+	    *ack_flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
 
 		inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 					  delay, TCP_RTO_MAX);
+		*ack_flag &= ~FLAG_SET_XMIT_TIMER;
 		return true;
 	}
 	return false;
@@ -2870,7 +2871,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const int acked,
 		tp->prior_ssthresh = 0;
 
 	/* B. In all the states check for reneging SACKs. */
-	if (tcp_check_sack_reneging(sk, flag))
+	if (tcp_check_sack_reneging(sk, ack_flag))
 		return;
 
 	/* C. Check consistency of the current state. */
-- 
2.42.0



