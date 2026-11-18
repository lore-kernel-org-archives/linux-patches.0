Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021886;
	b=L8cY8+vx3bRj5hoVP2oz2Qe1z1+gEFjodrdyf37DQ0bQqqiRkgBryGqScMZF/8Xs0k1Z
	 cOnwswUdCHXURlpHXypiqvjpuJuW1tdb/DwRDsxQZ1nwYe12IUftCnnK5sKu4IrOV17oI
	 MXJJ11QjTsgsNwpyoNl8zoHpBQEdRW5AKht/bmpRVkjDemSPRbJcEpPh1lzb9xP3ShuTJ
	 PL2DJBc6Ya8BgDPUq61OJfiriuDKPgRd927POvBLL+3zGcbJAF62g0u85RT73CCNtkZly
	 S82wxeopo/7s0SL5oldtqfoU3Nv4X1ldfFVapRtrRMpSzYZnnw//uej0d27yzpwAs2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BU6qqoAnNCbPA4oXYPYz87IaVNDOoLhE8J6pf/eCtVk=;
	b=Eb9bo9OZyqpKJqHWnbNeJc95h+R31sigxtSx5UVUL2G6cb8uQXim1iaIyN0f6roFf3RG
	 mAIHuXK2i4ATL/XqZBeiO0HlOXs0jMlYwXRyvXcSCRANCfHFEVYO9uCYIDbo4YIrUSv4Y
	 1usYm/5eZ20tkwsf6AHPK9lZJERbFgZ+6RfisnPI+gKDS+eRNrgRUWeCT5T6lnPVfHwDY
	 KIGdU5MV+4rbGISwt7zXIr/Q3E43hL5WvsyDI1dTMBq67ejUypArKmeiORq/D6Aao/hm+
	 9CB7NQxzeHuITMmaea1+FvF7XJwNAdFJ/LTRyHzuaLqS/xG3z2O1tpl962qonErrwkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rf2Ez273;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B9606A320;
	Wed, 18 Nov 2026 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rf2Ez273
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40C71F000C4;
	Wed, 18 Nov 2026 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021886;
	bh=BU6qqoAnNCbPA4oXYPYz87IaVNDOoLhE8J6pf/eCtVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rf2Ez273HyJ+qiT+uoA6erglMXpZ3+hR9PVxgztJbOg2JTuZ3KEEhjx4peZzGmcPt
	 w5EFThw1cnnMVDuD4DPBQ09Wws2XDrKm9iaiMxFhq32m3e68b88JPzqnI93KwUKF3/
	 ypn1hcfbhxCE7Fe7tgg5pQaX6H9toCtlJKpyqDMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2449/2651] ipmr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 16:01:29 +0100
Message-ID: <20261118150413.287892705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 389952e8776a4663044df2ae3e8987a9e81964cf ]

reg_vif_xmit() hands the skb to ipmr_cache_report() as an
IGMPMSG_WHOLEPKT report. When the mroute socket has IP_PKTINFO
enabled, ipmr_cache_report() calls ipv4_pktinfo_prepare() on the
original skb, which reads skb->cb[] as IPCB.

By the time the pimreg device transmits the packet, skb->cb[] is not
IPCB anymore: qdisc_pkt_len_init() overwrites IPCB(skb)->iif with
qdisc_skb_cb(skb)->pkt_len, and any qdisc installed on the device or a
tc BPF program writing skb->cb[] fills the area holding the IP options
and IPCB(skb)->flags.

For locally generated packets routed out pimreg (they carry an rtable
dst), the mroute socket can therefore receive a bogus ipi_ifindex
(the packet length), and the l3mdev slave test in
ipv4_pktinfo_prepare() is driven by stale qdisc data.

Clear IPCB before building the report, as done for IPv6 in
commit 238164201431 ("ip6mr: clear skb->cb[] in reg_vif_xmit()").
The skb is freed right after, so nothing else depends on its control
block.

Fixes: bb7403655b3c ("ipmr: support IP_PKTINFO on cache report IGMP msg")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261025111337.142787-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f51014b37178b..5bfbb8d88bf4c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -554,6 +554,11 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
 
+	/* skb->cb[] holds qdisc/tc state at this point, not IPCB.
+	 * ipmr_cache_report() reads it as IPCB to build IP_PKTINFO.
+	 */
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+
 	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
 	ipmr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
 			  IGMPMSG_WHOLEPKT);
-- 
2.53.0



