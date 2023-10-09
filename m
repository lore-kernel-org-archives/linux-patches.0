Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0319CA51
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddJCnp7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC50C433C7;
	Mon,  9 Oct 2023 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858144;
	bh=mLgNVC6gcnTLUSM2rqcsodv8yePbd4HpIzfAb7lzNCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddJCnp7DICXb5h9+ISdBWYY9Kms9NRUAkchG/AHvahn98wmPLU+UEhg2zHQRfRwrX
	 yuRB2y5tLJPyicTyU6IR3jq6LFAoui+izZjPBmKAINnc1Rb42CyttOzHluS+G8awy7
	 yHjtD+j1qho/cKRUFdEXkVLLjRjodQPwJPmo9hOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/131] netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
Date: Mon,  9 Oct 2023 15:01:10 +0200
Message-ID: <20231009130117.233106377@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 7433b6d2afd512d04398c73aa984d1e285be125b ]

Kyle Zeng reported that there is a race between IPSET_CMD_ADD and IPSET_CMD_SWAP
in netfilter/ip_set, which can lead to the invocation of `__ip_set_put` on a
wrong `set`, triggering the `BUG_ON(set->ref == 0);` check in it.

The race is caused by using the wrong reference counter, i.e. the ref counter instead
of ref_netlink.

Fixes: 24e227896bbf ("netfilter: ipset: Add schedule point in call_ad().")
Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/ZPZqetxOmH+w%2Fmyc@westworld/#r
Tested-by: Kyle Zeng <zengyhkyle@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1cf143f5df2e9..d3be0d0b0bdad 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -530,6 +530,14 @@ __ip_set_put(struct ip_set *set)
 /* set->ref can be swapped out by ip_set_swap, netlink events (like dump) need
  * a separate reference counter
  */
+static void
+__ip_set_get_netlink(struct ip_set *set)
+{
+	write_lock_bh(&ip_set_ref_lock);
+	set->ref_netlink++;
+	write_unlock_bh(&ip_set_ref_lock);
+}
+
 static inline void
 __ip_set_put_netlink(struct ip_set *set)
 {
@@ -1529,11 +1537,11 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 
 	do {
 		if (retried) {
-			__ip_set_get(set);
+			__ip_set_get_netlink(set);
 			nfnl_unlock(NFNL_SUBSYS_IPSET);
 			cond_resched();
 			nfnl_lock(NFNL_SUBSYS_IPSET);
-			__ip_set_put(set);
+			__ip_set_put_netlink(set);
 		}
 
 		ip_set_lock(set);
-- 
2.40.1



