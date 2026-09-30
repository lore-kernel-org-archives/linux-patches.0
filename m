Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA664FB9C3;
	Wed, 30 Sep 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788930; cv=none; b=mGHhdgl5o0x/VagoaLJro7d3CfNORnjEbqeZ/mazgaysoQE2gy5Eso0lcERs6lyl8g0cvxFvRTL2gfJM2zrDbVCZsM/gRlSA00JUjeqd0Jz70aYytDwlSlkNinmKk+UPXZKBv4VQJr+wrgBvyowE5OURF8HpbVMWJaqh/xcrn1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788930; c=relaxed/simple;
	bh=+C6S+WJvocQ9uNbUaYLtRftMBpSkf+Dj+FG+m/CdeW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVGXT04dddnGv5bavxbomDDdFYRFRT+z+i0BdcLjlSgHm3+YTZ+12dGeKCecorRUI9bNhJXfhUCSxY6vUBRIcWF2MkdwZYdrrXZCXUfnlP8XTS3S0KhVGuWzyoC3nNBWxuHbGTJ+7yHJIT/fSllv89qcTVPMx6Lb8Pi/IiBAMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrK/I/Bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrK/I/Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA6C1F000FF;
	Wed, 30 Sep 2026 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788929;
	bh=4vBfZJ/qumzAd6JN842XZyB8Dt41Gmq0zOphAIpdv4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrK/I/BxncwCJPX2qraijt3gLqZu4B7RZbCIZQWOCKmfZLLcc3l4OZDnxvevxmOp4
	 dwdZI4P+T4BM8Dy7dBwv9YhMlY2g1E0ipCg7E3mqciBC/NL20sDPM7w9sbzsYzyGar
	 0USmWQnUkt0j0A4t6Ha6dvZGRw/ku7GrrD+J1HtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/877] xfrm: Refactor xfrm_input lock to reduce contention with RSS
Date: Wed, 30 Sep 2026 17:20:07 +0200
Message-ID: <20260930152421.093478633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/xfrm/xfrm_input.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 1be187b980461..444334feece7b 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -493,6 +493,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		if (encap_type == -1) {
 			async = 1;
 			seq = XFRM_SKB_CB(skb)->seq.input.low;
+			spin_lock(&x->lock);
 			goto resume;
 		}
 		/* GRO call */
@@ -529,6 +530,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
+
+			nexthdr = x->type_offload->input_tail(x, skb);
 		}
 
 		goto lock;
@@ -626,11 +629,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
@@ -638,9 +639,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		XFRM_SKB_CB(skb)->seq.input.low = seq;
 		XFRM_SKB_CB(skb)->seq.input.hi = seq_hi;
 
-		if (crypto_done) {
-			nexthdr = x->type_offload->input_tail(x, skb);
-		} else {
+		if (!crypto_done) {
+			spin_unlock(&x->lock);
 			dev_hold(skb->dev);
 
 			nexthdr = x->type->input(x, skb);
@@ -651,9 +651,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			}
 
 			dev_put(skb->dev);
+			spin_lock(&x->lock);
 		}
 resume:
-		spin_lock(&x->lock);
 		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
 				xfrm_audit_state_icvfail(x, skb,
-- 
2.53.0



