Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F55726463A;
	Wed, 25 Feb 2026 01:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983527; cv=none; b=FECCrZ/bofB0458IZSsHbK/6dwy9VhuDIMt2Pq2dScBfzR3OSrlw+lcR2TkLZzVNtAWcCKewPqOVimBjP9NXQZDLiXSR7sgL0nDYfOliw05cIFvLozhZl/gTaAOJoir6j8d58zx1D9NOOBwxzrnNbvEpXNNzmhRaDVqFrQIJOao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983527; c=relaxed/simple;
	bh=vjyZLNTlZ1I1thJTTiJR0ytr8uhMdqwKHR69l6ATJ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCi1gahhz8FASEVQjLq1JvqJ52L3r6JQ/ivu36EKDXyrK8GkfDe4t6zZvAYIFWVeP8NTFfFYE1XuZA3j+ctn9msuiUJpOdMnTaVpuOBnlQIWKCfTVqxzYBLHckaeoPZQdr2NgxK9+Xzk1XR7jdqP+yazMvr6uIiZ+gQvJBbdOOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW+/GqrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW+/GqrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF22DC116D0;
	Wed, 25 Feb 2026 01:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983526;
	bh=vjyZLNTlZ1I1thJTTiJR0ytr8uhMdqwKHR69l6ATJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW+/GqrWUvz3T48YePBSgXiMW8I3hzLf35+G7VkDgTFfj87Ue9Pkr2KSVJv2XbH4/
	 xBT7wdS1Ce8rF1vg0GGizD7g6AiHRe1FdhFuzbpz2Sy+gnhPnlyln5YF0PbvFkbHHg
	 o9dYSoiVVGebMwOtPIoCQurAnPNhknRmd215fmuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 634/781] ovpn: fix VPN TX bytes counting
Date: Tue, 24 Feb 2026 17:22:23 -0800
Message-ID: <20260225012415.357602716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit b660b13d4c6379ca6360f24aaef8c5807fefd237 ]

In ovpn_net_xmit, after GSO segmentation and segment processing, the
first segment on the list is used to increment VPN TX statistics, which
fails to account for any subsequent segments in the chain.

Fix this by accumulating the length of every segment that successfully
passes skb_share_check into a tx_bytes variable. This ensures the peer
statistics accurately reflect the total data volume sent, regardless of
whether the original packet was segmented.

Fixes: 04ca14955f9a ("ovpn: store tunnel and transport statistics")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ovpn/io.c b/drivers/net/ovpn/io.c
index f70c58b10599b..955c9a37e1f8d 100644
--- a/drivers/net/ovpn/io.c
+++ b/drivers/net/ovpn/io.c
@@ -355,6 +355,7 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ovpn_priv *ovpn = netdev_priv(dev);
 	struct sk_buff *segments, *curr, *next;
 	struct sk_buff_head skb_list;
+	unsigned int tx_bytes = 0;
 	struct ovpn_peer *peer;
 	__be16 proto;
 	int ret;
@@ -414,6 +415,8 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 			continue;
 		}
 
+		/* only count what we actually send */
+		tx_bytes += curr->len;
 		__skb_queue_tail(&skb_list, curr);
 	}
 
@@ -426,7 +429,7 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	skb_list.prev->next = NULL;
 
-	ovpn_peer_stats_increment_tx(&peer->vpn_stats, skb_list.next->len);
+	ovpn_peer_stats_increment_tx(&peer->vpn_stats, tx_bytes);
 	ovpn_send(ovpn, skb_list.next, peer);
 
 	return NETDEV_TX_OK;
-- 
2.51.0



