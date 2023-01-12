Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F579C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E307DC433F0;
	Thu, 12 Jan 2023 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533568;
	bh=26CE7+HKJvi2y/A4fgjDo49kHCCAWep8ks8bZwWjDyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSvQPvTQ+QwPtkhYAhcD/kDgB5GxfMqCmoOaByIF1ASvnetRw8CzyCiAexki1vJjg
	 1VXqSGy/lpnkn6puWV5cGzLaG3cUQHl77M4HL4JzulPoC5u5Tsx3+b7F2pfT+FVrWY
	 rS1wLWoBojMsKKOd4zQdNMcXxdeH6xIrCsVDbKPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 520/783] net: add atomic_long_t to net_device_stats fields
Date: Thu, 12 Jan 2023 14:53:56 +0100
Message-Id: <20230112135548.309223033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6c1c5097781f563b70a81683ea6fdac21637573b ]

Long standing KCSAN issues are caused by data-race around
some dev->stats changes.

Most performance critical paths already use per-cpu
variables, or per-queue ones.

It is reasonable (and more correct) to use atomic operations
for the slow paths.

This patch adds an union for each field of net_device_stats,
so that we can convert paths that are not yet protected
by a spinlock or a mutex.

netdev_stats_to_stats64() no longer has an #if BITS_PER_LONG==64

Note that the memcpy() we were using on 64bit arches
had no provision to avoid load-tearing,
while atomic_long_read() is providing the needed protection
at no cost.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 58 +++++++++++++++++++++++----------------
 include/net/dst.h         |  5 ++--
 net/core/dev.c            | 14 ++--------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ef75567efd27..b478a16ef284 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -166,31 +166,38 @@ static inline bool dev_xmit_complete(int rc)
  *	(unsigned long) so they can be read and written atomically.
  */
 
+#define NET_DEV_STAT(FIELD)			\
+	union {					\
+		unsigned long FIELD;		\
+		atomic_long_t __##FIELD;	\
+	}
+
 struct net_device_stats {
-	unsigned long	rx_packets;
-	unsigned long	tx_packets;
-	unsigned long	rx_bytes;
-	unsigned long	tx_bytes;
-	unsigned long	rx_errors;
-	unsigned long	tx_errors;
-	unsigned long	rx_dropped;
-	unsigned long	tx_dropped;
-	unsigned long	multicast;
-	unsigned long	collisions;
-	unsigned long	rx_length_errors;
-	unsigned long	rx_over_errors;
-	unsigned long	rx_crc_errors;
-	unsigned long	rx_frame_errors;
-	unsigned long	rx_fifo_errors;
-	unsigned long	rx_missed_errors;
-	unsigned long	tx_aborted_errors;
-	unsigned long	tx_carrier_errors;
-	unsigned long	tx_fifo_errors;
-	unsigned long	tx_heartbeat_errors;
-	unsigned long	tx_window_errors;
-	unsigned long	rx_compressed;
-	unsigned long	tx_compressed;
+	NET_DEV_STAT(rx_packets);
+	NET_DEV_STAT(tx_packets);
+	NET_DEV_STAT(rx_bytes);
+	NET_DEV_STAT(tx_bytes);
+	NET_DEV_STAT(rx_errors);
+	NET_DEV_STAT(tx_errors);
+	NET_DEV_STAT(rx_dropped);
+	NET_DEV_STAT(tx_dropped);
+	NET_DEV_STAT(multicast);
+	NET_DEV_STAT(collisions);
+	NET_DEV_STAT(rx_length_errors);
+	NET_DEV_STAT(rx_over_errors);
+	NET_DEV_STAT(rx_crc_errors);
+	NET_DEV_STAT(rx_frame_errors);
+	NET_DEV_STAT(rx_fifo_errors);
+	NET_DEV_STAT(rx_missed_errors);
+	NET_DEV_STAT(tx_aborted_errors);
+	NET_DEV_STAT(tx_carrier_errors);
+	NET_DEV_STAT(tx_fifo_errors);
+	NET_DEV_STAT(tx_heartbeat_errors);
+	NET_DEV_STAT(tx_window_errors);
+	NET_DEV_STAT(rx_compressed);
+	NET_DEV_STAT(tx_compressed);
 };
+#undef NET_DEV_STAT
 
 
 #include <linux/cache.h>
@@ -5256,4 +5263,9 @@ do {								\
 
 extern struct net_device *blackhole_netdev;
 
+/* Note: Avoid these macros in fast path, prefer per-cpu or per-queue counters. */
+#define DEV_STATS_INC(DEV, FIELD) atomic_long_inc(&(DEV)->stats.__##FIELD)
+#define DEV_STATS_ADD(DEV, FIELD, VAL) 	\
+		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
+
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/include/net/dst.h b/include/net/dst.h
index acd15c544cf3..ae2cf57d796b 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -356,9 +356,8 @@ static inline void __skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 static inline void skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 				 struct net *net)
 {
-	/* TODO : stats should be SMP safe */
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
+	DEV_STATS_INC(dev, rx_packets);
+	DEV_STATS_ADD(dev, rx_bytes, skb->len);
 	__skb_tunnel_rx(skb, dev, net);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a421c54331ea..37bb60a7e97e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10320,24 +10320,16 @@ void netdev_run_todo(void)
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats)
 {
-#if BITS_PER_LONG == 64
-	BUILD_BUG_ON(sizeof(*stats64) < sizeof(*netdev_stats));
-	memcpy(stats64, netdev_stats, sizeof(*netdev_stats));
-	/* zero out counters that only exist in rtnl_link_stats64 */
-	memset((char *)stats64 + sizeof(*netdev_stats), 0,
-	       sizeof(*stats64) - sizeof(*netdev_stats));
-#else
-	size_t i, n = sizeof(*netdev_stats) / sizeof(unsigned long);
-	const unsigned long *src = (const unsigned long *)netdev_stats;
+	size_t i, n = sizeof(*netdev_stats) / sizeof(atomic_long_t);
+	const atomic_long_t *src = (atomic_long_t *)netdev_stats;
 	u64 *dst = (u64 *)stats64;
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = src[i];
+		dst[i] = atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));
-#endif
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
 
-- 
2.35.1



