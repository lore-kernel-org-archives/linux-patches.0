Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655F25DAEC;
	Tue, 11 Mar 2025 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706450; cv=none; b=gKs2To9++pYSMbOgELffzd8zhYPH2IuVjh2sGifz4exyCUcTOHlQTaVT8ujmJvm6Vuj0YnbUBD4X6twgIM/r0sR7N2dCJJkK6nOJchLvsjVZtoXtQtKa4R00LrE0btHE1SWfhe5yt9pkCY4tknU2qQAj7QvjsBxRxsl2VwLls74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706450; c=relaxed/simple;
	bh=NXm9UQmHy7AFsDL972HoMltseu/WyO6UwWS1D6CXaeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO8NIXTeQ2Z/EDcMEzUDOb2x8TiLZVIB8JgsSC+dXJDHnS2hckjPFRZ1pMlUlkCeNOJH5AHYJFG9CABelg9KgttheBNcfVz5JHEYXbzUSgfdps2PdJEC0ZzssaKSw0ocpPuXzDRnjbsDSXp9f6ZzPHPjNZuSuWKXXalA/A4Gj8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHVUGoPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHVUGoPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA83C4CEE9;
	Tue, 11 Mar 2025 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706450;
	bh=NXm9UQmHy7AFsDL972HoMltseu/WyO6UwWS1D6CXaeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHVUGoPRX1WdyFDJj2f7vojHMKC2adP6gyCrQs6voBlDrcntYZoccUnUatQR1cAw8
	 E7Yp1j6/bZXqpTEOTvVdRA4lQbhQ6nh0ug2zrLZncZBlX+McFj0eY3h112c+UtG/Fj
	 GyEUVxADog6vocuZit6AsNynb4a6Rf/BuaEG22JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/462] perf env: Conditionally compile BPF support code on having HAVE_LIBBPF_SUPPORT
Date: Tue, 11 Mar 2025 15:55:19 +0100
Message-ID: <20250311145800.448154869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ef0580ecd8b0306acf09b7a7508d72cafc67896d ]

If libbpf isn't selected, no need for a bunch of related code, that were
not even being used, as code using these perf_env methods was also
enclosed in HAVE_LIBBPF_SUPPORT.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03edb7020bb9 ("perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c    | 14 ++++++++++----
 tools/perf/util/env.c    | 15 ++++++++++++---
 tools/perf/util/env.h    |  4 ++--
 tools/perf/util/header.c | 21 ++++++++-------------
 4 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 5e9902fa1dc8a..48b5d6ec27b6e 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -11,8 +11,10 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <stdlib.h>
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/libbpf.h>
 #include "bpf-event.h"
+#endif
 #include "compress.h"
 #include "env.h"
 #include "namespaces.h"
@@ -728,6 +730,7 @@ bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by)
 	return false;
 }
 
+#ifdef HAVE_LIBBPF_SUPPORT
 static ssize_t bpf_read(struct dso *dso, u64 offset, char *data)
 {
 	struct bpf_prog_info_node *node;
@@ -765,6 +768,7 @@ static int bpf_size(struct dso *dso)
 	dso->data.file_size = node->info_linear->info.jited_prog_len;
 	return 0;
 }
+#endif // HAVE_LIBBPF_SUPPORT
 
 static void
 dso_cache__free(struct dso *dso)
@@ -894,10 +898,12 @@ static struct dso_cache *dso_cache__populate(struct dso *dso,
 		*ret = -ENOMEM;
 		return NULL;
 	}
-
+#ifdef HAVE_LIBBPF_SUPPORT
 	if (dso->binary_type == DSO_BINARY_TYPE__BPF_PROG_INFO)
 		*ret = bpf_read(dso, cache_offset, cache->data);
-	else if (dso->binary_type == DSO_BINARY_TYPE__OOL)
+	else
+#endif
+	if (dso->binary_type == DSO_BINARY_TYPE__OOL)
 		*ret = DSO__DATA_CACHE_SIZE;
 	else
 		*ret = file_read(dso, machine, cache_offset, cache->data);
@@ -1018,10 +1024,10 @@ int dso__data_file_size(struct dso *dso, struct machine *machine)
 
 	if (dso->data.status == DSO_DATA_STATUS_ERROR)
 		return -1;
-
+#ifdef HAVE_LIBBPF_SUPPORT
 	if (dso->binary_type == DSO_BINARY_TYPE__BPF_PROG_INFO)
 		return bpf_size(dso);
-
+#endif
 	return file_size(dso, machine);
 }
 
diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index abb43643c7857..08d641c4e4580 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -5,16 +5,18 @@
 #include "util/header.h"
 #include <linux/ctype.h>
 #include <linux/zalloc.h>
-#include "bpf-event.h"
 #include "cgroup.h"
 #include <errno.h>
 #include <sys/utsname.h>
-#include <bpf/libbpf.h>
 #include <stdlib.h>
 #include <string.h>
 
 struct perf_env perf_env;
 
+#ifdef HAVE_LIBBPF_SUPPORT
+#include "bpf-event.h"
+#include <bpf/libbpf.h>
+
 void perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node)
 {
@@ -182,6 +184,11 @@ static void perf_env__purge_bpf(struct perf_env *env)
 
 	up_write(&env->bpf_progs.lock);
 }
