Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30B4DEC26;
	Wed, 30 Sep 2026 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792501; cv=none; b=XTB4ymm4vhOaFu8+WjNylNI7RSAsQtX0Fmo3kHlH7ufJTidQpBcBuE432e2FcUq0vnsSofpM6NOrkuk3adpPskMChx7EtK7Cp0gJIiFxCL7/4de2/LZzrgR8KPm+C1/FSnRckxqZMlBPLt255fU2Zcgy7f0r7kEs55FOD9fW7+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792501; c=relaxed/simple;
	bh=X685JF4vp/biqhWY7mdfN4LkY/T3/Nr2ErFEyApOBB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyMoozfgINAsRMH8vOEvYMvw3CcSOCkziSPxQ1XY8uSUhZZZZFZwMHtV9nFmwAhrpo5KE7zou+f3GyRA56ZJ1VJPea8F/SHFs+6vXFS7pxp7ifxOFik8Jk1QqNaRPRM9Z4wUws2cvUXSIgC2dc7h8vuceg5NkDxnR0lS/uzxVrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHQaWBMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHQaWBMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA261F000FF;
	Wed, 30 Sep 2026 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792500;
	bh=241RO9K390PT/D4iodCNZ2aV/7Epy7lNR/MWGgJqCeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHQaWBMQ90BET8/7jfxcgxkQkaeiCL12MSVgJ/qnNVqnSos1uw44Wp78qbcYoTSrJ
	 6XPs6ZvZRtniydxqcNjD2AyYuct7Pb27c0U91lb4uGMsVl5b9IjqHa6QOM7rUfL7cx
	 F9Ja/pXgn9GieH8wWCZY0F4wJHcIJ2oBfcT4vpWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixuan Chai <petalzu987@gmail.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 677/752] vlan: ensure sufficient headroom in vlan_dev_hard_header()
Date: Wed, 30 Sep 2026 17:29:07 +0200
Message-ID: <20260930152412.897295672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 945a5bb7402d2..c26c47fc7b478 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -53,6 +53,11 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
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



