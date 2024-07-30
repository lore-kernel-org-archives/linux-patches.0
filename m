Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914418A6D0;
	Tue, 30 Jul 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359411; cv=none; b=gTxm5KwJZ+e5jERcE4jEiRVQImUcu64IuSkiV1auucqqJJpDs95DMg75d7MDSHFXL8y35bHQ2vMUdvDe9Pubc0olqv8Kx6LKLiAk/PnIErCbjmJADOnWvyc7STlbANWH3ZntidzlbOGtVotvo67CiXHkMiFm10OKcTYHM4scDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359411; c=relaxed/simple;
	bh=/mRckYWHSaTJHcalVfVYZy5sNU/r4fnc9BE5z8Vx5l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0x8/C+1BUi4nxluPZmBBinbrrke13OUw6YuNpVLdkCDc8pjpiwdBdLHc/+Nj3ZrV4gwAz5bP/Cv7NM3/Hf8LoB2M/W82XNTiqNo11E3fUyaER/UQmSyIbZczV1J9VpZdaXY4pyQiMdLfIDdE3wSRX1PpHCEDFqqLbfxggSG5Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzRllnEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzRllnEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2EFC32782;
	Tue, 30 Jul 2024 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359411;
	bh=/mRckYWHSaTJHcalVfVYZy5sNU/r4fnc9BE5z8Vx5l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzRllnEypRLDAfxJR7ouHvKJCf5G1uTvjO1hZEZytM72P278chZUpypri+GLOuzum
	 yuZKKYT3oLm1Wb6AJ8WUTKPyLqJTxuXqnTHQF6WARsg5O7uJe8ZdniT+7jm5jIF4dJ
	 eV3CJPJtH3hWBH+T5Gw3hOTGvUdEIO+Ijq7NX7ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 480/809] ipv4: Fix incorrect TOS in route get reply
Date: Tue, 30 Jul 2024 17:45:56 +0200
Message-ID: <20240730151743.694743856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 338bb57e4c2a1c2c6fc92f9c0bd35be7587adca7 ]

The TOS value that is returned to user space in the route get reply is
the one with which the lookup was performed ('fl4->flowi4_tos'). This is
fine when the matched route is configured with a TOS as it would not
match if its TOS value did not match the one with which the lookup was
performed.

However, matching on TOS is only performed when the route's TOS is not
zero. It is therefore possible to have the kernel incorrectly return a
non-zero TOS:

 # ip link add name dummy1 up type dummy
 # ip address add 192.0.2.1/24 dev dummy1
 # ip route get 192.0.2.2 tos 0xfc
 192.0.2.2 tos 0x1c dev dummy1 src 192.0.2.1 uid 0
     cache

Fix by adding a DSCP field to the FIB result structure (inside an
existing 4 bytes hole), populating it in the route lookup and using it
when filling the route get reply.

Output after the patch:

 # ip link add name dummy1 up type dummy
 # ip address add 192.0.2.1/24 dev dummy1
 # ip route get 192.0.2.2 tos 0xfc
 192.0.2.2 dev dummy1 src 192.0.2.1 uid 0
     cache

Fixes: 1a00fee4ffb2 ("ipv4: Remove rt_key_{src,dst,tos} from struct rtable.")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h |  1 +
 net/ipv4/fib_trie.c  |  1 +
 net/ipv4/route.c     | 14 +++++++-------
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 9b2f69ba5e498..c29639b4323f3 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -173,6 +173,7 @@ struct fib_result {
 	unsigned char		type;
 	unsigned char		scope;
 	u32			tclassid;
+	dscp_t			dscp;
 	struct fib_nh_common	*nhc;
 	struct fib_info		*fi;
 	struct fib_table	*table;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index f474106464d2f..8f30e3f00b7f2 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1629,6 +1629,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			res->nhc = nhc;
 			res->type = fa->fa_type;
 			res->scope = fi->fib_scope;
+			res->dscp = fa->fa_dscp;
 			res->fi = fi;
 			res->table = tb;
 			res->fa_head = &n->leaf;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b3073d1c8f8f7..7790a83474618 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2868,9 +2868,9 @@ EXPORT_SYMBOL_GPL(ip_route_output_flow);
 
 /* called with rcu_read_lock held */
 static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
-			struct rtable *rt, u32 table_id, struct flowi4 *fl4,
-			struct sk_buff *skb, u32 portid, u32 seq,
-			unsigned int flags)
+			struct rtable *rt, u32 table_id, dscp_t dscp,
+			struct flowi4 *fl4, struct sk_buff *skb, u32 portid,
+			u32 seq, unsigned int flags)
 {
 	struct rtmsg *r;
 	struct nlmsghdr *nlh;
@@ -2886,7 +2886,7 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	r->rtm_family	 = AF_INET;
 	r->rtm_dst_len	= 32;
 	r->rtm_src_len	= 0;
-	r->rtm_tos	= fl4 ? fl4->flowi4_tos : 0;
+	r->rtm_tos	= inet_dscp_to_dsfield(dscp);
 	r->rtm_table	= table_id < 256 ? table_id : RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, RTA_TABLE, table_id))
 		goto nla_put_failure;
@@ -3036,7 +3036,7 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 				goto next;
 
 			err = rt_fill_info(net, fnhe->fnhe_daddr, 0, rt,
-					   table_id, NULL, skb,
+					   table_id, 0, NULL, skb,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, flags);
 			if (err)
@@ -3359,8 +3359,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		err = fib_dump_info(skb, NETLINK_CB(in_skb).portid,
 				    nlh->nlmsg_seq, RTM_NEWROUTE, &fri, 0);
 	} else {
-		err = rt_fill_info(net, dst, src, rt, table_id, &fl4, skb,
-				   NETLINK_CB(in_skb).portid,
+		err = rt_fill_info(net, dst, src, rt, table_id, res.dscp, &fl4,
+				   skb, NETLINK_CB(in_skb).portid,
 				   nlh->nlmsg_seq, 0);
 	}
 	if (err < 0)
-- 
2.43.0



