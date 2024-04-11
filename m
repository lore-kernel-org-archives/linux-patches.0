Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7F21442F7;
	Thu, 11 Apr 2024 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829989; cv=none; b=C+Y83HQ9B8zvKSz3KKF3uBdfJFB2YqSK1fb6OH0/Sdq4atwCrDE9Gp20VmSXysOcuuRG/rW2HRRZFuMJ1/C4V/p/olFApRJSAtywlIDo94gXc0RNrxVNYzeUoJy8mMV56jnmI1QAKsGqceKPyQAAqTvyotGYpbUnqXyg6jAqpgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829989; c=relaxed/simple;
	bh=hjbhWAQxTo9BAW8FhU3HNgzRdM5Urp3LKbxW9OnAW+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8fVCwRIfbs+EKmoU02Ch4YowQedzGndkCxkNiRXrEA8Dssp3kgwJFt458c71Y/pRpIb5KpG5VW7O75aGM5kxQlAScnEcRKj+kPrT1LvV38IKNvzlZZtbpN2JquO0Fj9OHzHWNNTKWgI7vvA76Ic85fmj08czMhehFIC7UWbGPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg7zjae2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg7zjae2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF6CC433F1;
	Thu, 11 Apr 2024 10:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829989;
	bh=hjbhWAQxTo9BAW8FhU3HNgzRdM5Urp3LKbxW9OnAW+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg7zjae2j5YcbkiCVRxZvRLEiXjR6e1Nc0u6Q4IAMWRl3KqhnqDozt26FayUL5Q/C
	 ib6oQ9Vy7OFLkM8YzKNeWnIA9e6/ONjuQKvlT66K8g+35fxK5fW/XgXvcUEnaoJ9+e
	 Kopdk2bACjlLs6G7gLkhXCCWUpxv3jUd2gTnw2/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	William Tu <u9012063@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 174/175] ip_gre: do not report erspan version on GRE interface
Date: Thu, 11 Apr 2024 11:56:37 +0200
Message-ID: <20240411095424.801482739@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

commit ee496694b9eea651ae1aa4c4667d886cdf74aa3b upstream.

Although the type I ERSPAN is based on the barebones IP + GRE
encapsulation and no extra ERSPAN header. Report erspan version on GRE
interface looks unreasonable. Fix this by separating the erspan and gre
fill info.

IPv6 GRE does not have this info as IPv6 only supports erspan version
1 and 2.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
Link: https://lore.kernel.org/r/20221203032858.3130339-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1586,24 +1586,6 @@ static int ipgre_fill_info(struct sk_buf
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			o_flags |= TUNNEL_KEY;
-
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-			goto nla_put_failure;
-
-		if (t->erspan_ver == 1) {
-			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-				goto nla_put_failure;
-		} else if (t->erspan_ver == 2) {
-			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-				goto nla_put_failure;
-			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-				goto nla_put_failure;
-		}
-	}
-
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1644,6 +1626,34 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
+			t->parms.o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else if (t->erspan_ver == 2) {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
+
+	return ipgre_fill_info(skb, dev);
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void erspan_setup(struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -1722,7 +1732,7 @@ static struct rtnl_link_ops erspan_link_
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 


