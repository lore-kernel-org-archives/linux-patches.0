Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5896E4C74;
	Wed, 19 Jun 2024 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802016; cv=none; b=n2sIjvLNT6/oON3bCO5ed+9XPmC5XoLTRsSZolE0L5gxwna9mHJvfj/lnHnWjzUbOCKjCn6KmsWkQVY3MZfq7/T1KFCdcx86p9fp4AK/CNaBc2L0F3fq91KlvZln51qgES0A4Xwq0G8QqPJ+iSc38GRoXP/2eD/WdaRXTEdR7Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802016; c=relaxed/simple;
	bh=DW+Ri7dzU08jx7PBAhqR2bzvWe8YZnFIV+ElY8MyH4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUSxr47SCZUu755x7oKP/+YlVH6VBi+sDIagm/8u9ih/GZU1n6iF/K4yQcsATLGasEko6s62zuJE6W/dYDdw2qO7y8CXe2PlLj/Q3DPCBtxD06+DXU3PISC5gENip/ZetAsJ3oEnM36IHwt+t1MLODYQg2lWS3l1SWRKN3b/H6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUYtkjdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUYtkjdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB87EC2BBFC;
	Wed, 19 Jun 2024 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802016;
	bh=DW+Ri7dzU08jx7PBAhqR2bzvWe8YZnFIV+ElY8MyH4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUYtkjdXFJRAd9ZxwD8Ebng2Bb3QQOq1oDCIwIwpIQzgscEM4SWXPrV4xqT67gH91
	 +YDjz/g7wjLSi7PZs036md1bRPgxPnxxXiydp0tEI3M0ti9+Nwo+VcHi44VJFX4w3v
	 LDnQLGQfUV1VCFkdzQhDXHbXRsQhP6HSoV9WtKjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/267] bpf: Optimize the free of inner map
Date: Wed, 19 Jun 2024 14:52:53 +0200
Message-ID: <20240619125607.209718814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

[ Upstream commit af66bfd3c8538ed21cf72af18426fc4a408665cf ]

When removing the inner map from the outer map, the inner map will be
freed after one RCU grace period and one RCU tasks trace grace
period, so it is certain that the bpf program, which may access the
inner map, has exited before the inner map is freed.

However there is no need to wait for one RCU tasks trace grace period if
the outer map is only accessed by non-sleepable program. So adding
sleepable_refcnt in bpf_map and increasing sleepable_refcnt when adding
the outer map into env->used_maps for sleepable program. Although the
max number of bpf program is INT_MAX - 1, the number of bpf programs
which are being loaded may be greater than INT_MAX, so using atomic64_t
instead of atomic_t for sleepable_refcnt. When removing the inner map
from the outer map, using sleepable_refcnt to decide whether or not a
RCU tasks trace grace period is needed before freeing the inner map.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231204140425.1480317-6-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 2884dc7d08d9 ("bpf: Fix a potential use-after-free in bpf_link_free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  2 ++
 kernel/bpf/core.c       |  4 ++++
 kernel/bpf/map_in_map.c | 14 +++++++++-----
 kernel/bpf/syscall.c    |  8 ++++++++
 kernel/bpf/verifier.c   |  4 +++-
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2ebb5d4d43dc6..e4cd28c38b825 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -296,6 +296,8 @@ struct bpf_map {
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	bool free_after_mult_rcu_gp;
+	bool free_after_rcu_gp;
+	atomic64_t sleepable_refcnt;
 	s64 __percpu *elem_count;
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 1333273a71ded..05445a4d55181 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2673,12 +2673,16 @@ void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 			  struct bpf_map **used_maps, u32 len)
 {
 	struct bpf_map *map;
+	bool sleepable;
 	u32 i;
 
+	sleepable = aux->sleepable;
 	for (i = 0; i < len; i++) {
 		map = used_maps[i];
 		if (map->ops->map_poke_untrack)
 			map->ops->map_poke_untrack(map, aux);
+		if (sleepable)
+			atomic64_dec(&map->sleepable_refcnt);
 		bpf_map_put(map);
 	}
 }
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 3248ff5d81617..8ef269e66ba50 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -131,12 +131,16 @@ void bpf_map_fd_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
 	struct bpf_map *inner_map = ptr;
 
-	/* The inner map may still be used by both non-sleepable and sleepable
-	 * bpf program, so free it after one RCU grace period and one tasks
-	 * trace RCU grace period.
+	/* Defer the freeing of inner map according to the sleepable attribute
+	 * of bpf program which owns the outer map, so unnecessary waiting for
+	 * RCU tasks trace grace period can be avoided.
 	 */
-	if (need_defer)
-		WRITE_ONCE(inner_map->free_after_mult_rcu_gp, true);
+	if (need_defer) {
+		if (atomic64_read(&map->sleepable_refcnt))
+			WRITE_ONCE(inner_map->free_after_mult_rcu_gp, true);
+		else
+			WRITE_ONCE(inner_map->free_after_rcu_gp, true);
+	}
 	bpf_map_put(inner_map);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e886157a9efbb..e9a68c6043ce5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -753,8 +753,11 @@ void bpf_map_put(struct bpf_map *map)
 		/* bpf_map_free_id() must be called first */
 		bpf_map_free_id(map);
 
+		WARN_ON_ONCE(atomic64_read(&map->sleepable_refcnt));
 		if (READ_ONCE(map->free_after_mult_rcu_gp))
 			call_rcu_tasks_trace(&map->rcu, bpf_map_free_mult_rcu_gp);
+		else if (READ_ONCE(map->free_after_rcu_gp))
+			call_rcu(&map->rcu, bpf_map_free_rcu_gp);
 		else
 			bpf_map_free_in_work(map);
 	}
@@ -5358,6 +5361,11 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 		goto out_unlock;
 	}
 
+	/* The bpf program will not access the bpf map, but for the sake of
+	 * simplicity, increase sleepable_refcnt for sleepable program as well.
+	 */
+	if (prog->aux->sleepable)
+		atomic64_inc(&map->sleepable_refcnt);
 	memcpy(used_maps_new, used_maps_old,
 	       sizeof(used_maps_old[0]) * prog->aux->used_map_cnt);
 	used_maps_new[prog->aux->used_map_cnt] = map;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 24d7a32f1710e..ec0464c075bb4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17732,10 +17732,12 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 				return -E2BIG;
 			}
 
+			if (env->prog->aux->sleepable)
+				atomic64_inc(&map->sleepable_refcnt);
 			/* hold the map. If the program is rejected by verifier,
 			 * the map will be released by release_maps() or it
 			 * will be used by the valid program until it's unloaded
-			 * and all maps are released in free_used_maps()
+			 * and all maps are released in bpf_free_used_maps()
 			 */
 			bpf_map_inc(map);
 
-- 
2.43.0



