Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2174486E46;
	Thu, 20 Aug 2026 17:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247718; cv=none; b=UuwpSNFs7sT7jJix5TnB1u02t2L8cujVF/m20xZKCxinszQg8pbkYgtYBKv2nmWUwtIWMnyoZ8+UaUdmaEHlMUYEQvzy3/bl3s55UmfE3Lf1T5iUJtEuTSbAPIX//m2CIcn53LokxwgCycjsbTWP8jRyyIWscDjN48zZJ1zWhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247718; c=relaxed/simple;
	bh=sor4Ib2X7yLuGroKURFB2UEy5yi0fHo61KMkeltdzDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEqXziZr02kDxBQK2RnhjtNKvGNNlIyMtx38+ztXE37yJkUYZCj2+eBJOs4SlLMBdxSHUGS9Af8ADva5AimL7e5d0KqncwSell4oceVvdnW4e6UDHzjKn+cB2eGocps5uFVWOnO8OnDPVqRzXKCobS/BX8SPpmrsZRPEHvixYE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHAi+P9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHAi+P9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378291F000E9;
	Thu, 20 Aug 2026 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247716;
	bh=UireaOdx0QyavIAvitJjd1HeOz08f3OINCO0NDXPDRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHAi+P9OHiCpI/tN5mOJuoxsN7BYJcsiC1Pl0Xo/3vlLQHpGwCpJsZwJOCTutbvil
	 Sm8reF30RYwDJJBs5Mzic/VLygFBaRk45nivb2u74v/yFH85ZN7g51HMsS1u6I2zRK
	 hugXBqOxkvPCbfOkKcSYtQLs2g+4rX5OIm3q1Ijo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f9fd0f4b601cf88d6e6@syzkaller.appspotmail.com,
	Tangxin Xie <xietangxin@h-partners.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/166] ipvlan: inherit needed_headroom and needed_tailroom from phy_dev
Date: Thu, 20 Aug 2026 16:56:43 +0200
Message-ID: <20260820145215.504819138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e16e960d55a40d36bd7c2494cc005e757dc9a1ef ]

ipvlan devices inherit hard_header_len from phy_dev during ipvlan_init(),
but leave needed_headroom and needed_tailroom set to 0.

When the underlying phy_dev (or stacked lower device) requires extra headroom
or tailroom for headers/trailers (e.g. macsec, ipsec, wireguard, tunnels, or
veth with rx headroom), upper layers calculating packet headroom and tailroom
fail to reserve sufficient space.

This can result in reallocation overhead, skb headroom underflows, or KASAN
slab-use-after-free crashes when dev_hard_header() / ipvlan_hard_header()
prepends header data or when lower devices append tailroom.

Fix this by:
1. Inheriting needed_headroom and needed_tailroom from phy_dev in ipvlan_init().
2. Propagating needed_headroom and needed_tailroom updates to attached ipvlans
   in ipvlan_device_event() when receiving NETDEV_FEAT_CHANGE events.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Reported-by: syzbot+1f9fd0f4b601cf88d6e6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a720a21.40259c87.584f4.04bb.GAE@google.com/T/#u
Reported-by: Tangxin Xie <xietangxin@h-partners.com>
Closes: https://lore.kernel.org/netdev/CANn89i+1EW-sFNK8xoq98gMbPCeLS7e=+rs9gHfLg5Wj+4x0sw@mail.gmail.com/T/#mcc6307f115e500df23ea2980d5669fe95f20b6b4
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260806103857.115541-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 679e816146d81..706bf2e38d089 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -144,6 +144,8 @@ static int ipvlan_init(struct net_device *dev)
 	dev->hw_enc_features |= dev->features;
 	netif_inherit_tso_max(dev, phy_dev);
 	dev->hard_header_len = phy_dev->hard_header_len;
+	dev->needed_headroom = phy_dev->needed_headroom;
+	dev->needed_tailroom = phy_dev->needed_tailroom;
 
 	netdev_lockdep_set_classes(dev);
 
@@ -767,6 +769,8 @@ static int ipvlan_device_event(struct notifier_block *unused,
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
 			netif_inherit_tso_max(ipvlan->dev, dev);
+			ipvlan->dev->needed_headroom = dev->needed_headroom;
+			ipvlan->dev->needed_tailroom = dev->needed_tailroom;
 			netdev_update_features(ipvlan->dev);
 		}
 		break;
-- 
2.53.0



