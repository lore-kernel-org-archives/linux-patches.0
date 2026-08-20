Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD4D476CED;
	Thu, 20 Aug 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248601; cv=none; b=FIFJRYtIhgI24aS1tTgiWJoQhCAawcYLncNCSGN3PWx+LYC4ToeP4TAaLYrB7Ko2/4Br7ZUOCRzTHM7p5/gqHMeNtYwFkH9cnFfmrtQrx54d9fDLySm/NBrzLj5P2y7S7ssjFHfE1Q1aRDh6BayTAkRIhX3mk0PX0UJ8qQ7OCKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248601; c=relaxed/simple;
	bh=lxWTJDXstPlIyYXxzPyR4lx9SRWBxlKr/cSq/rj556w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhZkTfNR1XOAHyKVcMS2TMDYf7CyV5j2+nFjQ2Nx9XGJYEwx0KuuQ55GfdMki0ZZY4eCcCEHQCqb0IexMe5H4gws3+4tKS30M3pzAt5PlEOJGVq5kzdMQOp/VE9+MZhfzc8j+iWYpiCm1jcNEoOpEEqjk/jxDmJqQ0LBgapW0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LTnCFkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LTnCFkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883781F000E9;
	Thu, 20 Aug 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248600;
	bh=7R92Yjm8OCMAIJ9jppZglAC3P6OE2ddN7VtPjxsqj6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LTnCFkEZ33F1uL/AdDMzUjR0nKoXzLfF7k5p5iKwiDIYJzM1mIVApWjhEjWFAKbh
	 f5hYtew8H5FlgpHROnahPJ5yiBpTnu/L8FPxjHua5M3nwe0mDYkgvlzTQK0rbyTEpc
	 sSKmIpugwjSNibW97BFbTQ5lmxGiWCI7l47b63cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@h-partners.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/303] macvlan: inherit needed_headroom and needed_tailroom from lowerdev
Date: Thu, 20 Aug 2026 16:57:01 +0200
Message-ID: <20260820145302.034729994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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
index 14018be5e7e70..b18d5178cd0eb 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -913,6 +913,8 @@ static int macvlan_init(struct net_device *dev)
 	dev->hw_enc_features    |= dev->features;
 	netif_inherit_tso_max(dev, lowerdev);
 	dev->hard_header_len	= lowerdev->hard_header_len;
+	dev->needed_headroom	= lowerdev->needed_headroom;
+	dev->needed_tailroom	= lowerdev->needed_tailroom;
 	macvlan_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
@@ -1780,6 +1782,8 @@ static int macvlan_device_event(struct notifier_block *unused,
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



