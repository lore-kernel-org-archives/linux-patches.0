Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CD1372ECB;
	Thu, 30 Jul 2026 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424057; cv=none; b=PhIq5sqoF/TUm+bgyTq0Duc8P/cfMDckm897SscB60i4p66b8k7D1hXbalQAJCkPnh37uLU1xnVz7r/XSd2RO/md/KawzdLu/ZEVgZek+nSvrbT0sj6vWvT7DBYoPXGvoseLByA8YpNzByAAWh+Nkj/twdYygX9wv8kHyStCSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424057; c=relaxed/simple;
	bh=C6lXwftCTu5yDrNCeKbGegowj4sxpaza+WXZkwZLszA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e05gH+b4pMf0iE9j65Hr1Z2Edk0OBICw6yh0yyG7NaZCClL49f6aeaKYNp07Uwy+ovNpIujYMNDY/8m5stjgZjZDPpY3Vnoz1ZCFaGxN32WPzxbKa+DU0WROv5S3+diwRS3zaE7r14Ng6b+Ew8ZOlN9g3CnbZUgKZMAS8gS8cKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxHkLV7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxHkLV7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B47F1F000E9;
	Thu, 30 Jul 2026 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424056;
	bh=Jtzv9eNEzuxdjw1c5FB/CrwBAH5HeqS1UF9r3jcb+rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxHkLV7jV5GKXt6SrR/vX86AyIrHKT3zzi2uo0DcwY1W1ZM58iIDOPjkJWvc46wzv
	 te/QDQi4LIkThCjZCWIh02qKSFhhq0e6FqmL03n9XCmKe/5erU9lcj5rhrAQX6h30I
	 mHn1t1dVWqLm9u+kmCwPXC/uDfCTHE/OnK2sgr20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/675] ppp: annotate concurrent dev->stats accesses
Date: Thu, 30 Jul 2026 16:09:48 +0200
Message-ID: <20260730141450.621749291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ba712ecfd942b68b21a4b0a5daaf72f6616cc66d ]

dev->stats fields can be updated concurrently from multiple CPUs
without synchronization.

Use DEV_STATS_INC() for stats increments and DEV_STATS_READ()
when reading dev->stats in ppp_get_stats64() and ppp_get_stats()
to avoid data races.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/20260715055541.1147542-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index e09a916356a1d4..a2fe0fe2f3389f 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1490,7 +1490,7 @@ ppp_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
  outf:
 	kfree_skb(skb);
-	++dev->stats.tx_dropped;
+	DEV_STATS_INC(dev, tx_dropped);
 	return NETDEV_TX_OK;
 }
 
@@ -1540,11 +1540,11 @@ ppp_net_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 static void
 ppp_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats64)
 {
-	stats64->rx_errors        = dev->stats.rx_errors;
-	stats64->tx_errors        = dev->stats.tx_errors;
-	stats64->rx_dropped       = dev->stats.rx_dropped;
-	stats64->tx_dropped       = dev->stats.tx_dropped;
-	stats64->rx_length_errors = dev->stats.rx_length_errors;
+	stats64->rx_errors        = DEV_STATS_READ(dev, rx_errors);
+	stats64->tx_errors        = DEV_STATS_READ(dev, tx_errors);
+	stats64->rx_dropped       = DEV_STATS_READ(dev, rx_dropped);
+	stats64->tx_dropped       = DEV_STATS_READ(dev, tx_dropped);
+	stats64->rx_length_errors = DEV_STATS_READ(dev, rx_length_errors);
 	dev_fetch_sw_netstats(stats64, dev->tstats);
 }
 
@@ -1901,7 +1901,7 @@ ppp_prepare_tx_skb(struct ppp *ppp, struct sk_buff **pskb)
 
  drop:
 	kfree_skb(skb);
-	++ppp->dev->stats.tx_errors;
+	DEV_STATS_INC(ppp->dev, tx_errors);
 	return 1;
 }
 
@@ -2191,7 +2191,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
  err_linearize:
 	if (ppp->debug & 1)
 		netdev_err(ppp->dev, "PPP: no memory (fragment)\n");
-	++ppp->dev->stats.tx_errors;
+	DEV_STATS_INC(ppp->dev, tx_errors);
 	++ppp->nxseq;
 	return 1;	/* abandon the frame */
 }
@@ -2364,7 +2364,7 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
 	if (!ppp_decompress_proto(skb)) {
 		kfree_skb(skb);
 		if (ppp) {
-			++ppp->dev->stats.rx_length_errors;
+			DEV_STATS_INC(ppp->dev, rx_length_errors);
 			ppp_receive_error(ppp);
 		}
 		goto done;
@@ -2437,7 +2437,7 @@ ppp_receive_frame(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
 static void
 ppp_receive_error(struct ppp *ppp)
 {
-	++ppp->dev->stats.rx_errors;
+	DEV_STATS_INC(ppp->dev, rx_errors);
 	if (ppp->vj)
 		slhc_toss(ppp->vj);
 }
@@ -2704,7 +2704,7 @@ ppp_receive_mp_frame(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
 	 */
 	if (seq_before(seq, ppp->nextseq)) {
 		kfree_skb(skb);
-		++ppp->dev->stats.rx_dropped;
+		DEV_STATS_INC(ppp->dev, rx_dropped);
 		ppp_receive_error(ppp);
 		return;
 	}
@@ -2740,7 +2740,7 @@ ppp_receive_mp_frame(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
 		if (pskb_may_pull(skb, 2))
 			ppp_receive_nonmp_frame(ppp, skb);
 		else {
-			++ppp->dev->stats.rx_length_errors;
+			DEV_STATS_INC(ppp->dev, rx_length_errors);
 			kfree_skb(skb);
 			ppp_receive_error(ppp);
 		}
@@ -2846,7 +2846,7 @@ ppp_mp_reconstruct(struct ppp *ppp)
 		if (lost == 0 && (PPP_MP_CB(p)->BEbits & E) &&
 		    (PPP_MP_CB(head)->BEbits & B)) {
 			if (len > ppp->mrru + 2) {
-				++ppp->dev->stats.rx_length_errors;
+				DEV_STATS_INC(ppp->dev, rx_length_errors);
 				netdev_printk(KERN_DEBUG, ppp->dev,
 					      "PPP: reconstructed packet"
 					      " is too long (%d)\n", len);
@@ -2901,7 +2901,7 @@ ppp_mp_reconstruct(struct ppp *ppp)
 					      "  missed pkts %u..%u\n",
 					      ppp->nextseq,
 					      PPP_MP_CB(head)->sequence-1);
-			++ppp->dev->stats.rx_dropped;
+			DEV_STATS_INC(ppp->dev, rx_dropped);
 			ppp_receive_error(ppp);
 		}
 
@@ -3370,8 +3370,8 @@ ppp_get_stats(struct ppp *ppp, struct ppp_stats *st)
 		st->p.ppp_opackets += tx_packets;
 		st->p.ppp_obytes += tx_bytes;
 	}
-	st->p.ppp_ierrors = ppp->dev->stats.rx_errors;
-	st->p.ppp_oerrors = ppp->dev->stats.tx_errors;
+	st->p.ppp_ierrors = DEV_STATS_READ(ppp->dev, rx_errors);
+	st->p.ppp_oerrors = DEV_STATS_READ(ppp->dev, tx_errors);
 	if (!vj)
 		return;
 	st->vj.vjs_packets = vj->sls_o_compressed + vj->sls_o_uncompressed;
-- 
2.53.0



