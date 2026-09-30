Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3583C1D66;
	Wed, 30 Sep 2026 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796917; cv=none; b=gT6jA5/2pyXYRR6DbvCsWmzrkL9klDFC4ToNpFXucryO82PoX7dASZirWfEg/+TBmk2FbL95MZz20HULfNv1izJqI/gAqHNZTkdVlxoKpR3FRTSZuw+e1nv4PxPeHKTlsHiuVk2GhbR0zekpFmqcxLl8kIzE4rJZIBDcM7Q+JCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796917; c=relaxed/simple;
	bh=YzGrtisuqIFrCA7I/xocU0JArdNUp/uFNKlLtyqlFy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=issfwAmZqQcMhKleIAAGahGOA8fF75paXG0Q6BuysUCtQjXV7V0SULUDUEPMHCuxTdKWQLy90dNjcilk8PBx/LRoF1OQD/9sF/hLkulMPGfyzr926vrjYD0hR4nI9kMx0+y2tyXSfjDQKBNnWRMidryPxCSAjvldXM2txj31/RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVQbepE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVQbepE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFD1F000FF;
	Wed, 30 Sep 2026 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796915;
	bh=F+W1++JfnhcshUIS7saSE+wQYTwtYEnBR7qdlbIu1cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVQbepE5Gx2q2DH9uReBq41P70d3OoL9d0MB4bO8MHJBSO/ptG3UT6JY3hDiSA0VF
	 JuL+xntoZ0NinBCrS743K3P1sdnkSkbDPsSwfqBwswYpn6xJ2UwX9M0n8saVqfy233
	 9wtBGsGOigq1WqNpcq656Tp/hTK58qJwHwNRZkr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixuan Chai <petalzu987@gmail.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1081/1193] vlan: ensure sufficient headroom in vlan_dev_hard_header()
Date: Wed, 30 Sep 2026 17:29:25 +0200
Message-ID: <20260930152458.249840725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index e9326f322d7a2..708e5bcb14104 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -54,6 +54,11 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
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



