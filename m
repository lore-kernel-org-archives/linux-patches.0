Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C1A1AB6FF;
	Mon, 14 Oct 2024 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917952; cv=none; b=M2VS3rxRBYEdyHxCj7ZjQJhSW+GtlKwb8n/40ymxvRQ9hwy0zfsRAzeEszFaT7Xpp69pun3Im9RV4QmBm+Mr5+rNdnhmI3BXuqNiMJtWtIW51PNQXohhweeDoNdXMWGEefhdbeYM0Ge4opypEZuUC/fJuJN5NPxYPkO8gYp/B5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917952; c=relaxed/simple;
	bh=BQ/Ek5wW08DItIdX1/xux5IGCTwQZMk5GGdfAtRx7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eybQnXkLX9Zo+N1W7j2wC7EN4Ssmm5U+Y4K+Le4aBsXT61kRGCpQ/zmH9OwC1wO/AzI4AkW/qaspmwRjflKaUATfDFT1HBKzjCf6FqIHub/HWLULLqk4JqVoFpkDr/pYx/wr54w9VtFiIQthMqyKxse4Fx356voKbATrGf4n3ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYvsZ80B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYvsZ80B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D363C4CEC3;
	Mon, 14 Oct 2024 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917951;
	bh=BQ/Ek5wW08DItIdX1/xux5IGCTwQZMk5GGdfAtRx7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYvsZ80BE2mLCEXj/uxnS83Ndb1GfhKSSUVHcy0EFB8gRO1FWOm1T+zu6s6Ed63O9
	 jNxLH2xT/odtH5oZONsK9oLLLigXaI8rGNOVvBFX+0u4XSfvAaHCgCgBEnql65WFUn
	 7K4VNCVDkqrXExCIynqqwFy3UQSvsR75SyxCCVdM=
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
Subject: [PATCH 6.1 180/798] perf stat: Display iostat headers correctly
Date: Mon, 14 Oct 2024 16:12:14 +0200
Message-ID: <20241014141224.997565660@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 9053db0dc00a1..3e94159ea96cc 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -1162,7 +1162,8 @@ static void print_metric_headers(struct perf_stat_config *config,
 
 	/* Print metrics headers only */
 	evlist__for_each_entry(evlist, counter) {
-		if (config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
+		if (!config->iostat_run &&
+		    config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
 			continue;
 
 		os.evsel = counter;
-- 
2.43.0



