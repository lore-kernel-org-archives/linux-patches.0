Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F61546AA66;
	Thu, 30 Jul 2026 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427506; cv=none; b=QWCtP+C8/18OQ1yjySTlCxhciGx5NmW/qgP35AXAKfK2GVFgcU8Y2lx12BeYzAUAyhdddNKiJzaTMFcqUb0raRLSR1zorCaxZWy09mZmcmE3Yb89wS+X4dOMUjZJ9enTDfIhSO2gFoowO3Ed5cNY+NSX2dINhj1hoCgTAB1h0Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427506; c=relaxed/simple;
	bh=LT07UlgWwW8sm3IF+9YWQ/9nK3vkhqkGvNk/ax1/SjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIEMiSFHolsrcGR8AIdUq3N1qpJppbMcSuPNd/GOWrfqYM0SXuwmRFPQ7VS0RtscoBvGr5bSfOIZPyCZpbsKUx+DiEGGT7EwteWWbgYl1NmyGvjKuX8ypUZV2iNZgiagoqfWrRSGoPavt3La4hF3mcmwBrP/mD3pWfZatWr4/X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW2o5h+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW2o5h+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36931F00A3D;
	Thu, 30 Jul 2026 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427505;
	bh=3l3ajR5z/XZgm5LJR67vZRRoXjnQnrC4WAkCXaSJ5ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AW2o5h+7gIng2FBzmy6Sk3q2yVd/bu2oe3Kgo5BYiaQbNSEueo8GFT651pxY83fu1
	 kZXktL1XVJitOWxjwtczBJGKuQNbR0+xWj+dcQXwW8vdAGM6RGo0Qb8TD3wqPmRaH3
	 xyaIzvHzfAVYR+Vlhco+zdJd5YS5D3LubmYB3e5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/484] ppp: enable TX scatter-gather
Date: Thu, 30 Jul 2026 16:11:32 +0200
Message-ID: <20260730141427.702966902@linuxfoundation.org>
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
Stable-dep-of: 543adf072165 ("ppp: annotate data races in ppp_generic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 065a99c9d6b3e2..fe4a8bca0c2e8d 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1636,6 +1636,8 @@ static void ppp_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 	dev->priv_destructor = ppp_dev_priv_destructor;
 	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
+	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	dev->hw_features = dev->features;
 	netif_keep_dst(dev);
 }
 
@@ -1700,6 +1702,10 @@ pad_compress_skb(struct ppp *ppp, struct sk_buff *skb)
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
@@ -1787,6 +1793,10 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
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
@@ -1884,19 +1894,26 @@ ppp_push(struct ppp *ppp)
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
@@ -1981,6 +1998,8 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 		return 0; /* can't take now, leave it in xmit_pending */
 
 	/* Do protocol field compression */
+	if (skb_linearize(skb))
+		goto err_linearize;
 	p = skb->data;
 	len = skb->len;
 	if (*p == 0 && mp_protocol_compress) {
@@ -2139,6 +2158,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 
  noskb:
 	spin_unlock(&pch->downl);
+ err_linearize:
 	if (ppp->debug & 1)
 		netdev_err(ppp->dev, "PPP: no memory (fragment)\n");
 	++ppp->dev->stats.tx_errors;
-- 
2.53.0



