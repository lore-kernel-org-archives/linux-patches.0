Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520611A6161;
	Tue, 30 Jul 2024 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356846; cv=none; b=Bhrl0yz3fkNiAqShMK8OTQAyrthFsdMSW9pnY6U7p9RvMRpW08dbqrDuwVGnngLXpBCkT9k33up8/oe0nzrdDbbHTe8lCHcRyGAO1d61/RTa/ba0i8lQ1bNl26i8AbvvRSm27Pawu3ZYtW9NL2jyJ4xzOzQfXlexvJwodcG7jxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356846; c=relaxed/simple;
	bh=U9oTC/x7NECOK+f7R7+mEaT4Kx0SBTKfPpjyRzChTXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwAbhWZuyr1QiJ0zsh6Z2feZ4Gun9uxjl3LepZfQpJl9LK6YAB3JPoUykbnQtyfRHBrWuD/k7d+Eu+/3FH15bFd5S0Y0sTMDEdGGTS/Y/Jj5kccp0W1kXZUFLpX15wdO4MF2ZBz46tDjfY1HgUBnbMo19YT4wdAAlZgiDylF4NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/fh0cIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/fh0cIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB6C32782;
	Tue, 30 Jul 2024 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356846;
	bh=U9oTC/x7NECOK+f7R7+mEaT4Kx0SBTKfPpjyRzChTXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/fh0cIPYjK+TON2jhk2wUfUydBEXaNOzbTF4yfdK+OEh4H1j93gE1vyojx33loiP
	 PrMHUTW33bS4TUwVusL53CyvK4EDKC2JpmxqxAImQIXVALfFxEqHK3hFJySHsx1R7+
	 sft/psfyaxuZ995zH9OEnbBfFcGnTxE0mnezRGug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/440] ipv4: Fix incorrect TOS in route get reply
Date: Tue, 30 Jul 2024 17:47:47 +0200
Message-ID: <20240730151624.997085306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 15de07d365405..ca1700c2a5733 100644
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
index 9bdfdab906fe0..77b97c48da5ea 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1628,6 +1628,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			res->nhc = nhc;
 			res->type = fa->fa_type;
 			res->scope = fi->fib_scope;
+			res->dscp = fa->fa_dscp;
 			res->fi = fi;
 			res->table = tb;
 			res->fa_head = &n->leaf;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fcbacd39febe0..01b98590591db 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2934,9 +2934,9 @@ EXPORT_SYMBOL_GPL(ip_route_output_tunnel);
 
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
@@ -2952,7 +2952,7 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	r->rtm_family	 = AF_INET;
 	r->rtm_dst_len	= 32;
 	r->rtm_src_len	= 0;
-	r->rtm_tos	= fl4 ? fl4->flowi4_tos : 0;
+	r->rtm_tos	= inet_dscp_to_dsfield(dscp);
 	r->rtm_table	= table_id < 256 ? table_id : RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, RTA_TABLE, table_id))
 		goto nla_put_failure;
@@ -3102,7 +3102,7 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 				goto next;
 
 			err = rt_fill_info(net, fnhe->fnhe_daddr, 0, rt,
-					   table_id, NULL, skb,
+					   table_id, 0, NULL, skb,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, flags);
 			if (err)
@@ -3425,8 +3425,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
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



