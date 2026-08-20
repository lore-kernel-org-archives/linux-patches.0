Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F437A827;
	Thu, 20 Aug 2026 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239204; cv=none; b=fZ1XvVWsXSZyvFJS9gRpcN9AmKsc+OmjRCV0Z6nGZdyyoUhnSm3uKl9OjMpEZ6XpxO9yZYkOf5cXuhKHPR96S6OTf4JOi5AIFFhhTlNnR/NZOtC95CyZxkJOJC8YAqwTXJm/E7qAlR+1HVAFC0vjy1HUsFG/+C9mOdUNjIZoCeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239204; c=relaxed/simple;
	bh=JnuQ6BqQ2z96n3bziSMDIzQrd6R/An2kE05CkWrCqp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWXNcdMNibu6kU26nMUbqRhYR6KtijYAmnS0IY/feoP6mSDKlMZ2t/k5ieyRzxqt1lmGfnU1TAs9y9vYMUXEppZ9vZQewLrDuYVM3/ZXGDJSfUzcYEoCJ1goYnAzA17E822taoS+Dk2qzBi7FFKlUAJaCVfQB8P/o9lRp5hKoyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHNJU95K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHNJU95K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F9C1F00A3A;
	Thu, 20 Aug 2026 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239202;
	bh=xn0L13qGi0vF8zex+OrlH4QouF5Wl3Ph2Me+sLBDeCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHNJU95K6V0RmUrY07pKLRE8qAP2l5PcMPcKbvPvwELYnlFMLm+PjuaVoQVSyf+Kw
	 ZhgxiYRN0+7FCTxajrV7kYdn0UuJHy2Jsv1HYoBj7K0PqTQUeGf7RIxhm8degqozZs
	 z2MKFMy1avCVvAXT+McXsuIQCaZ5F6Qj1iflaFXA=
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
Subject: [PATCH 6.18 185/217] ipvlan: inherit needed_headroom and needed_tailroom from phy_dev
Date: Thu, 20 Aug 2026 16:55:53 +0200
Message-ID: <20260820145243.292479966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index baccdad695fda..93a8a7c91fb0e 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -146,6 +146,8 @@ static int ipvlan_init(struct net_device *dev)
 	dev->lltx = true;
 	netif_inherit_tso_max(dev, phy_dev);
 	dev->hard_header_len = phy_dev->hard_header_len;
+	dev->needed_headroom = phy_dev->needed_headroom;
+	dev->needed_tailroom = phy_dev->needed_tailroom;
 
 	netdev_lockdep_set_classes(dev);
 
@@ -773,6 +775,8 @@ static int ipvlan_device_event(struct notifier_block *unused,
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



