Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014435C68D;
	Tue, 21 Jul 2026 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669594; cv=none; b=ir6pnkdF8DHWAJmx5+mNWvG5uijJtXwDU/RE1X3zyhlfpzVmTkUOk21QddF6jpvydjT4O2y5664scTeAXUkmJoTyEECEGPC5sEf4z+ImSPEwGCG88sLC9RO78l1UtW4ubcfjEcBW7vyM1yQ81yHtWzTuTPhoXu9EDm040ZUu6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669594; c=relaxed/simple;
	bh=ZC84i1L054nguGxxw+QGooccs4TF8hO7QUg4OYQU16U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUmvepXN36e4lJ4y8yaTbwQw28/JlD31npkZHQeI6z2JP7HjYbGgIhH8gWbr3SUH9AnTwF8TOITPV80+Lkvx49IIq3Gd9kbSNl/zO1bKspnbZf8fZj7vs0eWBk3lgBSXVC6D4373XSBo56n59SZOSf+LndZ+FRUGWHPVYg6S0NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2BQEH3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2BQEH3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23B21F000E9;
	Tue, 21 Jul 2026 21:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669592;
	bh=C0lRR0l5BLOajQfIfldO+b8drd585U5rDDUn0BJok3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2BQEH3aHieVrDq96lXfQrTujmvzRst4JIVVXkeizlWoGBcCSZ08PwcIyLwj7ikfr
	 g8FjBBYzsS0rUT9D1jDnmd3sILORJT7AQg0BIX0QToFYpnXJFBYe++hDRsOeG19InL
	 I8o3NBu8DDXzcLeLgVZhy3Rbca2rtYtHpD0RL//8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d85ba1c732720b9a4097@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0570/1067] xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_default[]
Date: Tue, 21 Jul 2026 17:19:31 +0200
Message-ID: <20260721152437.354687759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 68de007d5ac9df0e3f4f187a179c5c842bb5a2be ]

KCSAN reported a data race involving net->xfrm.policy_count access.

Add missing READ_ONCE()/WRITE_ONCE() annotations on
xfrm_policy_count and xfrm_policy_default.

Fixes: 2518c7c2b3d7 ("[XFRM]: Hash policies when non-prefixed.")
Reported-by: syzbot+d85ba1c732720b9a4097@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a2b9e96.99669fcc.12a77b.0006.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     |  8 ++++----
 net/xfrm/xfrm_policy.c | 24 ++++++++++++------------
 net/xfrm/xfrm_user.c   | 18 +++++++++---------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index dfae35ff762542..74cb835e9c6d74 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1109,8 +1109,8 @@ int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
 static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
 					 int dir)
 {
-	if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
-		return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
+	if (!READ_ONCE(net->xfrm.policy_count[dir]) && !secpath_exists(skb))
+		return READ_ONCE(net->xfrm.policy_default[dir]) == XFRM_USERPOLICY_ACCEPT;
 
 	return false;
 }
@@ -1191,8 +1191,8 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (!net->xfrm.policy_count[XFRM_POLICY_OUT] &&
-	    net->xfrm.policy_default[XFRM_POLICY_OUT] == XFRM_USERPOLICY_ACCEPT)
+	if (!READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_OUT]) &&
+	    READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_OUT]) == XFRM_USERPOLICY_ACCEPT)
 		return true;
 
 	return (skb_dst(skb)->flags & DST_NOXFRM) ||
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index aabcbdd62b1cdc..615a2f3d7bdae4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -653,7 +653,7 @@ static void xfrm_byidx_resize(struct net *net, int total)
 
 static inline int xfrm_bydst_should_resize(struct net *net, int dir, int *total)
 {
-	unsigned int cnt = net->xfrm.policy_count[dir];
+	unsigned int cnt = READ_ONCE(net->xfrm.policy_count[dir]);
 	unsigned int hmask = net->xfrm.policy_bydst[dir].hmask;
 
 	if (total)
@@ -679,12 +679,12 @@ static inline int xfrm_byidx_should_resize(struct net *net, int total)
 
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si)
 {
-	si->incnt = net->xfrm.policy_count[XFRM_POLICY_IN];
-	si->outcnt = net->xfrm.policy_count[XFRM_POLICY_OUT];
-	si->fwdcnt = net->xfrm.policy_count[XFRM_POLICY_FWD];
-	si->inscnt = net->xfrm.policy_count[XFRM_POLICY_IN+XFRM_POLICY_MAX];
-	si->outscnt = net->xfrm.policy_count[XFRM_POLICY_OUT+XFRM_POLICY_MAX];
-	si->fwdscnt = net->xfrm.policy_count[XFRM_POLICY_FWD+XFRM_POLICY_MAX];
+	si->incnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_IN]);
+	si->outcnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_OUT]);
+	si->fwdcnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_FWD]);
+	si->inscnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_IN+XFRM_POLICY_MAX]);
+	si->outscnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_OUT+XFRM_POLICY_MAX]);
+	si->fwdscnt = READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_FWD+XFRM_POLICY_MAX]);
 	si->spdhcnt = net->xfrm.policy_idx_hmask;
 	si->spdhmcnt = xfrm_policy_hashmax;
 }
