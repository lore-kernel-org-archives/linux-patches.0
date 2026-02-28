Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A624D4A2E25
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300879; cv=none; b=QUo6NHHZi1wpjpRh2sXcQ8HO+XbMt3WnO0xkG5H8eVf2NzQm2BwHKfqOWMtXN3BvPK8YxD+0+orcO/mhrk8rKyMiln1CWqLl08g203vN5Kx62+jMhcvrXm79+Flz7KkqWeHY0bwC3RpNc40ZAHgo5vfoD7BZp3+eUpyurulwGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300879; c=relaxed/simple;
	bh=U+WUIVOycw5rgqjji3S+KDiWk4tFx3ojXaTdLXoEa2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaYZ4TQ29swJoU3DcVzsmDoL6XVxF9Zhier/+PaiYY++gHE/Rgq0PBhufsyjfA3NHTrsz74MgDQIeP7XalKn/qieKoRK5jnC3Yh4Uvo4AxjSEDR6FWQuMHkv/IQ4TgX4Zwd5cK93eyqcPyskJGkOklJ0ehGS2fLiRqvGYI93cRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9wQ3TDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9wQ3TDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB64DC116D0;
	Sat, 28 Feb 2026 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300879;
	bh=U+WUIVOycw5rgqjji3S+KDiWk4tFx3ojXaTdLXoEa2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9wQ3TDK2CnQoYqiLVRAcVIZtT//l137ky+p6pp/9PbdVmKNAIQJooeTqsHUZ/xlG
	 Of1qnKPweGtPttoIi9FsFGEPWryOHSnVUMUqT5Br8hqLBzoQzUEBkYl6OZ7QRcqq68
	 qNQEEBMzo3VG9wyPIxXsec6uArHcK3Krxhwh3IY41kM+jFiO1yDppEARBzmmQIuauz
	 nr8wf9/LIdh7ka48YT9d79t+sVS9z3jndjsyCe6N5soXtHUmNdpKPy7j/E9L4grd+6
	 Bs0gRRW21tcF9tVEkZ9pZtPNm58SnLcj0Qsvrpx4+Aj9vplVmk04yemNSXS6SX24X0
	 QZI65OHnsdgdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Tony Jones <tonyj@suse.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/752] perf callchain: Fix srcline printing with inlines
Date: Sat, 28 Feb 2026 12:35:16 -0500
Message-ID: <20260228174750.1542406-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit abec464767b5d26f0612250d511c18f420826ca1 ]

sample__fprintf_callchain() was using map__fprintf_srcline() which won't
report inline line numbers.

Fix by using the srcline from the callchain and falling back to the map
variant.

Fixes: 25da4fab5f66e659 ("perf evsel: Move fprintf methods to separate source file")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Tony Jones <tonyj@suse.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel_fprintf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel_fprintf.c b/tools/perf/util/evsel_fprintf.c
index 103984b29b1e1..cbf2dd2dfc6f4 100644
--- a/tools/perf/util/evsel_fprintf.c
+++ b/tools/perf/util/evsel_fprintf.c
@@ -182,8 +182,12 @@ int sample__fprintf_callchain(struct perf_sample *sample, int left_alignment,
 			if (print_dso && (!sym || !sym->inlined))
 				printed += map__fprintf_dsoname_dsoff(map, print_dsoff, addr, fp);
 
-			if (print_srcline)
-				printed += map__fprintf_srcline(map, addr, "\n  ", fp);
+			if (print_srcline) {
+				if (node->srcline)
+					printed += fprintf(fp, "\n  %s", node->srcline);
+				else
+					printed += map__fprintf_srcline(map, addr, "\n  ", fp);
+			}
 
 			if (sym && sym->inlined)
 				printed += fprintf(fp, " (inlined)");
-- 
2.51.0

