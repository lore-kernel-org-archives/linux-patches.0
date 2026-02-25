Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9F2D77F5;
	Wed, 25 Feb 2026 06:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002720; cv=none; b=UO6+7q34h7U9ekezEWA1NOcp5urHKqCTg2L/LPXgmJNO0nNkTPlrCm26RU7wd2gBoxeiir+EQygTaHfeyGAlLEDBn/XRgQP1q9ZcPQlWzBAcn+In0T1nz5XR9+9DagBi3L23Q08joAZC6y3103glNm9ksP9vdY4/Vqa2dP3m51A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002720; c=relaxed/simple;
	bh=E6+gq3WrAVQ9CSKeb3ZH6T1P4bZTzUV23JQeXsK97U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlLe8ID4xQFFWjBsgH+e3Zpx/YNnoiwTcIgMlv2auUA2RbqD7ODZYhMLH+zIDUTDMMiginijUaZXigV/7hzt1uDq/N6EFF34DVnXvtHbiJIFzcrd+HR1/+QjTHDfXW7435+a6zvupmcDwEEh4Ag4AxVl2RdaRjP2slcPzn4abmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1/XY7H7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1/XY7H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D0CC116D0;
	Wed, 25 Feb 2026 06:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002720;
	bh=E6+gq3WrAVQ9CSKeb3ZH6T1P4bZTzUV23JQeXsK97U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1/XY7H7gr1UkYlKQh0s/lgjelWbv6e/CwVL43pKMkM9XqkdDbOSkLhiyeV3Ddr3C
	 DPtrd+24byVpsaGSM5Y25rYivsDtI3rT/8J+TSvW04bywwTtbJ47fi+m1BF6DODApF
	 DssJNdMwnfMCiTzJj/OXBPrqALIueTGdM0AJJuTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/641] ovpn: fix VPN TX bytes counting
Date: Tue, 24 Feb 2026 17:23:58 -0800
Message-ID: <20260225012400.928559741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



