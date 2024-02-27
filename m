Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB5F78B61;
	Tue, 27 Feb 2024 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043569; cv=none; b=rWWHgT/dzvKct1q/fiLFWWSlNHOYFMZYtv8/qiTodna6Grj5+mC5tmh6E7+7Ut5xNIDk9EDJKcNiGjOa6EqfR39VWZDWcwM233FHa1OuFmI5DknupkFqSFGoMudPQ46ACfwateuMrATVuBwykIqHj6QNaGfav9VJGoo2aTIWT48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043569; c=relaxed/simple;
	bh=iSIrMGASVnfSA6HbP8HQM0hy3AO0FmYARCzc+y2lgWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBT73ro/KjM7YNN9+jjkrGGmhSvVIhH2JGq33pSVzrAZf3LL77TT6D7C5xuppvEaK1Wmc/fGz8XsQo5HiZpDnd5+5SXHGGYUmyx20P8rMHdDTgq/1BMKCGLysA4RRL+gKtm/wd4s1aHGJTHJySRjXbCCzGtUQJe17z0NEq+HQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaJs3zYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaJs3zYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C267BC433C7;
	Tue, 27 Feb 2024 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043569;
	bh=iSIrMGASVnfSA6HbP8HQM0hy3AO0FmYARCzc+y2lgWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaJs3zYRuZT3bWH8ogAaRgUHGZN5tQ9G18rv6dqh0D4CDjHbTCDtcAXobISo8I1AF
	 zWMQxW+LTNMmpiWpYmnNnp16GNoa3ZBDIJgosy3WVJxPYW50NvGXJgU5obZfScKADV
	 sS/kW14sWbc1Ia6QTZ8zOcbyJ3fZLJnlenAI/KFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/195] ipv6: properly combine dev_base_seq and ipv6.dev_addr_genid
Date: Tue, 27 Feb 2024 14:26:56 +0100
Message-ID: <20240227131615.536290462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index b8dc20fe7a4e2..46527b5cc8f0c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -706,6 +706,22 @@ static int inet6_netconf_get_devconf(struct sk_buff *in_skb,
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
@@ -739,8 +755,7 @@ static int inet6_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv6.dev_addr_genid) ^
-			  net->dev_base_seq;
+		cb->seq = inet6_base_seq(net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -5326,7 +5341,7 @@ static int inet6_dump_addr(struct sk_buff *skb, struct netlink_callback *cb,
 	}
 
 	rcu_read_lock();
-	cb->seq = atomic_read(&tgt_net->ipv6.dev_addr_genid) ^ tgt_net->dev_base_seq;
+	cb->seq = inet6_base_seq(tgt_net);
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &tgt_net->dev_index_head[h];
-- 
2.43.0



