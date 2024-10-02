Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBE01D0797;
	Wed,  2 Oct 2024 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878213; cv=none; b=txrZ0R2jcclaubrPjE+uZuyDwhF+mnLp4+dJy1wXI8YPoW3qEaLi4qe8JxMxcU5rEtETZyp4BM8wVs+2YFfVz9kZka8GM3V5baszBKpJUj5auxXv4many6wvEICrZVUOI4nrubP8AsqZ+vud0r+KRApj3KD50FSyDLVT96tgygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878213; c=relaxed/simple;
	bh=jbVM7d/BuwKcWOZs7WABmD5EdVWfBGOWswsqEgu1NfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr0BY3CckFIAzSFiHvgyDp5cwIOnVR5i6kH6DchQ8j+NjjyBchZcQz66LjoyEqK+zP0l8ZSwc3CKS0txjqdpahBeSo40PLkcTPlDfeNpTrn6Ss8WGCRTHM2sRXSepUBXV+3p1ZtJlCXci5bffMZDY3lCv8GTHKON8zBPnDAtxQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iryZ0LJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iryZ0LJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C7EC4CEC2;
	Wed,  2 Oct 2024 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878212;
	bh=jbVM7d/BuwKcWOZs7WABmD5EdVWfBGOWswsqEgu1NfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iryZ0LJnW9qxiPAzjxzFGqRddYUaCL9b3kqupVks5ZPfb31Y7odSrBn9mO4e8hnlX
	 YDHBW0ai0Z1RxAGWb49dd92zlBaOyqfT+7fa/ZGy4pRLm1ODFlPFUZ7ZkP76l9EW0v
	 H5ykvwe5uO8t38LOJm7t5FoOfC6MN7nGBcCVA2U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Ahern <dsa@cumulusnetworks.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Junhao He <hejunhao3@huawei.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yang Jihong <yangjihong@bytedance.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 305/634] perf time-utils: Fix 32-bit nsec parsing
Date: Wed,  2 Oct 2024 14:56:45 +0200
Message-ID: <20241002125823.147951535@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 38e2648a81204c9fc5b4c87a8ffce93a6ed91b65 ]

The "time utils" test fails in 32-bit builds:
  ...
  parse_nsec_time("18446744073.709551615")
  Failed. ptime 4294967295709551615 expected 18446744073709551615
  ...

Switch strtoul to strtoull as an unsigned long in 32-bit build isn't
64-bits.

Fixes: c284d669a20d408b ("perf tools: Move parse_nsec_time to time-utils.c")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yang Jihong <yangjihong@bytedance.com>
Link: https://lore.kernel.org/r/20240831070415.506194-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/time-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/time-utils.c b/tools/perf/util/time-utils.c
index 3024439216816..1b91ccd4d5234 100644
--- a/tools/perf/util/time-utils.c
+++ b/tools/perf/util/time-utils.c
@@ -20,7 +20,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 	u64 time_sec, time_nsec;
 	char *end;
 
-	time_sec = strtoul(str, &end, 10);
+	time_sec = strtoull(str, &end, 10);
 	if (*end != '.' && *end != '\0')
 		return -1;
 
@@ -38,7 +38,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 		for (i = strlen(nsec_buf); i < 9; i++)
 			nsec_buf[i] = '0';
 
-		time_nsec = strtoul(nsec_buf, &end, 10);
+		time_nsec = strtoull(nsec_buf, &end, 10);
 		if (*end != '\0')
 			return -1;
 	} else
-- 
2.43.0



