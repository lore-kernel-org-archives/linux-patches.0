Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038229;
	b=xG5PUBLATZ1bckOHssV6sCWdvHaMpuLhrV7Mp3jT7fmnyWYj5eqZcWeji8SW1m2lnD53
	 5ia49Rjm7UcS+X0KnXR6NxxugrzvNNGpBDL0SRWWDjNauTOMFTCuoSaS66B+LkXA1garh
	 LXMN5KSvyz0MoGg2rBCwPbpyULdbVtfYpZo+W9D7el2kMafa+cMyBHbIOD479UhDYMXW0
	 CYFv2LXFrnBFNDVypKomoLvLxXKf/o2iLmwvylpuWgkN697Xfy4Za2KFLOXpGlixIr8L+
	 G+mZf/RyNOJlIwMipnmzZ6INxEc965mDwQ25tg/kxu58zAxX7k78YZYO+V6v8br96Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJ7DyMq36OgaKqZcxRRNdDTnaxYjD24cD5XkPXXThmE=;
	b=tF9Z3yluLUzb//yGrfp7YozTMKyGpxQCEGvlHmh7RvfqeIlrDCC/yJJl80y7aROdeIRt
	 3tQKH8/cDxp1tUB0JVc1OSdzvL9XJt0xr6ZFSUEeYmpX4n714K8KMZRDdAw+MhJ0kB3fp
	 PQAuUkXsawClAfe2FPRoHlGodK1BB5j8IMJP9VCnGlf4Ejgr810aRT2R7fF9pBDPHL9P6
	 ND7zoAdiCwXVRoAec31x11I5t4ltqY52TFuZPrJ4555elVLHnr6KKmf4704Hp/HexqCu6
	 Zv+0lnORq+swzNBXIrNN+RVSOdS3+2hcICQQ2trQvyjlWZic4HlxwQXuWiCIUzyCBgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uic+bmmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5755606A320;
	Wed, 18 Nov 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uic+bmmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323AF1F000C4;
	Wed, 18 Nov 2026 21:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038229;
	bh=XJ7DyMq36OgaKqZcxRRNdDTnaxYjD24cD5XkPXXThmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uic+bmmm6UVTo7h3xi5/GCBOtrOT8KJbpew9A/jJw4GO9KOqOs9fpPymArjb/my8q
	 yTN6Nkc4Aewv4VvHWvkLRTLqcxt7NZ4uhWuNnntDiH5YbKUYqDtKR2nYY643O95oKc
	 F34bjfmRt/cNP+g9zC7RJn56npZYC1IokK9tkCgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1671/3318] ipmr: prevent info-leak in pmr_cache_report()
Date: Wed, 18 Nov 2026 15:38:13 +0100
Message-ID: <20261118150411.926759781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4f34002e2e37639133693c13a2a9977fab86880d ]

Yiming Qian reported:

<quote>
 ipmr_cache_report()` allocates a report skb with `alloc_skb(128,
 GFP_ATOMIC)` and appends a `struct igmphdr` using `skb_put()`. In the
 non-`IGMPMSG_WHOLEPKT` path it initializes only:

 - `igmp->type`
 - `igmp->code`

 but does not initialize:

 - `igmp->csum`
 - `igmp->group`

 Later, `igmpmsg_netlink_event()` copies the bytes after `sizeof(struct
 igmpmsg)` into the `IPMRA_CREPORT_PKT` netlink attribute and emits
 `RTM_NEWCACHEREPORT` on `RTNLGRP_IPV4_MROUTE_R`.

 As a result, 6 bytes of stale heap data from the skb head are
 disclosed to userspace.
</quote>

Let's use skb_put_zero() instead of skb_put() to fix this bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260430070611.4004529-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 94a6736bb5ab ("ipmr: only copy pktinfo to cache reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index dd4c570a0e04f..4bda6d5da981a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1094,11 +1094,12 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg->im_vif_hi = vifi >> 8;
 		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
 		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
-		/* Add our header */
-		igmp = skb_put(skb, sizeof(struct igmphdr));
+		/* Add our header.
+		 * Note that code, csum and group fields are cleared.
+		 */
+		igmp = skb_put_zero(skb, sizeof(struct igmphdr));
 		igmp->type = assert;
 		msg->im_msgtype = assert;
-		igmp->code = 0;
 		ip_hdr(skb)->tot_len = htons(skb->len);	/* Fix the length */
 		skb->transport_header = skb->network_header;
 	}
-- 
2.53.0



