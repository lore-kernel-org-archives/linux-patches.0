Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D4B8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A5DC433D2;
	Tue, 28 Mar 2023 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014856;
	bh=NmSHSlsP8RCxduUvIEdkUqUWq6TBok6LJUjCPlDgd3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYl1yJhLblwnPH0rESp0RAAdsgIQQiACWsct3tROKWT8rU6vUKcUguIBmjhmgq7HZ
	 fDrdqmVDwx/MupzQx8uzkNbkahAsNE06dVIIt1xxDygRkP7qwCA84Vn9Crp9Eks3si
	 9sftYC9zYNlGH+I/kQZWpDZA2Kl7KhOqLNmjQKxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 078/240] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Date: Tue, 28 Mar 2023 16:40:41 +0200
Message-Id: <20230328142623.034969152@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 032a954061afd4b7426c3eb6bfd2952ef1e9a384 ]

When BCM63xx internal switches are connected to switches with a 4-byte
Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
based on its PVID (which is likely 0).
Right now, the packet is received by the BCM63xx internal switch and the 6-byte
tag is properly processed. The next step would to decode the corresponding
4-byte tag. However, the internal switch adds an invalid VLAN tag after the
6-byte tag and the 4-byte tag handling fails.
In order to fix this we need to remove the invalid VLAN tag after the 6-byte
tag before passing it to the 4-byte tag decoding.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230319095540.239064-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 10239daa57454..cacdafb41200e 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -7,6 +7,7 @@
 
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -252,6 +253,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 					struct net_device *dev)
 {
+	int len = BRCM_LEG_TAG_LEN;
 	int source_port;
 	u8 *brcm_tag;
 
@@ -266,12 +268,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* VLAN tag is added by BCM63xx internal switch */
+	if (netdev_uses_dsa(skb->dev))
+		len += VLAN_HLEN;
+
 	/* Remove Broadcom tag and update checksum */
-	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+	skb_pull_rcsum(skb, len);
 
 	dsa_default_offload_fwd_mark(skb);
 
-	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
+	dsa_strip_etype_header(skb, len);
 
 	return skb;
 }
-- 
2.39.2



