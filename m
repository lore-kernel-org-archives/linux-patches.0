Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B065150278;
	Tue, 23 Jan 2024 00:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970707; cv=none; b=chg9mDv2Eg/csCnL2y9kH2nvuHZrb57yxF5ie/ZSGQC2hClvKCAEdNuS9Pe44jllxGjmk9YDg3dOT1/oiYG/fjFIXPTlaihc07WafhPvSKUS6MXmu235/aEoRhHqNXdjLa02wo/zmVb0/aap+NpKglSmC8iIGPzSb8D9iHU2fu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970707; c=relaxed/simple;
	bh=gFl8a8Zw6dNg4e1/eeyQLjfcQCNj3ikoenuBjhJ5Gq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjSCSbbbDPoM1S/MR33RqP8PTVu4UTPf/4ycW1+j4s1C5yDn3V4SrRjt4+q3AIMK087u98TpTLkVMKw4nU1/KA2fknDJseJjpJ7SUnVvZ+FUpCP8PATNtDfqmb2kdrpnh0saCdEwbd70hFIDXtE4DIz0BE7hg6dc0cCJ+bRDT30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOUsfSG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOUsfSG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BC6C433F1;
	Tue, 23 Jan 2024 00:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970707;
	bh=gFl8a8Zw6dNg4e1/eeyQLjfcQCNj3ikoenuBjhJ5Gq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOUsfSG2a/IBSp5Wnhh0iA8203w6Fm8VhqtTvgMkQ8CcCYTy3o+ATREPmnseSgJGm
	 vOJqWTjFwcLvnyrWyzq0mNoyAaiflQIVC+0M8zzhHzbfXajbfnCO88xBScGmV7rz0E
	 NMSvOTfw3cZx2vVCGFvasm3t4X48UYMV1KaHeYDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/417] bpf: Defer the free of inner map when necessary
Date: Mon, 22 Jan 2024 15:54:24 -0800
Message-ID: <20240122235755.015406171@linuxfoundation.org>
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
index 47420a973e58..c04a61ffac8a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -237,7 +237,11 @@ struct bpf_map {
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
@@ -253,6 +257,7 @@ struct bpf_map {
 	} owner;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
+	bool free_after_mult_rcu_gp;
 	s64 __percpu *elem_count;
 };
 
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 47ecc4818c93..141f3332038c 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -117,10 +117,15 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 
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
index 0c8b7733573e..f019c0821c70 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -628,6 +628,28 @@ static void bpf_map_put_uref(struct bpf_map *map)
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
  * (unrelying map implementation ops->map_free() might sleep)
  */
@@ -637,11 +659,11 @@ static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
 		/* bpf_map_free_id() must be called first */
 		bpf_map_free_id(map, do_idr_lock);
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
 
-- 
2.43.0



