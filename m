Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580447AF6D;
	Thu, 20 Aug 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244301; cv=none; b=sauOic8dRzicLDRu/WbLVnweCXfpIuiW+iCQdkZa63wYIUeW6txDxdGDHW8QTxyZxITS5SlEi6CyEii2DP9YtSouTC9zoq//D0AAeOU7LKx6h/vKb1lqpsnRFVMVcimOIi/ij9vsaerh1DNawmxdRQ3eVF3f6Y050l/KB0Q7zeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244301; c=relaxed/simple;
	bh=18sF2BM7Yv2V6JV3h63BZPwO9jK4ggHyaMhBKghlk48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5AbLLkkLSnvaWJSXtGR1aeqV2Kma4uewVYttLkUel5DDvSOr+q5pJMf7N+soB4JUpR1bqyqbH0RFsqr46Ed3C1Be4guPyAr8GOSxihoiNBaUg3eOYcIKOOnb07Xi3l3jQHin2vi5Gv3W9Zv1L2YuoxfsD+AxHDG5ra+3VUKze4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03N+DHRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03N+DHRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3D41F000E9;
	Thu, 20 Aug 2026 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244299;
	bh=81ItSvc90+vWlz8swBjNyh/grVH+T3BAvncw9/bxCj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03N+DHRe41gji/ODecLPNnokxlfxr54wbtv9zGntuVnahBKHCuGqG7JzKp804Hnk8
	 NxnnBWXT704VVOpTFj2FQHbU3/skuzYcrb2yHQUG8o8oiTFOAi/uKdm6UCx7JeqApE
	 Dax5bPO01WVf5mI8g+GVrlluVOyq4MzAfmN/DtCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/235] net: Add helper function to parse netlink msg of ip_tunnel_encap
Date: Thu, 20 Aug 2026 16:55:57 +0200
Message-ID: <20260820145220.113182533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 537dd2d9fb9f4aa7939fb4fcf552ebe4f497bd7e ]

Add ip_tunnel_netlink_encap_parms to parse netlink msg of ip_tunnel_encap.
Reduces duplicate code, no actual functional changes.

Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8211a2632466 ("net: ipip: require CAP_NET_ADMIN in the device netns for changelink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_tunnels.h  |    3 +++
 net/ipv4/ip_tunnel_core.c |   35 +++++++++++++++++++++++++++++++++++
 net/ipv4/ipip.c           |   38 ++------------------------------------
 net/ipv6/ip6_tunnel.c     |   37 ++-----------------------------------
 net/ipv6/sit.c            |   38 ++------------------------------------
 5 files changed, 44 insertions(+), 107 deletions(-)

--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -297,6 +297,9 @@ int ip_tunnel_newlink(struct net_device
 		      struct ip_tunnel_parm *p, __u32 fwmark);
 void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
 
+bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
+				   struct ip_tunnel_encap *encap);
+
 extern const struct header_ops ip_tunnel_header_ops;
 __be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
 
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -1099,3 +1099,38 @@ EXPORT_SYMBOL(ip_tunnel_parse_protocol);
 
 const struct header_ops ip_tunnel_header_ops = { .parse_protocol = ip_tunnel_parse_protocol };
 EXPORT_SYMBOL(ip_tunnel_header_ops);
+
+/* This function returns true when ENCAP attributes are present in the nl msg */
+bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
+				   struct ip_tunnel_encap *encap)
+{
+	bool ret = false;
+
+	memset(encap, 0, sizeof(*encap));
+
+	if (!data)
+		return ret;
+
+	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
+		ret = true;
+		encap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
+		ret = true;
+		encap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
+		ret = true;
+		encap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
+		ret = true;
+		encap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ip_tunnel_netlink_encap_parms);
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -446,40 +446,6 @@ static void ipip_netlink_parms(struct nl
 		*fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-/* This function returns true when ENCAP attributes are present in the nl msg */
-static bool ipip_netlink_encap_parms(struct nlattr *data[],
-				     struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 static int ipip_newlink(struct net *src_net, struct net_device *dev,
 			struct nlattr *tb[], struct nlattr *data[],
 			struct netlink_ext_ack *extack)
@@ -489,7 +455,7 @@ static int ipip_newlink(struct net *src_
 	struct ip_tunnel_encap ipencap;
 	__u32 fwmark = 0;
 
-	if (ipip_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 
 		if (err < 0)
@@ -510,7 +476,7 @@ static int ipip_changelink(struct net_de
 	bool collect_md;
 	__u32 fwmark = t->fwmark;
 
-	if (ipip_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 
 		if (err < 0)
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -2037,39 +2037,6 @@ static void ip6_tnl_netlink_parms(struct
 		parms->fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-static bool ip6_tnl_netlink_encap_parms(struct nlattr *data[],
-					struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 			   struct nlattr *tb[], struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
@@ -2082,7 +2049,7 @@ static int ip6_tnl_newlink(struct net *s
 
 	nt = netdev_priv(dev);
 
-	if (ip6_tnl_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip6_tnl_encap_setup(nt, &ipencap);
 		if (err < 0)
 			return err;
@@ -2119,7 +2086,7 @@ static int ip6_tnl_changelink(struct net
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 
-	if (ip6_tnl_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip6_tnl_encap_setup(t, &ipencap);
 
 		if (err < 0)
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1536,40 +1536,6 @@ static void ipip6_netlink_parms(struct n
 		*fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-/* This function returns true when ENCAP attributes are present in the nl msg */
-static bool ipip6_netlink_encap_parms(struct nlattr *data[],
-				      struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 #ifdef CONFIG_IPV6_SIT_6RD
 /* This function returns true when 6RD attributes are present in the nl msg */
 static bool ipip6_netlink_6rd_parms(struct nlattr *data[],
@@ -1621,7 +1587,7 @@ static int ipip6_newlink(struct net *src
 
 	nt = netdev_priv(dev);
 
-	if (ipip6_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip_tunnel_encap_setup(nt, &ipencap);
 		if (err < 0)
 			return err;
@@ -1676,7 +1642,7 @@ static int ipip6_changelink(struct net_d
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 
-	if (ipip6_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip_tunnel_encap_setup(t, &ipencap);
 		if (err < 0)
 			return err;


