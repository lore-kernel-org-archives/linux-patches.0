Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7592DEA7E;
	Fri, 21 Nov 2025 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731219; cv=none; b=nToGQuATpMt0GEyOF7j3fz5P2MOtqINKgfmfkjRasQ8p+iifgJVc9Nm8TCFuFxE9TK+TwLUPtgrm/hWWwJmSKP2nDXLtcdunOYNXLtX1x20iYxfyQJd1JOAmVlHtmbnOC0SLCM1K6msdGcNvOUMJ8B3taxekULi4szPdaQymjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731219; c=relaxed/simple;
	bh=6rTqn48+bDpiN9A9GRvFnLX9xnPH1nrbZGwRve3a+AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPzfrH+OFkvFMcARaP9YOGEJfJnN9OpI5ieSP0ew07BioZx9YGtnkOJkop5dDzyZ2IRep//B4kUQCRwqdhUhDjJkek3XRMTkbHFP+5bkm+02dqbcAlk1MjID6YpQAhd+ovzSvaYb0+66c669vGDVofrVkNf00LBKQjOpHsnfc4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSh/GpwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSh/GpwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591C7C4CEF1;
	Fri, 21 Nov 2025 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731218;
	bh=6rTqn48+bDpiN9A9GRvFnLX9xnPH1nrbZGwRve3a+AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSh/GpwJbuJrEj3Xar3928nfZzHtaESF5sjjrKnNzVjgVJVj/56mpqYYjg4vZA5rD
	 qz1DqNCkXAGPRCZbl0QHDKaAwhr3xgBPZ+wg93s2Xr+5fd0psb8lsqixW1BrGSiy9G
	 whI/nQ78VhlXxRe7/lFQRhzFCaYfXhhPQSHUva4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ananth Narayan <ananth.narayan@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/247] perf lock: Fix segfault due to missing kernel map
Date: Fri, 21 Nov 2025 14:11:19 +0100
Message-ID: <20251121130159.464355028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit d0206db94b36c998c11458cfdae2f45ba20bc4fb ]

Kernel maps are encoded in PERF_RECORD_MMAP2 samples but "perf lock
report" and "perf lock contention" do not process MMAP2 samples.

Because of that, machine->vmlinux_map stays NULL and any later access
triggers a segmentation fault.

Fix it by adding ->mmap2() callbacks.

Fixes: 53b00ff358dc75b1 ("perf record: Make --buildid-mmap the default")
Reported-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ananth Narayan <ananth.narayan@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 078634461df27..e8962c985d34a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1867,6 +1867,7 @@ static int __cmd_report(bool display_info)
 	eops.sample		 = process_sample_event;
 	eops.comm		 = perf_event__process_comm;
 	eops.mmap		 = perf_event__process_mmap;
+	eops.mmap2		 = perf_event__process_mmap2;
 	eops.namespaces		 = perf_event__process_namespaces;
 	eops.tracing_data	 = perf_event__process_tracing_data;
 	session = perf_session__new(&data, &eops);
@@ -2023,6 +2024,7 @@ static int __cmd_contention(int argc, const char **argv)
 	eops.sample		 = process_sample_event;
 	eops.comm		 = perf_event__process_comm;
 	eops.mmap		 = perf_event__process_mmap;
+	eops.mmap2		 = perf_event__process_mmap2;
 	eops.tracing_data	 = perf_event__process_tracing_data;
 
 	perf_env__init(&host_env);
-- 
2.51.0