+#else // HAVE_LIBBPF_SUPPORT
+static void perf_env__purge_bpf(struct perf_env *env __maybe_unused)
+{
+}
+#endif // HAVE_LIBBPF_SUPPORT
 
 void perf_env__exit(struct perf_env *env)
 {
@@ -218,11 +225,13 @@ void perf_env__exit(struct perf_env *env)
 	zfree(&env->memory_nodes);
 }
 
-void perf_env__init(struct perf_env *env)
+void perf_env__init(struct perf_env *env __maybe_unused)
 {
+#ifdef HAVE_LIBBPF_SUPPORT
 	env->bpf_progs.infos = RB_ROOT;
 	env->bpf_progs.btfs = RB_ROOT;
 	init_rwsem(&env->bpf_progs.lock);
+#endif
 }
 
 int perf_env__set_cmdline(struct perf_env *env, int argc, const char *argv[])
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 64b63e989472e..b5ddf2ab0e8c6 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -77,7 +77,7 @@ struct perf_env {
 	struct numa_node	*numa_nodes;
 	struct memory_node	*memory_nodes;
 	unsigned long long	 memory_bsize;
-
+#ifdef HAVE_LIBBPF_SUPPORT
 	/*
 	 * bpf_info_lock protects bpf rbtrees. This is needed because the
 	 * trees are accessed by different threads in perf-top
@@ -89,7 +89,7 @@ struct perf_env {
 		struct rb_root		btfs;
 		u32			btfs_cnt;
 	} bpf_progs;
-
+#endif // HAVE_LIBBPF_SUPPORT
 	/* same reason as above (for perf-top) */
 	struct {
 		struct rw_semaphore	lock;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8d4f35e08905c..94b9c96c29d58 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -19,7 +19,9 @@
 #include <sys/utsname.h>
 #include <linux/time64.h>
 #include <dirent.h>
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/libbpf.h>
+#endif
 #include <perf/cpumap.h>
 
 #include "dso.h"
@@ -987,13 +989,6 @@ static int write_bpf_prog_info(struct feat_fd *ff,
 	up_read(&env->bpf_progs.lock);
 	return ret;
 }
-#else // HAVE_LIBBPF_SUPPORT
-static int write_bpf_prog_info(struct feat_fd *ff __maybe_unused,
-			       struct evlist *evlist __maybe_unused)
-{
-	return 0;
-}
-#endif // HAVE_LIBBPF_SUPPORT
 
 static int write_bpf_btf(struct feat_fd *ff,
 			 struct evlist *evlist __maybe_unused)
@@ -1027,6 +1022,7 @@ static int write_bpf_btf(struct feat_fd *ff,
 	up_read(&env->bpf_progs.lock);
 	return ret;
 }
+#endif // HAVE_LIBBPF_SUPPORT
 
 static int cpu_cache_level__sort(const void *a, const void *b)
 {
@@ -1638,6 +1634,7 @@ static void print_dir_format(struct feat_fd *ff, FILE *fp)
 	fprintf(fp, "# directory data version : %"PRIu64"\n", data->dir.version);
 }
 
+#ifdef HAVE_LIBBPF_SUPPORT
 static void print_bpf_prog_info(struct feat_fd *ff, FILE *fp)
 {
 	struct perf_env *env = &ff->ph->env;
@@ -1683,6 +1680,7 @@ static void print_bpf_btf(struct feat_fd *ff, FILE *fp)
 
 	up_read(&env->bpf_progs.lock);
 }
+#endif // HAVE_LIBBPF_SUPPORT
 
 static void free_event_desc(struct evsel *events)
 {
@@ -2941,12 +2939,6 @@ static int process_bpf_prog_info(struct feat_fd *ff, void *data __maybe_unused)
 	up_write(&env->bpf_progs.lock);
 	return err;
 }
-#else // HAVE_LIBBPF_SUPPORT
-static int process_bpf_prog_info(struct feat_fd *ff __maybe_unused, void *data __maybe_unused)
-{
-	return 0;
-}
-#endif // HAVE_LIBBPF_SUPPORT
 
 static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 {
@@ -2994,6 +2986,7 @@ static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 	free(node);
 	return err;
 }
+#endif // HAVE_LIBBPF_SUPPORT
 
 static int process_compressed(struct feat_fd *ff,
 			      void *data __maybe_unused)
@@ -3124,8 +3117,10 @@ const struct perf_header_feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPR(MEM_TOPOLOGY,	mem_topology,	true),
 	FEAT_OPR(CLOCKID,	clockid,	false),
 	FEAT_OPN(DIR_FORMAT,	dir_format,	false),
+#ifdef HAVE_LIBBPF_SUPPORT
 	FEAT_OPR(BPF_PROG_INFO, bpf_prog_info,  false),
 	FEAT_OPR(BPF_BTF,       bpf_btf,        false),
+#endif
 	FEAT_OPR(COMPRESSED,	compressed,	false),
 	FEAT_OPR(CPU_PMU_CAPS,	cpu_pmu_caps,	false),
 	FEAT_OPR(CLOCK_DATA,	clock_data,	false),
-- 
2.39.5



