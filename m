Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35CC1EB5FD;
	Sat, 12 Sep 2026 07:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197896; cv=none; b=rIMXNMzr2KU3Hg5N+n7WNGqfOTrvnxTC3SNoYgJx23nDstxUThTld9uIn83Nyuz/v9j9cNNS2nnMn/CbXpwDTn7t2BXNbI+MCfSShsZPqZpXHsYMWmmVJ1kJeXokgtEhWt2geLJaQ4iTX1r6Vh/02IHyiNqts3nnH76fn9VyuzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197896; c=relaxed/simple;
	bh=YA/ju1pacLkUXfCJERd2YAY0QVZdcVLYqDKl3T6VDh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMM9UmnGNR/+YqmOzsYGtVcLccgzCm06sUtlCje6XfdB9VJBXyPjgsI1e/wF1YOIMj5mYD9M7zGjRlb52S0BJVPEE6vuoAOEcQFbXXtQIUDfMU2zdWoQyQQGFfUdQjXH56echvWoPH/ikaGohU8vyJwscfGY5+UfNNum5lLPBZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edZfCvCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edZfCvCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD01F000FF;
	Sat, 12 Sep 2026 07:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197894;
	bh=UOeBcfVyAlyWDVEe3ir+VI2jfo3dfl396TFD2uMflc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edZfCvCVgIg+foI5Ar4hzi4ywtLl9JKNc1UV5yOApoRpuVSDWVZ7ALzHE/lD2noMv
	 StNL0+h/z3wzut7bnSpqBDS8JJhm62V2vGGU8F0NHK3mU8/8LlBI9F2umbRQOKOc5U
	 Ergu8msLWSn8qWMOSUToizloFIxRd9Lfk4Adc+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0267/1815] perf data convert json: Fix trace_seq memory leak in process_sample_event()
Date: Sat, 12 Sep 2026 08:33:37 +0200
Message-ID: <20260912065655.238925179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 40412c3dbdb25..40888b7c44671 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -258,6 +258,7 @@ static int process_sample_event(const struct perf_tool *tool,
 				trace_seq_init(&s);
 				tep_print_field(&s, sample->raw_data, fields[i]);
 				output_json_key_string(out, true, 3, fields[i]->name, s.buffer);
+				trace_seq_destroy(&s);
 
 				i++;
 			}
-- 
2.53.0



