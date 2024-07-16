Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05391DDCE;
	Tue, 16 Jul 2024 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145307; cv=none; b=u7QRG92s/Ro7615yoFBP2HY2nrGOVoN9yBwtRoVqv/0WKkTUddd/Twx7dwBgFM8gDycUIE3Nzr7qaPcRfyBarquLMF2MhLdCaC0qo1IPjbwbYA4+AWjtqP9Rejb7lYjKHgYkyqOF3dkZpnylc3GbWw3415/Vj9ORTHAnr9lm3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145307; c=relaxed/simple;
	bh=axh6KxyaZxAFj18CvgkhjLko4OjOftjQFtXo4QY3Vm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhJsINy2YNQ0+bZHFewZ1OyDc92Xt1YbZ0WLTrY9IZVMT8UPkicxGKIrysFVW3hM+H9WwCxAyi+0EG6r7PqKD+3VvIo7Mz3fpafLK82l8Y+5USB6Op30rHI9Mbo6RbZnqztXryjhog6Ij3xyVsAEGCIuTiYCyQGVhrxGbQ5cq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqL5MB9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqL5MB9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F6EC116B1;
	Tue, 16 Jul 2024 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145306;
	bh=axh6KxyaZxAFj18CvgkhjLko4OjOftjQFtXo4QY3Vm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqL5MB9U+AjHlQP8SONYrUBtQsFdNhd8MCySGQ5rGxzpYrSoOmG/HuvmEoevCkkue
	 02b8rBGKXXFZ5HEUvX5kCBL2hvtzQ9KdubNPInbv3hVtbn4axx1uBEQm7JpC1j7g2i
	 KGsZn9jGPHLABfC69yuBss98cZCcWx/bOr2PcYOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/96] bpf: Remove __bpf_local_storage_map_alloc
Date: Tue, 16 Jul 2024 17:31:33 +0200
Message-ID: <20240716152747.368566781@linuxfoundation.org>
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

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 62827d612ae525695799b3635a087cb49c55e977 ]

bpf_local_storage_map_alloc() is the only caller of
__bpf_local_storage_map_alloc().  The remaining logic in
bpf_local_storage_map_alloc() is only a one liner setting
the smap->cache_idx.

Remove __bpf_local_storage_map_alloc() to simplify code.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20230308065936.1550103-4-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: af253aef183a ("bpf: fix order of args in call to bpf_map_kvcalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 63 ++++++++++++++--------------------
 1 file changed, 26 insertions(+), 37 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 8ea65973739e4..888b8e481083f 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -552,40 +552,6 @@ int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
-static struct bpf_local_storage_map *__bpf_local_storage_map_alloc(union bpf_attr *attr)
-{
-	struct bpf_local_storage_map *smap;
-	unsigned int i;
-	u32 nbuckets;
-
-	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
-	if (!smap)
-		return ERR_PTR(-ENOMEM);
-	bpf_map_init_from_attr(&smap->map, attr);
-
-	nbuckets = roundup_pow_of_two(num_possible_cpus());
-	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
-	nbuckets = max_t(u32, 2, nbuckets);
-	smap->bucket_log = ilog2(nbuckets);
-
-	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
-					 nbuckets, GFP_USER | __GFP_NOWARN);
-	if (!smap->buckets) {
-		bpf_map_area_free(smap);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	for (i = 0; i < nbuckets; i++) {
-		INIT_HLIST_HEAD(&smap->buckets[i].list);
-		raw_spin_lock_init(&smap->buckets[i].lock);
-	}
-
-	smap->elem_size = offsetof(struct bpf_local_storage_elem,
-				   sdata.data[attr->value_size]);
-
-	return smap;
-}
-
 int bpf_local_storage_map_check_btf(const struct bpf_map *map,
 				    const struct btf *btf,
 				    const struct btf_type *key_type,
@@ -641,10 +607,33 @@ bpf_local_storage_map_alloc(union bpf_attr *attr,
 			    struct bpf_local_storage_cache *cache)
 {
 	struct bpf_local_storage_map *smap;
+	unsigned int i;
+	u32 nbuckets;
+
+	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
+	if (!smap)
+		return ERR_PTR(-ENOMEM);
+	bpf_map_init_from_attr(&smap->map, attr);
+
+	nbuckets = roundup_pow_of_two(num_possible_cpus());
+	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
+	nbuckets = max_t(u32, 2, nbuckets);
+	smap->bucket_log = ilog2(nbuckets);
 
-	smap = __bpf_local_storage_map_alloc(attr);
-	if (IS_ERR(smap))
-		return ERR_CAST(smap);
+	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
+					 nbuckets, GFP_USER | __GFP_NOWARN);
+	if (!smap->buckets) {
+		bpf_map_area_free(smap);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for (i = 0; i < nbuckets; i++) {
+		INIT_HLIST_HEAD(&smap->buckets[i].list);
+		raw_spin_lock_init(&smap->buckets[i].lock);
+	}
+
+	smap->elem_size = offsetof(struct bpf_local_storage_elem,
+				   sdata.data[attr->value_size]);
 
 	smap->cache_idx = bpf_local_storage_cache_idx_get(cache);
 	return &smap->map;
-- 
2.43.0



