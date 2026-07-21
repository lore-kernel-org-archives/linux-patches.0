Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D947126D;
	Tue, 21 Jul 2026 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657182; cv=none; b=X9NveJ/K+nzfDUup02jKLUgwZU6rsWoSBCcDLVZBuQgnTvFCSDFKjfikekYJNFyxbKJ6Dz0yF+rPlxZ9TojZYIO1QtKKVFA6KRBX8air6L/OjkFqE+/QQPSs72wAO+IXktoQrYjdOwgGRwsZLBU7Y11xW7m0pd0WXvkVTB+9dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657182; c=relaxed/simple;
	bh=Qn7KKK0woSF0gOKXy6v45qiusbgAXjEuTljNwIgYkJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADL7xeA7uTRZ1ccjE998dZbdhK3S0LPmQKDj+lo+j8QBU2yEhNOZ4Wi6Uy72kB+Pc4kLP9QZKSd1VAdn4GGXyREH05TOirZm/sok85tuFgkGfNDwRNU1aO5Bi62NV0NjEuqZ3egiu5fIbetH6EYnMYO7XQxw2Qu/yFbAuvNR7N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sVU69Y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sVU69Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B941F000E9;
	Tue, 21 Jul 2026 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657181;
	bh=IqDjuYXmaC1bbxzw1YIp/Fbxz1RerVFKC9XBtbyXC+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2sVU69Y6mmtS2XCDL/bf8PJcwmVWR/STkpuExVwiyLiq6v6PT3Tyw9A1q0PVMnVRy
	 HLyb4tkJM7z4KKEDpxGog3PqKvAweREcwfM6+08zoEzM7U5L1xRoX6VRgfNs4kN5ia
	 ASTeCnKp8N8vY9V+JeLRjUOPxne5RBrU5X2tb8NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0651/1611] perf stat: Introduce perf_env__get_cpu_topology() to guard NULL env->cpu
Date: Tue, 21 Jul 2026 17:12:47 +0200
Message-ID: <20260721152530.031860534@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit afa4363a91a19dff65dceb7fbce7bba689bbc854 ]

process_cpu_topology() in header.c frees env->cpu on old-format
perf.data files that predate topology information, but leaves
nr_cpus_avail set.  The six perf_env__get_*_aggr_by_cpu() functions
in builtin-stat.c pass the bounds check but dereference a NULL
env->cpu pointer, crashing on old recordings.

Introduce perf_env__get_cpu_topology() as a safe accessor that
validates env->cpu, cpu.cpu >= 0, and cpu.cpu < nr_cpus_avail in
one place, returning a struct cpu_topology_map pointer or NULL.
Convert all six topology aggregation callbacks to use it.

Fixes: 88031a0de7d68d13 ("perf stat: Switch to cpu version of cpu_map__get()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 51 +++++++++++++++++++++------------------
 tools/perf/util/env.h     | 14 +++++++++++
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ae255f6c31e32c..64341ae6c464d3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1564,10 +1564,10 @@ static struct aggr_cpu_id perf_env__get_socket_aggr_by_cpu(struct perf_cpu cpu,
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	/* env->cpu[] has env->nr_cpus_avail entries; reject untrusted indices */
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail)
-		id.socket = env->cpu[cpu.cpu].socket_id;
+	if (topo)
+		id.socket = topo->socket_id;
 
 	return id;
 }
@@ -1576,15 +1576,16 @@ static struct aggr_cpu_id perf_env__get_die_aggr_by_cpu(struct perf_cpu cpu, voi
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
+	if (topo) {
 		/*
 		 * die_id is relative to socket, so start
 		 * with the socket ID and then add die to
 		 * make a unique ID.
 		 */
-		id.socket = env->cpu[cpu.cpu].socket_id;
-		id.die = env->cpu[cpu.cpu].die_id;
+		id.socket = topo->socket_id;
+		id.die = topo->die_id;
 	}
 
 	return id;
@@ -1632,12 +1633,13 @@ static struct aggr_cpu_id perf_env__get_cache_aggr_by_cpu(struct perf_cpu cpu,
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
+	if (topo) {
 		u32 cache_level = (perf_stat.aggr_level) ?: stat_config.aggr_level;
 
-		id.socket = env->cpu[cpu.cpu].socket_id;
-		id.die = env->cpu[cpu.cpu].die_id;
+		id.socket = topo->socket_id;
+		id.die = topo->die_id;
 		perf_env__get_cache_id_for_cpu(cpu, env, cache_level, &id);
 	}
 
@@ -1649,11 +1651,12 @@ static struct aggr_cpu_id perf_env__get_cluster_aggr_by_cpu(struct perf_cpu cpu,
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
-		id.socket = env->cpu[cpu.cpu].socket_id;
-		id.die = env->cpu[cpu.cpu].die_id;
-		id.cluster = env->cpu[cpu.cpu].cluster_id;
+	if (topo) {
+		id.socket = topo->socket_id;
+		id.die = topo->die_id;
+		id.cluster = topo->cluster_id;
 	}
 
 	return id;
@@ -1663,16 +1666,17 @@ static struct aggr_cpu_id perf_env__get_core_aggr_by_cpu(struct perf_cpu cpu, vo
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
+	if (topo) {
 		/*
 		 * core_id is relative to socket, die and cluster, we need a
 		 * global id. So we set socket, die id, cluster id and core id.
 		 */
-		id.socket = env->cpu[cpu.cpu].socket_id;
-		id.die = env->cpu[cpu.cpu].die_id;
-		id.cluster = env->cpu[cpu.cpu].cluster_id;
-		id.core = env->cpu[cpu.cpu].core_id;
+		id.socket = topo->socket_id;
+		id.die = topo->die_id;
+		id.cluster = topo->cluster_id;
+		id.core = topo->core_id;
 	}
 
 	return id;
@@ -1682,18 +1686,19 @@ static struct aggr_cpu_id perf_env__get_cpu_aggr_by_cpu(struct perf_cpu cpu, voi
 {
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
+	struct cpu_topology_map *topo = perf_env__get_cpu_topology(env, cpu);
 
-	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
+	if (topo) {
 		/*
 		 * core_id is relative to socket and die,
 		 * we need a global id. So we set
 		 * socket, die id and core id
 		 */
-		id.socket = env->cpu[cpu.cpu].socket_id;
-		id.die = env->cpu[cpu.cpu].die_id;
-		id.core = env->cpu[cpu.cpu].core_id;
-		id.cpu = cpu;
+		id.socket = topo->socket_id;
+		id.die = topo->die_id;
+		id.core = topo->core_id;
 	}
+	id.cpu = cpu;
 
 	return id;
 }
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 9977b85523a8c3..6ca0e223ea4050 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -164,6 +164,20 @@ const char *perf_env__pmu_mappings(struct perf_env *env);
 
 int perf_env__read_cpu_topology_map(struct perf_env *env);
 
+/*
+ * Safe accessor for env->cpu[] topology array.  env->cpu can be NULL when
+ * reading old-format perf.data that predates topology information —
+ * process_cpu_topology() in header.c frees it while nr_cpus_avail remains
+ * set, so callers must not index env->cpu[] without this check.
+ */
+static inline struct cpu_topology_map *
+perf_env__get_cpu_topology(struct perf_env *env, struct perf_cpu cpu)
+{
+	if (env->cpu && cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail)
+		return &env->cpu[cpu.cpu];
+	return NULL;
+}
+
 void cpu_cache_level__free(struct cpu_cache_level *cache);
 
 const char *perf_env__arch(struct perf_env *env);
-- 
2.53.0



