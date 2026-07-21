Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965F643F08A;
	Tue, 21 Jul 2026 22:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674435; cv=none; b=Ommj2ofifYkDBGh2hDbpAkc2gRfZeUisLpqEYvgjui5KWCnKwuqsOyqmiHZShNxBv5z9o38lKiNqqioOcAZ2884w+fB41V+drt1d3GH+szEd6VZlUDhDpymyjTShlL9LsZ5C/j9tgTvivtDEs1cUsvqmd85udY4hACBBeBELlXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674435; c=relaxed/simple;
	bh=iQEJtVoqYYuQDVHhKI0EpKTBNzO8dlzCzjlcTAowmns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaPIvIwV14Yd6DjwpIAcjedBnRmH5X53ZZ5RzVXjjjNc0LFU0obhc3hLBWDIvUuJyGYElN++Q5a8ACw2YSYSPY0JiPP63/r7fhaWYmOsVFm5d8vAi2yG71suHDe2Bh3YurVJe5WOkf1JxxGli5uD5Gc1UkC5lERqsPII09BC4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5RH9kUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5RH9kUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081EF1F00A3A;
	Tue, 21 Jul 2026 22:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674434;
	bh=UMSLdTjbEtDn4Ieo03f9bhGbxTAYJFRT8PHy+smdk7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5RH9kUWsGuVACC+9KOuOVj+8y+BTLSzcTjPIiXlsKcEEMFtgguz470pmddTwwRhI
	 0LtWwAWDUwtzwi7bUdcq/x8gQINMKbyjdjD5lfTx3RToAN+O/neGFHcUVtMe+7ukmu
	 zGlmQ/5q44LVnc8nzqvdjr/GZMbvRQ2iGEm0s3g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 538/699] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:24:57 +0200
Message-ID: <20260721152407.835679630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 035e1fed892d3d06002a73ff73668f618a514644 upstream.

pskb_may_pull() in batadv_interface_rx() could reallocate the buffer behind
the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the VLAN header but missed for the ethernet
header which is later used for the TT and AP isolation handling.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Fixes: c78296665c3d ("batman-adv: Check skb size before using encapsulated ETH+VLAN header")
[ move from mesh- to soft-interface.c ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index c8c62b0cd54c76..8b4a8e80c0a320 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -454,6 +454,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
+		ethhdr = eth_hdr(skb);
 		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */
-- 
2.53.0



