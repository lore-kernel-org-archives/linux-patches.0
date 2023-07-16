Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB88F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DDFC433C7;
	Sun, 16 Jul 2023 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538523;
	bh=c/Sx1O0dI4YsBKOAQ1zxB045CMtXjZGrRimk8AwEQyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc2uazws+r5znb26ygOS6reviS/o3o3Qx5TJ9Xl1oLPYl7lUoiaHxNP7l7y9cvTAI
	 1NKwU7FQEC1McAcBCT/Q9eDZdA4DsOL18XMFlOoRVNoMSXD+8rUQpOLDspl+0d35y9
	 Y7H0GgZI7eEs9WAe80KT9eGdFzIhvGL6/cvNDPVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 481/800] perf stat: Reset aggr stats for each run
Date: Sun, 16 Jul 2023 21:45:34 +0200
Message-ID: <20230716195000.251307845@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit ed4090a22c123b9b33368741253edddc6ff8d18f ]

When it runs multiple times with -r option, it missed to reset the
aggregation counters and the values were added up.  The aggregation
count has the values to be printed in the end.  It should reset the
counters at the beginning of each run.  But the current code does that
only when -I/--interval-print option is given.

Fixes: 91f85f98da7ab8c3 ("perf stat: Display event stats using aggr counts")
Reported-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230616073211.1057936-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b9ad32f21e575..463643cda0d5f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -723,6 +723,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			all_counters_use_bpf = false;
 	}
 
+	evlist__reset_aggr_stats(evsel_list);
+
 	evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
 		counter = evlist_cpu_itr.evsel;
 
-- 
2.39.2



