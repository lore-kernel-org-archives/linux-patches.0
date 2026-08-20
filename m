Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F41481AAD;
	Thu, 20 Aug 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247305; cv=none; b=VI4+3aGzB8tUZsbWDtXY0fNUV5bSJ6B3av/AXrLrYZDWmhYJLCf0nazEc4606HHio+R/DR8PMGwP/r/JkQkbvmkUchLuRI40P49QRW0ytfqi/lCJ6fP65jTw9l303bvJUjpLR3MB77J36CiqvxvlPMS6DGZKeiYN9ghTOxB1HOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247305; c=relaxed/simple;
	bh=ZCuGB1lbE3E8jVqslNs6vAmYn2xOUZjOC6KjcS4/6po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlX9Bz+0t8PoAhe0sIWm33Q2ylo2+E1qK1QCCUhAnWV60ca+3g7/9r7PM8xG0V2WtEq76TQOIK87rrrPSnyrsAhaQkLMiA6Ywuq1fgxCwrBodpYnsnmkWSwSCpB/Eo+BaiG5twtNiPHqDHdg9DTOtRzyXQxNskuEZ5NkBWOCirk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDNMLPfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDNMLPfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC7C1F00A3A;
	Thu, 20 Aug 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247303;
	bh=dl7grH0Zs1p6kSZig6L8LUJp5YEXDyyDG37tJXcIqew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDNMLPfLXI8WVbppMMy5TwAurxislOaMj3EHmDAYX8OUOieZqTEbg/eoiFMDYPnx+
	 CBqeBS3YwFE2yYT2eGwi5Kmckn/lFs/aHmWiNsNF+nQB4pp1GlPGPpKrWMhG4akSBM
	 o6DtdqbwHVOI4S/vkxaWxsQbVa/+1rts+45xG0j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 219/220] net: harmonize tstats and dstats
Date: Thu, 20 Aug 2026 16:56:49 +0200
Message-ID: <20260820145230.127378901@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit d3ed6dee73c560fad0a8e152c8e233b3fb3a2e44 upstream.

After the blamed commits below, some UDP tunnel use dstats for
accounting. On the xmit path, all the UDP-base tunnels ends up
using iptunnel_xmit_stats() for stats accounting, and the latter
assumes the relevant (tunnel) network device uses tstats.

The end result is some 'funny' stat report for the mentioned UDP
tunnel, e.g. when no packet is actually dropped and a bunch of
packets are transmitted:

gnv2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue \
		state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether ee:7d:09:87:90:ea brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast
         14916      23      0      15       0       0
    TX:  bytes packets errors dropped carrier collsns
             0    1566      0       0       0       0

Address the issue ensuring the same binary layout for the overlapping
fields of dstats and tstats. While this solution is a bit hackish, is
smaller and with no performance pitfall compared to other alternatives
i.e. supporting both dstat and tstat in iptunnel_xmit_stats() or
reverting the blamed commit.

With time we should possibly move all the IP-based tunnel (and virtual
devices) to dstats.

Fixes: c77200c07491 ("bareudp: Handle stats using NETDEV_PCPU_STAT_DSTATS.")
Fixes: 6fa6de302246 ("geneve: Handle stats using NETDEV_PCPU_STAT_DSTATS.")
Fixes: be226352e8dc ("vxlan: Handle stats using NETDEV_PCPU_STAT_DSTATS.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/2e1c444cf0f63ae472baff29862c4c869be17031.1738432804.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 +-
 net/core/dev.c            |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2746,9 +2746,9 @@ struct pcpu_sw_netstats {
 struct pcpu_dstats {
 	u64_stats_t		rx_packets;
 	u64_stats_t		rx_bytes;
-	u64_stats_t		rx_drops;
 	u64_stats_t		tx_packets;
 	u64_stats_t		tx_bytes;
+	u64_stats_t		rx_drops;
 	u64_stats_t		tx_drops;
 	struct u64_stats_sync	syncp;
 } __aligned(8 * sizeof(u64));
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11070,6 +11070,20 @@ struct rtnl_link_stats64 *dev_get_stats(
 	const struct net_device_ops *ops = dev->netdev_ops;
 	const struct net_device_core_stats __percpu *p;
 
+	/*
+	 * IPv{4,6} and udp tunnels share common stat helpers and use
+	 * different stat type (NETDEV_PCPU_STAT_TSTATS vs
+	 * NETDEV_PCPU_STAT_DSTATS). Ensure the accounting is consistent.
+	 */
+	BUILD_BUG_ON(offsetof(struct pcpu_sw_netstats, rx_bytes) !=
+		     offsetof(struct pcpu_dstats, rx_bytes));
+	BUILD_BUG_ON(offsetof(struct pcpu_sw_netstats, rx_packets) !=
+		     offsetof(struct pcpu_dstats, rx_packets));
+	BUILD_BUG_ON(offsetof(struct pcpu_sw_netstats, tx_bytes) !=
+		     offsetof(struct pcpu_dstats, tx_bytes));
+	BUILD_BUG_ON(offsetof(struct pcpu_sw_netstats, tx_packets) !=
+		     offsetof(struct pcpu_dstats, tx_packets));
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		ops->ndo_get_stats64(dev, storage);


