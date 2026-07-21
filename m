Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4040A42DA53;
	Tue, 21 Jul 2026 19:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662606; cv=none; b=qmAa43vlSmk8ob6JBK+1+2qoscuWVzJA183N78hFurXQ/NulZaEluUYr7Li3begJosVV04OvsbzuIVOkjCLujTo+iXUMt8RrY1CeRs2JeAnCm/rUQXd5adH4uQ0nzDIFSprhW9Cqxx2OLhk72tG4keSxK5e5GZD/lOoPCU8dMU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662606; c=relaxed/simple;
	bh=vSshCZNcq0rnwIvfPjCuoBR8WPkElVOAra9hllTxJO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUSLxQ2uGHo3kP6BzzSPpq7y8Z7LtgpM/XwEszmbljgOMoEY4a/JCN7lz9NZRDWMB0sH8UNyvKN6q+UGi3LLxDQZTXW30M11VweB7YDixoU8lU5+tdBu0xr1ODe89so2aSEn+ZCwAs2kGF7sIY9jip4G/VvsX+RSYMhWba8+lbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOpicyy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOpicyy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782771F000E9;
	Tue, 21 Jul 2026 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662605;
	bh=vq/nvgDSC7e/m/GDe6VNP8y0a3LigZ80ko+i/w8JlZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOpicyy1LpnChBsmaxn98cjVJifYZFXyuykohaZLTIg3vdsRTaNtdubzY1skU65wA
	 8RDx5QjBu7hN7WopGlZ9RclVnTVAZh3aYyY01mnXS7fytzzk3tEuTCqyamU4qr4y2+
	 PMay1VLyhL8w+yUu3nYyRv5T/bEWLuWfFd+VZito=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0465/1276] perf stat: Bounds-check CPU index in topology aggregation callbacks
Date: Tue, 21 Jul 2026 17:15:08 +0200
Message-ID: <20260721152456.507277164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 52e69b1c5b606b513d403dd4addc784c27a0c8e2 ]

Six perf_env__get_*_aggr_by_cpu() functions access env->cpu[cpu.cpu]
after only checking cpu.cpu != -1.  env->cpu[] is allocated with
env->nr_cpus_avail entries, so a CPU index from an untrusted perf.data
file that exceeds that count causes an out-of-bounds heap read.

Replace the != -1 guard with >= 0 && < env->nr_cpus_avail in all six
functions.  The >= 0 check also catches -1 and any other negative values
that could bypass the old check.

Affected functions:
  - perf_env__get_socket_aggr_by_cpu()
  - perf_env__get_die_aggr_by_cpu()
  - perf_env__get_cache_aggr_by_cpu()
  - perf_env__get_cluster_aggr_by_cpu()
  - perf_env__get_core_aggr_by_cpu()
  - perf_env__get_cpu_aggr_by_cpu()

Fixes: 68d702f7a120 ("perf stat report: Add support to initialize aggr_map from file")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e476598de80836..4331820b199601 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1561,7 +1561,8 @@ static struct aggr_cpu_id perf_env__get_socket_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1)
+	/* env->cpu[] has env->nr_cpus_avail entries; reject untrusted indices */
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail)
 		id.socket = env->cpu[cpu.cpu].socket_id;
 
 	return id;
@@ -1572,7 +1573,7 @@ static struct aggr_cpu_id perf_env__get_die_aggr_by_cpu(struct perf_cpu cpu, voi
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * die_id is relative to socket, so start
 		 * with the socket ID and then add die to
@@ -1628,7 +1629,7 @@ static struct aggr_cpu_id perf_env__get_cache_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		u32 cache_level = (perf_stat.aggr_level) ?: stat_config.aggr_level;
 
 		id.socket = env->cpu[cpu.cpu].socket_id;
@@ -1645,7 +1646,7 @@ static struct aggr_cpu_id perf_env__get_cluster_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		id.socket = env->cpu[cpu.cpu].socket_id;
 		id.die = env->cpu[cpu.cpu].die_id;
 		id.cluster = env->cpu[cpu.cpu].cluster_id;
@@ -1659,7 +1660,7 @@ static struct aggr_cpu_id perf_env__get_core_aggr_by_cpu(struct perf_cpu cpu, vo
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * core_id is relative to socket, die and cluster, we need a
 		 * global id. So we set socket, die id, cluster id and core id.
@@ -1678,7 +1679,7 @@ static struct aggr_cpu_id perf_env__get_cpu_aggr_by_cpu(struct perf_cpu cpu, voi
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * core_id is relative to socket and die,
 		 * we need a global id. So we set
-- 
2.53.0



