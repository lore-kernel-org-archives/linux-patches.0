Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3D155753;
	Wed, 19 Feb 2025 09:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956249; cv=none; b=cGPHalxLW2OYn1EdSoS969pGDVniLLthOaXYU3iWqESy48bMvIVekLxIke6Bh57YMyDPwASLdbKnSHGY/P8rmVgHbMpliQGvSkC2sBU10CGf2PJoKpmBZJczrH2kWNYEKHINpqu1r96+F8/x00GlH9KfkXx0ocFbzC2RU4gsJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956249; c=relaxed/simple;
	bh=oeR54UNGEJOEN6Waj8QbB6Ju7oxRu9oWOm9zGhjl+LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2IGL8uZ2+AeZmKgy8NGxHHBFdOw6ZSfErjg6gMjCXQiPguIT5Ei+YuYVs5WlTgmQp2/OzbXSndMY8M4LBRBjCahcGzn0R8tr0QdfVIB0Pht/2c3WVdfct0GJHt7C/J6Fvg0LQbtpLvScSy6YeJLf9wq1lDsMzsdnIVv/qNuhFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVzYthgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVzYthgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5804EC4CED1;
	Wed, 19 Feb 2025 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956248;
	bh=oeR54UNGEJOEN6Waj8QbB6Ju7oxRu9oWOm9zGhjl+LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVzYthgCGdwdv+tsm+is/tLEkHpTDdiR7IOnoEb2fQSHZTrZMdAx/haFhxg4j5N2W
	 6FG5rXqusBTkqKhnikQ3RTTlNj5j6z5FDk+MOjTGjVsEtGsaDkGS/6pfEa/Zkxjwt4
	 jfTtoWPvHAp2M972JXUsSt6IIJIVbPrQ4DkQikcE=
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
Subject: [PATCH 6.1 108/578] perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()
Date: Wed, 19 Feb 2025 09:21:52 +0100
Message-ID: <20250219082657.226742279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 03edb7020bb920f1935c3f30acad0bb27fdb99af ]

If perf_env__insert_bpf_prog_info() returns false due to a duplicate bpf
prog info node insertion, the temporary info_node and info_linear memory
will leak. Add a check to ensure the memory is freed if the function
returns false.

Fixes: d56354dc49091e33 ("perf tools: Save bpf_prog_info and BTF of new BPF programs")
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
Link: https://lore.kernel.org/r/20241205084500.823660-4-quic_zhonhan@quicinc.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 10 ++++++++--
 tools/perf/util/env.c       |  8 ++++++--
 tools/perf/util/env.h       |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 91c7bfa82a50a..6cc1b9adc65c6 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -352,7 +352,10 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 		}
 
 		info_node->info_linear = info_linear;
-		perf_env__insert_bpf_prog_info(env, info_node);
+		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
+			free(info_linear);
+			free(info_node);
+		}
 		info_linear = NULL;
 
 		/*
@@ -540,7 +543,10 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	info_node = malloc(sizeof(struct bpf_prog_info_node));
 	if (info_node) {
 		info_node->info_linear = info_linear;
-		perf_env__insert_bpf_prog_info(env, info_node);
+		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
+			free(info_linear);
+			free(info_node);
+		}
 	} else
 		free(info_linear);
 
diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index a0393f9c5fda7..fa08f82f88e7a 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -19,12 +19,16 @@ struct perf_env perf_env;
 #include "bpf-utils.h"
 #include <bpf/libbpf.h>
 
-void perf_env__insert_bpf_prog_info(struct perf_env *env,
+bool perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node)
 {
+	bool ret;
+
 	down_write(&env->bpf_progs.lock);
-	__perf_env__insert_bpf_prog_info(env, info_node);
+	ret = __perf_env__insert_bpf_prog_info(env, info_node);
 	up_write(&env->bpf_progs.lock);
+
+	return ret;
 }
 
 bool __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info_node *info_node)
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 7d1360ff79fd8..bc2d0ef351997 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -166,7 +166,7 @@ int perf_env__nr_cpus_avail(struct perf_env *env);
 void perf_env__init(struct perf_env *env);
 bool __perf_env__insert_bpf_prog_info(struct perf_env *env,
 				      struct bpf_prog_info_node *info_node);
-void perf_env__insert_bpf_prog_info(struct perf_env *env,
+bool perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node);
 struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
 							__u32 prog_id);
-- 
2.39.5



