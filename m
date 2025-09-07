Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBA1CDFAC;
	Sun,  7 Sep 2025 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275617; cv=none; b=Tq7qNIzTAHNyfPrCQcm2b8lO4S5N8OAjC2u2CLEHjrPY336T/dnFrCjrHbxdGG8OP2xfkVOC4tm2oE2btXCXhhpvmK9Zqg0mgViGZ0dm165S6/0qH8QF6yfAJRRiB4rh2FtNuFrmlMgszmGi/xA9s+0l6XedIZkG8j2+Wwg0FzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275617; c=relaxed/simple;
	bh=u5+makXpfW8Jps4QhlCi9Ytos2Li+P5hZSYSGDIxqm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL4Z5SUzIxiHm1rIcjaOtra+c0oq6+XoxTQsgM/snEDWyiNJKGsD/Ish2Bogzvfhq011Ca8ebEBjqSj9FahU6zlDPO0+tgas3Ri6Qkc3vyfKb6I8X85WfsN+zwxY3XVYUV+HBKO7EaNFF9hCLnup4oZaZ261eEB52psCaapXFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC5ZYVFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC5ZYVFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5039C4CEF0;
	Sun,  7 Sep 2025 20:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275617;
	bh=u5+makXpfW8Jps4QhlCi9Ytos2Li+P5hZSYSGDIxqm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC5ZYVFPeasriN5yeq4/r+0SlWFn0V2uaAEMrIMF1L8uNjOLm2A0QG1X7Y3nUjaBG
	 Cs4Y+tpgJ3gX3ZX0BcqeRPd7Bw15z/eyCq0pU4Bj9jOExjlfWUnB2dQk8Hv7/OCuD9
	 G+/fb7bGGQ7sWoYZMEF0J3zMgtJCDX+xkL3qVpeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibaut VARENE <hacks@slashdirt.org>,
	Felix Fietkau <nbd@nbd.name>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/52] net: ethernet: mtk_eth_soc: fix tx vlan tag for llc packets
Date: Sun,  7 Sep 2025 21:57:31 +0200
Message-ID: <20250907195602.302651626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d4736737110ffa83d29f1c5d17b26113864205f6 ]

When sending llc packets with vlan tx offload, the hardware fails to
actually add the tag. Deal with this by fixing it up in software.

Fixes: 656e705243fd ("net-next: mediatek: add support for MT7623 ethernet")
Reported-by: Thibaut VARENE <hacks@slashdirt.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250831182007.51619-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 011210e6842de..dc29403e4b733 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1178,6 +1178,13 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool gso = false;
 	int tx_num;
 
+	if (skb_vlan_tag_present(skb) &&
+	    !eth_proto_is_802_3(eth_hdr(skb)->h_proto)) {
+		skb = __vlan_hwaccel_push_inside(skb);
+		if (!skb)
+			goto dropped;
+	}
+
 	/* normally we can rely on the stack not calling this more than once,
 	 * however we have 2 queues running on the same ring so we need to lock
 	 * the ring access
@@ -1223,8 +1230,9 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 drop:
 	spin_unlock(&eth->page_lock);
-	stats->tx_dropped++;
 	dev_kfree_skb_any(skb);
+dropped:
+	stats->tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
-- 
2.50.1



