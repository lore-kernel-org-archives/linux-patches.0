Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052F3AA19A;
	Wed,  3 Dec 2025 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779599; cv=none; b=QtV9L+Ike861uBBHBQf0oIAkgyp069VomxQGG5rBKKgQuPLM1/M5MsakRGkFOLVuLnNDERn5RkR3YWjmGc08mqo84m9ZOfvb4Yolwd3wtpJR8RRqJlwQLCi6Mwbs5TueSaDmc9rYqFGzCXKhokQTzExQXiV1ra0RbJvlNFmaE9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779599; c=relaxed/simple;
	bh=PrZG4J2jrgkDajoaVv1ZmFAOce1lr39ksnpMig3gw2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGzudBZak8LkNFtS+iuQSUpbOaAcXfFaJ7OgHfLirWHrfOimnJm//QUKoplliXTmh/bqP9nn0Muhllp6/EcjTYiqSx2k/nlIL1wM43iEmSGO1lAuY0LeZUU67Y+x2/5uun1hn0eSVhhc+dzOJqHtSpcd3C9N1Cr114/NwPIvYBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O01gg98a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O01gg98a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F5C4CEF5;
	Wed,  3 Dec 2025 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779599;
	bh=PrZG4J2jrgkDajoaVv1ZmFAOce1lr39ksnpMig3gw2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O01gg98am/j3/hT+WwDGthkdD1oZiIDSSCQg89mzbCq1zkFOn36BfR0fsJpENjS+A
	 P7z4a+8Eusp+Gj40tscKxg/XI+c17s30bxfE8B8evpxcRyVo7tMqa71xMj6EFOdIEq
	 ix3eU+cxEyEsJ/d1TJG205uTDO34ATI0ww2JCz34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/568] net: dsa: tag_brcm: legacy: fix untagged rx on unbridged ports for bcm63xx
Date: Wed,  3 Dec 2025 16:25:07 +0100
Message-ID: <20251203152451.880999506@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 3d18a84eddde169d6dbf3c72cc5358b988c347d0 ]

The internal switch on BCM63XX SoCs will unconditionally add 802.1Q VLAN
tags on egress to CPU when 802.1Q mode is enabled. We do this
unconditionally since commit ed409f3bbaa5 ("net: dsa: b53: Configure
VLANs while not filtering").

This is fine for VLAN aware bridges, but for standalone ports and vlan
unaware bridges this means all packets are tagged with the default VID,
which is 0.

While the kernel will treat that like untagged, this can break userspace
applications processing raw packets, expecting untagged traffic, like
STP daemons.

This also breaks several bridge tests, where the tcpdump output then
does not match the expected output anymore.

Since 0 isn't a valid VID, just strip out the VLAN tag if we encounter
it, unless the priority field is set, since that would be a valid tag
again.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20251027194621.133301-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 04b57534fe4de..cd07ae440d69d 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -251,12 +251,14 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 {
 	int len = BRCM_LEG_TAG_LEN;
 	int source_port;
+	__be16 *proto;
 	u8 *brcm_tag;
 
 	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
+	proto = (__be16 *)(brcm_tag + BRCM_LEG_TAG_LEN);
 
 	source_port = brcm_tag[5] & BRCM_LEG_PORT_ID;
 
@@ -264,8 +266,12 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	/* VLAN tag is added by BCM63xx internal switch */
-	if (netdev_uses_dsa(skb->dev))
+	/* The internal switch in BCM63XX SoCs always tags on egress on the CPU
+	 * port. We use VID 0 internally for untagged traffic, so strip the tag
+	 * if the TCI field is all 0, and keep it otherwise to also retain
+	 * e.g. 802.1p tagged packets.
+	 */
+	if (proto[0] == htons(ETH_P_8021Q) && proto[1] == 0)
 		len += VLAN_HLEN;
 
 	/* Remove Broadcom tag and update checksum */
-- 
2.51.0



