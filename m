Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB60C1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3645CC433D6;
	Wed, 23 Nov 2022 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195044;
	bh=FbKiOSvjV+jJEQIIhM3Jg2i8iFQpugwOgF/soOb1W0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBfAII0wbNvCdyiIEInPE7i8zJYDRaoQLWwSHvduPX5hBQnThFExuDxaiE1WK6rT0
	 M3y90Ijeht2ETw8Kbpxm9eQGBC00pI0qaF91VSzqEsr3+mFSXx5vJx5WTP1Fzd72sl
	 i2r0prrw2bLLy2v7eeWKuutn7aE6xOTsfIEcEIcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuang Wang <nashuiliang@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/156] net: macvlan: Use built-in RCU list checking
Date: Wed, 23 Nov 2022 09:50:58 +0100
Message-Id: <20221123084601.634260773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuang Wang <nashuiliang@gmail.com>

[ Upstream commit 5df1341ea822292275c56744aab9c536d75c33be ]

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to hlist_for_each_entry_rcu() to silence false
lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.

Execute as follow:

 ip link add link eth0 type macvlan mode source macaddr add <MAC-ADDR>

The rtnl_lock is held when macvlan_hash_lookup_source() or
macvlan_fill_info_macaddr() are called in the non-RCU read side section.
So, pass lockdep_rtnl_is_held() to silence false lockdep warning.

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 253c0605f6e6..29c70d5e3926 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -138,7 +138,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &vlan->port->vlan_source_hash[idx];
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
 		    entry->vlan == vlan)
 			return entry;
@@ -1604,7 +1604,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
-- 
2.35.1



