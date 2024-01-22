Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC76027E;
	Tue, 23 Jan 2024 01:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974678; cv=none; b=Rg4UntWfvP+M5QmuahJsM7q+N0rrTz9icxAsq5iTO17e47XLe3tkfNaMxHUVb4rKzeXodUv5iEgoXSdaCmcYtD8DpptbQdJIkcnQJAPQdW9aWiAZLV1o+JkSOv3Hf8PlY8TU8ATkvi6TdJXpKxuced/g88DU+V2dOzfFixJO1jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974678; c=relaxed/simple;
	bh=47kiL4Tw0gvwMNQf9m3xpldhv9K7Ty8aAf4JVpTX8+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwGnpIE/lWVcAU24BxkFzSSTk7etpmbcXZAv/oJXiyanXOH1KfiV5yTX8atDOxwt5eJbTSey45Fpua8ZzvDYkS5mRXvgnPZdjLh913shtirdY2OEP05qo/PiPXRhcXj9y0u0eKr0UZV87fq61NleMJtnY6KPENmNVsON0gYfIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeU4tQ7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeU4tQ7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8997C433C7;
	Tue, 23 Jan 2024 01:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974677;
	bh=47kiL4Tw0gvwMNQf9m3xpldhv9K7Ty8aAf4JVpTX8+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeU4tQ7cc4ZNTIY7d5YnjB1rdEsjlhSN9WMANP05OxKDb1IkijO6g/JCWOM1JLWSH
	 7nMPgcMGw7KEX/B0cf5Q9HEQEOt8NywBB7AZlqpZQ1wL3wFCIVK0k7uP7LKXl+HhWS
	 EeRUMx+pZOPlIeS0gAhC4W2uYVm0cLif85YUOJtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/583] bpf: Add map and need_defer parameters to .map_fd_put_ptr()
Date: Mon, 22 Jan 2024 15:52:50 -0800
Message-ID: <20240122235815.789652315@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 876673364161 ("bpf: Defer the free of inner map when necessary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  6 +++++-
 kernel/bpf/arraymap.c   | 12 +++++++-----
 kernel/bpf/hashtab.c    |  6 +++---
 kernel/bpf/map_in_map.c |  2 +-
 kernel/bpf/map_in_map.h |  2 +-
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 75e039081f92..4bed78e47347 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -106,7 +106,11 @@ struct bpf_map_ops {
 	/* funcs called by prog_array and perf_event_array map */
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
 				int fd);
-	void (*map_fd_put_ptr)(void *ptr);
+	/* If need_defer is true, the implementation should guarantee that
+	 * the to-be-put element is still alive before the bpf program, which
+	 * may manipulate it, exists.
+	 */
+	void (*map_fd_put_ptr)(struct bpf_map *map, void *ptr, bool need_defer);
 	int (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
 	u32 (*map_fd_sys_lookup_elem)(void *ptr);
 	void (*map_seq_show_elem)(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index c85ff9162a5c..9bfad7e96913 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -867,7 +867,7 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 	}
 
 	if (old_ptr)
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 	return 0;
 }
 
@@ -890,7 +890,7 @@ static long fd_array_map_delete_elem(struct bpf_map *map, void *key)
 	}
 
 	if (old_ptr) {
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 		return 0;
 	} else {
 		return -ENOENT;
@@ -913,8 +913,9 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	return prog;
 }
 
-static void prog_fd_array_put_ptr(void *ptr)
+static void prog_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_prog is freed after one RCU or tasks trace grace period */
 	bpf_prog_put(ptr);
 }
 
@@ -1201,8 +1202,9 @@ static void *perf_event_fd_array_get_ptr(struct bpf_map *map,
 	return ee;
 }
 
-static void perf_event_fd_array_put_ptr(void *ptr)
+static void perf_event_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_perf_event is freed after one RCU grace period */
 	bpf_event_entry_free_rcu(ptr);
 }
 
@@ -1256,7 +1258,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
 	return cgroup_get_from_fd(fd);
 }
 
-static void cgroup_fd_array_put_ptr(void *ptr)
+static void cgroup_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	/* cgroup_put free cgrp after a rcu grace period */
 	cgroup_put(ptr);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index fd8d4b0addfc..5b9146fa825f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -897,7 +897,7 @@ static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
 
 	if (map->ops->map_fd_put_ptr) {
 		ptr = fd_htab_map_get_ptr(map, l);
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, true);
 	}
 }
 
@@ -2484,7 +2484,7 @@ static void fd_htab_map_free(struct bpf_map *map)
 		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
 			void *ptr = fd_htab_map_get_ptr(map, l);
 
-			map->ops->map_fd_put_ptr(ptr);
+			map->ops->map_fd_put_ptr(map, ptr, false);
 		}
 	}
 
@@ -2525,7 +2525,7 @@ int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 
 	ret = htab_map_update_elem(map, key, &ptr, map_flags);
 	if (ret)
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, false);
 
 	return ret;
 }
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index cd5eafaba97e..2dfeb5835e16 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -127,7 +127,7 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 	return inner_map;
 }
 
-void bpf_map_fd_put_ptr(void *ptr)
+void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	/* ptr->ops->map_free() has to go through one
 	 * rcu grace period by itself.
diff --git a/kernel/bpf/map_in_map.h b/kernel/bpf/map_in_map.h
index bcb7534afb3c..7d61602354de 100644
--- a/kernel/bpf/map_in_map.h
+++ b/kernel/bpf/map_in_map.h
@@ -13,7 +13,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd);
 void bpf_map_meta_free(struct bpf_map *map_meta);
 void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
 			 int ufd);
-void bpf_map_fd_put_ptr(void *ptr);
+void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer);
 u32 bpf_map_fd_sys_lookup_elem(void *ptr);
 
 #endif
-- 
2.43.0



