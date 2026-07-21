Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B14043B3DA;
	Tue, 21 Jul 2026 21:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669985; cv=none; b=u/BFiWvhmuQsvgP+FKnWKrN0qxdPgkedVpQc4BU+Dt0oGINSv2Z2t8QlrPr4bvwqhnXFTFBfyCU/N/mBWb2g8oQFxpU6Po7MtxV7BH4RS+NjPPxgFpf3sfoLaQhR+rane9MwG34W+sfQkAATo1ZeaVqaVSF9OZWeqIgk9U4Yf/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669985; c=relaxed/simple;
	bh=NLsvBJ5AOixUIupAjzHR8T6eUDH3An4UdQ6QHDCww6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYEoa2lAlqfVS+aJ1AYFx+Wnr/qCn3jNWKUMsMna0SrA3bjM6rtJgi/ZyTtV1eoiZuq6YstBAYbILWZon9GFRty4htLH+p7ONUaQRa/+5yyJeafNHkdP0JLG+p2icJbkqfSSeyrhLphkpAL567uFmGzJr/P8vEIwfDPPNw8PRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pY1RIaKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pY1RIaKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AC1F000E9;
	Tue, 21 Jul 2026 21:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669984;
	bh=GInqN4NqZ0JVTARGOW8N8qhGCdyrawm17lzooP6S++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pY1RIaKiwpFH9Q5XWtAIZ0X+LdIsNFk1oTJj6CCn+K6QN2qUDpNpDra5ZR+JZ7NNn
	 yqg5eZErD8Dud0FrOKDjZomWO9U9NKP1P3mEY0rHhaFyeuHnIu7gw34Q0sk2CrPVbQ
	 WCsl3dtBaP/iJ5s0/ub/IDxTARuFXAaD6ylAAXFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0762/1067] batman-adv: gw: acquire ethernet header only after skb realloc
Date: Tue, 21 Jul 2026 17:22:43 +0200
Message-ID: <20260721152441.615588902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 77880a3be88d378d60cc1e8f8ec70430e2ed0518 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 6c413b1c22a2 ("batman-adv: send every DHCP packet as bat-unicast")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -693,12 +693,13 @@ bool batadv_gw_out_of_range(struct batad
 	struct batadv_gw_node *gw_node = NULL;
 	struct batadv_gw_node *curr_gw = NULL;
 	struct batadv_neigh_ifinfo *curr_ifinfo, *old_ifinfo;
-	struct ethhdr *ethhdr = (struct ethhdr *)skb->data;
+	struct ethhdr *ethhdr;
 	bool out_of_range = false;
 	u8 curr_tq_avg;
 	unsigned short vid;
 
 	vid = batadv_get_vid(skb, 0);
+	ethhdr = (struct ethhdr *)skb->data;
 
 	if (is_multicast_ether_addr(ethhdr->h_dest))
 		goto out;


