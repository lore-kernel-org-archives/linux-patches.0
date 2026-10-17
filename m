Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180831F16B;
	Sat, 17 Oct 2026 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258525; cv=none; b=BE5LqZFcEsHiZLF9Mri++Sill1bGiktL/9TyeghDNrC8YDgblh6NhzJKCQxrbvoA0GyJXTmrDitM/scxUx5NZnMFeihppnS1lwEqpyBeQf5tCva28LQ4uvZmH+C/fgMmi4pJi1Q64hRii+tv73uN0UM/P4yvGYSq2FChtoDETj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258525; c=relaxed/simple;
	bh=nKc6ta09vlwgvghDmdf5SzEI/ITwroJWhsC81yWJTHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+rTdrkxKPZL5hkWR4wEa3tAB3BFL+fUY4zHboGecqnHcZxm4d9prNgRGM1lWBe/BkPwikd4MjqgAfRGqbtcjx47EoALgbwBWhZUD/wMruV8iaBg/82BmxTkh6CECcsIIwHJV1npVvdG+AOy8HumsLKYRQ8vr9gMwy6UbZLo6yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhHXSAcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhHXSAcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D161F000C4;
	Sat, 17 Oct 2026 17:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258524;
	bh=xV3K5wXZ7A/YK0/8Ds8fENvHlJzWS52VH77Ey6Bh+nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhHXSAcVyVLcbDGINnPqFeT8ale2mM9v3B9nPMk42pkfPMJS0OMXdI0l46KH7/8au
	 NEGp5EaVciLTxv4I/hGThcLf67ythcVhP7E7ZRBbKXIgqJBJRjOfSwNZQ/hl9Y0pW4
	 /kKVZ+t576By8/Vo3KA1sZeHn19IwjuszdUkvbiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0886/1674] xfrm: hold device only for the asynchronous decryption
Date: Sat, 17 Oct 2026 17:52:38 +0200
Message-ID: <20261017160453.855230581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit b05d42eefac737ce3cd80114d3579111023941b8 ]

The dev_hold() on skb->dev during packet reception was originally
added to prevent the device from being released prematurely during
asynchronous decryption operations.

As current hardware can offload decryption, this asynchronous path is
not always utilized. This often results in a pattern of dev_hold()
immediately followed by dev_put() for each packet, creating
unnecessary reference counting overhead detrimental to performance.

This patch optimizes this by skipping the dev_hold() and subsequent
dev_put() when asynchronous decryption is not being performed.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 1c428b038400 ("xfrm: hold dev ref until after transport_finish NF_HOOK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3100c5ef18622..ffbccf0d1bb99 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -490,6 +490,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		/* An encap_type of -1 indicates async resumption. */
 		if (encap_type == -1) {
 			async = 1;
+			dev_put(skb->dev);
 			seq = XFRM_SKB_CB(skb)->seq.input.low;
 			goto resume;
 		}
@@ -627,18 +628,18 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		XFRM_SKB_CB(skb)->seq.input.low = seq;
 		XFRM_SKB_CB(skb)->seq.input.hi = seq_hi;
 
-		dev_hold(skb->dev);
-
-		if (crypto_done)
+		if (crypto_done) {
 			nexthdr = x->type_offload->input_tail(x, skb);
-		else
+		} else {
+			dev_hold(skb->dev);
+
 			nexthdr = x->type->input(x, skb);
+			if (nexthdr == -EINPROGRESS)
+				return 0;
 
-		if (nexthdr == -EINPROGRESS)
-			return 0;
+			dev_put(skb->dev);
+		}
 resume:
-		dev_put(skb->dev);
-
 		spin_lock(&x->lock);
 		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
-- 
2.53.0



