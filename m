Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B45187C2;
	Wed, 30 Sep 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789091; cv=none; b=cAAxocrIpSHshLtbrkKcqw15xZUiZTK3NN4vbS5cqpJxFFD3zxBBc58gyZk/WHO42KHSwg+DnBcehLXlrMaUm1vBU3nwTwB/ezFpm+iYDV/odlTC5/nPq2LZu/pN0AVm53dqHs07XJPLT1ECaUYT0gvpbC1/LaUxPt172e+axtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789091; c=relaxed/simple;
	bh=+e80dk1TUXlvKUTnaFeyVdnnHkk1v0LsnxRPtjKd7E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUGdqLx12krbdD3jMhU5Cn01Pdm2LAmos15hvjs9ByKP/D23zM8aqN/XAxjLTU6FUVoACRDbqgbmAPGNqFY7Wn4f0Ig+rFu7zsH/wbNUeWKHVPuPdFS3dMNAbCgPl1U9gBS/JLReqGtPzOGnFSDyqC/j6bcic8IFCI5m8BCrXuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x05VfDoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x05VfDoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBBD1F000FF;
	Wed, 30 Sep 2026 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789090;
	bh=WzVYAihHfzts6xoflykOxkLnQZWI2RouJHMZe+FraRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x05VfDoLSYm9ZUybYaOYq2/J6jwkO8kdUcYv4L05HyMymFzfzXg96XHEhefhU65q1
	 Y0KTheVEivOjl2S3+YLfVy5x53scAp8AScewl66GNm/lGlBfsGNSzmnB9EUcr1QYkh
	 0stmD+NanVFEW68v0JVyj2w7/kO3VLJiz0DgzvM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/877] bpf: Remove migrate_{disable|enable} in ->map_for_each_callback
Date: Wed, 30 Sep 2026 17:20:22 +0200
Message-ID: <20260930152421.405189449@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit ea5b229630a631ee6a72e1f58bc40029efc1daf8 ]

BPF program may call bpf_for_each_map_elem(), and it will call
the ->map_for_each_callback callback of related bpf map. Considering the
running context of bpf program has already disabled migration, remove
the unnecessary migrate_{disable|enable} pair in the implementations of
->map_for_each_callback. To ensure the guarantee will not be voilated
later, also add cant_migrate() check in the implementations.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250108010728.207536-3-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 1c21452d02ee ("bpf: Fix UAF due to concurrent consumption of ttrace lists in alloc_bulk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c |  6 ++----
 kernel/bpf/hashtab.c  | 11 +++++------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7ec69545fe056..fcc0ca7ee8831 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -735,13 +735,13 @@ static long bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback
 	u64 ret = 0;
 	void *val;
 
+	cant_migrate();
+
 	if (flags != 0)
 		return -EINVAL;
 
 	is_percpu = map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
 	array = container_of(map, struct bpf_array, map);
-	if (is_percpu)
-		migrate_disable();
 	for (i = 0; i < map->max_entries; i++) {
 		if (is_percpu)
 			val = this_cpu_ptr(array->pptrs[i]);
@@ -756,8 +756,6 @@ static long bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback
 			break;
 	}
 
-	if (is_percpu)
-		migrate_enable();
 	return num_elems;
 }
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 49db2d0e32157..6df745abb88a7 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2225,17 +2225,18 @@ static long bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_
 	bool is_percpu;
 	u64 ret = 0;
 
+	cant_migrate();
+
 	if (flags != 0)
 		return -EINVAL;
 
 	is_percpu = htab_is_percpu(htab);
 
 	roundup_key_size = round_up(map->key_size, 8);
-	/* disable migration so percpu value prepared here will be the
-	 * same as the one seen by the bpf program with bpf_map_lookup_elem().
+	/* migration has been disabled, so percpu value prepared here will be
+	 * the same as the one seen by the bpf program with
+	 * bpf_map_lookup_elem().
 	 */
-	if (is_percpu)
-		migrate_disable();
 	for (i = 0; i < htab->n_buckets; i++) {
 		b = &htab->buckets[i];
 		rcu_read_lock();
@@ -2261,8 +2262,6 @@ static long bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_
 		rcu_read_unlock();
 	}
 out:
-	if (is_percpu)
-		migrate_enable();
 	return num_elems;
 }
 
-- 
2.53.0



