Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF981519AA;
	Wed,  5 Feb 2025 14:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764318; cv=none; b=cgDLtjZMBsJRyfk2d41czPhJ8o7eua33PDQ2TK4crcRB19RkxmI5YeT83rhIDnU1lOQzcVQOOZYjeV4qF9a9uNMWJ3YKurDaZnHRb1/eY2TR2FWnT2Wcs/rERfmgbojZn69gYXdxUfGOKDwAIOFQXl6iX9KgteXLWBlcBs3CHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764318; c=relaxed/simple;
	bh=+nFf8HdaDThP0AZmuTY2FDRHhLUjK1lPljetGVWZBqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwtACJZu8fhhQBfq883FdYEMIKHfoad43k+hWzx47rNVcCwWKiEbA9dSpyYT44gIsv7CoZoLhhuqQF0N1llIA7rJIKkw5n9FpG3WxyxwnN5MbLf/dBWfeyrQYUE0TNP0HfgpzKxWznHjcOCvhHEim5g9B8mCwKXCzpIt29B42wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGFyta6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGFyta6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0F3C4CED1;
	Wed,  5 Feb 2025 14:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764318;
	bh=+nFf8HdaDThP0AZmuTY2FDRHhLUjK1lPljetGVWZBqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGFyta6hqh8ng/9fcpRfsRWlE7ifdqNFP8dxIlVyq6hqlM2A+FS6gpxrJXmGv/2Xw
	 SLIaU9vsKibMYQejQZ6/SarsssjIZEjzKvawFBeBS/dlZME14SusFt8zHGdqO42hBW
	 ZoF+j5jfbQ75E+Vaa8m0c6byp+KcPnB3q/FHi/z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/393] perf header: Fix one memory leakage in process_bpf_prog_info()
Date: Wed,  5 Feb 2025 14:41:20 +0100
Message-ID: <20250205134426.460728007@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit a7da6c7030e1aec32f0a41c7b4fa70ec96042019 ]

Function __perf_env__insert_bpf_prog_info() will return without inserting
bpf prog info node into perf env again due to a duplicate bpf prog info
node insertion, causing the temporary info_linear and info_node memory to
leak. Modify the return type of this function to bool and add a check to
ensure the memory is freed if the function returns false.

Fixes: 606f972b1361f477 ("perf bpf: Save bpf_prog_info information as headers to perf.data")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20241205084500.823660-3-quic_zhonhan@quicinc.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/env.c    | 5 +++--
 tools/perf/util/env.h    | 2 +-
 tools/perf/util/header.c | 5 ++++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index d2c7b6e6eae51..1f1a95bfd4a59 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -28,7 +28,7 @@ void perf_env__insert_bpf_prog_info(struct perf_env *env,
 	up_write(&env->bpf_progs.lock);
 }
 
-void __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info_node *info_node)
+bool __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info_node *info_node)
 {
 	__u32 prog_id = info_node->info_linear->info.id;
 	struct bpf_prog_info_node *node;
@@ -46,13 +46,14 @@ void __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info
 			p = &(*p)->rb_right;
 		} else {
 			pr_debug("duplicated bpf prog info %u\n", prog_id);
-			return;
+			return false;
 		}
 	}
 
 	rb_link_node(&info_node->rb_node, parent, p);
 	rb_insert_color(&info_node->rb_node, &env->bpf_progs.infos);
 	env->bpf_progs.infos_cnt++;
+	return true;
 }
 
 struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 359eff51cb85b..7d1360ff79fd8 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -164,7 +164,7 @@ const char *perf_env__raw_arch(struct perf_env *env);
 int perf_env__nr_cpus_avail(struct perf_env *env);
 
 void perf_env__init(struct perf_env *env);
-void __perf_env__insert_bpf_prog_info(struct perf_env *env,
+bool __perf_env__insert_bpf_prog_info(struct perf_env *env,
 				      struct bpf_prog_info_node *info_node);
 void perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 34d3b567ae772..0b44176826bfd 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3177,7 +3177,10 @@ static int process_bpf_prog_info(struct feat_fd *ff, void *data __maybe_unused)
 		/* after reading from file, translate offset to address */
 		bpil_offs_to_addr(info_linear);
 		info_node->info_linear = info_linear;
-		__perf_env__insert_bpf_prog_info(env, info_node);
+		if (!__perf_env__insert_bpf_prog_info(env, info_node)) {
+			free(info_linear);
+			free(info_node);
+		}
 	}
 
 	up_write(&env->bpf_progs.lock);
-- 
2.39.5



