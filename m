Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43464C6E;
	Mon, 23 Jun 2025 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686233; cv=none; b=J/HLXut7yhF3KHY1nJjIWoy9JNzUNqSKF6dKmg07XFvm+90HV5RQunKTOqd1Xs4+slR8swjSg9qspVrjLy5ovUZKZQi6jvGfP/UW4yXehy6foNlQ0Z6ne8RGCEJrK3/oVZLGhh+yhtH7PrEk1QY+SX99oQ2kma/l0IVrFTPed30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686233; c=relaxed/simple;
	bh=RILQruk9yMhZRsqQf/L/dgHtQ+PVedhNZxWq6LfWq3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCfkdfLXAOhIBB1VIa3Rpcx51ss0GwwC5whFVasrAi6e1IbhGbevcPosfB74EYrXi9CgAZ8Zmp9oQJVIjcb5zNTLqm7/NSXlIhS0EFX2Lcb7mstMT5d66WXb6gYKcJBwLRTI/hN2B5vvLtgeN7eatpj4BP8Tn+hR4eAvot2LnsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvgJAuGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvgJAuGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64355C4CEEA;
	Mon, 23 Jun 2025 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686233;
	bh=RILQruk9yMhZRsqQf/L/dgHtQ+PVedhNZxWq6LfWq3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvgJAuGWsv2+pTHrNBpSTwi8Zq501A4q7Q8w3F6JyQMtwh+j15Ef77jcqiHA/rfEN
	 Z7eONna5JBgSwTv0rgQ2Jrabn7vfOOExA4ZtSOOgBDqpTtvr/6VqvqGgm6xp1KnZyu
	 nITZJe085jROXwpdEA6Ac76nUMtuuiYN6sNUe+7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/222] tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows
Date: Mon, 23 Jun 2025 15:08:20 +0200
Message-ID: <20250623130617.038382653@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit cd171461b90a2d2cf230943df60d580174633718 ]

tcp_rcv_state_process() must tweak tp->advmss for TS enabled flows
before the call to tcp_init_transfer() / tcp_init_buffer_space().

Otherwise tp->rcvq_space.space is off by 120 bytes
(TCP_INIT_CWND * TCPOLEN_TSTAMP_ALIGNED).

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d07aa23943c13..2378d561d171d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6333,6 +6333,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (!tp->srtt_us)
 			tcp_synack_rtt_meas(sk, req);
 
+		if (tp->rx_opt.tstamp_ok)
+			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
+
 		if (req) {
 			tcp_rcv_synrecv_state_fastopen(sk);
 		} else {
@@ -6356,9 +6359,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 
-		if (tp->rx_opt.tstamp_ok)
-			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
-
 		if (!inet_csk(sk)->icsk_ca_ops->cong_control)
 			tcp_update_pacing_rate(sk);
 
-- 
2.39.5



