Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F891FC7D0;
	Wed,  5 Mar 2025 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198015; cv=none; b=Mnpya4AabY8s4VVIeqK67Jjx+PfIxSvfQj3slb6PxkNnteqApUCN/8ly9H8H4hx5ma7uispw/68v6AhISTdH3mhszfC69xyOSoHHifzQNLE+LMKcddg0Gmqaldba96PF2smhcSPvCzhRwOha0wfsNKtDNMGkR9yQnsdPgStYWb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198015; c=relaxed/simple;
	bh=08jgndekO2rOfw4Hot5B5aK2YviS5bR0x7ESI5tC5yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwlHxAULtZw8idN14+8FxHtvKq4XF2Q7yABfccWjn7fLzkRtFdFpnVc0fkt0v4uKNHSBqL3IkZ/xDNrcYc8O6mpae4FCAzZjFNxqmX+acuLt9MFvZ1l4s8HFe++Il91xet0rXmNvxAwuKAbdZjfkuKohKIWnneTgEV8eXOAvalI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFdVlQfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFdVlQfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470B6C4CED1;
	Wed,  5 Mar 2025 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198015;
	bh=08jgndekO2rOfw4Hot5B5aK2YviS5bR0x7ESI5tC5yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFdVlQfSH0UiAvW9wgmrHF6Rd9fAYgYWLzLrHWsml4K8F6bSz302vvD50J0gk5AYD
	 jwMYK+ZgdOf+qoePFb1F6IzdWCS7YXVNHsjhLntEjhRCZmCFjSlDCFhoeL2IR2OBqD
	 Z8A8DRn+lbvyhm1yhs7hWpbSvuQghZMQJ2FhBJKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/150] ipv4: Convert icmp_route_lookup() to dscp_t.
Date: Wed,  5 Mar 2025 18:47:44 +0100
Message-ID: <20250305174505.225677094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 913c83a610bb7dd8e5952a2b4663e1feec0b5de6 ]

Pass a dscp_t variable to icmp_route_lookup(), instead of a plain u8,
to prevent accidental setting of ECN bits in ->flowi4_tos. Rename that
variable ("tos" -> "dscp") to make the intent clear.

While there, reorganise the function parameters to fill up horizontal
space.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/294fead85c6035bcdc5fcf9a6bb4ce8798c45ba1.1727807926.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f45bc187a92a7..0a2f988c4c24e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -477,13 +477,11 @@ static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
 	return route_lookup_dev;
 }
 
-static struct rtable *icmp_route_lookup(struct net *net,
-					struct flowi4 *fl4,
+static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 					struct sk_buff *skb_in,
-					const struct iphdr *iph,
-					__be32 saddr, u8 tos, u32 mark,
-					int type, int code,
-					struct icmp_bxm *param)
+					const struct iphdr *iph, __be32 saddr,
+					dscp_t dscp, u32 mark, int type,
+					int code, struct icmp_bxm *param)
 {
 	struct net_device *route_lookup_dev;
 	struct dst_entry *dst, *dst2;
@@ -497,7 +495,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->saddr = saddr;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_uid = sock_net_uid(net, NULL);
-	fl4->flowi4_tos = tos & INET_DSCP_MASK;
+	fl4->flowi4_tos = inet_dscp_to_dsfield(dscp);
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
@@ -549,7 +547,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     tos, rt2->dst.dev);
+				     inet_dscp_to_dsfield(dscp), rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
@@ -745,8 +743,9 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	ipc.opt = &icmp_param.replyopts.opt;
 	ipc.sockc.mark = mark;
 
-	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr, tos, mark,
-			       type, code, &icmp_param);
+	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr,
+			       inet_dsfield_to_dscp(tos), mark, type, code,
+			       &icmp_param);
 	if (IS_ERR(rt))
 		goto out_unlock;
 
-- 
2.39.5



