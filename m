Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27A738D018
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302136; cv=none; b=MEbM/SvKdr4XPINLCQS1IfvNn6Oce0hFqPzFl60jH5HeBNfrisBE6Xf/uamCROkO8oqNY73CAuL9LfeJzABkp283efg5z8WS0nSKsNJfHErqPn89I3rhBRKBK6o7a8Ygf+FDJudLmsL4QUJEhHc+WICy+7XGkqFwywwNVwo8X2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302136; c=relaxed/simple;
	bh=vSC72T4Qh/1LQ02R2Ulp3wOYUs+c8Qyg7jnVyz9CpcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7+BpJ53HBZuWkGplBxRbFrpCbnj9NdHvCJBw8aUdSiK7OAYXBN4DC1lMFowdfb6RUz5tg43yCkmwmRUCDf6dbZsakjLjNFcOn4qD1YTbgoHkui2MVv5USo+Kapk0n4w1Vno8D8bNPHoeLoblQBwn2UvEW0vsIirH1omt3bXTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKX0aoQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKX0aoQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C019C19424;
	Sat, 28 Feb 2026 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302135;
	bh=vSC72T4Qh/1LQ02R2Ulp3wOYUs+c8Qyg7jnVyz9CpcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKX0aoQ7U/3ddpurmdmXYGszBEHSBP3ugigZTBdofBPlYxBVq3PQr06p7IxKZCknN
	 gWNr/FqZMMni+U6kLHlaNJeGH3IJfaWecY3Yy1GYIfzgwYq1llyinBZ7wdRmegv0x8
	 11n0L2SDyYhdzpuxRDfxMJPYFjkpS/UcNdYpLWUBrreE92zlAVk1CsUk0y9bFjBZub
	 ExzAxqJSbz+B/uczP1PCvFSh4NRshmANyhNH5K5ZbCy8fBHkYn2E0IiwRM9XyVtMgd
	 HneIzYJSSWioyWH87nYpa1VXt8lpko9Y8ntYwZNq7TE5HNoV5l9Plf666rxmspnRE3
	 4jYTq9qELLLWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/283] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Sat, 28 Feb 2026 13:04:29 -0500
Message-ID: <20260228180709.1583486-127-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 838eb9687691d29915797a885b861fd09353386e ]

tcp_tx_timestamp() is only called at the end of tcp_sendmsg_locked()
before the final tcp_push().

By the time it is called, it is possible all the copied data
has been sent already (transmit queue is empty).

If this is the case, use the last skb in the rtx queue.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260127123828.4098577-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5dde0aed31440..2bae34d63c3db 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -468,6 +468,9 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 
+	if (unlikely(!skb))
+		skb = skb_rb_last(&sk->tcp_rtx_queue);
+
 	if (tsflags && skb) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 		struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.51.0

