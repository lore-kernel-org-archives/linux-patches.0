Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5695918BBBB;
	Wed,  5 Feb 2025 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768291; cv=none; b=UBKlCWmUxyTjNmXLFUesTxvyePGW9xfnX9okjeo2BqI4PP/E+Z9Bs/rahkZav7epFnVrSFZTb11JpxzjNQgM35njQdYGiZv+5KXcn3Fl3aAPBmugISf4Bl5gIBwkWJY74PxPDarFXgloToJ08GmNdSaw8iXqrPiP/pUXmXrHqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768291; c=relaxed/simple;
	bh=D8FZexhvTdUqqdpFpPjw2t64KTM5Ii7S5xs8KgeygSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgqucZe3Lzd1WcKw4cYWXzl7WphNWcxzh/j7x/CG5q6tIadRJobTI4niP14TrIGuRw6rdmpd961PhqzJ7O5g6Me33ts0becvkmWifpNfldAf2MoVB71rc5qg2cHY+VwjPRt3AgsF3BIGVg+b72q9LFfltYP2DDBBCNvZzHxMFFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTx+m9nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTx+m9nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5312EC4CED1;
	Wed,  5 Feb 2025 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768290;
	bh=D8FZexhvTdUqqdpFpPjw2t64KTM5Ii7S5xs8KgeygSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTx+m9nRFZKCi3sVzdYANOomKj8aJkkiUn7Suclrik7TJjhwVPQ3BRBzMGUik2lOx
	 j/vWhaOs9xapDqgsLXtScB5Pd/IHXgJc7W46BG87suiBx2PsR3LI85MiGdTVkcNati
	 FvZ1FwOtZaSqLUVs6inrmSqZPEj3iZMCqxNG7OIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 526/623] net: page_pool: dont try to stash the napi id
Date: Wed,  5 Feb 2025 14:44:28 +0100
Message-ID: <20250205134516.348642905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 67e4bb2ced0f2d8fbd414f932daea94ba63ae4c4 ]

Page ppol tried to cache the NAPI ID in page pool info to avoid
having a dependency on the life cycle of the NAPI instance.
Since commit under Fixes the NAPI ID is not populated until
napi_enable() and there's a good chance that page pool is
created before NAPI gets enabled.

Protect the NAPI pointer with the existing page pool mutex,
the reading path already holds it. napi_id itself we need
to READ_ONCE(), it's protected by netdev_lock() which are
not holding in page pool.

