Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C540C46EC94;
	Tue, 21 Jul 2026 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659570; cv=none; b=XVfYkIWP3r5rvTb3UJq3IM9/3NHXAmP7vYC6yOzWg1k5wJr03qwCicwxR6pisP2xwk51YPCcEwxp6tuXLzh8VcfAohuAsezxZWS7SJfskh+mwkAdfJhKluaeJLPaU8ymP+BAAjreH3Ki7EE7j4qKujk7lWF1T6sRiGpnK5r78Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659570; c=relaxed/simple;
	bh=Iunk+/uXTzMJuMS09YgG3Y5YkcAJI220gwIctkfpRFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZjsqpwJdJKUJXT+FSoQeYB/+JWiP7ghk3CvV+LshGr/yh8VPF3rLCoDgUY7dk4lYMDEHkvcqVEIPXX1T4QWUX0XEhKWpqiXnfHFpO4PXwuk5be+FlwmilcxV0ZMStpRhRuw43xt3BuMIW7Udc8oeuQWJxGRgrVNRS/nI4ZstN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0E5+mBEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0E5+mBEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DFC1F000E9;
	Tue, 21 Jul 2026 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659568;
	bh=h3kwD6gqpVUCTpNudEsgYhhW2ni5+TED0+EKG0+64iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0E5+mBEWxtTSYvmFl6u1HXZ4OwLsaFQMYwSSWQm2SCEjo/y8CzlKgSJFQsu0F0KVt
	 GN4Adkks62fPGSryr64q90WdBr8R71/SJXajRnj0fYrrVoIJeb6htxEdKN7tN3Bkuc
	 fqqmdoE3CeongGYNT8Kr0E+s9xbTy4HWgqjWM/nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1568/1611] bpf: Consistently use bpf_rcu_lock_held() everywhere
Date: Tue, 21 Jul 2026 17:28:04 +0200
Message-ID: <20260721152550.732705503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 48a97ffc6c826640907d13b199e29008f4fe2c15 ]

We have many places which open-code what's now is bpf_rcu_lock_held()
macro, so replace all those places with a clean and short macro invocation.
For that, move bpf_rcu_lock_held() macro into include/linux/bpf.h.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20251014201403.4104511-1-andrii@kernel.org
Stable-dep-of: 2f884d371faf ("bpf: Allow LPM map access from sleepable BPF programs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h               |    3 +++
 include/linux/bpf_local_storage.h |    3 ---
 kernel/bpf/hashtab.c              |   21 +++++++--------------
 kernel/bpf/helpers.c              |   12 ++++--------
 4 files changed, 14 insertions(+), 25 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2375,6 +2375,9 @@ bpf_prog_run_array_uprobe(const struct b
 bool bpf_jit_bypass_spec_v1(void);
 bool bpf_jit_bypass_spec_v4(void);
 
+#define bpf_rcu_lock_held() \
+	(rcu_read_lock_held() || rcu_read_lock_trace_held() || rcu_read_lock_bh_held())
+
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
 extern struct mutex bpf_stats_enabled_mutex;
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -18,9 +18,6 @@
 
 #define BPF_LOCAL_STORAGE_CACHE_SIZE	16
 
-#define bpf_rcu_lock_held()                                                    \
-	(rcu_read_lock_held() || rcu_read_lock_trace_held() ||                 \
-	 rcu_read_lock_bh_held())
 struct bpf_local_storage_map_bucket {
 	struct hlist_head list;
 	raw_spinlock_t lock;
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -669,8 +669,7 @@ static void *__htab_map_lookup_elem(stru
 	struct htab_elem *l;
 	u32 hash, key_size;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1104,8 +1103,7 @@ static long htab_map_update_elem(struct
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1212,8 +1210,7 @@ static long htab_lru_map_update_elem(str
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1281,8 +1278,7 @@ static long htab_map_update_elem_in_plac
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1344,8 +1340,7 @@ static long __htab_lru_percpu_map_update
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1422,8 +1417,7 @@ static long htab_map_delete_elem(struct
 	u32 hash, key_size;
 	int ret;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
@@ -1458,8 +1452,7 @@ static long htab_lru_map_delete_elem(str
 	u32 hash, key_size;
 	int ret;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 
 	key_size = map->key_size;
 
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -42,8 +42,7 @@
  */
 BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 	return (unsigned long) map->ops->map_lookup_elem(map, key);
 }
 
@@ -59,8 +58,7 @@ const struct bpf_func_proto bpf_map_look
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 	return map->ops->map_update_elem(map, key, value, flags);
 }
 
@@ -77,8 +75,7 @@ const struct bpf_func_proto bpf_map_upda
 
 BPF_CALL_2(bpf_map_delete_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 	return map->ops->map_delete_elem(map, key);
 }
 
@@ -134,8 +131,7 @@ const struct bpf_func_proto bpf_map_peek
 
 BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
-		     !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!bpf_rcu_lock_held());
 	return (unsigned long) map->ops->map_lookup_percpu_elem(map, key, cpu);
 }
 


