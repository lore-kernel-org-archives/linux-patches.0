Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF9E47AF65;
	Tue, 13 Oct 2026 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893768; cv=none; b=m3RV/S2jID2YtEf4IRPeSfLiDiA2fOdIkfbw53ZUY/R1xPgu4EKuardcvn0j8Bko3YDhqwmDolBRztFiI+aMgn9zh33xMkcqL1Ss4/KYd1OiUjTAGMlsYr+ZVDn8yYqmzoCKmsfl2/RyFCcKBQSVnraEsmRLTX8bIbyPd97fR/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893768; c=relaxed/simple;
	bh=lvvJUz9reF04f7/AQmmIt83/cKTv+gBTze8YX7gJGpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr8FwtqeCpCtEDyHu4paBjxTUuA3BbM29kCjevIv0Op2/P9BPEachrqCfFLBad2wPOP6otIeWJgKWN6DKgNwtMaFQ5LbytVwgV/VrA7v9/qds8B9kKPQjEQseO+BgKSXTe5bYzCdGmRN/opqq5jFTqrCZVycDggkP5S5KF0x/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYHowE77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYHowE77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409CD1F000FF;
	Tue, 13 Oct 2026 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893767;
	bh=gi2Uzx8aAEXZd+5x1e8/lgJyZb8GusxZgKpAW6Hto7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYHowE77BQ0e4f8x4+5YSOwK2PtGs/8uoFAT34H6Na0SY3s3dmGTP/z7OQDmyDnDd
	 bPW+5MxyQn7v353XLPwCKMb+m+N/pgG/G+IRrhK0LD2MzvP17g+FKbN5x6arliotl9
	 oyjcLp1jJ1HzrNeb7IfSJfc4atynuqWmLrvC7Bo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/621] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Tue, 13 Oct 2026 13:34:54 +0200
Message-ID: <20261013112927.949785785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0a0b35f0bf10b4c2be607465f5c9c12c8681305b ]

The ttl field has been decremented already and evaluation of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Moreover, check for headroom and call skb_expand_head() like in the IP
output path to ensure there is sufficient headroom when forwarding this
via neigh_xmit().

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 2354e975932d ("netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fwd_netdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 4bce36c3a6a07..8468bed3e87d2 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -101,6 +101,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
 	struct net_device *dev;
+	unsigned int hh_len;
 	int neigh_table;
 
 	switch (priv->nfproto) {
@@ -152,8 +153,19 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
+	hh_len = LL_RESERVED_SPACE(dev);
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb) {
+			verdict = NF_STOLEN;
+			goto out;
+		}
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.53.0



