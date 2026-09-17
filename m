Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9744E77ED;
	Thu, 17 Sep 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660065; cv=none; b=QdNi7nguxR6RzAEVJLq8pQL1igatb9N6OZcpNgZT/O03dXcwuDsFx+FaL1KUBU6X4HC6KZ8mbJ9WwLag6y3Dq1jrKMt2O5cAm0W2eWbxk1hvVKbTVHcNT+mWqFKyDOw/ugTX+2KdbAkrp4ajG/9EE50Kr3zPoPN43+afo64EBB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660065; c=relaxed/simple;
	bh=y/6PWD21ilwZrOIcOb6UCzi0g2E44TPwYubBHLvvo+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DitL1JR9BNwo3+/jv/MLl7bR6tJ4x3sWYDKvVm0OHdrNOCuqJkMTribjyTPIOVlyOOMcydPUNWTrkyFWmUg8sxJKIFFqksYSjWsI5Is9otfjn/psBnLJpBXv4s0JWg+w8pAPKgMHnKjCGnCtat4On4G9hSl4ZY6Fud1Dp5urJvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQhZE+hN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQhZE+hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EA31F00899;
	Thu, 17 Sep 2026 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660056;
	bh=NHsCNQ5pBwQD9/0CkW+5U1e3wUjXlX46n9YJI4KLjiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQhZE+hNQ6xddduhwfPyP+fgsp1WjWBdKCitu25y0W6Q5jxgm6oHtnY2v1s5qOaYU
	 kAOJzwey/clfjI3v4rQWp9I3b78Fn20GHTltjmLqDtaaB9cMgQo1G0bMictHWeWT58
	 0ebodbiQ8QwvqBDXyIbOSYjxao5LLBCeFvsqcpqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 465/733] ipmr: account multicast table and route memory
Date: Thu, 17 Sep 2026 16:12:53 +0100
Message-ID: <20260917151403.551857591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit b7ee18725f2292ab554aa96a101ae42d45f008bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipmr.c      |    3 ++-
 net/ipv4/ipmr_base.c |    2 +-
 net/ipv6/ip6mr.c     |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3376,7 +3376,8 @@ int __init ip_mr_init(void)
 {
 	int err;
 
-	mrt_cachep = KMEM_CACHE(mfc_cache, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	mrt_cachep = KMEM_CACHE(mfc_cache,
+				SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	err = register_pernet_subsys(&ipmr_net_ops);
 	if (err)
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -52,7 +52,7 @@ mr_table_alloc(struct net *net, u32 id,
 	struct mr_table *mrt;
 	int err;
 
-	mrt = kzalloc_obj(*mrt);
+	mrt = kzalloc_obj(*mrt, GFP_KERNEL_ACCOUNT);
 	if (!mrt)
 		return ERR_PTR(-ENOMEM);
 	mrt->id = id;
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1427,7 +1427,7 @@ int __init ip6_mr_init(void)
 {
 	int err;
 
-	mrt_cachep = KMEM_CACHE(mfc6_cache, SLAB_HWCACHE_ALIGN);
+	mrt_cachep = KMEM_CACHE(mfc6_cache, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT);
 	if (!mrt_cachep)
 		return -ENOMEM;
 


