Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF4B1C5D77;
	Tue, 11 Mar 2025 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705489; cv=none; b=sht0DnF4+88czFnjcC2IUq3lZbcT358tgzaothrFi9IoCmobkiAqwXVtWEvhsV5cyxVPRnCPEvvBrinE9wKWp2Ww+azmuTmFNVJIlTItRUMNWDLJCz4f3FsdNlwzPIThJezddu8d9YGg11adN/T4usttxVMCnAwL9tJQWe4eBp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705489; c=relaxed/simple;
	bh=nszJ7hRn5z8Z9tM1cuWV7KHYpB0Zzy6KTsajACJBmRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Saj+mR4dHJBiDbxnhT0XG9NqeA1EJBifRbr1mXQuyJnu7/B/Oi9S8BG1e7Bf6Z5/zEROaJzIEcPYbCaCNSSalwgc7Bhvrc/A4fTEjpO4J6Wf/1NljsLGLqhHfc5n2i4HT2ns0uDdouOT7kcZ7z0FmXUhmKd5plQyQO00jPoshmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1HQdBdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1HQdBdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A65C4CEE9;
	Tue, 11 Mar 2025 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705489;
	bh=nszJ7hRn5z8Z9tM1cuWV7KHYpB0Zzy6KTsajACJBmRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1HQdBdcAy7L6CDbHlbBT9gAF3SoAVdEGJqUx7Nh3Ngtm74rbhvswCKhyNpz47RAs
	 Pg0XO4HTMtGTTCEzz9JLL81oOjrQNMFP6RRz+ERa1wGi0ooqIJjmO3HJuTkZe57IXt
	 +XY+GB3zamdeudVCAxywcp9iEkPFuQeMDR8aJTw0=
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
Subject: [PATCH 5.4 036/328] perf header: Fix one memory leakage in process_bpf_prog_info()
Date: Tue, 11 Mar 2025 15:56:46 +0100
Message-ID: <20250311145716.330138681@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 953db9dd25eb0..f8239fbe6b09d 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -21,7 +21,7 @@ void perf_env__insert_bpf_prog_info(struct perf_env *env,
 	up_write(&env->bpf_progs.lock);
 }
 
-void __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info_node *info_node)
+bool __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info_node *info_node)
 {
 	__u32 prog_id = info_node->info_linear->info.id;
 	struct bpf_prog_info_node *node;
@@ -39,13 +39,14 @@ void __perf_env__insert_bpf_prog_info(struct perf_env *env, struct bpf_prog_info
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
index b0778483fa04b..9c5777a2ea7e0 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -117,7 +117,7 @@ const char *perf_env__raw_arch(struct perf_env *env);
 int perf_env__nr_cpus_avail(struct perf_env *env);
 
 void perf_env__init(struct perf_env *env);
-void __perf_env__insert_bpf_prog_info(struct perf_env *env,
+bool __perf_env__insert_bpf_prog_info(struct perf_env *env,
 				      struct bpf_prog_info_node *info_node);
 void perf_env__insert_bpf_prog_info(struct perf_env *env,
 				    struct bpf_prog_info_node *info_node);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6dc99378b191b..a66a05091a974 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2724,7 +2724,10 @@ static int process_bpf_prog_info(struct feat_fd *ff, void *data __maybe_unused)
 		/* after reading from file, translate offset to address */
 		bpf_program__bpil_offs_to_addr(info_linear);
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



