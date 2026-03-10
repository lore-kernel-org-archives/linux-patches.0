Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189BB344D99;
	Tue, 10 Mar 2026 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142145; cv=none; b=flaMdPstuWqIRqTlq7lJ4MqvsZDUCtsRwYbjbFLOC5rueTFUzM+vyg/ym5AjmSlObMBAu+GzRH5BsIN23zFbrsiCwpcqI4koOhFQwlFvBv6H3QOHieam/3DGfKCgxHLSuf8N/Ra69KmCSTLLVpvo2M52RYPV9yFT13WLMDYmJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142145; c=relaxed/simple;
	bh=F6ZjuHtdS8fiymrBO4j+5SdaAoqrSP7xuf3+7PFmjug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF5JoDhE7kSdjAcJ5f0wnsAQE7DulifHU+o8f+4DgdMbsKOOGQQxRNozu1ouXGkybuiRX59ScgCTs9dGqHoQ7rY36riRxxd1OYdlQHpRPDEdT6Us99e9TmnCQjA7AUjAbWnSDDN+DXgG6ys6pBmgcK/onYGD2p8zaayxlCc4M74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7dYRzlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7dYRzlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB62C19423;
	Tue, 10 Mar 2026 11:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142145;
	bh=F6ZjuHtdS8fiymrBO4j+5SdaAoqrSP7xuf3+7PFmjug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7dYRzlxEm/i/QDjSPNmCackyD5Hx3dGs/mF3XFu+5Mm5nY9Bd0MbmyB+ErAndPNT
	 PpCOM+FLpk2JQ1f+9YyXjpW/TmBTEfTD9vDCoWLFhloFCSejWspID5BQb7wXaS5B6M
	 a0F4pVpDKOjBdEUFByO8iuPGPg1WP8owM4TftGOYWcnMRBKpG8r9LFdBlnknm/UMFG
	 ZbYpDuAzC0WFsHSm4uYF4+AumI9Dxw5amnpvwgrC8sWbm3OMd+SQ/roCq6q/+Xf5nS
	 /sdaEPSX5quQn6Dw4uhya4h9IkGyYH7SamJB8YJ03vIPsVJh2u29YgV7/YY06UmM+R
	 I1HKK+ZMRyNGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 232/314] tcp: give up on stronger sk_rcvbuf checks (for now)
Date: Tue, 10 Mar 2026 07:18:11 -0400
Message-ID: <219f0073b52f1b7f5d3d43aefd90d61e427900d6.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 026dfef287c07f37d4d4eef7a0b5a4bfdb29b32d ]

We hit another corner case which leads to TcpExtTCPRcvQDrop

Connections which send RPCs in the 20-80kB range over loopback
experience spurious drops. The exact conditions for most of
the drops I investigated are that:
 - socket exchanged >1MB of data so its not completely fresh
 - rcvbuf is around 128kB (default, hasn't grown)
 - there is ~60kB of data in rcvq
 - skb > 64kB arrives

The sum of skb->len (!) of both of the skbs (the one already
in rcvq and the arriving one) is larger than rwnd.
My suspicion is that this happens because __tcp_select_window()
rounds the rwnd up to (1 << wscale) if less than half of
the rwnd has been consumed.

Eric suggests that given the number of Fixes we already have
pointing to 1d2fbaad7cd8 it's probably time to give up on it,
until a bigger revamp of rmem management.

Also while we could risk tweaking the rwnd math, there are other
drops on workloads I investigated, after the commit in question,
not explained by this phenomenon.

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/20260225122355.585fd57b@kernel.org
Fixes: 1d2fbaad7cd8 ("tcp: stronger sk_rcvbuf checks")
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260227003359.2391017-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 834cd37276d59..87e678903b977 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5100,25 +5100,11 @@ static void tcp_ofo_queue(struct sock *sk)
 static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb);
 static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
 
-/* Check if this incoming skb can be added to socket receive queues
- * while satisfying sk->sk_rcvbuf limit.
- *
- * In theory we should use skb->truesize, but this can cause problems
- * when applications use too small SO_RCVBUF values.
- * When LRO / hw gro is used, the socket might have a high tp->scaling_ratio,
- * allowing RWIN to be close to available space.
- * Whenever the receive queue gets full, we can receive a small packet
- * filling RWIN, but with a high skb->truesize, because most NIC use 4K page
- * plus sk_buff metadata even when receiving less than 1500 bytes of payload.
- *
- * Note that we use skb->len to decide to accept or drop this packet,
- * but sk->sk_rmem_alloc is the sum of all skb->truesize.
- */
 static bool tcp_can_ingest(const struct sock *sk, const struct sk_buff *skb)
 {
 	unsigned int rmem = atomic_read(&sk->sk_rmem_alloc);
 
-	return rmem + skb->len <= sk->sk_rcvbuf;
+	return rmem <= sk->sk_rcvbuf;
 }
 
 static int tcp_try_rmem_schedule(struct sock *sk, const struct sk_buff *skb,
-- 
2.51.0

