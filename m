Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822B232C93E;
	Fri, 17 Oct 2025 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714065; cv=none; b=UpPQKwt0iz9KjwLxRoJY70zzR2yPnfz0Eb0sXB5RnAPvm4RcpCWGGXHHEj+/I/+IqVE5O40CtZvMOyJf1GsDGfcy3vIOTaVJW2qF3yYtRe2rd7ffYBvewZjThh23jn/vIBJBQTPq487wyku+PPrSTriINqMBgeIUyZbyS9cLTA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714065; c=relaxed/simple;
	bh=/qG9wSyuKR7mxl3fE5+5Cf0PIs8T2VfkZbZNWTzfrbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOoWwgld1YedLc3BoKuQz+jvNk88m9VIK4Qh4YUol0Qi9VREiviEx55id2Id6TW8bRb/jY+2OVjw6+u9c37GFZxtJvwBLgZDVaoXGi6zgpgCc26xpLhCuLZuM7QyFRf2zEqO3BjoKfNr9r25ZPagloq6bTAiuqpPRDgFnq6werY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlXFC9Or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlXFC9Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BFFC4CEF9;
	Fri, 17 Oct 2025 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714065;
	bh=/qG9wSyuKR7mxl3fE5+5Cf0PIs8T2VfkZbZNWTzfrbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlXFC9OrdzbtiqY9d+YF7vcSH6/DKJstJhjl1lIcpSEdlK7MyW9ouhqjjzpP0N1Ur
	 rF6je+z90q8Hh04eApvZGgC5cnjXjz54TIcYP+lcJWXaWDp7hJMAGO7ZAt2Kqzo07o
	 vFh0A6E7lDEYeNnla1QoZ70fdd0gRhUWoXDDGAyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
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
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/277] perf evsel: Avoid container_of on a NULL leader
Date: Fri, 17 Oct 2025 16:50:22 +0200
Message-ID: <20251017145147.703847776@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2354479026d726954ff86ce82f4b649637319661 ]

An evsel should typically have a leader of itself, however, in tests
like 'Sample parsing' a NULL leader may occur and the container_of
will return a corrupt pointer.

Avoid this with an explicit NULL test.

Fixes: fba7c86601e2e42d ("libperf: Move 'leader' from tools/perf to perf_evsel::leader")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
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
Link: https://lore.kernel.org/r/20250821163820.1132977-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6d7249cc1a993..b3de8ce559998 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3497,6 +3497,8 @@ bool evsel__is_hybrid(const struct evsel *evsel)
 
 struct evsel *evsel__leader(const struct evsel *evsel)
 {
+	if (evsel->core.leader == NULL)
+		return NULL;
 	return container_of(evsel->core.leader, struct evsel, core);
 }
 
-- 
2.51.0