@@ -2220,7 +2220,7 @@ static void __xfrm_policy_link(struct xfrm_policy *pol, int dir)
 	struct net *net = xp_net(pol);
 
 	list_add(&pol->walk.all, &net->xfrm.policy_all);
-	net->xfrm.policy_count[dir]++;
+	WRITE_ONCE(net->xfrm.policy_count[dir], net->xfrm.policy_count[dir] + 1);
 	xfrm_pol_hold(pol);
 }
 
@@ -2240,7 +2240,7 @@ static struct xfrm_policy *__xfrm_policy_unlink(struct xfrm_policy *pol,
 	}
 
 	list_del_init(&pol->walk.all);
-	net->xfrm.policy_count[dir]--;
+	WRITE_ONCE(net->xfrm.policy_count[dir], net->xfrm.policy_count[dir] - 1);
 
 	return pol;
 }
@@ -3113,7 +3113,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 
 		/* To accelerate a bit...  */
 		if (!if_id && ((dst_orig->flags & DST_NOXFRM) ||
-			       !net->xfrm.policy_count[XFRM_POLICY_OUT]))
+			       !READ_ONCE(net->xfrm.policy_count[XFRM_POLICY_OUT])))
 			goto nopol;
 
 		xdst = xfrm_bundle_lookup(net, fl, family, dir, &xflo, if_id);
@@ -3185,7 +3185,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 
 nopol:
 	if ((!dst_orig->dev || !(dst_orig->dev->flags & IFF_LOOPBACK)) &&
-	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
+	    READ_ONCE(net->xfrm.policy_default[dir]) == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
 	}
@@ -3607,7 +3607,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		const bool is_crypto_offload = sp &&
 			(xfrm_input_state(skb)->xso.type == XFRM_DEV_OFFLOAD_CRYPTO);
 
-		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
+		if (READ_ONCE(net->xfrm.policy_default[dir]) == XFRM_USERPOLICY_BLOCK) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
 			return 0;
 		}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2a6afca79bd3a7..12fcb743053653 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2179,9 +2179,9 @@ static int xfrm_notify_userpolicy(struct net *net)
 	}
 
 	up = nlmsg_data(nlh);
-	up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
-	up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
-	up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
+	up->in = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_IN]);
+	up->fwd = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_FWD]);
+	up->out = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_OUT]);
 
 	nlmsg_end(skb, nlh);
 
@@ -2205,13 +2205,13 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
 
 	if (xfrm_userpolicy_is_valid(up->in))
-		net->xfrm.policy_default[XFRM_POLICY_IN] = up->in;
+		WRITE_ONCE(net->xfrm.policy_default[XFRM_POLICY_IN], up->in);
 
 	if (xfrm_userpolicy_is_valid(up->fwd))
-		net->xfrm.policy_default[XFRM_POLICY_FWD] = up->fwd;
+		WRITE_ONCE(net->xfrm.policy_default[XFRM_POLICY_FWD], up->fwd);
 
 	if (xfrm_userpolicy_is_valid(up->out))
-		net->xfrm.policy_default[XFRM_POLICY_OUT] = up->out;
+		WRITE_ONCE(net->xfrm.policy_default[XFRM_POLICY_OUT], up->out);
 
 	rt_genid_bump_all(net);
 
@@ -2241,9 +2241,9 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	r_up = nlmsg_data(r_nlh);
-	r_up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
-	r_up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
-	r_up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
+	r_up->in = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_IN]);
+	r_up->fwd = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_FWD]);
+	r_up->out = READ_ONCE(net->xfrm.policy_default[XFRM_POLICY_OUT]);
 	nlmsg_end(r_skb, r_nlh);
 
 	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
-- 
2.53.0



