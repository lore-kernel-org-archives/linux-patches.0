Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F02B9B7;
	Tue, 23 Jan 2024 00:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970701; cv=none; b=rvTH8aeESXeUMMEPnS6WRNKTkj4B9bRIO8lCOYY2cxgV8+h5yZsT3yhYNIymeUZQ5fMRLQeHbgJ+yQB2N7ne8YXXUsgyu1ttrytvsER8Vb2pow3dg5yOvHRcco4Azs7k3G1WP4HVU8zsBLhv9hhN6j8HuSCVMQaoMio/u8wRj40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970701; c=relaxed/simple;
	bh=CGVHA4Ge5vYjmcXBZKXYADpU2mW7R8zJAGQ29FV+lV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTHXkx7MKywd4vqDdiDs8HX38w3DBvrNM0vvUWTTZ7H+2FoOyAhaheLQzQ01OMhLp2Pg4y1vpiayoMc5ezyHP2MNLNoVjN8xRtZnbL1lFB2WiqoJkk9ADS8ehqoX5LU/p0/9qURTNQwOjyGjFeziYzTKR6yFOY6r2NhUUzBbmxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVk48pLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVk48pLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67999C433C7;
	Tue, 23 Jan 2024 00:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970701;
	bh=CGVHA4Ge5vYjmcXBZKXYADpU2mW7R8zJAGQ29FV+lV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVk48pLCAHpBA3kY1D/MvNYdc8l11YxWOYB3DGpbksSW9JmnQtNcmQ8EiPFFraXhW
	 ArPITe2e/mOj1+jz3+FEGq6KrUhghu7+5W2z5v94lUFU0wL/PDz8NX0oCtMjXugt++
	 WSzdmjosqZRq+dNMuDeh4W9wKp6Ld1ugJcDhUnvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/417] bpf: Add map and need_defer parameters to .map_fd_put_ptr()
Date: Mon, 22 Jan 2024 15:54:23 -0800
Message-ID: <20240122235754.980572922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 21b192ce018a..47420a973e58 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -102,7 +102,11 @@ struct bpf_map_ops {
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
index 00f23febb9a7..c04e69f34e4d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -852,7 +852,7 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 	}
 
 	if (old_ptr)
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 	return 0;
 }
 
@@ -875,7 +875,7 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
 	}
 
 	if (old_ptr) {
-		map->ops->map_fd_put_ptr(old_ptr);
+		map->ops->map_fd_put_ptr(map, old_ptr, true);
 		return 0;
 	} else {
 		return -ENOENT;
@@ -898,8 +898,9 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	return prog;
 }
 
-static void prog_fd_array_put_ptr(void *ptr)
+static void prog_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_prog is freed after one RCU or tasks trace grace period */
 	bpf_prog_put(ptr);
 }
 
@@ -1185,8 +1186,9 @@ static void *perf_event_fd_array_get_ptr(struct bpf_map *map,
 	return ee;
 }
 
-static void perf_event_fd_array_put_ptr(void *ptr)
+static void perf_event_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	/* bpf_perf_event is freed after one RCU grace period */
 	bpf_event_entry_free_rcu(ptr);
 }
 
@@ -1239,7 +1241,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
 	return cgroup_get_from_fd(fd);
 }
 
-static void cgroup_fd_array_put_ptr(void *ptr)
+static void cgroup_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	/* cgroup_put free cgrp after a rcu grace period */
 	cgroup_put(ptr);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index ce0051eee746..88c71de0a0a9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -880,7 +880,7 @@ static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
 
 	if (map->ops->map_fd_put_ptr) {
 		ptr = fd_htab_map_get_ptr(map, l);
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, true);
 	}
 }
 
@@ -2424,7 +2424,7 @@ static void fd_htab_map_free(struct bpf_map *map)
 		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
 			void *ptr = fd_htab_map_get_ptr(map, l);
 
-			map->ops->map_fd_put_ptr(ptr);
+			map->ops->map_fd_put_ptr(map, ptr, false);
 		}
 	}
 
@@ -2465,7 +2465,7 @@ int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 
 	ret = htab_map_update_elem(map, key, &ptr, map_flags);
 	if (ret)
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_ptr(map, ptr, false);
 
 	return ret;
 }
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 8e87f69aae60..47ecc4818c93 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -115,7 +115,7 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
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



