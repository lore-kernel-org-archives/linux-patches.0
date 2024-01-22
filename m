Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1813474E;
	Tue, 23 Jan 2024 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971924; cv=none; b=Q1tgLKqxjPYA3oTDo1De9rxkpURDy4IXeNdC897hxCXRV1HXYfwkg6gxtlQXv/evmruxkhkGkXyLyfA89JJRj8f0IYIcOm4mfDCiHPNrzwsNA9u7wwhTdSR8x2XiD7xNK+a72zlbqTP9yKjt3J7V9258x11GKFu7gX/O0cn8/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971924; c=relaxed/simple;
	bh=Yt5qdZiLIBRoCjPkgVNWqDCZcw2dgVV4xYLP+ivJgtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFRSUdZMDzB3iuJ1tjR6vNUyBq/NKwqzoWIxNxOXV66NP9IvoNn/jKNo1qN0juN1iF6apAHG+wh+l4iD7z6SB10gBu8jEIY5yTiFFQxcLzwJ0CBF5hf63SUCrqRB54EGGqDI0y3nip1Rx49qZ0W9hOt/tiNWTBZqYeXGbheKmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBWSVTYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBWSVTYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D65C433F1;
	Tue, 23 Jan 2024 01:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971924;
	bh=Yt5qdZiLIBRoCjPkgVNWqDCZcw2dgVV4xYLP+ivJgtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBWSVTYGrv1ufOpXl91gQqdeFvoGT+tAE0jySBlE6m5cxL6t1bvKkGB8SUU4Q2GP4
	 avPWaYt2goqLV5LfPlteEFsZLtbr04Vn4dR8sbVdBqTBuh199At0ravjER67n1hXJU
	 +td6qZswm/09Epu1Da88SRg080iqJpqHzvspz1As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Junhao He <hejunhao3@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linuxarm@huawei.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/417] perf header: Fix one memory leakage in perf_event__fprintf_event_update()
Date: Mon, 22 Jan 2024 15:58:41 -0800
Message-ID: <20240122235804.028433232@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 813900d19b923fc1b241c1ce292472f68066092b ]

When dump the raw trace by `perf report -D` ASan reports a memory
leakage in perf_event__fprintf_event_update().

It shows that we allocated a temporary cpumap for dumping the CPUs but
doesn't release it and it's not used elsewhere. Fix this by free the
cpumap after the dumping.

Fixes: c853f9394b7bc189 ("perf tools: Add perf_event__fprintf_event_update function")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linuxarm@huawei.com
Link: https://lore.kernel.org/r/20231207081635.8427-2-yangyicong@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9e2dce70b130..eaeeba8d65ec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -4314,9 +4314,10 @@ size_t perf_event__fprintf_event_update(union perf_event *event, FILE *fp)
 		ret += fprintf(fp, "... ");
 
 		map = cpu_map__new_data(&ev->cpus.cpus);
-		if (map)
+		if (map) {
 			ret += cpu_map__fprintf(map, fp);
-		else
+			perf_cpu_map__put(map);
+		} else
 			ret += fprintf(fp, "failed to get cpus\n");
 		break;
 	default:
-- 
2.43.0



