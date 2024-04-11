Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FF1E48E;
	Thu, 11 Apr 2024 10:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832635; cv=none; b=pN5BI1BtHo1FkavUyRtLLhsWwgXbhLkylJX4uKrVAwHJFzYCRfT4R7dCiqAODuc/5AnoQhIUQ7HgiJB8LZC1ZRNP9rmMm6RmZ2OtAQXbfTNOijenp9zxdBBzrUMJVxZDHZ2mzDQ0bUOeDQE8alf67xjAeYg5ZyNZM/JaDjWh3+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832635; c=relaxed/simple;
	bh=Os7XymKyKNxvQryzYgFYr/gDeAuXDf16XF4WwQrKF+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqOpKI2QjYrm40fhDaXIR0iDAzOKW4rqgRVUaFAQjk812FVy0pTsr2B2yc4/Dxc7EYVo+CcSNNrr5HzuFYdRFRf3eo0FxhNBYT9B6yx9t8PjawIHhlITgY+jMSN6Ef2aYHC9xXz7SMXmqivHRRTeRUEazP9e7KmYFrpDLZlCsBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iutwVdGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iutwVdGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2918C433F1;
	Thu, 11 Apr 2024 10:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832635;
	bh=Os7XymKyKNxvQryzYgFYr/gDeAuXDf16XF4WwQrKF+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iutwVdGopDprZHw0uBPzGUGtxOx4kpkAdN6sHc556mktR/vOq7C80etYtGkzA3otF
	 s03KiOtnEZmG6zufsxXA7UcH+N+89gnlxi6ZgqTDifgEmFMgyVUjfa3YiqnRwM5pYE
	 T+zeybMIRp4UpVV+Aa6hAPYMqasIbWzCZ5WZ04T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/57] libperf evlist: Avoid out-of-bounds access
Date: Thu, 11 Apr 2024 11:57:40 +0200
Message-ID: <20240411095408.968049347@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1947b92464c3268381604bbe2ac977a3fd78192f ]

Parallel testing appears to show a race between allocating and setting
evsel ids. As there is a bounds check on the xyarray it yields a segv
like:

```
AddressSanitizer:DEADLYSIGNAL

=================================================================

==484408==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000010

==484408==The signal is caused by a WRITE memory access.

==484408==Hint: address points to the zero page.

    #0 0x55cef5d4eff4 in perf_evlist__id_hash tools/lib/perf/evlist.c:256
    #1 0x55cef5d4f132 in perf_evlist__id_add tools/lib/perf/evlist.c:274
    #2 0x55cef5d4f545 in perf_evlist__id_add_fd tools/lib/perf/evlist.c:315
    #3 0x55cef5a1923f in store_evsel_ids util/evsel.c:3130
    #4 0x55cef5a19400 in evsel__store_ids util/evsel.c:3147
    #5 0x55cef5888204 in __run_perf_stat tools/perf/builtin-stat.c:832
    #6 0x55cef5888c06 in run_perf_stat tools/perf/builtin-stat.c:960
    #7 0x55cef58932db in cmd_stat tools/perf/builtin-stat.c:2878
...
```

Avoid this crash by early exiting the perf_evlist__id_add_fd and
perf_evlist__id_add is the access is out-of-bounds.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240229070757.796244-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c                  | 18 ++++++++++++------
 tools/lib/perf/include/internal/evlist.h |  4 ++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 5146ff0fa078c..6aa1c35273a18 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -224,10 +224,10 @@ u64 perf_evlist__read_format(struct perf_evlist *evlist)
 
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
-				 int cpu, int thread, u64 id)
+				 int cpu_map_idx, int thread, u64 id)
 {
 	int hash;
-	struct perf_sample_id *sid = SID(evsel, cpu, thread);
+	struct perf_sample_id *sid = SID(evsel, cpu_map_idx, thread);
 
 	sid->id = id;
 	sid->evsel = evsel;
@@ -245,21 +245,27 @@ void perf_evlist__reset_id_hash(struct perf_evlist *evlist)
 
 void perf_evlist__id_add(struct perf_evlist *evlist,
 			 struct perf_evsel *evsel,
-			 int cpu, int thread, u64 id)
+			 int cpu_map_idx, int thread, u64 id)
 {
-	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
+	if (!SID(evsel, cpu_map_idx, thread))
+		return;
+
+	perf_evlist__id_hash(evlist, evsel, cpu_map_idx, thread, id);
 	evsel->id[evsel->ids++] = id;
 }
 
 int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 			   struct perf_evsel *evsel,
-			   int cpu, int thread, int fd)
+			   int cpu_map_idx, int thread, int fd)
 {
 	u64 read_data[4] = { 0, };
 	int id_idx = 1; /* The first entry is the counter value */
 	u64 id;
 	int ret;
 
+	if (!SID(evsel, cpu_map_idx, thread))
+		return -1;
+
 	ret = ioctl(fd, PERF_EVENT_IOC_ID, &id);
 	if (!ret)
 		goto add;
@@ -288,7 +294,7 @@ int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	id = read_data[id_idx];
 
 add:
-	perf_evlist__id_add(evlist, evsel, cpu, thread, id);
+	perf_evlist__id_add(evlist, evsel, cpu_map_idx, thread, id);
 	return 0;
 }
 
diff --git a/tools/lib/perf/include/internal/evlist.h b/tools/lib/perf/include/internal/evlist.h
index f366dbad6a88c..49b17b2b3923f 100644
--- a/tools/lib/perf/include/internal/evlist.h
+++ b/tools/lib/perf/include/internal/evlist.h
@@ -119,11 +119,11 @@ u64 perf_evlist__read_format(struct perf_evlist *evlist);
 
 void perf_evlist__id_add(struct perf_evlist *evlist,
 			 struct perf_evsel *evsel,
-			 int cpu, int thread, u64 id);
+			 int cpu_map_idx, int thread, u64 id);
 
 int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 			   struct perf_evsel *evsel,
-			   int cpu, int thread, int fd);
+			   int cpu_map_idx, int thread, int fd);
 
 void perf_evlist__reset_id_hash(struct perf_evlist *evlist);
 
-- 
2.43.0



