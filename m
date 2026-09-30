Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD0051AFED;
	Wed, 30 Sep 2026 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788361; cv=none; b=fRAgn8fj/3Rf14hB1RbT7Npk0GZsb4MaoND5DRSa/z2SrBiFLCrsbMe32vkqq4Qss1vVxtZVNlSP0UY5eMvJnJox/6NsbMlHnkBItEpcJTduzEbRABGdUEd8xvcLvnlwT6rObkqH5W/WSeDAEWVXanQ2yWFlLRdhn4v87NsmoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788361; c=relaxed/simple;
	bh=b19GcJY9KPDND+n2hlTqqYpAh9PFIo1T3PPjq5m1ndc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ebsz0FKfGTAa1rtkEOH81/Kq3D2AtmQ8QKmbmQrxHmRK5/crGD13IL2haubPJA+7JhZaefM5ojk3AFuhh0LqJXpeKSUSZV0Py50PjkdYKeUheAwX7+oJW9F4p/0B+Z7WTjdpjQ4y5Dn0VOe/HuZ+/CoTMPmH7Ic+c0vPG2ANdbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA66xhL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA66xhL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD71F000FF;
	Wed, 30 Sep 2026 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788359;
	bh=9/Zz0OZkpozdnCMwzfSJ+N2RJ+C+rg9kKm7kX4PwOfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA66xhL4L7hXN8OhHu7TCTbjaZdzft9o3/f3xNCgkxMepcAIKyyA74vSN2j5grNJj
	 SyOAqpVS5uu+dhAaSgtlj+8O2WiBa243DN8qHCzyapZEwA/LAV3iGmAuYkkzGdkyQi
	 bwwGerPCK0Zdlct995FnBlktS+beECMZ92U2D+8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/877] neighbour: Move neigh_find_table() to neigh_get().
Date: Wed, 30 Sep 2026 17:16:47 +0200
Message-ID: <20260930152416.807347811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0e5ac19c78654abbf43dc4ffdae290c8cb81c59c ]

neigh_valid_get_req() calls neigh_find_table() to fetch neigh_tables[].

neigh_find_table() uses rcu_dereference_rtnl(), but RTNL actually does
not protect it at all; neigh_table_clear() can be called without RTNL
and only waits for RCU readers by synchronize_rcu().

Fortunately, there is no bug because IPv4 is built-in, IPv6 cannot be
unloaded, and DECNET was removed.

To fetch neigh_tables[] by rcu_dereference() later, let's move
neigh_find_table() from neigh_valid_get_req() to neigh_get().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250716221221.442239-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b57d5810fa0d8..0dc0ba5cf7443 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2912,10 +2912,9 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
-					 struct neigh_table **tbl, void **dst,
+					 struct nlattr **tb,
 					 struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[NDA_MAX + 1];
 	struct ndmsg *ndm;
 	int err, i;
 
@@ -2946,12 +2945,6 @@ static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	*tbl = neigh_find_table(ndm->ndm_family);
-	if (!*tbl) {
-		NL_SET_ERR_MSG(extack, "Unsupported family in header for neighbor get request");
-		return ERR_PTR(-EAFNOSUPPORT);
-	}
-
 	for (i = 0; i <= NDA_MAX; ++i) {
 		switch (i) {
 		case NDA_DST:
@@ -2959,12 +2952,6 @@ static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
 				NL_SET_ERR_ATTR_MISS(extack, NULL, NDA_DST);
 				return ERR_PTR(-EINVAL);
 			}
-
-			if (nla_len(tb[i]) != (int)(*tbl)->key_len) {
-				NL_SET_ERR_MSG(extack, "Invalid network address in neighbor get request");
-				return ERR_PTR(-EINVAL);
-			}
-			*dst = nla_data(tb[i]);
 			break;
 		default:
 			if (!tb[i])
@@ -3002,16 +2989,17 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(in_skb->sk);
 	u32 pid = NETLINK_CB(in_skb).portid;
+	struct nlattr *tb[NDA_MAX + 1];
 	struct net_device *dev = NULL;
-	struct neigh_table *tbl = NULL;
 	u32 seq = nlh->nlmsg_seq;
+	struct neigh_table *tbl;
 	struct neighbour *neigh;
 	struct sk_buff *skb;
 	struct ndmsg *ndm;
-	void *dst = NULL;
+	void *dst;
 	int err;
 
-	ndm = neigh_valid_get_req(nlh, &tbl, &dst, extack);
+	ndm = neigh_valid_get_req(nlh, tb, extack);
 	if (IS_ERR(ndm))
 		return PTR_ERR(ndm);
 
@@ -3022,6 +3010,21 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	if (!skb)
 		return -ENOBUFS;
 
+	tbl = neigh_find_table(ndm->ndm_family);
+	if (!tbl) {
+		NL_SET_ERR_MSG(extack, "Unsupported family in header for neighbor get request");
+		err = -EAFNOSUPPORT;
+		goto err_free_skb;
+	}
+
+	if (nla_len(tb[NDA_DST]) != (int)tbl->key_len) {
+		NL_SET_ERR_MSG(extack, "Invalid network address in neighbor get request");
+		err = -EINVAL;
+		goto err_free_skb;
+	}
+
+	dst = nla_data(tb[NDA_DST]);
+
 	if (ndm->ndm_ifindex) {
 		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
 		if (!dev) {
-- 
2.53.0



