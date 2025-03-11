Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAEC249F9;
	Tue, 11 Mar 2025 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706318; cv=none; b=ux1FFXFTTjfU437Cn8mgaLbpN+p7ZjC3o51HO1DpT73YMmzCyaDtbfJjFVpxBhV//CXHZ08piIcQzCVZ6DHUsDXXP5aOfT7mLZDUwiWsPdwGYVlCT5Cs3iW4adrAtwlbT3R2Dp61nJBUjyeqJ7YrKDes9fj9kuYepBYvFMaIheg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706318; c=relaxed/simple;
	bh=b9OhwSzfPgo9+37stWMhfPs9zWu6PLT3tsVY/pDk2lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOleMYfyfsCg7EvTWXXW8s0aNgIEwxdO3djS2GkY3jP2wE0MP7Wu95vHF4tjrOYKfyykysChzkKcu9d15yJ7d84KU+BO/PbtdOZYxrdnZQtXnVuLH4K2P24RnXj1YwfzdEynn4hJZf90YmjbVmCDvmYaaZ5JRBwLLd6MTzSW5co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2aZ9xmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2aZ9xmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1D0C4CEE9;
	Tue, 11 Mar 2025 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706318;
	bh=b9OhwSzfPgo9+37stWMhfPs9zWu6PLT3tsVY/pDk2lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2aZ9xmRxTmozg9z/cVPrI1HNN576wZBDlIx2sWZCSztRwc0KbOr2BrYkRSDg2QT+
	 NRF7YrNDRshKKx5erSWK5j4G27a+l2HmWnl3SxmlylphaLafxFrIZGEQ9CjlZJNngX
	 ey6twm09/5nNUhXFIc+6449FXHkM2CdS1HrJ2FQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 307/328] net-timestamp: support TCP GSO case for a few missing flags
Date: Tue, 11 Mar 2025 16:01:17 +0100
Message-ID: <20250311145727.109375830@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

From: Jason Xing <kerneljasonxing@gmail.com>

[ Upstream commit 3c9231ea6497dfc50ac0ef69fff484da27d0df66 ]

When I read through the TSO codes, I found out that we probably
miss initializing the tx_flags of last seg when TSO is turned
off, which means at the following points no more timestamp
(for this last one) will be generated. There are three flags
to be handled in this patch:
1. SKBTX_HW_TSTAMP
2. SKBTX_BPF
3. SKBTX_SCHED_TSTAMP
Note that SKBTX_BPF[1] was added in 6.14.0-rc2 by commit
6b98ec7e882af ("bpf: Add BPF_SOCK_OPS_TSTAMP_SCHED_CB callback")
and only belongs to net-next branch material for now. The common
issue of the above three flags can be fixed by this single patch.

This patch initializes the tx_flags to SKBTX_ANY_TSTAMP like what
the UDP GSO does to make the newly segmented last skb inherit the
tx_flags so that requested timestamp will be generated in each
certain layer, or else that last one has zero value of tx_flags
which leads to no timestamp at all.

Fixes: 4ed2d765dfacc ("net-timestamp: TCP timestamping")
Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_offload.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index fc61cd3fea652..27b7887f4f4eb 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -11,12 +11,15 @@
 #include <net/tcp.h>
 #include <net/protocol.h>
 
-static void tcp_gso_tstamp(struct sk_buff *skb, unsigned int ts_seq,
+static void tcp_gso_tstamp(struct sk_buff *skb, struct sk_buff *gso_skb,
 			   unsigned int seq, unsigned int mss)
 {
+	u32 flags = skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP;
+	u32 ts_seq = skb_shinfo(gso_skb)->tskey;
+
 	while (skb) {
 		if (before(ts_seq, seq + mss)) {
-			skb_shinfo(skb)->tx_flags |= SKBTX_SW_TSTAMP;
+			skb_shinfo(skb)->tx_flags |= flags;
 			skb_shinfo(skb)->tskey = ts_seq;
 			return;
 		}
@@ -115,8 +118,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	th = tcp_hdr(skb);
 	seq = ntohl(th->seq);
 
-	if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_SW_TSTAMP))
-		tcp_gso_tstamp(segs, skb_shinfo(gso_skb)->tskey, seq, mss);
+	if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP))
+		tcp_gso_tstamp(segs, gso_skb, seq, mss);
 
 	newcheck = ~csum_fold((__force __wsum)((__force u32)th->check +
 					       (__force u32)delta));
-- 
2.39.5



