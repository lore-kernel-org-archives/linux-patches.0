Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACFC19E992;
	Thu, 20 Aug 2026 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247245; cv=none; b=IA0K7NtvgypjodYXQLVPUeyJdIWMaFerPq+tMgdn4x0YqaZXAwZ6ht8g2PN3x4giAJG8hO4FJ2cDsC7yiiKK0qgi54kM3ciYeBHXoXeaqdaHXzmg3SFa/V1BlDce8MEwkI/5i7xzeTe0Z1vL8FbF4CpvMxuEzn8Xp2oMU/nPRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247245; c=relaxed/simple;
	bh=yLMXqPa42fO1NTqqljFDnF/MAIFiRCmWEGY7J1ILKKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M58mU6P8gWzJsq7aKeW0rrun3k3b/KVHcgE4R0eDew9k7fWuq2iVobDz2Ss6qHSlq5L8OeoBPjlcYOHoyCMOtczGm8VCo0GYzYn2WHwS/jG30batP3erOKi6b36YuvgJEFu+NmHEvZIIiqOwp0wFaw/RwhKeEYXBvqH3ukDV1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsGVASMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsGVASMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C881F000E9;
	Thu, 20 Aug 2026 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247244;
	bh=oF/u96Kyen2SDMX6zPGnowblmdVPXNGV2ZlKgREKup0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsGVASMXZ84ynsYqEmO+PUxuhLzplc9wHPPcYOV1Y2yNKYu4mjEIWnDXgpE/RsHrg
	 KT8JDl8uJglP/oPbar/rJzvPoUHjz3EwrCGFdr5nu/U08MzeNs2zO1Iv7A8vSN8Yix
	 6gLC5b+EMzMUStlChxH1CQtzjUhVedMaqnFmwr9s=
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
Subject: [PATCH 6.12 200/220] ipvlan: inherit needed_headroom and needed_tailroom from phy_dev
Date: Thu, 20 Aug 2026 16:56:30 +0200
Message-ID: <20260820145229.521950379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
index bce52c743f0e8..1d7b9381839d1 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -145,6 +145,8 @@ static int ipvlan_init(struct net_device *dev)
 	dev->lltx = true;
 	netif_inherit_tso_max(dev, phy_dev);
 	dev->hard_header_len = phy_dev->hard_header_len;
+	dev->needed_headroom = phy_dev->needed_headroom;
+	dev->needed_tailroom = phy_dev->needed_tailroom;
 
 	netdev_lockdep_set_classes(dev);
 
@@ -770,6 +772,8 @@ static int ipvlan_device_event(struct notifier_block *unused,
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



