Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F0437CD22;
	Wed, 30 Sep 2026 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783126; cv=none; b=Gox0piECX4yQxdknC/R3d2K0tUQJSqsOo8wM8QEHEsAJZGXRvwCyIQFbrF4oSs97DyK0TLFIC+eTGWipAWb2jyotBiJZam8D3d4e1v1CwEMNwsAH2W1kzH2YSHWW/ZsqaI3se5IKa9ce7D1xxLNHeDqafGNzr2MPtwP+1u9Xb6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783126; c=relaxed/simple;
	bh=V+srchfj5X0suiaWZXTRX/juF1twut9pAVg5j7MiXv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSzHMoJfG7pSXP983B9dRBRZACm6JmG+Fa3Ylm9/085lRNAsb8PmgFrSdSLrQaZPykjLFQo6GtTheVS1tHeAnzVwfZlbLksqZ8ql+pBiYM6M3AbomZiOy/t5DQr0LImLCkAYm3DX2ZrndwYdjp7CdmFLxL0cH9KmAHn6BFvDX2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTQwMSv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTQwMSv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85ED1F000FF;
	Wed, 30 Sep 2026 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783120;
	bh=xUIFsZLyZQNguusbWXZylb/YpFhQgKNcZjUNoPAtV4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTQwMSv4YXXx0K41G1A0lnJFz7gL5/1MROPeqBkOphQK3xQtDj2zQmo98eY2fbRKl
	 oYAgwMC4Hv7jyMtimND1RioZ8FWvmpQaoMD5irXrvVbRKaoBrQZQELc54ARvP9gEhH
	 yAJ7lWIuxzFZOw6VGZ0a+O5k1BN7GEjVEPTQ4Xpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@h-partners.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 286/595] macvlan: inherit needed_headroom and needed_tailroom from lowerdev
Date: Wed, 30 Sep 2026 17:22:59 +0200
Message-ID: <20260930152353.851248802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cef51860becd9700217c81732ca1eb1ea6ed6fe1 ]

macvlan devices inherit hard_header_len from lowerdev during macvlan_init(),
but leave needed_headroom and needed_tailroom set to 0.

When the underlying lowerdev requires extra headroom or tailroom for
headers/trailers (e.g. macsec, ipsec, wireguard, tunnels, or veth with rx
headroom), upper layers calculating packet headroom and tailroom fail to
reserve sufficient space.

This can result in reallocation overhead, skb headroom underflows, or KASAN
slab-use-after-free crashes when dev_hard_header() / macvlan_hard_header()
prepends header data or when lower devices append tailroom.

Fix this by:
1. Inheriting needed_headroom and needed_tailroom from lowerdev in macvlan_init().
2. Propagating needed_headroom and needed_tailroom updates to attached macvlans
   in macvlan_device_event() when receiving NETDEV_FEAT_CHANGE events.

Fixes: b863ceb7ddce ("[NET]: Add macvlan driver")
Reported-by: Tangxin Xie <xietangxin@h-partners.com>
Closes: https://lore.kernel.org/netdev/CANn89i+1EW-sFNK8xoq98gMbPCeLS7e=+rs9gHfLg5Wj+4x0sw@mail.gmail.com/T/#m16adf0ff972cbfd8066c3a8e656e75eaeb12d021
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260806141938.287660-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 95ae47a7a69dd..f6ad599252d32 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -910,6 +910,8 @@ static int macvlan_init(struct net_device *dev)
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
+	dev->needed_headroom	= lowerdev->needed_headroom;
+	dev->needed_tailroom	= lowerdev->needed_tailroom;
 	macvlan_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
@@ -1731,6 +1733,8 @@ static int macvlan_device_event(struct notifier_block *unused,
 		list_for_each_entry(vlan, &port->vlans, list) {
 			vlan->dev->gso_max_size = dev->gso_max_size;
 			vlan->dev->gso_max_segs = dev->gso_max_segs;
+			vlan->dev->needed_headroom = dev->needed_headroom;
+			vlan->dev->needed_tailroom = dev->needed_tailroom;
 			netdev_update_features(vlan->dev);
 		}
 		break;
-- 
2.53.0



