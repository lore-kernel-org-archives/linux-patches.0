Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591398;
	b=mFd/pGI6ox4TA1E0GCxHnrD0PHeXwhsF4FbYXqTGt/41/6TwfMTN6SJ4i3loovXCzYPQ
	 YSXsom525brsXCZNCYZut9nTD+eKxiYl/TP020Ad2YZI2Tl4jSGedVgqspNmOt67vB8mc
	 IXWmZnreff9JOTJnFQ6l+izMI8UwDyjXDg5yA1gfSTOv6HynVBUdi6fjInkismf7BvBgx
	 Ddb2PWamJL/4Y291dmRRgvYHLtIBLuFvIB5tQzK0AxIdjZ20Q10ETOPQ7Tn7+5Dt5ZCZq
	 Cn1wkuVX+ckIoikMOAlLDFlMjb6MIEO8OU9Ak49PasB9gl/v8R2WdLgFunv54kKjE0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JB/8N/3W+BjlSkiT7swjZTEkAMHZ/Fn1mRjENrVxIjU=;
	b=mssAkEZENHCICpfmc3ueZV0jDv14JkyYnY4wb3tgRXvtcZijbZDW3MtdCh3U79/7KcA8
	 P7r9LY4ICVFB4wQtxzJGwqoW4S1I3z+8hHcoV4+GvdPKuZO5W0NKtGiwdLDqofzcZBjza
	 CAVc2cgFGJzNoqmt+q2OrAlbQiujdxWtU2a0vOmIObZiqHPq2TIVnlAQ0NwHyrzGFQLeG
	 FbtHDbzpcxMJuPwhdqbGLlK0OLIp/FQLvgez8H7IlnifpOlP0fOczYuaBdXdc2yzCRyty
	 Lk6jrvC/b1FNDHdjEbVhbWhQeEKWZ43nsAWr0NKz6Ks+vUWzY01kLpVC/AvBHooZHkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCW3dfK+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565F6079D40;
	Fri, 13 Nov 2026 17:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCW3dfK+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DDF1F000C5;
	Fri, 13 Nov 2026 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591397;
	bh=JB/8N/3W+BjlSkiT7swjZTEkAMHZ/Fn1mRjENrVxIjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCW3dfK+GUh33seNrevQEmNuac8JsxTU2AnABrxvKeq5v6LwGLnohozBKYKdJl1cS
	 jYb0/yvPWrRq4B6uU3ZxaSSB9+UJr+F8Db1DNfRLd03uIM7EMsN9wUUrxHuEVNNFkj
	 5dgSBIV8TxTXjSHncxw5/It/eBw+hbJ5aScO/Zjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/670] ipmr: prevent info-leak in pmr_cache_report()
Date: Fri, 13 Nov 2026 10:51:00 -0500
Message-ID: <20261113153828.737896282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8fadd5281c5e4..b9b0be1b02a62 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1095,11 +1095,12 @@ static int ipmr_cache_report(const struct mr_table *mrt,
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



