Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58DF140E3D;
	Thu, 11 Apr 2024 10:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831072; cv=none; b=skZlqz9Mnrr1iSWRsv+F+AzHUTqslgcyf1g6mjusCUX+2Sn1oa5RckY3fnc8Ws631yfLV+Wl70DIapns5svCRr1Lk/0vjTlEuf0ML24LyZ+pmOxPut3K6r/HaylOglhBe/oVTCZ/ml1fUoZ4gkehfJTKrynrrAdsevFkaQsjpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831072; c=relaxed/simple;
	bh=ZIOYROQLtSPba7XN4yJC3yy4oD1qJ8om2eyziQ56wJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY7WQ5RuOYDjQ0fXXsocvKuDqVP06Orhu4IOuJlP2fpHYGKEvzI2dP0mhhsnBbXI9/T5cW3NhBaWsN0xO3N/AMriBlqGxf6/RPH1rK6IXf+MxaCvaw/g8qj0ncx/crrfnNzglaWwz76t95LVGlQ8RmzSbjiSWJTyGwgTP0TS/0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seQmvjdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seQmvjdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2BBC433C7;
	Thu, 11 Apr 2024 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831072;
	bh=ZIOYROQLtSPba7XN4yJC3yy4oD1qJ8om2eyziQ56wJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seQmvjdQTVgWbsqfrQUgb6pumj2GeB+0snDA0/9uZdcYbhuQ8HOf7VcqYkhyRBSt/
	 2elp3FjnSsJqEydYfV+rTxftjjyAL/mou26n0kZXPBXvc/XaWiDDHrpErId+ofclZD
	 IzGBm7eidXTjePeXPqf6rI7lAmFoMWO9akSGcm2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	William Tu <u9012063@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 214/215] ip_gre: do not report erspan version on GRE interface
Date: Thu, 11 Apr 2024 11:57:03 +0200
Message-ID: <20240411095431.294653996@linuxfoundation.org>
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
@@ -1504,24 +1504,6 @@ static int ipgre_fill_info(struct sk_buf
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
@@ -1562,6 +1544,34 @@ nla_put_failure:
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
@@ -1640,7 +1650,7 @@ static struct rtnl_link_ops erspan_link_
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 


