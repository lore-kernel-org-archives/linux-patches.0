Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235E5372FB;
	Wed, 30 Sep 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790105; cv=none; b=VG0kqX5IFa7DcwT+6DKclxmlLN0Xqf3MfeACuay4sE6FMsVDvNzFzMYtxgCIwSBMPd2qLA/UdNxXYu1yPnMopzlY0/f7gLdHIaN7hqP+A0kQfbQp9YPlN4EucidUoKXqsbEJZEEoqtTRkUe+y+lTxXLG/2LlU6A0GMZfl81TvZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790105; c=relaxed/simple;
	bh=GVUFMOgFTOdVTeikuTeStQxT1fGMle5nnmYZa4KGQcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtBSVzyAvCEZAZ4pokoNzp0DLjiIJW5lf3xreTeKPTdJ2ULASYTT8fgWMP982vN/R0OfPwVwFJiSkpDrKIlDhiS2V9ERS4lbDa5RI84gUdZg+6C7kvv98kOPN0WKXNKNMKDsLlZyVaKb81mKZ7uZlR8ZYwOwOXXUuNhGjIxuYq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFPej5+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFPej5+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA39B1F000FF;
	Wed, 30 Sep 2026 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790104;
	bh=p4tUk9SZpM4yqmyQzEHuRDDt6j7wzPpOYXjK7Njy8E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFPej5+i08xak4yEh7NFnkVu8Q5cOlZ3KSbD/257XKACRHHOSMIblCFyiL+6f4fu+
	 SJt6Ks+/AfpmA0ZQ6lmz0AubPZLneOcf29cn6zya07GQyq2cXv4zoXFOS0DDieHIiu
	 w/dt2v5+axNZlw12p9bIZCRv1IXPGmDcolXNY44o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 712/877] ipmr: account multicast table and route memory
Date: Wed, 30 Sep 2026 17:27:03 +0200
Message-ID: <20260930152430.049112444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ changed kzalloc_obj(*mrt, GFP_KERNEL_ACCOUNT) to kzalloc(sizeof(*mrt), GFP_KERNEL_ACCOUNT) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipmr.c      |    3 ++-
 net/ipv4/ipmr_base.c |    2 +-
 net/ipv6/ip6mr.c     |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3162,7 +3162,8 @@ int __init ip_mr_init(void)
 {
 	int err;
 
-	mrt_cachep = KMEM_CACHE(mfc_cache, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	mrt_cachep = KMEM_CACHE(mfc_cache,
+				SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	err = register_pernet_subsys(&ipmr_net_ops);
 	if (err)
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
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1387,7 +1387,7 @@ int __init ip6_mr_init(void)
 {
 	int err;
 
-	mrt_cachep = KMEM_CACHE(mfc6_cache, SLAB_HWCACHE_ALIGN);
+	mrt_cachep = KMEM_CACHE(mfc6_cache, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT);
 	if (!mrt_cachep)
 		return -ENOMEM;
 


