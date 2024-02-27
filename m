Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EB013EFE9;
	Tue, 27 Feb 2024 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043909; cv=none; b=k1pRShKNhrpOJ+gVxxpxu8W8kRKfcYZIC0uh8C6N+sh/DvjgD0Ekx9CS9T9LPhAkF5zlfsA/6tZA/aGrLLfz+kiMbeI6ZTFufJkLB+iXSzT2yf529hDsCXZpcM+1d6QeiCYqUw1W+UZ1QU+wQlvCHGREtA3RNUYQ7voSmtUml5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043909; c=relaxed/simple;
	bh=kUzF5kHR8cs2Ol/0IjoR6h/d7aDWwqPSfOY0QYqUqYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M++J/Qn8iMeYywlLwiawzSUnb9E3EhdZcZBEYUpOWVXxbP9vhvS41gbbf9G7/cAY/rQvPJNVOKhXa2PvfK9GnzUgRnAJMygMaVARlRY0GpXn8oqcDgOfgnNl9lg4NG/lViiXEDHm0eERzRXLwuzlVdN2UYW1Z48zn2b0v409H8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkZBfAoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkZBfAoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9686BC43390;
	Tue, 27 Feb 2024 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043909;
	bh=kUzF5kHR8cs2Ol/0IjoR6h/d7aDWwqPSfOY0QYqUqYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkZBfAozTwKCPTL8auA1/L6j9OJCgcCvCc9V9GgQtTYaPnbu+6oI/wkotYXhoSZ5U
	 Ajdb9bYFcExjdzkzsInxLFTBeoGrqyArrNABED43pQe2mJh3moZM2XRZ9oyGOnpmlY
	 NjTGmmHIFHPTnrhBvbFk8zXEFB0oNVMVyIypF6Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 71/84] ipv4: properly combine dev_base_seq and ipv4.dev_addr_genid
Date: Tue, 27 Feb 2024 14:27:38 +0100
Message-ID: <20240227131555.180507987@linuxfoundation.org>
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
index 4c013f8800f0c..ed00b233cee2e 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1798,6 +1798,21 @@ static int in_dev_dump_addr(struct in_device *in_dev, struct sk_buff *skb,
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
@@ -1849,8 +1864,7 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 		idx = 0;
 		head = &tgt_net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&tgt_net->ipv4.dev_addr_genid) ^
-			  tgt_net->dev_base_seq;
+		cb->seq = inet_base_seq(tgt_net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -2249,8 +2263,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
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



