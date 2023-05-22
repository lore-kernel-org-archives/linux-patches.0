Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610ED168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C17C433EF;
	Mon, 22 May 2023 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782760;
	bh=OQ7XY+QmbQ/wqKS44nz6JlaIQOvpadW0HzxgGX4tBu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLQuatBuEXrsgEoPaVmhj5r2I8xmN2+YP1m+R97277iFlpZ5BW0cciJMdxXMSaj+a
	 6jaBdojyvp7Q9hlNFWj2aV3I8M1X6E7fs+BH0KVJinevTJhudCzP7Xa4wE6mRY6R+Q
	 CPaJXSn5JSWIO7I9GnZt25McbxFpFE5gvDlCMLY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/203] netfilter: nf_tables: always release netdev hooks from notifier
Date: Mon, 22 May 2023 20:07:14 +0100
Message-Id: <20230522190355.235409695@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit dc1c9fd4a8bbe1e06add9053010b652449bfe411 ]

This reverts "netfilter: nf_tables: skip netdev events generated on netns removal".

The problem is that when a veth device is released, the veth release
callback will also queue the peer netns device for removal.

Its possible that the peer netns is also slated for removal.  In this
case, the device memory is already released before the pre_exit hook of
the peer netns runs:

BUG: KASAN: slab-use-after-free in nf_hook_entry_head+0x1b8/0x1d0
Read of size 8 at addr ffff88812c0124f0 by task kworker/u8:1/45
Workqueue: netns cleanup_net
Call Trace:
 nf_hook_entry_head+0x1b8/0x1d0
 __nf_unregister_net_hook+0x76/0x510
 nft_netdev_unregister_hooks+0xa0/0x220
 __nft_release_hook+0x184/0x490
 nf_tables_pre_exit_net+0x12f/0x1b0
 ..

Order is:
1. First netns is released, veth_dellink() queues peer netns device
   for removal
2. peer netns is queued for removal
3. peer netns device is released, unreg event is triggered
4. unreg event is ignored because netns is going down
5. pre_exit hook calls nft_netdev_unregister_hooks but device memory
   might be free'd already.

Fixes: 68a3765c659f ("netfilter: nf_tables: skip netdev events generated on netns removal")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_chain_filter.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 3ced0eb6b7c3b..5b02408a920bf 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -342,6 +342,12 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 	}
 
+	/* UNREGISTER events are also happening on netns exit.
+	 *
+	 * Although nf_tables core releases all tables/chains, only this event
+	 * handler provides guarantee that hook->ops.dev is still accessible,
+	 * so we cannot skip exiting net namespaces.
+	 */
 	__nft_release_basechain(ctx);
 }
 
@@ -360,9 +366,6 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	if (!check_net(ctx.net))
-		return NOTIFY_DONE;
-
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-- 
2.39.2



