Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF87313E2B;
	Mon, 13 Oct 2025 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370081; cv=none; b=GK96K45MmaLKAV6VGYevDRzx31w9DdCnQ/1tXJC8Yit7YTKFZSO/mKg42dkAcGxoy5/RKjJgQMAxiRo23tA747EtcfNqmeafyqdlYbojhydEjheJaL1fPieu9co/8mpa2BoNMmSpyEas1LLq+YYVkh/430VG7eJZtDN5iMi/3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370081; c=relaxed/simple;
	bh=600ZitHVKHCo/qG23AEsO2s/8/Qf3q8DBYtlftq1pus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqRd4r899udTubcb5yc7CxWj62KLESIwu2S08L0fpmhexvWKqdq14/Zg6rdxVhjY+zZZTG8lrIthic4SR9CYiR1La6fdICLe1dMoI1GMQig4SZ5Q1l41fuWxe66DVAdKQh9r2KqC+IARUAvAJrnttmMWrI8x/PkmSbXzRwex0Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K13GsDn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K13GsDn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705F9C4CEE7;
	Mon, 13 Oct 2025 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370080;
	bh=600ZitHVKHCo/qG23AEsO2s/8/Qf3q8DBYtlftq1pus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K13GsDn9vcoSe9fkuj3uXvApV+/pJZyOHSSVW5eLsoVNUVBmZj85hOD8ZOGfVpkeD
	 ue8bBSRNOs9lVFdq8SRWGbdo3eUbEhfMlH94wy2uiNfIdWcAde8AUmZNYWdp0vyZFp
	 tS4HqZoW1TWqaqGU2hj+nsKPLnGzDTLxfyRqGHi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 471/563] tcp: use skb->len instead of skb->truesize in tcp_can_ingest()
Date: Mon, 13 Oct 2025 16:45:32 +0200
Message-ID: <20251013144428.352054506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f017c1f768b670bced4464476655b27dfb937e67 ]

Some applications are stuck to the 20th century and still use
small SO_RCVBUF values.

After the blamed commit, we can drop packets especially
when using LRO/hw-gro enabled NIC and small MSS (1500) values.

LRO/hw-gro NIC pack multiple segments into pages, allowing
tp->scaling_ratio to be set to a high value.

Whenever the receive queue gets full, we can receive a small packet
filling RWIN, but with a high skb->truesize, because most NIC use 4K page
plus sk_buff metadata even when receiving less than 1500 bytes of payload.

Even if we refine how tp->scaling_ratio is estimated,
we could have an issue at the start of the flow, because
the first round of packets (IW10) will be sent based on
the initial tp->scaling_ratio (1/2)

Relax tcp_can_ingest() to use skb->len instead of skb->truesize,
allowing the peer to use final RWIN, assuming a 'perfect'
scaling_ratio of 1.

Fixes: 1d2fbaad7cd8 ("tcp: stronger sk_rcvbuf checks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250927092827.2707901-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 71b76e98371a6..64f93668a8452 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4890,12 +4890,23 @@ static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
 
 /* Check if this incoming skb can be added to socket receive queues
  * while satisfying sk->sk_rcvbuf limit.
+ *
+ * In theory we should use skb->truesize, but this can cause problems
+ * when applications use too small SO_RCVBUF values.
+ * When LRO / hw gro is used, the socket might have a high tp->scaling_ratio,
+ * allowing RWIN to be close to available space.
+ * Whenever the receive queue gets full, we can receive a small packet
+ * filling RWIN, but with a high skb->truesize, because most NIC use 4K page
+ * plus sk_buff metadata even when receiving less than 1500 bytes of payload.
+ *
+ * Note that we use skb->len to decide to accept or drop this packet,
+ * but sk->sk_rmem_alloc is the sum of all skb->truesize.
  */
 static bool tcp_can_ingest(const struct sock *sk, const struct sk_buff *skb)
 {
-	unsigned int new_mem = atomic_read(&sk->sk_rmem_alloc) + skb->truesize;
+	unsigned int rmem = atomic_read(&sk->sk_rmem_alloc);
 
-	return new_mem <= sk->sk_rcvbuf;
+	return rmem + skb->len <= sk->sk_rcvbuf;
 }
 
 static int tcp_try_rmem_schedule(struct sock *sk, const struct sk_buff *skb,
-- 
2.51.0



