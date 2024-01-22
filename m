Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706014D424;
	Tue, 23 Jan 2024 00:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969279; cv=none; b=uOpRLZy2aBiAF9tMkZInARXhUrO5yyVercmT0KUXQ5COLMpWtc6SVBEPyQdeR4r8vcDGSiRZpiQhJLDcbrShOVvg6nmIRZmIuanq5rREGrGLNKXPHMGpJU1hreeeVwnNRMEmqchnYHcvlVfVzqnepwJ42hQbRXmFYS+szkYq/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969279; c=relaxed/simple;
	bh=OH6bPyXq4pX1NqXIJaj2y+S4+LZOkLZI7d9jvFueiyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEDVNoNDexwV1yxzngI+0HpbtBKaPbHGNHXlykcBsS4U5ElUreVClQ+FePC4JZ5xvWZ4d4t+VX7whHHJ7p8x80h/BdagWqr8nWhdYEjYiZ0tu7NwMwn/LmwEXJL/Q1aYp2DHQrn6E8TiYugjs8QrlW0vWdoq5Ku33F4gJ10rb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7LUCWS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7LUCWS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C88C43394;
	Tue, 23 Jan 2024 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969278;
	bh=OH6bPyXq4pX1NqXIJaj2y+S4+LZOkLZI7d9jvFueiyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7LUCWS+WVMzm8U7TceBcLTWOLxZozEl+ASNPbd0cAOZITxpqicmJQhLW9u3gMNqd
	 dTJT5dIQXPTYR00j6leTlKkUp23/K/2UtdxfFTPKAoYwVqwtnFc/qGpkMScWlh/RDD
	 m6YEhvb6g/RygBKa6aOgJrRZ+NxenXKcLGX6CRK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 132/641] bpf: Defer the free of inner map when necessary
Date: Mon, 22 Jan 2024 15:50:36 -0800
Message-ID: <20240122235822.181683579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 876673364161da50eed6b472d746ef88242b2368 ]

When updating or deleting an inner map in map array or map htab, the map
may still be accessed by non-sleepable program or sleepable program.
However bpf_map_fd_put_ptr() decreases the ref-counter of the inner map
directly through bpf_map_put(), if the ref-counter is the last one
(which is true for most cases), the inner map will be freed by
ops->map_free() in a kworker. But for now, most .map_free() callbacks
don't use synchronize_rcu() or its variants to wait for the elapse of a
RCU grace period, so after the invocation of ops->map_free completes,
the bpf program which is accessing the inner map may incur
use-after-free problem.

Fix the free of inner map by invoking bpf_map_free_deferred() after both
one RCU grace period and one tasks trace RCU grace period if the inner
map has been removed from the outer map before. The deferment is
accomplished by using call_rcu() or call_rcu_tasks_trace() when
releasing the last ref-counter of bpf map. The newly-added rcu_head
field in bpf_map shares the same storage space with work field to
reduce the size of bpf_map.

Fixes: bba1dc0b55ac ("bpf: Remove redundant synchronize_rcu.")
Fixes: 638e4b825d52 ("bpf: Allows per-cpu maps and map-in-map in sleepable programs")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231204140425.1480317-5-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  7 ++++++-
 kernel/bpf/map_in_map.c | 11 ++++++++---
 kernel/bpf/syscall.c    | 32 +++++++++++++++++++++++++++-----
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 741af9e5cb9d..7a7859a5cce4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -276,7 +276,11 @@ struct bpf_map {
 	 */
 	atomic64_t refcnt ____cacheline_aligned;
 	atomic64_t usercnt;
-	struct work_struct work;
+	/* rcu is used before freeing and work is only used during freeing */
+	union {
+		struct work_struct work;
+		struct rcu_head rcu;
+	};
 	struct mutex freeze_mutex;
 	atomic64_t writecnt;
 	/* 'Ownership' of program-containing map is claimed by the first program
@@ -292,6 +296,7 @@ struct bpf_map {
 	} owner;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
+	bool free_after_mult_rcu_gp;
 	s64 __percpu *elem_count;
 };
 
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 2dfeb5835e16..3248ff5d8161 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -129,10 +129,15 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 
 void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
-	/* ptr->ops->map_free() has to go through one
-	 * rcu grace period by itself.
+	struct bpf_map *inner_map = ptr;
+
+	/* The inner map may still be used by both non-sleepable and sleepable
+	 * bpf program, so free it after one RCU grace period and one tasks
+	 * trace RCU grace period.
 	 */
-	bpf_map_put(ptr);
+	if (need_defer)
+		WRITE_ONCE(inner_map->free_after_mult_rcu_gp, true);
+	bpf_map_put(inner_map);
 }
 
 u32 bpf_map_fd_sys_lookup_elem(void *ptr)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0ed286b8a0f0..c6579067eeea 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -719,6 +719,28 @@ static void bpf_map_put_uref(struct bpf_map *map)
 	}
 }
 
+static void bpf_map_free_in_work(struct bpf_map *map)
+{
+	INIT_WORK(&map->work, bpf_map_free_deferred);
+	/* Avoid spawning kworkers, since they all might contend
+	 * for the same mutex like slab_mutex.
+	 */
+	queue_work(system_unbound_wq, &map->work);
+}
+
+static void bpf_map_free_rcu_gp(struct rcu_head *rcu)
+{
+	bpf_map_free_in_work(container_of(rcu, struct bpf_map, rcu));
+}
+
+static void bpf_map_free_mult_rcu_gp(struct rcu_head *rcu)
+{
+	if (rcu_trace_implies_rcu_gp())
+		bpf_map_free_rcu_gp(rcu);
+	else
+		call_rcu(rcu, bpf_map_free_rcu_gp);
+}
+
 /* decrement map refcnt and schedule it for freeing via workqueue
  * (underlying map implementation ops->map_free() might sleep)
  */
@@ -728,11 +750,11 @@ void bpf_map_put(struct bpf_map *map)
 		/* bpf_map_free_id() must be called first */
 		bpf_map_free_id(map);
 		btf_put(map->btf);
-		INIT_WORK(&map->work, bpf_map_free_deferred);
-		/* Avoid spawning kworkers, since they all might contend
-		 * for the same mutex like slab_mutex.
-		 */
-		queue_work(system_unbound_wq, &map->work);
+
+		if (READ_ONCE(map->free_after_mult_rcu_gp))
+			call_rcu_tasks_trace(&map->rcu, bpf_map_free_mult_rcu_gp);
+		else
+			bpf_map_free_in_work(map);
 	}
 }
 EXPORT_SYMBOL_GPL(bpf_map_put);
-- 
2.43.0



