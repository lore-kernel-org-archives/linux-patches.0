Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F552311C2F;
	Mon, 13 Apr 2026 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098143; cv=none; b=ljvSwp/0eLq4R2vP9jELZ6RMr4/La9hSASBJZTh248a9Y3TtcxwByMj4q5rRfmE2Uwec4WN3oV3mPBJ+Q7ow6IVKYj/1Ya4Y8/vooyaw88vQwCXOjzQYu2eazHKa8sVPZFd96Hkdxk/vUQC5xdu3m4xt+xqBrPxGrTJURasNjqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098143; c=relaxed/simple;
	bh=GitkFxv5Vzq0Fjvv5yp4kn1LMNK+iC3FR6iI+PQSfL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otwdx9YpzzgeG7xShOi+UGFsZmP6KjpXkyicHRHWaJxt4gzaraIRHfhNw4LmjbmgaSBPsy4q00p3hAoAGSqXtXBuQVdsXW1dNyarId1pMlKjoyBCpgaMd31VJHsNUS0GciCfainRObMsF4aPbmbUMrh9kzsV6v4ITAFKo8diJWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVXw5ofH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVXw5ofH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFA4C2BCAF;
	Mon, 13 Apr 2026 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098143;
	bh=GitkFxv5Vzq0Fjvv5yp4kn1LMNK+iC3FR6iI+PQSfL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVXw5ofHVOccv4hZjcdRYvw2S8/ihptKEqmB+nDN9fc2gSP5n8ZNRKqukXldkrpMe
	 Do8LXE8MqzAK+cZu+b4pD8ykxDIQr1HeI8S4g2lTWzuews94eBmtQdFAi7bwTAQrGQ
	 TXgrfZB4ZpT6FpDgJ6qe7lSLjuvqeq6C9UpE3liU=
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
Subject: [PATCH 5.15 411/570] bridge: br_nd_send: linearize skb before parsing ND options
Date: Mon, 13 Apr 2026 17:59:02 +0200
Message-ID: <20260413155845.864106207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3db1def4437b3..a44d14b94865e 100644
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



