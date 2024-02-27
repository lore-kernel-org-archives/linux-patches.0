Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671E2F2D;
	Tue, 27 Feb 2024 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041242; cv=none; b=b5lWAhfxFnpse07/ICNjK/tgGgXiFw6m03QJ7gRHltRBrfn1GFi1J0n60gkqXAAK55dpkxYoIHupl1Wo+wqXOn8oWIzYzfA268CuX8TWGv/k2bc1IDFefDIssnMYHDuDDQlPe1/3eamk26eBjMFeQPDFEwYmJpvHUvovrQQqyvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041242; c=relaxed/simple;
	bh=VY1+cQe6pW1sMwNlVSc9xDZc+gqWNvvXNlT76umntqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcIsjehBnOv2U2ak7cfBKS+JtZYwXDg//GTEBnd/DLsr8hgCE7uA1J9fjHyS69PCvn9mqjRHb4d6xlCyZ7/GkCDzJKgopjnQMSpyr+ysSI2qVYpz0f/fEJZTpTEhyreHXxLtrwSsHlAacolSqVwdhbdrrdJeM9uOLKcivfw4Pm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsyKQQYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsyKQQYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B723FC433F1;
	Tue, 27 Feb 2024 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041242;
	bh=VY1+cQe6pW1sMwNlVSc9xDZc+gqWNvvXNlT76umntqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsyKQQYvJOj/wmgSCypqdFtugB05m9jeJP3REUPLpkUQ1YUJArk3KSvZywVpNwbUg
	 JZeD0PTBbtTMNm/o0AtIVX6aW8XmXHRhje5nDssByjeO2a/uQCPIFuo5jYPHH1nkcK
	 ZYBJxdNX41CoI0YbRKAq2lSokVTB0c+PDidOfBaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 269/334] ipv4: properly combine dev_base_seq and ipv4.dev_addr_genid
Date: Tue, 27 Feb 2024 14:22:07 +0100
Message-ID: <20240227131639.667440244@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 081a0e3b0d4c061419d3f4679dec9f68725b17e4 ]

net->dev_base_seq and ipv4.dev_addr_genid are monotonically increasing.

If we XOR their values, we could miss to detect if both values
were changed with the same amount.

Fixes: 0465277f6b3f ("ipv4: provide addr and netconf dump consistency info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ca0ff15dc8fa3..bc74f131fe4df 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1825,6 +1825,21 @@ static int in_dev_dump_addr(struct in_device *in_dev, struct sk_buff *skb,
 	return err;
 }
 
+/* Combine dev_addr_genid and dev_base_seq to detect changes.
+ */
+static u32 inet_base_seq(const struct net *net)
+{
+	u32 res = atomic_read(&net->ipv4.dev_addr_genid) +
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
 static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = cb->nlh;
@@ -1876,8 +1891,7 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 		idx = 0;
 		head = &tgt_net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&tgt_net->ipv4.dev_addr_genid) ^
-			  tgt_net->dev_base_seq;
+		cb->seq = inet_base_seq(tgt_net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -2278,8 +2292,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
-			  net->dev_base_seq;
+		cb->seq = inet_base_seq(net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
-- 
2.43.0



