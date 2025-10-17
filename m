Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257ED23EA9E;
	Fri, 17 Oct 2025 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714900; cv=none; b=RG44wtab7cFgcWUuJa8vg/vhHnDCo9T+BbMAlp+XFyGKCAMpLQba/M7YUHVOTOADMfmgWuaKW4/OW6yQkkkBsKu7WeAi0m94G0J5nIcneDS6P43QKt/XqN2xiEsMU84qHyA3UMaIN7CpePF6N9w8H7GYQ1iZPC8/L+3/ABH4iIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714900; c=relaxed/simple;
	bh=CZMeh/Aj82C6yAJS56+OHQsyA8se28H+2HTmWXcdD68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT9zwNa+/acMQboWFps1LrNmt8ANlRNeAEOlrBp5yCiMNzYJSjWVuLILVbNIPZ19K+viy7mm3QOWH95D6g/sOxxIfRC/SoPuKqDcdnZfRzuNQWR8EjwLbxB5icw8d1gHhyWQGAbcWmPRal2pQ9tdE90zUALWQyDC0cIzg1zIPBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHeAw+V5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHeAw+V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33146C4CEFE;
	Fri, 17 Oct 2025 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714899;
	bh=CZMeh/Aj82C6yAJS56+OHQsyA8se28H+2HTmWXcdD68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHeAw+V5CDL4KqfyOM3PsW2ITkgEnrgHyaWnLN/OUUjAh4m5EVuGlNThhC6GAn0tM
	 s8MmS6ohrz98Ji9e8nhy+kXozVGfn7uphIL/409ipSXMclVQPa0Wzw4l8/oE1sha5h
	 rxgiaTKDV+s/QHAnomD63N+YYxiznqfyleYnU0N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Blake Jones <blakejones@google.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nam Cao <namcao@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 028/371] libperf event: Ensure tracing data is multiple of 8 sized
Date: Fri, 17 Oct 2025 16:50:03 +0200
Message-ID: <20251017145202.817956369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit b39c915a4f365cce6bdc0e538ed95d31823aea8f ]

Perf's synthetic-events.c will ensure 8-byte alignment of tracing
data, writing it after a perf_record_header_tracing_data event.

Add padding to struct perf_record_header_tracing_data to make it 16-byte
rather than 12-byte sized.

Fixes: 055c67ed39887c55 ("perf tools: Move event synthesizing routines to separate .c file")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Blake Jones <blakejones@google.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250821163820.1132977-6-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/include/perf/event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 6608f1e3701b4..aa1e91c97a226 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -291,6 +291,7 @@ struct perf_record_header_event_type {
 struct perf_record_header_tracing_data {
 	struct perf_event_header header;
 	__u32			 size;
+	__u32			 pad;
 };
 
 #define PERF_RECORD_MISC_BUILD_ID_SIZE (1 << 15)
-- 
2.51.0



