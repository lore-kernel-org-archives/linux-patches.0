Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0C237C925;
	Thu, 20 Aug 2026 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238582; cv=none; b=TRDEzBR173AwRvOuhmboNQddFWxWoQGdE2X8OSwurfc1UAmxSnBM3mFSLfLnkapSoYV/oPgOab1oGIVyfTK+ely63HMNBZ+ZWw6+FbQwZ1hc/p9QeKEILpid65tA7GL6nBnOPT3kQUGRWKmu/Oyu6/cbkCyE0qtNcMe9QSm9/yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238582; c=relaxed/simple;
	bh=/aFOAhKsPUTNr9wnGybru0HC7mR0fomWUh0i1kjuPfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtNriDzpe7WpC200Zq1YOYIJZD+4lQh0ZxGXmtOh6ZhozFQLQG+K4GcZyip69OzzD5q3+egD7sXcvH8JSzwK6g/UKDLWC/fNzB8+Y92phzP4mxXj1EJs25OEMrB6ktvXtv3aIIPEbN/oGY4v3TgIX4QKlzqWFQFEEic30AFm0x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTYoL++Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTYoL++Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433BA1F000E9;
	Thu, 20 Aug 2026 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238580;
	bh=nMM4PSntJLy1HaXBx16GT2wGj19bterg12hWsEqJsxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTYoL++Z0ShuKthmzn7e+QNLC8QXPFLQnOR8QN3vZZpGhEYyYCCrs1pABlPXhFjCs
	 Q86tFjIaN4iUPOVo8XKe9Fbu6j+FBNWrQXCQqRPyaPOnY+JZDnXfs9FjpF0ZmS1zSa
	 nXt2TsuLAP7M/dkh2282MA0D3G0n2UNz/V2NTJEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@h-partners.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 198/228] macvlan: inherit needed_headroom and needed_tailroom from lowerdev
Date: Thu, 20 Aug 2026 16:55:40 +0200
Message-ID: <20260820145251.054671492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/net/macvlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c40fa331836bb..ff2f4bb651b74 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -950,6 +950,8 @@ static int macvlan_init(struct net_device *dev)
 	dev->lltx		= true;
 	netif_inherit_tso_max(dev, lowerdev);
 	dev->hard_header_len	= lowerdev->hard_header_len;
+	dev->needed_headroom	= lowerdev->needed_headroom;
+	dev->needed_tailroom	= lowerdev->needed_tailroom;
 	macvlan_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
@@ -1824,6 +1826,8 @@ static int macvlan_device_event(struct notifier_block *unused,
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(vlan, &port->vlans, list) {
 			netif_inherit_tso_max(vlan->dev, dev);
+			vlan->dev->needed_headroom = dev->needed_headroom;
+			vlan->dev->needed_tailroom = dev->needed_tailroom;
 			netdev_update_features(vlan->dev);
 		}
 		break;
-- 
2.53.0



