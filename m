Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847AB30B505;
	Mon, 13 Oct 2025 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369546; cv=none; b=GoKyC5VVe5uehdL0FeYH1s9OWqmvaECVh8ZbQHLhjh305/LZUiPgdDfKcu6j/0Y4T1o17WhkXL47tA3D29OjJiETmtTKb3kBV2eNnTVSWCU3cw+Z/cokef5tF12MYyuHC+NjcJHxxTudL3iZxu1cVFBLYaOuZisCWb6ZXUl5jY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369546; c=relaxed/simple;
	bh=RgIiEDqglrDetT/y3m/y8k/OF7jwc+0PcjG9LSQAvOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hdkl/AEg/o/HjaLKFGzRifzjPWxPYoG4jZcxrZ6jtctUPp4Te55g7W3562H1PLVb2o38jlQr6cBbqTqQhVXXm1t4HU6LU4WoYm2/x1IhJhzyEuxiqGWcaoDYpZ2B8Qi8rzYH0MpFFEBmDgh04/prkMUf+C8CV6OVR/jSW9n+wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMeKU5/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMeKU5/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC93C4CEE7;
	Mon, 13 Oct 2025 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369546;
	bh=RgIiEDqglrDetT/y3m/y8k/OF7jwc+0PcjG9LSQAvOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMeKU5/P5zL4Qxfrl5qWhWoN2LqHJFDDeQAJ7G5kee99lLuD7ljMSKsu6WXt4VF2O
	 rng5+nitUVdEorl9OnMKOccxqpxp/VNtUE2lj3Q7/9anvyZJiNtvL6b3fEAOP2nThT
	 1l1el6Pt77mV47VWc8b9sTo0/6envf5YPL9lBWb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 285/563] ipv6: mcast: Add ip6_mc_find_idev() helper
Date: Mon, 13 Oct 2025 16:42:26 +0200
Message-ID: <20251013144421.595566903@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 60c481d4caa569001c708d4e9622d19650b6bedc ]

Extract the same code logic from __ipv6_sock_mc_join() and
ip6_mc_find_dev(), also add new helper ip6_mc_find_idev() to
reduce redundancy and enhance readability.

No functional changes intended.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Link: https://patch.msgid.link/20250822064051.2991480-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b775ecf1655c ("ipv6: start using dst_dev_rcu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 67 ++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 36ca27496b3c0..55c49dc14b1bd 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -169,6 +169,29 @@ static int unsolicited_report_interval(struct inet6_dev *idev)
 	return iv > 0 ? iv : 1;
 }
 
+static struct net_device *ip6_mc_find_dev(struct net *net,
+					  const struct in6_addr *group,
+					  int ifindex)
+{
+	struct net_device *dev = NULL;
+	struct rt6_info *rt;
+
+	if (ifindex == 0) {
+		rcu_read_lock();
+		rt = rt6_lookup(net, group, NULL, 0, NULL, 0);
+		if (rt) {
+			dev = dst_dev(&rt->dst);
+			dev_hold(dev);
+			ip6_rt_put(rt);
+		}
+		rcu_read_unlock();
+	} else {
+		dev = dev_get_by_index(net, ifindex);
+	}
+
+	return dev;
+}
+
 /*
  *	socket join on multicast group
  */
@@ -191,28 +214,13 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	}
 
 	mc_lst = sock_kmalloc(sk, sizeof(struct ipv6_mc_socklist), GFP_KERNEL);
-
 	if (!mc_lst)
 		return -ENOMEM;
 
 	mc_lst->next = NULL;
 	mc_lst->addr = *addr;
 
-	if (ifindex == 0) {
-		struct rt6_info *rt;
-
-		rcu_read_lock();
-		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
-		if (rt) {
-			dev = dst_dev(&rt->dst);
-			dev_hold(dev);
-			ip6_rt_put(rt);
-		}
-		rcu_read_unlock();
-	} else {
-		dev = dev_get_by_index(net, ifindex);
-	}
-
+	dev = ip6_mc_find_dev(net, addr, ifindex);
 	if (!dev) {
 		sock_kfree_s(sk, mc_lst, sizeof(*mc_lst));
 		return -ENODEV;
@@ -302,27 +310,14 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 }
 EXPORT_SYMBOL(ipv6_sock_mc_drop);
 
-static struct inet6_dev *ip6_mc_find_dev(struct net *net,
-					 const struct in6_addr *group,
-					 int ifindex)
+static struct inet6_dev *ip6_mc_find_idev(struct net *net,
+					  const struct in6_addr *group,
+					  int ifindex)
 {
-	struct net_device *dev = NULL;
+	struct net_device *dev;
 	struct inet6_dev *idev;
 
-	if (ifindex == 0) {
-		struct rt6_info *rt;
-
-		rcu_read_lock();
-		rt = rt6_lookup(net, group, NULL, 0, NULL, 0);
-		if (rt) {
-			dev = dst_dev(&rt->dst);
-			dev_hold(dev);
-			ip6_rt_put(rt);
-		}
-		rcu_read_unlock();
-	} else {
-		dev = dev_get_by_index(net, ifindex);
-	}
+	dev = ip6_mc_find_dev(net, group, ifindex);
 	if (!dev)
 		return NULL;
 
@@ -374,7 +369,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	idev = ip6_mc_find_dev(net, group, pgsr->gsr_interface);
+	idev = ip6_mc_find_idev(net, group, pgsr->gsr_interface);
 	if (!idev)
 		return -ENODEV;
 
@@ -509,7 +504,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	    gsf->gf_fmode != MCAST_EXCLUDE)
 		return -EINVAL;
 
-	idev = ip6_mc_find_dev(net, group, gsf->gf_interface);
+	idev = ip6_mc_find_idev(net, group, gsf->gf_interface);
 	if (!idev)
 		return -ENODEV;
 
-- 
2.51.0



