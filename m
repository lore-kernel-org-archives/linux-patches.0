Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884D3140E3D;
	Thu, 11 Apr 2024 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830915; cv=none; b=a7ib+anmwukBFGHTf1L2Zu/pVZ1muLkI3yxiJZM0+A6YeNuRCSC9/Ds4pXS+uespYVeuxJlpSRliOL7u9k0c0q5+W8VRMV5o+t8E0DozTyQ8e1/IJi0xgY4xY+Ymr6CaiQ76o6xtB9GiMIfo11z2mePy9U9PyQOZXuefsX1yU1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830915; c=relaxed/simple;
	bh=Nc0oIWGY5V+HOv1ZZLELsGImBDoPi+6AztMhGqtvl9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9pcLSMDS8Wie13WISsbRCzN86KwHsNIejY6+8h2mClMaCb16sGKTODe7mYpp3jVnBYf+AkH/xcTMdMnxqaMWD56OD/DHOy6EKujmnPhD7UMudGHQxctrtZCI2CYzavuaM7bmJ9P8pjdPUn8qfuKfV9AVVgf6k5m0aLOJzPqirk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6EGIaBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6EGIaBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38B1C433F1;
	Thu, 11 Apr 2024 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830915;
	bh=Nc0oIWGY5V+HOv1ZZLELsGImBDoPi+6AztMhGqtvl9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6EGIaBx37+p7VzAeilC8E1bZgsTQYFRzeQ4Ofpoqix4lSBSPDYmnF1Dfkp44wSHc
	 IRMjODSV713N9EMNuGrDp7AEOmss7FgW6wGJ194XUiOBIdJ/eDy529EKA/x+I25CWS
	 VqtXdeIH7yNDwJfwe4IenFSty1XwZQDnzpXD28sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <u9012063@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/215] erspan: Add type I version 0 support.
Date: Thu, 11 Apr 2024 11:56:11 +0200
Message-ID: <20240411095429.746025563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <u9012063@gmail.com>

[ Upstream commit f989d546a2d5a9f001f6f8be49d98c10ab9b1897 ]

The Type I ERSPAN frame format is based on the barebones
IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
Both type I and II use 0x88BE as protocol type. Unlike type II
and III, no sequence number or key is required.
To creat a type I erspan tunnel device:
  $ ip link add dev erspan11 type erspan \
            local 172.16.1.100 remote 172.16.1.200 \
            erspan_ver 0

Signed-off-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 17af420545a7 ("erspan: make sure erspan_base_hdr is present in skb->head")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/erspan.h | 19 +++++++++++++--
 net/ipv4/ip_gre.c    | 58 ++++++++++++++++++++++++++++++++------------
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/include/net/erspan.h b/include/net/erspan.h
index b39643ef4c95f..0d9e86bd98934 100644
--- a/include/net/erspan.h
+++ b/include/net/erspan.h
@@ -2,7 +2,19 @@
 #define __LINUX_ERSPAN_H
 
 /*
- * GRE header for ERSPAN encapsulation (8 octets [34:41]) -- 8 bytes
+ * GRE header for ERSPAN type I encapsulation (4 octets [34:37])
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |0|0|0|0|0|00000|000000000|00000|    Protocol Type for ERSPAN   |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ *  The Type I ERSPAN frame format is based on the barebones IP + GRE
+ *  encapsulation (as described above) on top of the raw mirrored frame.
+ *  There is no extra ERSPAN header.
+ *
+ *
+ * GRE header for ERSPAN type II and II encapsulation (8 octets [34:41])
  *       0                   1                   2                   3
  *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@@ -43,7 +55,7 @@
  * |                  Platform Specific Info                       |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  *
- * GRE proto ERSPAN type II = 0x88BE, type III = 0x22EB
+ * GRE proto ERSPAN type I/II = 0x88BE, type III = 0x22EB
  */
 
 #include <uapi/linux/erspan.h>
