Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD2134252D;
	Wed,  8 Apr 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672486; cv=none; b=j40pUBJSYtA1qwhx1qpq/drVrNQTThkmGlqFro60WYEqK98kPRpbnbFOQBLvTpoYo/6+LTg7oqLD5ODZp4ZZTBAOC/ndkUMSsMK16dG6pNczMBxop38LpUjKNyZGIBG14HD+9sEzR02mEzJ/lOir+4ktq6mNdoubMmH1xiUvyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672486; c=relaxed/simple;
	bh=twIhOr40BkxJPioTRqgYrf1ZjGbS+6GUUrHXHWHEhJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrI35c2F17o7ZlwrU/tZPH8d/RYAnUh2/4/WvETyuLhueTcvbxNIZJbezslnMKzD10WUSQrmQGQdeBzSmX58eFZE+4c2EkAEXedFEorKM+QZpUJvNhd3+k2iVmuMPqbD8zG9kbas5JxYMFUaM0GCbm9OBoeL+PXA7mzFbkSmgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAsfYQ/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAsfYQ/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC294C19425;
	Wed,  8 Apr 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672486;
	bh=twIhOr40BkxJPioTRqgYrf1ZjGbS+6GUUrHXHWHEhJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAsfYQ/d1wL46LIWLXLBCTfJ9xmh3xTE8GgZckQaObKmk6Gi28Mp4pbnRzR/3nEac
	 Gq8/6Nj+xyCuO/LFEOe7YaNhxOT7v3u8xCh5ahR2023NKJA0uWI2uqlVh/JG1CYQl7
	 ko40852gpRy434TGS6adWquX5I7zikTc/zS67NWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/160] bridge: br_nd_send: linearize skb before parsing ND options
Date: Wed,  8 Apr 2026 20:01:52 +0200
Message-ID: <20260408175914.143366032@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Yang Yang <n05ec@lzu.edu.cn>

[ Upstream commit a01aee7cafc575bb82f5529e8734e7052f9b16ea ]

br_nd_send() parses neighbour discovery options from ns->opt[] and
assumes that these options are in the linear part of request.

Its callers only guarantee that the ICMPv6 header and target address
are available, so the option area can still be non-linear. Parsing
ns->opt[] in that case can access data past the linear buffer.

Linearize request before option parsing and derive ns from the linear
network header.

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260326034441.2037420-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_arp_nd_proxy.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index c7869a286df40..b8bfc336ff7a7 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -248,12 +248,12 @@ struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *msg)
 
 static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		       struct sk_buff *request, struct neighbour *n,
-		       __be16 vlan_proto, u16 vlan_tci, struct nd_msg *ns)
+		       __be16 vlan_proto, u16 vlan_tci)
 {
 	struct net_device *dev = request->dev;
 	struct net_bridge_vlan_group *vg;
+	struct nd_msg *na, *ns;
 	struct sk_buff *reply;
-	struct nd_msg *na;
 	struct ipv6hdr *pip6;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
 	int ns_olen;
@@ -261,7 +261,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	u8 *daddr;
 	u16 pvid;
 
-	if (!dev)
+	if (!dev || skb_linearize(request))
 		return;
 
 	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
@@ -278,6 +278,8 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	skb_set_mac_header(reply, 0);
 
 	daddr = eth_hdr(request)->h_source;
+	ns = (struct nd_msg *)(skb_network_header(request) +
+			       sizeof(struct ipv6hdr));
 
 	/* Do we need option processing ? */
 	ns_olen = request->len - (skb_network_offset(request) +
@@ -465,9 +467,9 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 				if (vid != 0)
 					br_nd_send(br, p, skb, n,
 						   skb->vlan_proto,
-						   skb_vlan_tag_get(skb), msg);
+						   skb_vlan_tag_get(skb));
 				else
-					br_nd_send(br, p, skb, n, 0, 0, msg);
+					br_nd_send(br, p, skb, n, 0, 0);
 				replied = true;
 			}
 
-- 
2.53.0



