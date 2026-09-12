Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FEF299920;
	Sat, 12 Sep 2026 12:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215032; cv=none; b=HXzp6NhyS08yKgUJPacJu1iY86iWjiUHGYATOwixp83CzOE7YCCOOAZ9Rd9cetZ5ZQDm1+4BikBN58rPfuJNgK3XG/+Y4xl4Tjmbgdu9ch+qlDXlOM8j39wePkD1xjGhgsne9z2XX8zu6xXIlvtcU/ZdjHKpNUTlN03pN9apCWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215032; c=relaxed/simple;
	bh=tHJH21qyfj1Bw9gcEsXxOlafJekpUmRXwPaVf69Lw54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLnTAiKX8MPxPuhGvLceib8cntra4tinUDu1WjlbgAQmqjndJlAl6/1vRd1VWV0m7Cs2lZpZVAJ5FMfQ8dIpLHfh8Fd5yro0VxRIBJT0YrX67CyzwuGKRq1ZExrfYWamn3p245H13nJfV+k4EX1+7WJJd87BxUA2ov/fPnCEUWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOmFNJ3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOmFNJ3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082E71F000FF;
	Sat, 12 Sep 2026 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215031;
	bh=+/FIskbNPkltn8TcmUg7Ad9MSDyO0d/JaDf3nBa4PrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOmFNJ3IajXineDDKJoCZbWk4P/0mUGzvYvX1t3ULzgH6xp6u9aCtgS/SJzXjECek
	 L2zNTFoUZVnSA7de8KrA8oXhV5NWYuZJt/4Pl3edF69RhShPtukxMa2CjgyeKJwLiu
	 WHZZgXrSZ7QB6h8WKe57BceqeeulgZibEZGxiar8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0448/1376] perf data convert json: Fix trace_seq memory leak in process_sample_event()
Date: Sat, 12 Sep 2026 08:47:54 +0200
Message-ID: <20260912065617.517645162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit dcb87c88952046ef43cb5ba3a5b95eb29c362a16 ]

Unlike the in-kernel trace_seq which uses a statically allocated buffer,
the userspace traceevent library's trace_seq uses a dynamically allocated
one. Therefore, every trace_seq_init() call must be paired with a
trace_seq_destroy(), otherwise it produces a memory leak.

In process_sample_event(), a trace_seq is initialized for each field when
formatting tracepoint raw_data, but the matching trace_seq_destroy() is
never called, leaking memory for every field of every sample processed.

Add the missing trace_seq_destroy() after using the trace_seq buffer to
properly free the allocated memory.

Detected with Valgrind on a perf.data file with 2,729 tracepoint samples:
  Before: definitely lost: 55,537,664 bytes in 13,559 blocks
  After:  definitely lost: 0 bytes in 0 blocks

Fixes: 9d895e468429 ("perf data: Add tracepoint fields when converting to JSON")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data-convert-json.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/data-convert-json.c b/tools/perf/util/data-convert-json.c
index 20bfb0884e9ea..395b231cf16c4 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -242,6 +242,7 @@ static int process_sample_event(const struct perf_tool *tool,
 				trace_seq_init(&s);
 				tep_print_field(&s, sample->raw_data, fields[i]);
 				output_json_key_string(out, true, 3, fields[i]->name, s.buffer);
+				trace_seq_destroy(&s);
 
 				i++;
 			}
-- 
2.53.0



