Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86985277026;
	Sat, 17 Oct 2026 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256039; cv=none; b=KbX5MDg/+HXJbjwdxzJZzK3OUEnwStM6UGOdlzaj3Vdibex+7R5qPeDea8dOa1CrO3uFPHgROtIbryGe5xTSWEKZaRimPiBsy/GSoSfFLq9s0y8l0CX7zbxueFcl7uxvX/EN2s2Yc3fAQ64mb/D0LmRKvCfOKvAZVzeQrgeGygI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256039; c=relaxed/simple;
	bh=Vlv9SQZGPP6j1xyYvs47zcOlWxfM/N5Az56lBtLwGBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq5iMwjy3ClFVU5DFMToosyywjcD95+nQr2nexFUEkPnH5PPZmDraZdnrIPTltSXrClD18p2cHIUgSsNHpT2fCXqqG1OkmoW6o8+eamYpvxREhoS05LFgomPiX0BnO6FHPwGScmkpC2Xk3K5597yqiu266CahNbM5synwePI3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxYIO+Kd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxYIO+Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87251F000C5;
	Sat, 17 Oct 2026 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256038;
	bh=b36Qhil7kguvxNPfnAfUKpsoRqhjTTtkFuVfLXh0xbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxYIO+Kd8mOHdU61K9CqxlqDllG9IYrxTuvxE4niRzUQQhxbwEt/oakBEP8g1EnoI
	 SXLe2zY94yMDXdrzTrvfZn+oN4O7gFSeujQQhhQyLEw+VOfpFr/AjPP9WfTRg6jZH5
	 9mCiIw9X2O0bxniiCJ2bwDHYqXpfILIcNCC/Jyrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0103/1674] ipmr: account multicast table and route memory
Date: Sat, 17 Oct 2026 17:39:35 +0200
Message-ID: <20261017160433.791284177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit b7ee18725f2292ab554aa96a101ae42d45f008bd ]

A netadmin in a user+net namespace can create many IPv4 and IPv6
multicast routing tables with MRT_TABLE and MRT6_TABLE. Each unseen
id allocates an mr_table via the shared mr_table_alloc(), links it
into the per-net list, and leaves it until netns teardown. Those
objects were not charged to memcg, so the host unreclaimable slab
grows with the table count.

Account mr_table allocations with GFP_KERNEL_ACCOUNT and mark the
IPv4/IPv6 MFC caches SLAB_ACCOUNT. This matches the established
handling of IP addresses, routes and alternate interface names.

Unresolved MFC entries are still allocated from softIRQ with
GFP_ATOMIC and are not charged. They expire after 10 seconds and are
bounded by the socket receive queue; see commit 0079ad8e8dc3
("ipmr: remove hard code cache_resolve_queue_len limit").

Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
Fixes: d1db275dd3f6 ("ipv6: ip6mr: support multiple tables")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/050b58f7fc6b45da0fb12768ebb62d18fa46133d.1788784801.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted upstream allocation helpers to existing kzalloc() and kmem_cache_create() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c      | 3 ++-
 net/ipv4/ipmr_base.c | 2 +-
 net/ipv6/ip6mr.c     | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f39cd565569a5..127473aeb7e32 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3159,7 +3159,8 @@ int __init ip_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip_mrt_cache",
 				       sizeof(struct mfc_cache),
-				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				       SLAB_ACCOUNT,
 				       NULL);
 
 	err = register_pernet_subsys(&ipmr_net_ops);
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 28d77d454d442..66fe1a253b9ff 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -38,7 +38,7 @@ mr_table_alloc(struct net *net, u32 id,
 	struct mr_table *mrt;
 	int err;
 
-	mrt = kzalloc(sizeof(*mrt), GFP_KERNEL);
+	mrt = kzalloc(sizeof(*mrt), GFP_KERNEL_ACCOUNT);
 	if (!mrt)
 		return ERR_PTR(-ENOMEM);
 	mrt->id = id;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 18451dfeae682..a7fa0d1d82b08 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1389,7 +1389,7 @@ int __init ip6_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip6_mrt_cache",
 				       sizeof(struct mfc6_cache),
-				       0, SLAB_HWCACHE_ALIGN,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
 				       NULL);
 	if (!mrt_cachep)
 		return -ENOMEM;
-- 
2.53.0



