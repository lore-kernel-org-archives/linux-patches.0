Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011201DDCE;
	Tue, 16 Jul 2024 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145304; cv=none; b=TRC/1QNW496NQQwW9tFhEBglWpzUO9DPZCZPTQrNwNmIRI//Aly4QQdrdmZq9jsw73ziGL21ztECs69vVeSlKwDMV1rCD/DP00b4ZDMvXuQqBmVNQ1a8oSI5DvAZZ0utuoPOGuJ9R8XHqjIqDEDzj/Bh4LaZ1XEM9N1OHr6q0sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145304; c=relaxed/simple;
	bh=yZQOb6ss2OGk4WJzVRdwaVloOXYIC8v+57Tzu+XuoLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6eOvDEpC5XwLf5AbxkFiq7bF4GH5IYQVTD846HP/SdZ2Cd7za5Md3H9xirTD2wq3zstuDuSoiHdMxPXl6KEvTlV1NQzEUENTBewHoIAp+thJdmgg2YGiOnuhnuRvf34mQUe7/Gjx901+khCtW8E4Tcs+pDB8kfBMtx3SaBzMBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsKZRD1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsKZRD1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB8BC116B1;
	Tue, 16 Jul 2024 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145303;
	bh=yZQOb6ss2OGk4WJzVRdwaVloOXYIC8v+57Tzu+XuoLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsKZRD1+Qnx5Yo6Q16ZDD1xXG5YeEzSqzlXTvn+NKmFgoxImRrlK8bVuyTG1PWtMd
	 c9VMoy+JUJ3KfbVEL4mD6za8lYdEVLp3yKWKK7kYrbYCDwrNhnatW4s0ah/yL9VZvs
	 lbi7QK22RLpHUeGcKKhR5nbsrBq4AbXC7FZoDojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/96] bpf: use bpf_map_kvcalloc in bpf_local_storage
Date: Tue, 16 Jul 2024 17:31:32 +0200
Message-ID: <20240716152747.330581504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit ddef81b5fd1da4d7c3cc8785d2043b73b72f38ef ]

Introduce new helper bpf_map_kvcalloc() for the memory allocation in
bpf_local_storage(). Then the allocation will charge the memory from the
map instead of from current, though currently they are the same thing as
it is only used in map creation path now. By charging map's memory into
the memcg from the map, it will be more clear.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Link: https://lore.kernel.org/r/20230210154734.4416-3-laoar.shao@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: af253aef183a ("bpf: fix order of args in call to bpf_map_kvcalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1ca1902af23e9..6b18b8da025f9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1777,6 +1777,8 @@ struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1793,6 +1795,12 @@ bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	return kzalloc(size, flags);
 }
 
+static inline void *
+bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size, gfp_t flags)
+{
+	return kvcalloc(n, size, flags);
+}
+
 static inline void __percpu *
 bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 		     gfp_t flags)
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index f8dd7c516e320..8ea65973739e4 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -568,8 +568,8 @@ static struct bpf_local_storage_map *__bpf_local_storage_map_alloc(union bpf_att
 	nbuckets = max_t(u32, 2, nbuckets);
 	smap->bucket_log = ilog2(nbuckets);
 
-	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
+					 nbuckets, GFP_USER | __GFP_NOWARN);
 	if (!smap->buckets) {
 		bpf_map_area_free(smap);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1e46a84694b8a..d77597daa0022 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -470,6 +470,21 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	return ptr;
 }
 
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = kvcalloc(n, size, flags | __GFP_ACCOUNT);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
+
+	return ptr;
+}
+
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags)
 {
-- 
2.43.0



