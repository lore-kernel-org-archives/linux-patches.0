Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E801233155;
	Mon, 10 Mar 2025 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630411; cv=none; b=gH7UWM91ppsx/MA9UbVK+zyGUoJ2ltQHHpuB+NkldkczSV0HVqb7XBt4cZAPsSqjem/cBiv67lIVTjMVYDIH7u6pXGP2gmo88iNxvOtjtKB/0tJarGYy6pDT7ZmwXQ9kc1bHkxkBa5PxuHm/AUSh4mEjfJr67G4iJz4DCP456ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630411; c=relaxed/simple;
	bh=FX6VferWbLnvrAfD3h2NW+gGcp50MznKPcKkb/OPaF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iT3VrCCvtHK1iVn4TDKCe3jQMlOdRxgtuKG+6Ht56Y6+C8rLCG6CpVqEPt6dftm4KFKRwXfDmBZjlraoEpvTySSFQ2ezFwlQ7ip4Kc3f1i+gq88IA2s4pXSguzkEqSuTR+mgdetFtnj2YJ9Xw5MFfTKLwG1bMrSijMQHg9Nk9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeyU2zGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeyU2zGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2F9C4CEE5;
	Mon, 10 Mar 2025 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630410;
	bh=FX6VferWbLnvrAfD3h2NW+gGcp50MznKPcKkb/OPaF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeyU2zGT5r964fwK7EKBgF1+LFR5so6HR8UCaY69cIxmeMkap5vQJrXF6MUR5FU0C
	 f59WVD5iQRIjJk7TkPSSjr6yNe/+686Dv7m3VUUmFbWnWrftwIY0VJrxc2oqpm66aM
	 AL8g/iE/tl8y6ZFvaCU5/P60D5FIsLTNdC/WUxtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xu xin <xu.xin16@zte.com.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/620] Namespaceify min_pmtu sysctl
Date: Mon, 10 Mar 2025 18:04:03 +0100
Message-ID: <20250310170601.263370773@linuxfoundation.org>
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

From: xu xin <xu.xin16@zte.com.cn>

[ Upstream commit 1de6b15a434c0068253fea5d719f71143e7e3a79 ]

This patch enables the sysctl min_pmtu to be configured per net
namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 139512191bd0 ("ipv4: use RCU protection in __ip_rt_update_pmtu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h |  2 ++
 net/ipv4/route.c         | 53 ++++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index d60a10cfc3823..16515c04a46a7 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -84,6 +84,8 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
 
+	u32 ip_rt_min_pmtu;
+
 	struct local_ports ip_local_ports;
 
 	u8 sysctl_tcp_ecn;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3ad78bbd6261b..9a837cd2b925a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -118,6 +118,8 @@
 
 #define RT_GC_TIMEOUT (300*HZ)
 
+#define DEFAULT_MIN_PMTU (512 + 20 + 20)
+
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
@@ -125,7 +127,6 @@ static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 static int ip_rt_mtu_expires __read_mostly	= 10 * 60 * HZ;
-static u32 ip_rt_min_pmtu __read_mostly		= 512 + 20 + 20;
 static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1034,9 +1035,9 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	if (old_mtu < mtu)
 		return;
 
-	if (mtu < ip_rt_min_pmtu) {
+	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
-		mtu = min(old_mtu, ip_rt_min_pmtu);
+		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
 	}
 
 	if (rt->rt_pmtu == mtu && !lock &&
@@ -3578,14 +3579,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{
-		.procname	= "min_pmtu",
-		.data		= &ip_rt_min_pmtu,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &ip_min_valid_pmtu,
-	},
 	{
 		.procname	= "min_adv_mss",
 		.data		= &ip_rt_min_advmss,
@@ -3598,13 +3591,21 @@ static struct ctl_table ipv4_route_table[] = {
 
 static const char ipv4_route_flush_procname[] = "flush";
 
-static struct ctl_table ipv4_route_flush_table[] = {
+static struct ctl_table ipv4_route_netns_table[] = {
 	{
 		.procname	= ipv4_route_flush_procname,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= ipv4_sysctl_rtcache_flush,
 	},
+	{
+		.procname       = "min_pmtu",
+		.data           = &init_net.ipv4.ip_rt_min_pmtu,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &ip_min_valid_pmtu,
+	},
 	{ },
 };
 
@@ -3612,9 +3613,11 @@ static __net_init int sysctl_route_net_init(struct net *net)
 {
 	struct ctl_table *tbl;
 
-	tbl = ipv4_route_flush_table;
+	tbl = ipv4_route_netns_table;
 	if (!net_eq(net, &init_net)) {
-		tbl = kmemdup(tbl, sizeof(ipv4_route_flush_table), GFP_KERNEL);
+		int i;
+
+		tbl = kmemdup(tbl, sizeof(ipv4_route_netns_table), GFP_KERNEL);
 		if (!tbl)
 			goto err_dup;
 
@@ -3623,6 +3626,12 @@ static __net_init int sysctl_route_net_init(struct net *net)
 			if (tbl[0].procname != ipv4_route_flush_procname)
 				tbl[0].procname = NULL;
 		}
+
+		/* Update the variables to point into the current struct net
+		 * except for the first element flush
+		 */
+		for (i = 1; i < ARRAY_SIZE(ipv4_route_netns_table) - 1; i++)
+			tbl[i].data += (void *)net - (void *)&init_net;
 	}
 	tbl[0].extra1 = net;
 
@@ -3632,7 +3641,7 @@ static __net_init int sysctl_route_net_init(struct net *net)
 	return 0;
 
 err_reg:
-	if (tbl != ipv4_route_flush_table)
+	if (tbl != ipv4_route_netns_table)
 		kfree(tbl);
 err_dup:
 	return -ENOMEM;
@@ -3644,7 +3653,7 @@ static __net_exit void sysctl_route_net_exit(struct net *net)
 
 	tbl = net->ipv4.route_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv4.route_hdr);
-	BUG_ON(tbl == ipv4_route_flush_table);
+	BUG_ON(tbl == ipv4_route_netns_table);
 	kfree(tbl);
 }
 
@@ -3654,6 +3663,17 @@ static __net_initdata struct pernet_operations sysctl_route_ops = {
 };
 #endif
 
+static __net_init int netns_ip_rt_init(struct net *net)
+{
+	/* Set default value for namespaceified sysctls */
+	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
+	return 0;
+}
+
+static struct pernet_operations __net_initdata ip_rt_ops = {
+	.init = netns_ip_rt_init,
+};
+
 static __net_init int rt_genid_init(struct net *net)
 {
 	atomic_set(&net->ipv4.rt_genid, 0);
@@ -3759,6 +3779,7 @@ int __init ip_rt_init(void)
 #ifdef CONFIG_SYSCTL
 	register_pernet_subsys(&sysctl_route_ops);
 #endif
+	register_pernet_subsys(&ip_rt_ops);
 	register_pernet_subsys(&rt_genid_ops);
 	register_pernet_subsys(&ipv4_inetpeer_ops);
 	return 0;
-- 
2.39.5



