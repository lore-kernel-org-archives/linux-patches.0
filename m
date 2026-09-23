Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B004374E64;
	Wed, 23 Sep 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175240; cv=none; b=HJ1iF1QB1BNDI9ietBBPLNNdeZkAVAo5kYZ6RllBLU24bDgIKlp30HTUrMAfOVN5z3Ayn2nQiZ+rht/DL+aWZf45ThNAvtjTgLptCubPebEvezYDem1LrL+B96aK7/J2hOiaS1SOsZKnE9ZQdqgBq3HUeJfIb9w+hltyFTUh1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175240; c=relaxed/simple;
	bh=pjZSndSuZarcREDzDGzXwwCGKJuMBRbEBlGb3Zvnr9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duwm03yLxtiu0p/bmLnQ7d7k3Bj1G92f8Gr3skSNQQa+9LfyismrZdlstU28f5BzCjSaYSmGHnz84IXrq4PeXelgdW70CMsxz6AiVIZhWW2hXJJuD6VTZvU81HCyuvju677mOtUtmvc2zXDdBCwK9x1j98PRElBVIkcxsTzIXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNebK5wz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNebK5wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767F51F000FF;
	Wed, 23 Sep 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175239;
	bh=3+j4+2iF6DTLRIPrxus90NO1Kb+fQhEWVU7gmkgD7LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNebK5wzeQjGlswQmZLmSTnErvXmIxvWZUNTMgENWh39/OulyIE3mJJq7nLKE3gwt
	 uZO6UszyWkdhu6x8lY39tDLljpHSm+j+k+0eDxvIf1jW0zIaUN6yRTGy0Pit8E2Wul
	 Bmw6rzor/lfnh05Yn0eQKRG7gFojPBoML+R9B0y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 365/398] xfrm: Refactor xfrm_input lock to reduce contention with RSS
Date: Wed, 23 Sep 2026 16:07:19 +0200
Message-ID: <20260923140652.897992788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 10a11861943902fda74f37f456b45183b2bca270 ]

With newer NICs like mlx5 supporting RSS for IPsec crypto offload,
packets for a single Security Association (SA) are scattered across
multiple CPU cores for parallel processing. The xfrm_state spinlock
(x->lock) is held for each packet during xfrm processing.

When multiple connections or flows share the same SA, this parallelism
causes high lock contention on x->lock, creating a performance
bottleneck and limiting scalability.

The original xfrm_input() function exacerbated this issue by releasing
and immediately re-acquiring x->lock. For hardware crypto offload
paths, this unlock/relock sequence is unnecessary and introduces
significant overhead. This patch refactors the function to relocate
the type_offload->input_tail call for the offload path, performing all
necessary work while continuously holding the lock. This reordering is
safe, since packets which don't pass the checks below will still fail
them with the new code.

Performance testing with iperf using multiple parallel streams over a
single IPsec SA shows significant improvement in throughput as the
number of queues (and thus CPU cores) increases:

+-----------+---------------+--------------+-----------------+
| RX queues | Before (Gbps) | After (Gbps) | Improvement (%) |
+-----------+---------------+--------------+-----------------+
|         2 |          32.3 |         34.4 |             6.5 |
|         4 |          34.4 |         40.0 |            16.3 |
|         6 |          24.5 |         38.3 |            56.3 |
|         8 |          23.1 |         38.3 |            65.8 |
|        12 |          18.1 |         29.9 |            65.2 |
|        16 |          16.0 |         25.2 |            57.5 |
+-----------+---------------+--------------+-----------------+

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 3cf5cdecd99c ("xfrm: save input state data before secpath resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -504,6 +504,7 @@ int xfrm_input(struct sk_buff *skb, int
 		if (encap_type == -1) {
 			async = 1;
 			seq = XFRM_SKB_CB(skb)->seq.input.low;
+			spin_lock(&x->lock);
 			goto resume;
 		}
 		/* GRO call */
@@ -540,6 +541,8 @@ int xfrm_input(struct sk_buff *skb, int
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
+
+			nexthdr = x->type_offload->input_tail(x, skb);
 		}
 
 		goto lock;
@@ -637,11 +640,9 @@ lock:
 			goto drop_unlock;
 		}
 
-		spin_unlock(&x->lock);
-
 		if (xfrm_tunnel_check(skb, x, family)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-			goto drop;
+			goto drop_unlock;
 		}
 
 		seq_hi = htonl(xfrm_replay_seqhi(x, seq));
@@ -649,9 +650,8 @@ lock:
 		XFRM_SKB_CB(skb)->seq.input.low = seq;
 		XFRM_SKB_CB(skb)->seq.input.hi = seq_hi;
 
-		if (crypto_done) {
-			nexthdr = x->type_offload->input_tail(x, skb);
-		} else {
+		if (!crypto_done) {
+			spin_unlock(&x->lock);
 			dev_hold(skb->dev);
 
 			nexthdr = x->type->input(x, skb);
@@ -662,9 +662,9 @@ lock:
 			}
 
 			dev_put(skb->dev);
+			spin_lock(&x->lock);
 		}
 resume:
-		spin_lock(&x->lock);
 		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
 				xfrm_audit_state_icvfail(x, skb,


