Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C54469843;
	Thu, 20 Aug 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247801; cv=none; b=o//Wpv354zaJpx7gsw4KBrEZkdday7ZjWBSzxmBaeqzrtOFZZwRHwqot8IfwrD9OfAUlCAQsoJz3l7iPz6T1FDtJhhmFrilMtyV2gQTOLHj3YxsD2jMJcp7GU5RivOQf7e+ye7kpHVAOLOS7pTYS71SeONHAywgIvVjZnjN3sQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247801; c=relaxed/simple;
	bh=BEh0EFgwDgnLPibnSd/eYv9LRJDqUSU064AVLLgE8+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omiU1lb3gvoB6VURlbY4R+DIxVsY+Xfg3V1USSXvBvmet/g1MiZv4CPkOMBkVBzkG4z1hzbaCJZoJtvxKkoA5F55VGqx5LGQIhnEZVPQvqvyKvqFgjQsaunRSdSTDc7K59iCk0ddn9UbAFA1JvvJ2clq8RAPZg7yTfv/JiJI7ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6Ky1k+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6Ky1k+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B71C1F000E9;
	Thu, 20 Aug 2026 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247800;
	bh=FZMW946dZIxC7z2ZvmEHfVpDnFLljcDuJjJ9EU5INHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6Ky1k+WT9hL+jcEPZJwBfpx8rbonuVsZPMScWgG4PuLGPh4YALcqw1+2LTHCjmSA
	 53JvpP2R4f/3jHBGDUSfHhL35nNmRZ4cofdX1wg760WT8ii4soNtyZJJpGyWmNk36V
	 0lZOZEQzoLYYI1ITGS4PHp4chCZnIWWOwd9cADDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 166/166] net: harmonize tstats and dstats
Date: Thu, 20 Aug 2026 16:57:05 +0200
Message-ID: <20260820145216.154937421@linuxfoundation.org>
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
@@ -2750,9 +2750,9 @@ struct pcpu_sw_netstats {
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
@@ -10710,6 +10710,20 @@ struct rtnl_link_stats64 *dev_get_stats(
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


