Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A90449B2A;
	Tue, 21 Jul 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657124; cv=none; b=BEuPkGOSm6EkDWalpJKGn6qUOe37/HsI33LLNS0McppbQmmTvroGfmX7VcJ/nNO3vT7+yMTB+D/dek/gEo1rls+z8ZJIy0EOCslshvhs7VtWPfJ8fYfPA4iSlGqZJ+eOFqeO8Xsc2QOPmWO0gKmMNin9oowdiWawB6qVCoA1bsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657124; c=relaxed/simple;
	bh=pkDB4/I3TcEU9/Ed/+DLSWWWOcfE7afAdUf6OHX6YWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEEdGc0gOj1iwyzoKN9QQXph8TD/hiIWE/78rmVFOLYruiwyKNQadZpLWuVb7zPxG/KT8QmlIq8KGQkkeH/FAUVwcqIZj6fPtCKMDDly8u49ww10UygoUZxpzWCir+OaJjhC6pU6C9Yuu4Y9Pt5TxOoAoUpNWUoADaY4ZdDJvlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQJNAPLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQJNAPLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C930C1F000E9;
	Tue, 21 Jul 2026 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657123;
	bh=lFmThuOKEQbB0ljgOxrXV9axdKmhGL98fhuyNM7a7Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQJNAPLWIKIZvg0qs4dBQGvrl7n4Rskb/BU5BnVNnsTNtkjB0FLrvuIdDpBbxR7Bj
	 cnalYmRykEcJ8/RURXaOHeefWAU8eGZVnFtCcfWZxgehM3Rn0Xh0CsbuRln0dN9jWJ
	 HVSUeudFvORZKt1ZNY4LLkav7Qt7QebCvm4MJvmU=
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
Subject: [PATCH 6.18 0644/1611] perf stat: Bounds-check CPU index in topology aggregation callbacks
Date: Tue, 21 Jul 2026 17:12:40 +0200
Message-ID: <20260721152529.877182100@linuxfoundation.org>
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
index 9eb0876633c05e..ae255f6c31e32c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1565,7 +1565,8 @@ static struct aggr_cpu_id perf_env__get_socket_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1)
+	/* env->cpu[] has env->nr_cpus_avail entries; reject untrusted indices */
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail)
 		id.socket = env->cpu[cpu.cpu].socket_id;
 
 	return id;
@@ -1576,7 +1577,7 @@ static struct aggr_cpu_id perf_env__get_die_aggr_by_cpu(struct perf_cpu cpu, voi
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * die_id is relative to socket, so start
 		 * with the socket ID and then add die to
@@ -1632,7 +1633,7 @@ static struct aggr_cpu_id perf_env__get_cache_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		u32 cache_level = (perf_stat.aggr_level) ?: stat_config.aggr_level;
 
 		id.socket = env->cpu[cpu.cpu].socket_id;
@@ -1649,7 +1650,7 @@ static struct aggr_cpu_id perf_env__get_cluster_aggr_by_cpu(struct perf_cpu cpu,
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		id.socket = env->cpu[cpu.cpu].socket_id;
 		id.die = env->cpu[cpu.cpu].die_id;
 		id.cluster = env->cpu[cpu.cpu].cluster_id;
@@ -1663,7 +1664,7 @@ static struct aggr_cpu_id perf_env__get_core_aggr_by_cpu(struct perf_cpu cpu, vo
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * core_id is relative to socket, die and cluster, we need a
 		 * global id. So we set socket, die id, cluster id and core id.
@@ -1682,7 +1683,7 @@ static struct aggr_cpu_id perf_env__get_cpu_aggr_by_cpu(struct perf_cpu cpu, voi
 	struct perf_env *env = data;
 	struct aggr_cpu_id id = aggr_cpu_id__empty();
 
-	if (cpu.cpu != -1) {
+	if (cpu.cpu >= 0 && cpu.cpu < env->nr_cpus_avail) {
 		/*
 		 * core_id is relative to socket and die,
 		 * we need a global id. So we set
-- 
2.53.0



