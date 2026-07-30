Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4BD38E8BB;
	Thu, 30 Jul 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427503; cv=none; b=O84c1yD1mDVHkihtTMgTXQWf5kj0RYF0lfT2f+4fNQh01AImuRBoE0ZFHDeuaR764VmcZEAaoeqnz6zQjlJLrk9S3g94zN3SqNZCZ2SFaRG5b82kOtdvWW4p9YTFCoT7pVQiADkjo30yfkeS0HL5ipmQmxCSB5uaNfjcsmbm85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427503; c=relaxed/simple;
	bh=kh5CzeLDw4fC8yDqe0YOtd+eYeQCGf/x7NCjucGFVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD4S9vXTE3QNjVb+EqZymxu9B1Sz2ySmTUH5vZ2xPdHZ4W5Aaa5JyQqdz1UqSgxpU9C+jeQZRB32YdllXrBJ2xX9wCGs0nyXQgs4E+UBVGXk3wcSFw1aPLkuKZMviZsXMzm+N09t7li1lDYdElfUr1esQKSNOGEChEablJYS/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm2Lmzy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm2Lmzy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53911F00A3E;
	Thu, 30 Jul 2026 16:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427502;
	bh=52ZKir+B8FfDY3I9X4Zg2cic9zlcrl8BcT5TdJUi7iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm2Lmzy0YKUFET3fj0KlAZU6nxNHa8eqf2kVYzWoVURQNg3KGwuSaJsBEwx0XUunK
	 /dSNcHtn2cpGWgkRFbs1yxRco53Go/CzVzh9WCL4S/E2/hBMix++I5UCYFKvtSe7gF
	 57hTCdlqZEzbkrFjHPpntN5cxknSMZPPqXsKuPts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/484] ppp: convert to percpu netstats
Date: Thu, 30 Jul 2026 16:11:31 +0200
Message-ID: <20260730141427.683013372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 1a3e9b7a6b09e8ab3d2af019e4a392622685855e ]

Convert to percpu netstats to avoid lock contention when reading them.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20250610083211.909015-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 543adf072165 ("ppp: annotate data races in ppp_generic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 52 +++++++++++++----------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 62169a38b984a2..065a99c9d6b3e2 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -107,18 +107,6 @@ struct ppp_file {
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
 
-/*
- * Data structure to hold primary network stats for which
- * we want to use 64 bit storage.  Other network stats
- * are stored in dev->stats of the ppp strucute.
- */
-struct ppp_link_stats {
-	u64 rx_packets;
-	u64 tx_packets;
-	u64 rx_bytes;
-	u64 tx_bytes;
-};
-
 /*
  * Data structure describing one ppp unit.
  * A ppp unit corresponds to a ppp network interface device
@@ -162,7 +150,6 @@ struct ppp {
 	struct bpf_prog *active_filter; /* filter for pkts to reset idle */
 #endif /* CONFIG_PPP_FILTER */
 	struct net	*ppp_net;	/* the net we belong to */
-	struct ppp_link_stats stats64;	/* 64 bit network stats */
 };
 
 /*
@@ -1545,23 +1532,12 @@ ppp_net_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 static void
 ppp_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats64)
 {
-	struct ppp *ppp = netdev_priv(dev);
-
-	ppp_recv_lock(ppp);
-	stats64->rx_packets = ppp->stats64.rx_packets;
-	stats64->rx_bytes   = ppp->stats64.rx_bytes;
-	ppp_recv_unlock(ppp);
-
-	ppp_xmit_lock(ppp);
-	stats64->tx_packets = ppp->stats64.tx_packets;
-	stats64->tx_bytes   = ppp->stats64.tx_bytes;
-	ppp_xmit_unlock(ppp);
-
 	stats64->rx_errors        = dev->stats.rx_errors;
 	stats64->tx_errors        = dev->stats.tx_errors;
 	stats64->rx_dropped       = dev->stats.rx_dropped;
 	stats64->tx_dropped       = dev->stats.tx_dropped;
 	stats64->rx_length_errors = dev->stats.rx_length_errors;
+	dev_fetch_sw_netstats(stats64, dev->tstats);
 }
 
 static int ppp_dev_init(struct net_device *dev)
@@ -1659,6 +1635,7 @@ static void ppp_setup(struct net_device *dev)
 	dev->type = ARPHRD_PPP;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 	dev->priv_destructor = ppp_dev_priv_destructor;
+	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
 	netif_keep_dst(dev);
 }
 
@@ -1804,8 +1781,7 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 #endif /* CONFIG_PPP_FILTER */
 	}
 
-	++ppp->stats64.tx_packets;
-	ppp->stats64.tx_bytes += skb->len - PPP_PROTO_LEN;
+	dev_sw_netstats_tx_add(ppp->dev, 1, skb->len - PPP_PROTO_LEN);
 
 	switch (proto) {
 	case PPP_IP:
@@ -2483,8 +2459,7 @@ ppp_receive_nonmp_frame(struct ppp *ppp, struct sk_buff *skb)
 		break;
 	}
 
-	++ppp->stats64.rx_packets;
-	ppp->stats64.rx_bytes += skb->len - 2;
+	dev_sw_netstats_rx_add(ppp->dev, skb->len - PPP_PROTO_LEN);
 
 	npi = proto_to_npindex(proto);
 	if (npi < 0) {
@@ -3312,14 +3287,25 @@ static void
 ppp_get_stats(struct ppp *ppp, struct ppp_stats *st)
 {
 	struct slcompress *vj = ppp->vj;
+	int cpu;
 
 	memset(st, 0, sizeof(*st));
-	st->p.ppp_ipackets = ppp->stats64.rx_packets;
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *p = per_cpu_ptr(ppp->dev->tstats, cpu);
+		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
+
+		rx_packets = u64_stats_read(&p->rx_packets);
+		rx_bytes = u64_stats_read(&p->rx_bytes);
+		tx_packets = u64_stats_read(&p->tx_packets);
+		tx_bytes = u64_stats_read(&p->tx_bytes);
+
+		st->p.ppp_ipackets += rx_packets;
+		st->p.ppp_ibytes += rx_bytes;
+		st->p.ppp_opackets += tx_packets;
+		st->p.ppp_obytes += tx_bytes;
+	}
 	st->p.ppp_ierrors = ppp->dev->stats.rx_errors;
-	st->p.ppp_ibytes = ppp->stats64.rx_bytes;
-	st->p.ppp_opackets = ppp->stats64.tx_packets;
 	st->p.ppp_oerrors = ppp->dev->stats.tx_errors;
-	st->p.ppp_obytes = ppp->stats64.tx_bytes;
 	if (!vj)
 		return;
 	st->vj.vjs_packets = vj->sls_o_compressed + vj->sls_o_uncompressed;
-- 
2.53.0



