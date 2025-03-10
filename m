Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE162F28;
	Mon, 10 Mar 2025 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630681; cv=none; b=IMEcQV9g9RPb8cpVNaxxGutcjo2YcGj+B8ycUFGL1UsdP+tWVU0tLZXDGaXYul2tdleoze7a0X1Twr+0SwwL19qC439zGqCaiJH92ssYIsnkhb6w3+rO1C2sjmnvrcfsZEWhiikRY6SnseEpdasmT9Bx1ZWuiu3N4PtjKSlQRUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630681; c=relaxed/simple;
	bh=BLMmwmwh5Cz+NVNca2+wY5iZ4f6OFv+iQkuRhTEClBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aavSxlOB5LsAPCbm0Czzao7W2qN9XsKFvMuQxMc+nuo52YAeixHlqp97jwKQwLZ8Og4M7VcSqKN6359bAD1XjBCieZz5laJ38Ud2Pe2JaD2pzHfjBRdiFZ+5V7dCLobFQYD6Q/TRIQ0wjM6H9Db8KTsSjdcUhkSS0UU+d/9J/WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os/Yvz9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os/Yvz9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336FBC4CEE5;
	Mon, 10 Mar 2025 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630681;
	bh=BLMmwmwh5Cz+NVNca2+wY5iZ4f6OFv+iQkuRhTEClBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os/Yvz9Tnx9NeRy8J8Yfg/QkVBQgdEWIDUZ+v84iJrIoiEqO3XX5Z25ATuNaV9fEu
	 RulfJxG2Se7ytkho1X9I86Tz7CFBQtnZpc84q85asWnEM6xBUWCfH0SkotfoknO1fM
	 BdMrDSwyGrqAkEDKmZz2dt6mDIjJI38kH9l6tW3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Meister <fmei@sfs.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/620] net: loopback: Avoid sending IP packets without an Ethernet header
Date: Mon, 10 Mar 2025 18:05:45 +0100
Message-ID: <20250310170605.266217970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 0e4427f8f587c4b603475468bb3aee9418574893 ]

After commit 22600596b675 ("ipv4: give an IPv4 dev to blackhole_netdev")
IPv4 neighbors can be constructed on the blackhole net device, but they
are constructed with an output function (neigh_direct_output()) that
simply calls dev_queue_xmit(). The latter will transmit packets via
'skb->dev' which might not be the blackhole net device if dst_dev_put()
switched 'dst->dev' to the blackhole net device while another CPU was
using the dst entry in ip_output(), but after it already initialized
'skb->dev' from 'dst->dev'.

Specifically, the following can happen:

    CPU1                                      CPU2

udp_sendmsg(sk1)                          udp_sendmsg(sk2)
udp_send_skb()                            [...]
ip_output()
    skb->dev = skb_dst(skb)->dev
                                          dst_dev_put()
                                              dst->dev = blackhole_netdev
ip_finish_output2()
    resolves neigh on dst->dev
neigh_output()
neigh_direct_output()
dev_queue_xmit()

This will result in IPv4 packets being sent without an Ethernet header
via a valid net device:

tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp9s0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
22:07:02.329668 20:00:40:11:18:fb > 45:00:00:44:f4:94, ethertype Unknown
(0x58c6), length 68:
        0x0000:  8dda 74ca f1ae ca6c ca6c 0098 969c 0400  ..t....l.l......
        0x0010:  0000 4730 3f18 6800 0000 0000 0000 9971  ..G0?.h........q
        0x0020:  c4c9 9055 a157 0a70 9ead bf83 38ca ab38  ...U.W.p....8..8
        0x0030:  8add ab96 e052                           .....R

Fix by making sure that neighbors are constructed on top of the
blackhole net device with an output function that simply consumes the
packets, in a similar fashion to dst_discard_out() and
blackhole_netdev_xmit().

Fixes: 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to invalidate dst entries")
Fixes: 22600596b675 ("ipv4: give an IPv4 dev to blackhole_netdev")
Reported-by: Florian Meister <fmei@sfs.com>
Closes: https://lore.kernel.org/netdev/20250210084931.23a5c2e4@hermes.local/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250220072559.782296-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/loopback.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 498e5c8013efb..0160a4f57ce92 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -243,8 +243,22 @@ static netdev_tx_t blackhole_netdev_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int blackhole_neigh_output(struct neighbour *n, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+	return 0;
+}
+
+static int blackhole_neigh_construct(struct net_device *dev,
+				     struct neighbour *n)
+{
+	n->output = blackhole_neigh_output;
+	return 0;
+}
+
 static const struct net_device_ops blackhole_netdev_ops = {
 	.ndo_start_xmit = blackhole_netdev_xmit,
+	.ndo_neigh_construct = blackhole_neigh_construct,
 };
 
 /* This is a dst-dummy device used specifically for invalidated
-- 
2.39.5



