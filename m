Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F52D38E8CE;
	Wed, 30 Sep 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791617; cv=none; b=mc2A32mRRUFT11gWP5GlvAF42qWf/minCaa+jtm1fqDjlTyZcFR3BYFTSFpGpdxxnwDZ6IhmKHynztK4100LaD/PtRrhv+c6cM9JdnVTY63v57Pjoty/ysKwEpDg6neUBFfi72YbO/mQ0YobhaD883uG2Thz+3wuo6OhsQMhoWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791617; c=relaxed/simple;
	bh=szHAOg/i3BuK+V7/35iy0t0FHaf7/IFNujd8cALj6wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBvFtZWumionEqgj+Dps2dpOzMqy/nbJxTtlS8ecEOuRNVSLZjzXz3OmpxrgMJ9li8BaOArSep4MC/iHra/6j7eBIvV+s+iJae1o89GvvMnwHC4+GE7U7ecLxzjyx1yDqtaixdfmTho81K76LGtXG2xM39OXZwYyaT5gggxKgZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC9Jb5Jt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC9Jb5Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9273E1F000FF;
	Wed, 30 Sep 2026 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791616;
	bh=vdqKb4lTb+RwIpGqIPIIPYeYbLe7yrnvQK89ZKXK1zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iC9Jb5Jt7xKdStaKWVujkjngmW0YbMi1kshPiSM3D5sAMlv+PGnxAH5ki0+EUnrx0
	 zjmCh4pfhKV0ZuBG/kdCB5uAn2fdevtaUKUsyTChJB0JSCcAWeD7Y1ZWQxG7DQwqQh
	 zfVVtqX/FT1hqWip+W9kLOoNF3wIxKtQZS3c284I=
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
Subject: [PATCH 5.15 363/752] macvlan: inherit needed_headroom and needed_tailroom from lowerdev
Date: Wed, 30 Sep 2026 17:23:53 +0200
Message-ID: <20260930152406.136890169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86a531ffe9fc0..c8c1761908c1b 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -913,6 +913,8 @@ static int macvlan_init(struct net_device *dev)
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
+	dev->needed_headroom	= lowerdev->needed_headroom;
+	dev->needed_tailroom	= lowerdev->needed_tailroom;
 	macvlan_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
@@ -1769,6 +1771,8 @@ static int macvlan_device_event(struct notifier_block *unused,
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



