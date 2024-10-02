Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FB19752C;
	Wed,  2 Oct 2024 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878227; cv=none; b=PBMU//mCkFnJPHBU3004Cb6QLXIzXQFgMxgksKpzGIxedidgBQlwhLPDCJaccyNwlPp5EVCmIUuBYP6v/4xAHSbExhBHPTgdTBBZxgiUaFYPXJEEsOY/ig7x+TVc3nal+VG5dMmFd3/y7P5KiZP2CyQIFs+GoPwPhzLaqFl78/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878227; c=relaxed/simple;
	bh=ZBNTwmEHGcAY9XaNqGB160/8LiDa5M4YsXcskDmdt7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGdetG/sNn7xly6VnbXuXB8W0sce6bzkdjoUQUBUAR/HpgMN46FIBpHKC4OvSigD7W8L21j1ebQ1c7OxOydjyCRgw1HoNhPYOeuRV20wRswk6LTOpYB6kbhA2EGhiunD0otNviYMwIC3DsFyIdcyIjyjgju6/5UuUyoGpQH2tqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uCE8BPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uCE8BPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0968C4CEC2;
	Wed,  2 Oct 2024 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878227;
	bh=ZBNTwmEHGcAY9XaNqGB160/8LiDa5M4YsXcskDmdt7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uCE8BPHMdvVOGY0T6Gxk3meuUTJMZlBf8OG2CZUWKVZNu1C8Rb3k4IURBJFgKRxE
	 5DuVpEuZfV/vni2PX7RXAaEAYPlaisXV1lRbkuFfAFba0TJMwKFz7IJRh4Mz2yH1MN
	 zSvp5FmsXQdkIlov9OFxU/dQ+PYpACAQUY/Om9h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Junhao He <hejunhao3@huawei.com>,
	linuxarm@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Zeng Tao <prime.zeng@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 300/634] perf stat: Display iostat headers correctly
Date: Wed,  2 Oct 2024 14:56:40 +0200
Message-ID: <20241002125822.950836708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 2615639352420e6e3115952c5b8f46846e1c6d0e ]

Currently we'll only print metric headers for metric leader in
aggregration mode. This will make `perf iostat` header not shown
since it'll aggregrated globally but don't have metric events:

  root@ubuntu204:/home/yang/linux/tools/perf# ./perf stat --iostat --timeout 1000
   Performance counter stats for 'system wide':
      port
  0000:00                    0                    0                    0                    0
  0000:80                    0                    0                    0                    0
  [...]

Fix this by excluding the iostat in the check of printing metric
headers. Then we can see the headers:

  root@ubuntu204:/home/yang/linux/tools/perf# ./perf stat --iostat --timeout 1000
   Performance counter stats for 'system wide':
      port             Inbound Read(MB)    Inbound Write(MB)    Outbound Read(MB)   Outbound Write(MB)
  0000:00                    0                    0                    0                    0
  0000:80                    0                    0                    0                    0
  [...]

Fixes: 193a9e30207f5477 ("perf stat: Don't display metric header for non-leader uncore events")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: linuxarm@huawei.com
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Link: https://lore.kernel.org/r/20240802065800.48774-1-yangyicong@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 186305fd2d0ef..ac79ac4ccbe02 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -1226,7 +1226,8 @@ static void print_metric_headers(struct perf_stat_config *config,
 
 	/* Print metrics headers only */
 	evlist__for_each_entry(evlist, counter) {
-		if (config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
+		if (!config->iostat_run &&
+		    config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
 			continue;
 
 		os.evsel = counter;
-- 
2.43.0



