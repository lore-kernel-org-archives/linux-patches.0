Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D7139BFFE;
	Tue, 21 Jul 2026 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660107; cv=none; b=DopX9GNy73BOnJGrQSkO5XCSqld0beLxsIv9ngEWhgQK5z+hiRt/ThDa+ElNWzJzkgmW3JNyf0niWjioyaBWwbEzkEn1PcTjrZk6HRvY5XHP2jmleV1LIdABdQkAmH8jdp0pUfsYeKnxmBBmBWzDUL/tkEKsRZgocKrs9jtn4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660107; c=relaxed/simple;
	bh=2V5+SSZTwZInqW2NW4u2cXUCDwwmcYN/P0E8geJI/fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OiZ+5e7ZJJITT7AuSXoDPnSaq3ATH9DXEqFVLc+1vK7invsvmSfrNwbKNl0rsNdoEBPiGazeprRQ8P8BzhV644SgAYakPXqfD+RFaIgVUVlm4rfuUu3IwEikiSsfrRG0bQ35Z5JaZGLy2BPEm3dW31RZVfy9g0oVdoJxrt++/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+ceBy9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+ceBy9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDE81F000E9;
	Tue, 21 Jul 2026 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660105;
	bh=Xc6CTfUT8fwE07sgWRJUhkRCWtx6ShKRUa5G867kZPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+ceBy9pTjDZEhsX3fHTjI7udir/PcLxvEJKzkZXxZTSFK/RnvTpAu/rPM7awPXS4
	 PpbiM7T43ahBqEZwt/0FG8c0oSwsL0xVgaAtQmp28p7RNEaWPdHK5r/Y4ENerdw5zA
	 GjMufAam0xv5272O8rgjiB5dHOVoD+fd9+ydmhrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Gabriel Marin <gmx@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0854/2077] perf tool: Fix missing schedstat delegates and dont_split_sample_group in delegate_tool
Date: Tue, 21 Jul 2026 17:08:47 +0200
Message-ID: <20260721152612.932954630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 09d355618f7ccc27ffc7fc668b2e232872962079 ]

delegate_tool was missing the delegate overrides for schedstat_cpu
and schedstat_domain. As a result, when allocated with zalloc, these
callbacks defaulted to NULL, causing a segmentation fault crash if
any schedstat events were delivered during event processing.
Fix this by adding delegate_schedstat_cpu and delegate_schedstat_domain
via the CREATE_DELEGATE_OP2 macro, and ensuring delegate_tool__init
correctly registers them.

Additionally, delegate_tool__init completely omitted copying the
dont_split_sample_group property from the delegate. This would cause
wrapper tools to default the flag to false, which corrupts piped event
processing (e.g., in perf inject) by triggering duplicate event
deliveries on split sample values in deliver_sample_group().

Similarly, perf_tool__init() omitted the initialization of this
boolean field. On stack-allocated tools that rely on this initializer
(like intel-tpebs or __cmd_evlist), this could result in uninitialized
stack garbage evaluating to true—silently dropping non-leader event
members in deliver_sample_group().

Fix both issues by properly copying the field in delegate_tool__init
and initializing it to false in perf_tool__init.

Fixes: 6331b266935916bf ("perf tool: Add a delegate_tool that just delegates actions to another tool")
Fixes: 79bcd34e0f3da39f ("perf inject: Fix leader sampling inserting additional samples")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Gabriel Marin <gmx@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/tool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/tool.c b/tools/perf/util/tool.c
index 013c7839e2cfd2..ff2150517b7558 100644
--- a/tools/perf/util/tool.c
+++ b/tools/perf/util/tool.c
@@ -285,6 +285,7 @@ void perf_tool__init(struct perf_tool *tool, bool ordered_events)
 	tool->no_warn = false;
 	tool->show_feat_hdr = SHOW_FEAT_NO_HEADER;
 	tool->merge_deferred_callchains = true;
+	tool->dont_split_sample_group = false;
 
 	tool->sample = process_event_sample_stub;
 	tool->mmap = process_event_stub;
@@ -433,6 +434,8 @@ CREATE_DELEGATE_OP2(stat_config);
 CREATE_DELEGATE_OP2(stat_round);
 CREATE_DELEGATE_OP2(thread_map);
 CREATE_DELEGATE_OP2(time_conv);
+CREATE_DELEGATE_OP2(schedstat_cpu);
+CREATE_DELEGATE_OP2(schedstat_domain);
 CREATE_DELEGATE_OP2(tracing_data);
 
 #define CREATE_DELEGATE_OP3(name)					\
@@ -470,6 +473,7 @@ void delegate_tool__init(struct delegate_tool *tool, struct perf_tool *delegate)
 	tool->tool.no_warn = delegate->no_warn;
 	tool->tool.show_feat_hdr = delegate->show_feat_hdr;
 	tool->tool.merge_deferred_callchains = delegate->merge_deferred_callchains;
+	tool->tool.dont_split_sample_group = delegate->dont_split_sample_group;
 
 	tool->tool.sample = delegate_sample;
 	tool->tool.read = delegate_read;
@@ -516,4 +520,6 @@ void delegate_tool__init(struct delegate_tool *tool, struct perf_tool *delegate)
 	tool->tool.bpf_metadata = delegate_bpf_metadata;
 	tool->tool.compressed = delegate_compressed;
 	tool->tool.auxtrace = delegate_auxtrace;
+	tool->tool.schedstat_cpu = delegate_schedstat_cpu;
+	tool->tool.schedstat_domain = delegate_schedstat_domain;
 }
-- 
2.53.0



