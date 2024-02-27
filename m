Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3759D13B2B4;
	Tue, 27 Feb 2024 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043927; cv=none; b=PwFs4HwjyuNp9IEB+XVyh4KtxXsHpefx4wND+CDCgHWfA1dz7rSnnLx4Zecm2CNUKwI1vYguK/Nm1anY1PenjmYo5WqD1qZApe1L14PI+Z5OTj4GlROsjRUIxl1MafvxlNVF/hQE0jnIamCwy+3IlBYh92bQUoJKu2joeCq2GLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043927; c=relaxed/simple;
	bh=C5w2seccK0YTu103fpgTwsfq4WQYNHbfwmQvqYQKu10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTnsd7vb2O+ZIRjUgxDaPxbOyQFiVpmnG10Pxvp21E5zzJwIAK67ZG7s/LL+vEvLXnudRFmVAfQxdD4AAhHNkdyufMQdxy+DGaY4P5QxFePrePndSUJppiGZyMIumn2bwdpCmnI95IC8GR+K+eOP6PRCbrJHpxAkjfTnA5C8LmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBuJyWOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBuJyWOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A720BC433F1;
	Tue, 27 Feb 2024 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043926;
	bh=C5w2seccK0YTu103fpgTwsfq4WQYNHbfwmQvqYQKu10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBuJyWOrTXif48iDqO2uwKquyRpM4H/0U7EzgzkSjq/QiSAR4ivWf0DBDFnnFOLli
	 qk0BlP2jbANqAMw7RuW90DKgyw7xZcVeK4JyPmKFZlrLgQf/0cRu1c1B8LVQgduWkb
	 0YqiAtOfHmeO+8MJ1gT+fOMgEcWgjWGbd67pGitw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/84] ipv6: properly combine dev_base_seq and ipv6.dev_addr_genid
Date: Tue, 27 Feb 2024 14:27:39 +0100
Message-ID: <20240227131555.212737588@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e898e4cd1aab271ca414f9ac6e08e4c761f6913c ]

net->dev_base_seq and ipv6.dev_addr_genid are monotonically increasing.

If we XOR their values, we could miss to detect if both values
were changed with the same amount.

Fixes: 63998ac24f83 ("ipv6: provide addr and netconf dump consistency info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4bec4c0617412..6fcbe8912b431 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -696,6 +696,22 @@ static int inet6_netconf_get_devconf(struct sk_buff *in_skb,
 	return err;
 }
 
+/* Combine dev_addr_genid and dev_base_seq to detect changes.
+ */
+static u32 inet6_base_seq(const struct net *net)
+{
+	u32 res = atomic_read(&net->ipv6.dev_addr_genid) +
+		  net->dev_base_seq;
+
+	/* Must not return 0 (see nl_dump_check_consistent()).
+	 * Chose a value far away from 0.
+	 */
+	if (!res)
+		res = 0x80000000;
+	return res;
+}
+
+
 static int inet6_netconf_dump_devconf(struct sk_buff *skb,
 				      struct netlink_callback *cb)
 {
@@ -729,8 +745,7 @@ static int inet6_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv6.dev_addr_genid) ^
-			  net->dev_base_seq;
+		cb->seq = inet6_base_seq(net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -5232,7 +5247,7 @@ static int inet6_dump_addr(struct sk_buff *skb, struct netlink_callback *cb,
 	}
 
 	rcu_read_lock();
-	cb->seq = atomic_read(&tgt_net->ipv6.dev_addr_genid) ^ tgt_net->dev_base_seq;
+	cb->seq = inet6_base_seq(tgt_net);
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &tgt_net->dev_index_head[h];
-- 
2.43.0