@@ -139,6 +151,9 @@ static inline u8 get_hwid(const struct erspan_md2 *md2)
 
 static inline int erspan_hdr_len(int version)
 {
+	if (version == 0)
+		return 0;
+
 	return sizeof(struct erspan_base_hdr) +
 	       (version == 1 ? ERSPAN_V1_MDSIZE : ERSPAN_V2_MDSIZE);
 }
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index db48dec61f305..f8369580ea273 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -248,6 +248,15 @@ static void gre_err(struct sk_buff *skb, u32 info)
 	ipgre_err(skb, info, &tpi);
 }
 
+static bool is_erspan_type1(int gre_hdr_len)
+{
+	/* Both ERSPAN type I (version 0) and type II (version 1) use
+	 * protocol 0x88BE, but the type I has only 4-byte GRE header,
+	 * while type II has 8-byte.
+	 */
+	return gre_hdr_len == 4;
+}
+
 static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		      int gre_hdr_len)
 {
@@ -262,17 +271,26 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	int len;
 
 	itn = net_generic(net, erspan_net_id);
-
 	iph = ip_hdr(skb);
-	ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
-	ver = ershdr->ver;
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
-				  tpi->flags | TUNNEL_KEY,
-				  iph->saddr, iph->daddr, tpi->key);
+	if (is_erspan_type1(gre_hdr_len)) {
+		ver = 0;
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
+					  tpi->flags | TUNNEL_NO_KEY,
+					  iph->saddr, iph->daddr, 0);
+	} else {
+		ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
+		ver = ershdr->ver;
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
+					  tpi->flags | TUNNEL_KEY,
+					  iph->saddr, iph->daddr, tpi->key);
+	}
 
 	if (tunnel) {
-		len = gre_hdr_len + erspan_hdr_len(ver);
+		if (is_erspan_type1(gre_hdr_len))
+			len = gre_hdr_len;
+		else
+			len = gre_hdr_len + erspan_hdr_len(ver);
+
 		if (unlikely(!pskb_may_pull(skb, len)))
 			return PACKET_REJECT;
 
@@ -670,7 +688,10 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 	}
 
 	/* Push ERSPAN header */
-	if (tunnel->erspan_ver == 1) {
+	if (tunnel->erspan_ver == 0) {
+		proto = htons(ETH_P_ERSPAN);
+		tunnel->parms.o_flags &= ~TUNNEL_SEQ;
+	} else if (tunnel->erspan_ver == 1) {
 		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
 				    tunnel->index,
 				    truncate, true);
@@ -1080,7 +1101,10 @@ static int erspan_validate(struct nlattr *tb[], struct nlattr *data[],
 	if (ret)
 		return ret;
 
-	/* ERSPAN should only have GRE sequence and key flag */
+	if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
+		return 0;
+
+	/* ERSPAN type II/III should only have GRE sequence and key flag */
 	if (data[IFLA_GRE_OFLAGS])
 		flags |= nla_get_be16(data[IFLA_GRE_OFLAGS]);
 	if (data[IFLA_GRE_IFLAGS])
@@ -1188,7 +1212,7 @@ static int erspan_netlink_parms(struct net_device *dev,
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
 
-		if (t->erspan_ver != 1 && t->erspan_ver != 2)
+		if (t->erspan_ver > 2)
 			return -EINVAL;
 	}
 
@@ -1273,7 +1297,11 @@ static int erspan_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
-	tunnel->tun_hlen = 8;
+	if (tunnel->erspan_ver == 0)
+		tunnel->tun_hlen = 4; /* 4-byte GRE hdr. */
+	else
+		tunnel->tun_hlen = 8; /* 8-byte GRE hdr. */
+
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
 		       erspan_hdr_len(tunnel->erspan_ver);
@@ -1470,8 +1498,8 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver == 1 || t->erspan_ver == 2) {
-		if (!t->collect_md)
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
 			o_flags |= TUNNEL_KEY;
 
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
@@ -1480,7 +1508,7 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		if (t->erspan_ver == 1) {
 			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
 				goto nla_put_failure;
-		} else {
+		} else if (t->erspan_ver == 2) {
 			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
 				goto nla_put_failure;
 			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-- 
2.43.0



