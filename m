Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3C84E1D8;
	Tue, 23 Jan 2024 00:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969996; cv=none; b=c468dUwl6sP78cOXMfm4xFFhgjJQc4yR88MpAAZ4Rc5dKFUUZ85F0PDzbYaKkmcKtsx2rPAGAMtUqlKSMvHtciLIhcyTZEZM5LOFztUeASwDa3VQLuT6VuocrkE33a8aWsM1+sOoM7xlZ1zl7EbEbXUVhQdL/YWtbTT+VpQMgE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969996; c=relaxed/simple;
	bh=LhBTIdOaoHcUmGE2oP0sOAZWUpr7AXiEuVWlN9tqvRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjx/O/D11jqFOM70z/TbboVXin2Ho0lSAW5egHARdvod8UNjjEjCR7VX/dyWzCcGgcxTysHgSuY+TXhZRt5sLH1YQ2yf450XrK8MoOEwPm7/m/tg0A9gvYIor6X+mw8uVitOiSEXD/MBHoMepRblq7wwPvY2N+umToKw//FjqpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvszTyWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvszTyWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132E6C433C7;
	Tue, 23 Jan 2024 00:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969995;
	bh=LhBTIdOaoHcUmGE2oP0sOAZWUpr7AXiEuVWlN9tqvRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvszTyWd6Hz6ZgfOOeS5IUfjp7dLbv8hHmaNxej4G781ox0OIOuO/8txyvQG2PIoP
	 RcEuCvZVJDBdkboqJJF4UdTffzP88Qep/1rR+1J+TWp06mFLSGxlnRwZI0D+RxPMZJ
	 qEcfQ9QGrcBFVu7czUAsLB8yDHQ8TgirZa/yVlLQ=
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
Subject: [PATCH 6.7 532/641] perf header: Fix one memory leakage in perf_event__fprintf_event_update()
Date: Mon, 22 Jan 2024 15:57:16 -0800
Message-ID: <20240122235834.759834372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 7609b4d468dc..b39b3e4cec8a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -4371,9 +4371,10 @@ size_t perf_event__fprintf_event_update(union perf_event *event, FILE *fp)
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



