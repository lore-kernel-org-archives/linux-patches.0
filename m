Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7481BDC3;
	Mon, 14 Oct 2024 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917941; cv=none; b=aBeZ4QJSksPeHjLfYwRkrdosCfLzV7i3nAwR3BAeNo3fYOC7o/t982GGoFOBk0b0QTSWona+4cOyyC33trHUUf3wNUywdyFTFHWFC8MBUm1EQCj13uemotvn2UJRC6K202HLaMXF1FWoLMwSBKjSjYJfcs3Pb7Dk3q/mmK4JrmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917941; c=relaxed/simple;
	bh=bq7Uf8crbSf8V4sH+7niuNdHHoio9EeXpWw4eA/W6kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4J1C3t2BNSVN3CDJ0eP8ZtUUaGaEjyF1aK1A4ZZ3LrFZjX+KBU76i+flL196F8XFnQe1H+UGnFpc1/uQ27Xz9eEm3w8QYfbbi8a/5U7MOdQvl9KSXap3dybXDb7dv831BkkiOMweAyaQCSGIq1b2ZZIHBfMUAKhWKfIV9t9msU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGCVvMxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGCVvMxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13BAC4CEC3;
	Mon, 14 Oct 2024 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917941;
	bh=bq7Uf8crbSf8V4sH+7niuNdHHoio9EeXpWw4eA/W6kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGCVvMxMJmOjXrJ2xT6mEQg8MS1aWAL/+vnewb8QoO8BpX9mbCBJIRRmM1ryCZvA0
	 frCEUkfbjarcQdAWrJQJCLaXossiqb4m7bqX7bphyBwJ/gI8Hu8Xyf3D+r4o+wV2x4
	 LvtcsjKOGolfYWVjsRSoZhHD6GIBbeyshWJji+oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/798] perf mem: Free the allocated sort string, fixing a leak
Date: Mon, 14 Oct 2024 16:12:11 +0200
Message-ID: <20241014141224.880114656@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 3da209bb1177462b6fe8e3021a5527a5a49a9336 ]

The get_sort_order() returns either a new string (from strdup) or NULL
but it never gets freed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Fixes: 2e7f545096f954a9 ("perf mem: Factor out a function to generate sort order")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20240731235505.710436-3-namhyung@kernel.org
[ Added Fixes tag ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 923fb8316fdae..fbd05617c2ddd 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -368,6 +368,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 		rep_argv[i] = argv[j];
 
 	ret = cmd_report(i, rep_argv);
+	free(new_sort_order);
 	free(rep_argv);
 	return ret;
 }
-- 
2.43.0



