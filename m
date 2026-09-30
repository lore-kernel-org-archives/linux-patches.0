Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A381651C060;
	Wed, 30 Sep 2026 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793269; cv=none; b=ZyAbXwomdjxY0wIZ2zoC+YmbCAP9mcoUHKs+oj+EWy/QmjmHXTSkbLtQHSa/9TGxRP6Skvjac5dQniSOY8m83XIu+z4DY2tWoWCp8/xdnI/4kwgN+4BDBzF5yK3yqylTOf685jvxBUDZvNO3YmJ4HOiLVSc5MvgL55LCX3GdFow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793269; c=relaxed/simple;
	bh=fGsQDJbUEQdL67oMNjp60sudvgsQmV9izo2BjNwvSfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWhy0bUAXpf4Bk0wBnK04ho4TdJ85R+PyPcdxiXa93/EcUgboWUpCyx4uCtGfRmWCK3fjRskkeDjQW6zfLE4xEq+r6aPmcQVEsU3/zzyaaWF8qzk4S3pEI/c+ybRjgfB6YxzsabHAnF2WAbLHckCveCvb04BR7QHiydFeYug4m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PycmPEsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PycmPEsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293A1F000FF;
	Wed, 30 Sep 2026 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793268;
	bh=wX9dt0+9SLoNHWXeGKGgoxzQeBB2X28AzzapyJjsfTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PycmPEsGxlzhR3Oc0JEsiWt8NOXBcOCHOGr1Ir3eTcqNh9jxpwfp5bpA12dvUXgvq
	 yDcqzKXH6TUnLb1BXqluYHcuXQcOvUJ44QHbSn3JdAtrluYX/MahB/3IEm30EFaiKA
	 mutQkfXm1cpyQ5kPTv+659u0WLx3Fr5Mn1Ec4Suw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixuan Chai <petalzu987@gmail.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/395] vlan: ensure sufficient headroom in vlan_dev_hard_header()
Date: Wed, 30 Sep 2026 17:27:37 +0200
Message-ID: <20260930152344.878554240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd5dd68267c4238795fadaf02b3575ca3f8a6500 ]

Callers that only reserve ETH_HLEN or less (such as llc_alloc_frame()),
or skbs allocated before dynamic device/headroom changes (e.g. toggling
VLAN_FLAG_REORDER_HDR or bonding/team switching slaves), can reach
vlan_dev_hard_header() with insufficient headroom and trigger
skb_under_panic().

Use skb_cow_head() in vlan_dev_hard_header() when VLAN_FLAG_REORDER_HDR
is not set to ensure sufficient headroom for the VLAN header(s) and the
underlying device hard header.

Use READ_ONCE() to read dev->hard_header_len and dev->needed_headroom as
they can be updated concurrently under RTNL (e.g. in
vlan_transfer_features()) while vlan_dev_hard_header() runs locklessly on
the transmit path. Also avoid LL_RESERVED_SPACE(dev) here so that the
extra HH_DATA_MOD alignment padding does not trigger unnecessary
pskb_expand_head() reallocations on inner stacked VLAN devices after the
outer VLAN header has been pushed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Zixuan Chai <petalzu987@gmail.com>
Closes: https://lore.kernel.org/netdev/cover.1789987105.git.petalzu987@gmail.com/
Link: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260924082951.1599377-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 560521cf596e3..618c8617c2c43 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -55,6 +55,11 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 	int rc;
 
 	if (!(vlan->flags & VLAN_FLAG_REORDER_HDR)) {
+		unsigned int hlen = READ_ONCE(dev->hard_header_len) +
+				    READ_ONCE(dev->needed_headroom);
+
+		if (skb_cow_head(skb, hlen) < 0)
+			return -ENOMEM;
 		vhdr = skb_push(skb, VLAN_HLEN);
 
 		vlan_tci = vlan->vlan_id;
-- 
2.53.0



