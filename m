Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790D7993D;
	Wed, 21 Feb 2024 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521436; cv=none; b=C/x9v8++De18nxlNCKzvkDDeePYkocczXv8EHY+8tqNhNoEBgvTLGrsbVAeXyxxIon780zBfxtASlC9Z0+vsGWLrt53dRrvVX0d6hQrremFsUNQ36nSQTsHNQ9JZ5qoWCo1rsK23CFtH3HSPtcm9BLzhvbm5sH7wlODcOgwoES8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521436; c=relaxed/simple;
	bh=5oac1d21qiDoJPGYPnp1IveNFAw3z7Mw1kfHB4S9TTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB4rZ4kWafUWNLOvqZfwPEzdZQx5+c8DGKMPOSOtlePnONmO6xCDHyAW+y6ITHX4sVlUPe0Mw9aZRI+MhaBKc/zu0Lu665jAsgbrB7Hl728hA4Q3TPWRl4lgVVVhCDF5BXs2KhGDbDlEl5lQ5hZn5jYGbHl6b8y7D09qPPcXTTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoFX+rSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoFX+rSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57197C433C7;
	Wed, 21 Feb 2024 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521435;
	bh=5oac1d21qiDoJPGYPnp1IveNFAw3z7Mw1kfHB4S9TTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoFX+rSZ6oFV+6HTzDt6E0WqoTv+TsdMLWe0weg2R5NCXDS/nbEWIZJozFNZ9f5ry
	 CQM+RtkCFv8G/UKz/z4VtmyrZlPxLPh9WF9yCUQaz/rd2agVJGrqbQn5coluLAcRx6
	 RLfcCtoC/Bn3IR5jyO6CNCwyFYdgvyDXfpofD/Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/202] bpf: Add map and need_defer parameters to .map_fd_put_ptr()
Date: Wed, 21 Feb 2024 14:06:22 +0100
Message-ID: <20240221125934.420147830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 20c20bd11a0702ce4dc9300c3da58acf551d9725 ]

map is the pointer of outer map, and need_defer needs some explanation.
need_defer tells the implementation to defer the reference release of
the passed element and ensure that the element is still alive before
the bpf program, which may manipulate it, exits.

The following three cases will invoke map_fd_put_ptr() and different
need_defer values will be passed to these callers:

1) release the reference of the old element in the map during map update
   or map deletion. The release must be deferred, otherwise the bpf
   program may incur use-after-free problem, so need_defer needs to be
   true.
2) release the reference of the to-be-added element in the error path of
   map update. The to-be-added element is not visible to any bpf
   program, so it is OK to pass false for need_defer parameter.
3) release the references of all elements in the map during map release.
   Any bpf program which has access to the map must have been exited and
   released, so need_defer=false will be OK.

These two parameters will be used by the following patches to fix the
potential use-after-free problem for map-in-map.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231204140425.1480317-3-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  6 +++++-
 kernel/bpf/arraymap.c   | 12 +++++++-----
 kernel/bpf/hashtab.c    |  6 +++---
 kernel/bpf/map_in_map.c |  2 +-
 kernel/bpf/map_in_map.h |  2 +-
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 766ea96bf5b8..269754890879 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -44,7 +44,11 @@ struct bpf_map_ops {
 	/* funcs called by prog_array and perf_event_array map */
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
 				int fd);
-	void (*map_fd_put_ptr)(void *ptr);
+	/* If need_defer is true, the implementation should guarantee that
+	 * the to-be-put element is still alive before the bpf program, which
+	 * may manipulate it, exists.
+	 */
+	void (*map_fd_put_ptr)(struct bpf_map *map, void *ptr, bool need_defer);
 	u32 (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
 	u32 (*map_fd_sys_lookup_elem)(void *ptr);
 	void (*map_seq_show_elem)(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 0c17aab3ce5f..44f53c06629e 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -469,7 +469,7 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 
 	old_ptr = xchg(array->ptrs + index, new_ptr);
 	if (old_ptr)
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 
 	return 0;
 }
@@ -485,7 +485,7 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
 
 	old_ptr = xchg(array->ptrs + index, NULL);
 	if (old_ptr) {
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 		return 0;
 	} else {
 		return -ENOENT;
@@ -509,8 +509,9 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	return prog;
 }
 
-static void prog_fd_array_put_ptr(void *ptr)
+static void prog_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_prog is freed after one RCU or tasks trace grace period */
 	bpf_prog_put(ptr);
 }
 
@@ -598,8 +599,9 @@ static void *perf_event_fd_array_get_ptr(struct bpf_map *map,
 	return ee;
 }
 
-static void perf_event_fd_array_put_ptr(void *ptr)
+static void perf_event_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_perf_event is freed after one RCU grace period */
 	bpf_event_entry_free_rcu(ptr);
 }
 
@@ -640,7 +642,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
 	return cgroup_get_from_fd(fd);
 }
 
-static void cgroup_fd_array_put_ptr(void *ptr)
+static void cgroup_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	/* cgroup_put free cgrp after a rcu grace period */
 	cgroup_put(ptr);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3f3ed33bd2fd..8e379b667a0f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -677,7 +677,7 @@ static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
 
 	if (map->ops->map_fd_put_ptr) {
 		ptr = fd_htab_map_get_ptr(map, l);
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, true);
 	}
 }
 
@@ -1337,7 +1337,7 @@ static void fd_htab_map_free(struct bpf_map *map)
 		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
 			void *ptr = fd_htab_map_get_ptr(map, l);
 
-			map->ops->map_fd_put_ptr(ptr);
+			map->ops->map_fd_put_ptr(map, ptr, false);
 		}
 	}
 
@@ -1378,7 +1378,7 @@ int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 
 	ret = htab_map_update_elem(map, key, &ptr, map_flags);
 	if (ret)
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, false);
 
 	return ret;
 }
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 9670ee5ee74e..051c5e40792c 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -102,7 +102,7 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 	return inner_map;
 }
 
-void bpf_map_fd_put_ptr(void *ptr)
+void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	/* ptr->ops->map_free() has to go through one
 	 * rcu grace period by itself.
diff --git a/kernel/bpf/map_in_map.h b/kernel/bpf/map_in_map.h
index 6183db9ec08c..1e652a7bf60e 100644
--- a/kernel/bpf/map_in_map.h
+++ b/kernel/bpf/map_in_map.h
@@ -18,7 +18,7 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 			const struct bpf_map *meta1);
 void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
 			 int ufd);
-void bpf_map_fd_put_ptr(void *ptr);
+void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer);
 u32 bpf_map_fd_sys_lookup_elem(void *ptr);
 
 #endif
-- 
2.43.0



