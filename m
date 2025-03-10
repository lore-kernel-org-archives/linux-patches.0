Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF2817CA12;
	Mon, 10 Mar 2025 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629040; cv=none; b=fGOI0KT7FwZC9R09cETv+BKa9WkC631XgL9qXBQsdGeVzgwQj3yn4gvq9X0pmPOMRppIFH/gahpocylMEoUY9Kk9oeRQigNN7q6onTnv8QnGlenE0B5lBCnGRwMcXQdy41S/drKBtsIWG0GaWJaeNvsB12m0MzuUlKrOEPDviao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629040; c=relaxed/simple;
	bh=H8OQ0Q2FqCfN3CA5xJrHvz+wc7Ps4dx2NCWKfK4kEZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL0002GEU1vYgf3f5LN++84tvdPeo7AYnVEzcf8RHc2T11NQk57zMGDUaZCDosuMWIPFC9s8EI4lglxgzXfvRq/aX0f3xmI6rEFsgRhzqVPvUc6WoMKRG/u0n1sH0KJu8AGU6ikNbJV/YpPfYaqpdsbzH/waDIKzPBLXHq6+aho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yCqC0qN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yCqC0qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BD0C4CEE5;
	Mon, 10 Mar 2025 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629040;
	bh=H8OQ0Q2FqCfN3CA5xJrHvz+wc7Ps4dx2NCWKfK4kEZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yCqC0qNnpc4ngWwA/xJbnxzyqS2EUth9t8ik7YvDedvsPwiGrrmF/fAsq4sg8j9k
	 MG+abfaG46zPtXYrmbQZClrU6KPDoKZ9IGT+/Gu2Ypk/LgXtKOaiy0B/o3prDw0uxV
	 YYRRlJzdwv3Ex+YSOh/N+pe5K5pRK5cEkar3p8Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/620] xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO
Date: Mon, 10 Mar 2025 18:00:03 +0100
Message-ID: <20250310170551.807471100@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit c05c5e5aa163f4682ca97a2f0536575fc7dbdecb ]

When skb needs GSO and wrap around happens, if xo->seq.low (seqno of
the first skb segment) is before the last seq number but oseq (seqno
of the last segment) is after it, xo->seq.low is still bigger than
replay_esn->oseq while oseq is smaller than it, so the update of
replay_esn->oseq_hi is missed for this case wrap around because of
the change in the cited commit.

For example, if sending a packet with gso_segs=3 while old
replay_esn->oseq=0xfffffffe, we calculate:
    xo->seq.low = 0xfffffffe + 1 = 0x0xffffffff
    oseq = 0xfffffffe + 3 = 0x1
(oseq < replay_esn->oseq) is true, but (xo->seq.low <
replay_esn->oseq) is false, so replay_esn->oseq_hi is not incremented.

To fix this issue, change the outer checking back for the update of
replay_esn->oseq_hi. And add new checking inside for the update of
packet's oseq_hi.

Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_replay.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 49dd788859d8b..6f6a18dc375b7 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -714,10 +714,12 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 			oseq += skb_shinfo(skb)->gso_segs;
 		}
 
-		if (unlikely(xo->seq.low < replay_esn->oseq)) {
-			XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
-			xo->seq.hi = oseq_hi;
-			replay_esn->oseq_hi = oseq_hi;
+		if (unlikely(oseq < replay_esn->oseq)) {
+			replay_esn->oseq_hi = ++oseq_hi;
+			if (xo->seq.low < replay_esn->oseq) {
+				XFRM_SKB_CB(skb)->seq.output.hi = oseq_hi;
+				xo->seq.hi = oseq_hi;
+			}
 			if (replay_esn->oseq_hi == 0) {
 				replay_esn->oseq--;
 				replay_esn->oseq_hi--;
-- 
2.39.5



