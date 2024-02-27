Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56813B2B3;
	Tue, 27 Feb 2024 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044278; cv=none; b=CRxSDvkxjoZK+8XAU/lA1m6aagV45qpJEHNi4p/7LuQaUX7H1XuW+giuVW7Kc3rhK7DRb31Si5KxRIAvdO1Uehi52G9QylFaxbYQQ3VHMYVZNh5sHCackPHYog7tgX/fAy0A4CThp6YJIPKytcOP3+7zgg1uzdmSny/pQBn0n44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044278; c=relaxed/simple;
	bh=0ivcT5Vb9Rbd+gSHw8z9sVZBkWFxFe90lrHoNRpXk6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0bJaiC2mZnTU6ylARudNK17rPQGIlkTZ3+On4V7AlMi1xs0kONSzNZfA+QzHwOHvrWMlndYEfYmM8Olr1vK5CcITCzvH0rhz1j0nqW6rfg4u7tsqz+HIDRdyTdllTXYKPw57HBI1BkIPQnBQdou5wBB7RiiXu0TIXvAZjrQl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhq6BZGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhq6BZGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC924C433C7;
	Tue, 27 Feb 2024 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044278;
	bh=0ivcT5Vb9Rbd+gSHw8z9sVZBkWFxFe90lrHoNRpXk6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhq6BZGuhl2ANknKGfbPusN3/20h8HhHZIjw9IvqShM9bvgEXXSY4x3bV5dVFHDxf
	 znu8LVqlEVixa2U2GLTHu0LvVO8T5aRuDlVGxzpQQrMyCpji9gIBo9mJ/vToS4NEi4
	 1F9iwyNUficDzoZGtbwpcapia6HsA7KQbfOYuC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/122] ipv4: properly combine dev_base_seq and ipv4.dev_addr_genid
Date: Tue, 27 Feb 2024 14:27:46 +0100
Message-ID: <20240227131602.141630918@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index da1ca8081c035..9ac7d47d27b81 100644
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



