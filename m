Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B94052DC;
	Thu, 30 Jul 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424049; cv=none; b=kFvi2ibv8mhWYShPqU4KvFln8ZC5gYFgk4QnCTxfcTF3VHKYuAVb04J00xYZqywR3v5jXMYJORNp4Jki/XjddjGPdU2KD3Hfd603Tous6ETqOwUmx6+rjneoMw99ZTJa6NreD2T8kDw9ZJJ3dul2uUd3AdnXKfvdb16qZ/+Xc0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424049; c=relaxed/simple;
	bh=NTmRDgTirkoPzZMVoxFcFeahTZC5VIU4Hh4/BWK6HNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asxI2GLgV5e5J9B0VDVAr2Qyaobj91d+1GJMsUwrCZF7fGgq9qW9xWy6TPo1M4N1ECO8YCQBq6XATIuQRvP/ndVz7ErvrdNHiksVyFZsXtMe/rZS4gGJoRam7ORGvg+GNfecFDW25FlmjdiQSXUVU05ZyWhQrTvIKx+XLHlou/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqTJawJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqTJawJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED93D1F000E9;
	Thu, 30 Jul 2026 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424047;
	bh=UFBEA7y6mcqEs4v2rgVm4k77tN3CsQausLC6gI/2bCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqTJawJwv6g4lhON8smOBA4Gfkd9w9xQhhBS3wS20ThN5l5POE6IhoCoqwmOmvFFj
	 /lsUb35t5b9N0oFxe2RLmnsonrtlQ8wyFcK3dprCoRcwCR/vX5RZGYnY1xGK4BOauI
	 JYeFgizSkXSDgAgKzPvFFYCYn+EmD2fPMpbOx18I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/675] ppp: enable TX scatter-gather
Date: Thu, 30 Jul 2026 16:09:46 +0200
Message-ID: <20260730141450.579186578@linuxfoundation.org>
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

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 42fcb213e58a7da33d5d2d7517b4e521025c68c3 ]

PPP channels using chan->direct_xmit prepend the PPP header to a skb and
call dev_queue_xmit() directly. In this mode the skb does not need to be
linear, but the PPP netdevice currently does not advertise
scatter-gather features, causing unnecessary linearization and
preventing GSO.

Enable NETIF_F_SG and NETIF_F_FRAGLIST on PPP devices. In case a linear
buffer is required (PPP compression, multilink, and channels without
direct_xmit), call skb_linearize() explicitly.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20260129012902.941-1-dqfext@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: ba712ecfd942 ("ppp: annotate concurrent dev->stats accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 72e98286fba2fe..6d001fb1462d30 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1645,6 +1645,8 @@ static void ppp_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 	dev->priv_destructor = ppp_dev_priv_destructor;
 	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
+	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	dev->hw_features = dev->features;
 	netif_keep_dst(dev);
 }
 
@@ -1714,6 +1716,10 @@ pad_compress_skb(struct ppp *ppp, struct sk_buff *skb)
 		ppp->xcomp->comp_extra + ppp->dev->hard_header_len;
 	int compressor_skb_size = ppp->dev->mtu +
 		ppp->xcomp->comp_extra + PPP_HDRLEN;
+
+	if (skb_linearize(skb))
+		return NULL;
+
 	new_skb = alloc_skb(new_skb_size, GFP_ATOMIC);
 	if (!new_skb) {
 		if (net_ratelimit())
@@ -1801,6 +1807,10 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	case PPP_IP:
 		if (!ppp->vj || (ppp->flags & SC_COMP_TCP) == 0)
 			break;
+
+		if (skb_linearize(skb))
+			goto drop;
+
 		/* try to do VJ TCP header compression */
 		new_skb = alloc_skb(skb->len + ppp->dev->hard_header_len - 2,
 				    GFP_ATOMIC);
@@ -1898,19 +1908,26 @@ ppp_push(struct ppp *ppp)
 	}
 
 	if ((ppp->flags & SC_MULTILINK) == 0) {
+		struct ppp_channel *chan;
 		/* not doing multilink: send it down the first channel */
 		list = list->next;
 		pch = list_entry(list, struct channel, clist);
 
 		spin_lock(&pch->downl);
-		if (pch->chan) {
-			if (pch->chan->ops->start_xmit(pch->chan, skb))
-				ppp->xmit_pending = NULL;
-		} else {
-			/* channel got unregistered */
+		chan = pch->chan;
+		if (unlikely(!chan || (!chan->direct_xmit && skb_linearize(skb)))) {
+			/* channel got unregistered, or it requires a linear
+			 * skb but linearization failed
+			 */
 			kfree_skb(skb);
 			ppp->xmit_pending = NULL;
+			goto out;
 		}
+
+		if (chan->ops->start_xmit(chan, skb))
+			ppp->xmit_pending = NULL;
+
+out:
 		spin_unlock(&pch->downl);
 		return;
 	}
@@ -1995,6 +2012,8 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 		return 0; /* can't take now, leave it in xmit_pending */
 
 	/* Do protocol field compression */
+	if (skb_linearize(skb))
+		goto err_linearize;
 	p = skb->data;
 	len = skb->len;
 	if (*p == 0 && mp_protocol_compress) {
@@ -2153,6 +2172,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 
  noskb:
 	spin_unlock(&pch->downl);
+ err_linearize:
 	if (ppp->debug & 1)
 		netdev_err(ppp->dev, "PPP: no memory (fragment)\n");
 	++ppp->dev->stats.tx_errors;
-- 
2.53.0