Before this patch napi IDs were missing for mlx5:

 # ./cli.py --spec netlink/specs/netdev.yaml --dump page-pool-get

 [{'id': 144, 'ifindex': 2, 'inflight': 3072, 'inflight-mem': 12582912},
  {'id': 143, 'ifindex': 2, 'inflight': 5568, 'inflight-mem': 22806528},
  {'id': 142, 'ifindex': 2, 'inflight': 5120, 'inflight-mem': 20971520},
  {'id': 141, 'ifindex': 2, 'inflight': 4992, 'inflight-mem': 20447232},
  ...

After:

 [{'id': 144, 'ifindex': 2, 'inflight': 3072, 'inflight-mem': 12582912,
   'napi-id': 565},
  {'id': 143, 'ifindex': 2, 'inflight': 4224, 'inflight-mem': 17301504,
   'napi-id': 525},
  {'id': 142, 'ifindex': 2, 'inflight': 4288, 'inflight-mem': 17563648,
   'napi-id': 524},
  ...

Fixes: 86e25f40aa1e ("net: napi: Add napi_config")
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250123231620.1086401-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/page_pool/types.h |  1 -
 net/core/dev.c                |  2 +-
 net/core/page_pool.c          |  2 ++
 net/core/page_pool_priv.h     |  2 ++
 net/core/page_pool_user.c     | 15 +++++++++------
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index c022c410abe39..386efddd2aac0 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -236,7 +236,6 @@ struct page_pool {
 	struct {
 		struct hlist_node list;
 		u64 detach_time;
-		u32 napi_id;
 		u32 id;
 	} user;
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 71988f2f484b2..a994b1c725098 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6573,7 +6573,7 @@ void napi_resume_irqs(unsigned int napi_id)
 static void __napi_hash_add_with_id(struct napi_struct *napi,
 				    unsigned int napi_id)
 {
-	napi->napi_id = napi_id;
+	WRITE_ONCE(napi->napi_id, napi_id);
 	hlist_add_head_rcu(&napi->napi_hash_node,
 			   &napi_hash[napi->napi_id % HASH_SIZE(napi_hash)]);
 }
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f89cf93f6eb45..32570333068d8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1108,7 +1108,9 @@ void page_pool_disable_direct_recycling(struct page_pool *pool)
 	WARN_ON(!test_bit(NAPI_STATE_SCHED, &pool->p.napi->state));
 	WARN_ON(READ_ONCE(pool->p.napi->list_owner) != -1);
 
+	mutex_lock(&page_pools_lock);
 	WRITE_ONCE(pool->p.napi, NULL);
+	mutex_unlock(&page_pools_lock);
 }
 EXPORT_SYMBOL(page_pool_disable_direct_recycling);
 
diff --git a/net/core/page_pool_priv.h b/net/core/page_pool_priv.h
index 57439787b9c2b..2fb06d5f6d559 100644
--- a/net/core/page_pool_priv.h
+++ b/net/core/page_pool_priv.h
@@ -7,6 +7,8 @@
 
 #include "netmem_priv.h"
 
+extern struct mutex page_pools_lock;
+
 s32 page_pool_inflight(const struct page_pool *pool, bool strict);
 
 int page_pool_list(struct page_pool *pool);
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bfd..6677e0c2e2565 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/xarray.h>
+#include <net/busy_poll.h>
 #include <net/net_debug.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
@@ -14,10 +15,11 @@
 #include "netdev-genl-gen.h"
 
 static DEFINE_XARRAY_FLAGS(page_pools, XA_FLAGS_ALLOC1);
-/* Protects: page_pools, netdevice->page_pools, pool->slow.netdev, pool->user.
+/* Protects: page_pools, netdevice->page_pools, pool->p.napi, pool->slow.netdev,
+ *	pool->user.
  * Ordering: inside rtnl_lock
  */
-static DEFINE_MUTEX(page_pools_lock);
+DEFINE_MUTEX(page_pools_lock);
 
 /* Page pools are only reachable from user space (via netlink) if they are
  * linked to a netdev at creation time. Following page pool "visibility"
@@ -216,6 +218,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 {
 	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
 	size_t inflight, refsz;
+	unsigned int napi_id;
 	void *hdr;
 
 	hdr = genlmsg_iput(rsp, info);
@@ -229,8 +232,10 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 	    nla_put_u32(rsp, NETDEV_A_PAGE_POOL_IFINDEX,
 			pool->slow.netdev->ifindex))
 		goto err_cancel;
-	if (pool->user.napi_id &&
-	    nla_put_uint(rsp, NETDEV_A_PAGE_POOL_NAPI_ID, pool->user.napi_id))
+
+	napi_id = pool->p.napi ? READ_ONCE(pool->p.napi->napi_id) : 0;
+	if (napi_id >= MIN_NAPI_ID &&
+	    nla_put_uint(rsp, NETDEV_A_PAGE_POOL_NAPI_ID, napi_id))
 		goto err_cancel;
 
 	inflight = page_pool_inflight(pool, false);
@@ -319,8 +324,6 @@ int page_pool_list(struct page_pool *pool)
 	if (pool->slow.netdev) {
 		hlist_add_head(&pool->user.list,
 			       &pool->slow.netdev->page_pools);
-		pool->user.napi_id = pool->p.napi ? pool->p.napi->napi_id : 0;
-
 		netdev_nl_page_pool_event(pool, NETDEV_CMD_PAGE_POOL_ADD_NTF);
 	}
 
-- 
2.39.5



