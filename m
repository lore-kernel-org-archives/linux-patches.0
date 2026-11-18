Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046816;
	b=jLSetaxyUSwu9JOuhujQWK/QC+Jsfueah1q5kJEYPDqk/iJq+Ipj4t/U7penhbqUq3WZ
	 ndg2CqXehiGX5N7NISt240nJX952vAVchUJ17EHwyUWOFdVhry362pepyRuJTyNGfHqj8
	 Kj/7qeVPK3BywLfnBpD00U0XhRitR+GzlGwkAXUidEkXKXIJqSGrR4XO5wca2+M4fA0El
	 s08tbfb0rbRv41nb8Zf6m6iMf3BNBhYf6BFzU/xzX88CuRQjv9EOGpFo80Q215G0129Ld
	 Kku1agWYglQpdhO1PKGSDrZk4/lWdhvZSwwi1OEczkUafMVG7nSNTmbLRRO8U9y2zYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCrMCP2acCyazMDpuO+oCpcC79ytbkbYgsdD8Jy0Oek=;
	b=vNZ0ona1/gfh5InILQdm8vuOOk/wpYrYb7FDhV/nMc8yAO5i8idqgzf8B0mzkRzRtsPE
	 zLLBCr6Ck9J0Mw4w0wDbGoahoGcodlgaDJgnngLpHwu/r08ZFtfYoeHCSfvkKxBwsa/Ti
	 bH3eKlrhW6fz3FIBCtGfmaaoLagNsDkjRT9V3b6A6lxkILpB9cjRdFTZs3qdkeUGEc2IS
	 m5Q3sNmbeCO8GabsrR3F/pHM3s+m66HgMjTZvp9JguaHwxgV4YeCAfxCpwOSCM51M0QC2
	 O76xKQRbzuA/00oxHX9XITdf1HHUFsAoe6nWCZgbhCYhH0guulIEwbiNzlnRSdbikfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lKCfw/di";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C32606A320;
	Thu, 19 Nov 2026 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKCfw/di
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5161F000C4;
	Thu, 19 Nov 2026 00:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046816;
	bh=aCrMCP2acCyazMDpuO+oCpcC79ytbkbYgsdD8Jy0Oek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKCfw/diXZp5Y6D3zBGBqP8y3tjKd609rRjwe2aiN3wB1Aky6IQJMgTC2lfEt/U/M
	 K9Kgh652WRjH/USFg0TmaeW/QO8paoSJOme5B5HZcD4OezGjOKbpljJcTjex+LLSnr
	 7EsOiFWoV+SzYCRwlgfmiGcuDEjC4PIGmRg3nn5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1415/2857] ipmr: prevent info-leak in pmr_cache_report()
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150252.279807984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f9c39b3cb5aa..459d58b36dec6 100644
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



