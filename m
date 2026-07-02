Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A0C360EFC;
	Thu,  2 Jul 2026 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010490; cv=none; b=P5FsGpnCupDvGfwkvW15y6/w+PLX2aCSDsjCSEtihR67Tx2pK1OMhNSy//63ZoopNXX0IYwU7gMhOK4mlxc7Pel3fSvNFfCXF/Vw48n0st3XX9iTVOS7g3La5oM2lT7qD/cILT2bTZ1POinOfF0wJZlBtxoFCzNAnR9aSM/2vGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010490; c=relaxed/simple;
	bh=w3eeAwbhoFnypXG1HbCwNHslNz4zF+yCuGyhZf+bhn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX1W79XlbvU6GAUYbYobZn8KaD99afCFKRTkzYWTrx8NQfQesi9EgNnG3JEY1BcdcYleMiaFwzOdZVT3j6K1gVUK+SzpBkvN6LI+/7lAjZu3ARKYDZ+0Z5ZVo0Uonx161bVzNeaZ/8rRLBrUxeGTHAAxceLWvvg88S03UYeKHFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMjVdpAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMjVdpAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56DB1F00A3E;
	Thu,  2 Jul 2026 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010485;
	bh=1u5AuLXjov0rV1YBHOV23PAyGDTMUZnnu2LSXNhqSVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMjVdpAwMLFQdQv5A02zh/1K3RhVY3Oy/LmPsqf2/LbPhNQF8a+NjwZ/ioQmiRWvJ
	 84q1eL8Dj+Wzr5I5Po6JZ80xmSgY8KMrropi90XbOweyy4xpMKzji2xI10Pe7/68pO
	 LzBwJv6TzqjQNu8QUSFqVJffsKgldaX1SGChZ/cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/204] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:19:27 +0200
Message-ID: <20260702155120.965236995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 4cd6d3a4b96a8576f1fed8f9f9f17c2dc2978e0c upstream.

Before batman-adv is allowed to write to an skb, it either has to have its
own copy of the skb or used skb_cow() to ensure that the data part is not
shared.

The old implementation used a shared queue and created copies before
attempting to write to it. But with the new implementation, the broadcast
packet is already modified when it gets received. Potentially writing to
shared buffers in this process.

Adding a skb_cow() right before this operation avoids this and can at the
same time prepare it for the modifications required to rebroadcast the
packet.

Cc: stable@kernel.org
Fixes: 3f69339068f9 ("batman-adv: bcast: queue per interface, if needed")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index f1061985149fc5..32a40c1c115c6a 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1198,6 +1198,12 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 	if (batadv_is_my_mac(bat_priv, bcast_packet->orig))
 		goto free_skb;
 
+	/* create a copy of the skb, if needed, to modify it. */
+	if (skb_cow(skb, ETH_HLEN) < 0)
+		goto free_skb;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+
 	if (bcast_packet->ttl-- < 2)
 		goto free_skb;
 
-- 
2.53.0



