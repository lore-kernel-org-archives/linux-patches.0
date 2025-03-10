Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5778622758F;
	Mon, 10 Mar 2025 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630414; cv=none; b=UezrugVVCqD6uUJz+P1dYpQM1P7cWy+5t5KwCk1lIQPHnqvkYDdosa1RiO5rt+p+mUQVs3Y+E+DXqULcDg+2qdYYYZHBFJvMeIDcQh4K4IyA1MHeRMd01s7eP2fdTu51dPsjuSHIJobtVuZ6FS1yaJknTXUKg/4Itf5hRogqsoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630414; c=relaxed/simple;
	bh=LKV34rjjpZhk7LgvYqdyzbYUdO6E6L5i8ReAm/bnrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuuKpuwcZ9OasJjQgCeXmb1Px954cJASkhwG9UtJBbfenmW2tutJEDpbS30X0Zb2ONOFfqkUx9zUC+wwOcriWMxBM3odBWHiNNu76h21O1jsG8rfr3Wcyu3/gqnK4xuJI/dvPq6++5aitBNCgDunMchPNxhE+ydEl0Kuj67YJKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MasSto2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MasSto2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7190EC4CEE5;
	Mon, 10 Mar 2025 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630413;
	bh=LKV34rjjpZhk7LgvYqdyzbYUdO6E6L5i8ReAm/bnrBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MasSto2dnCWXevYRnBymnvrShzvsGNiv6VL1GyOCzCRN/v5KeoqgyxkGYRmos1Gwc
	 GmWOxFO49K6ArSXqEyYUQJMQwM1qBSGSSk5jsX/IYhAsU2DbU6sj94p0hijTsI8o4H
	 YxOHPgcUNXhvlad9K4S1/m9Jxdgc/TwfQvekvwtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xu xin <xu.xin16@zte.com.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/620] Namespaceify mtu_expires sysctl
Date: Mon, 10 Mar 2025 18:04:04 +0100
Message-ID: <20250310170601.303785667@linuxfoundation.org>
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

[ Upstream commit 1135fad204805518462c1f0caaca6bcd52ba78cf ]

This patch enables the sysctl mtu_expires to be configured per net
namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 139512191bd0 ("ipv4: use RCU protection in __ip_rt_update_pmtu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 16515c04a46a7..8bc0d865338e4 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,7 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratemask;
 
 	u32 ip_rt_min_pmtu;
+	int ip_rt_mtu_expires;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9a837cd2b925a..75c379315ef37 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -119,6 +119,7 @@
 #define RT_GC_TIMEOUT (300*HZ)
 
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
+#define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
 
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
@@ -126,7 +127,6 @@ static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
-static int ip_rt_mtu_expires __read_mostly	= 10 * 60 * HZ;
 static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1041,7 +1041,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	}
 
 	if (rt->rt_pmtu == mtu && !lock &&
-	    time_before(jiffies, dst->expires - ip_rt_mtu_expires / 2))
+	    time_before(jiffies, dst->expires - net->ipv4.ip_rt_mtu_expires / 2))
 		return;
 
 	rcu_read_lock();
@@ -1051,7 +1051,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		fib_select_path(net, &res, fl4, NULL);
 		nhc = FIB_RES_NHC(res);
 		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
-				      jiffies + ip_rt_mtu_expires);
+				      jiffies + net->ipv4.ip_rt_mtu_expires);
 	}
 	rcu_read_unlock();
 }
@@ -3572,13 +3572,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "mtu_expires",
-		.data		= &ip_rt_mtu_expires,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 	{
 		.procname	= "min_adv_mss",
 		.data		= &ip_rt_min_advmss,
@@ -3606,6 +3599,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.proc_handler   = proc_dointvec_minmax,
 		.extra1         = &ip_min_valid_pmtu,
 	},
+	{
+		.procname       = "mtu_expires",
+		.data           = &init_net.ipv4.ip_rt_mtu_expires,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
 	{ },
 };
 
@@ -3667,6 +3667,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 {
 	/* Set default value for namespaceified sysctls */
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
+	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	return 0;
 }
 
-- 
2.39.5



