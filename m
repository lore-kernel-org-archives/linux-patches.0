Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788BB1D26E3;
	Wed,  2 Oct 2024 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879840; cv=none; b=CVRMQswTATxGnLT+TVY2+waO9chntUtDp/Nb+xXik3cEm28Dg8mphdSD1n4/445tjCgW4C+tQ6Sc9SpDMDcNigVVJmeOAHKmuihLLw4qm1nhwBtTRqdac1bZtGEdh7NbYZewlj3ww3IbvL9eRKmRUsvVa6WX/FLl+7MMxQXr23Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879840; c=relaxed/simple;
	bh=f32Fkn9uy5RYS1/H79l+tpJGpByw8ELLikoAOCkTHOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOO0gwFyD/tw4qkfx2eZNS0b3qx2lzuy6DKcXMBQCgSGe+Q2Wpp0F82Mj79YxT85fIRCc6N0493ptwUcYQe3bJQa/GmyLROTdBT+TzIZ+eKXQVZercQUJDKACtCCc3fO5ExizeX5ZOOk/F16MwNvqbk5QoQyKZeV1zulLucAbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU1P8wHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU1P8wHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8A8C4CEC2;
	Wed,  2 Oct 2024 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879840;
	bh=f32Fkn9uy5RYS1/H79l+tpJGpByw8ELLikoAOCkTHOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU1P8wHSdQM3nDj7LF1iEl4MnedBACck7X73KsXC5vOA4Mou6tGsvMAzHy/0AnI3y
	 Ne/9eNMtUFJSril55DG60cvOFkZDVVUSwb0hMWkMcZSBgkrk/NNRPnSWWW2KC8eTbb
	 SQzAuAn0Es/fv0nC72RnwU85R1jR/seCH+qpvOSc=
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
Subject: [PATCH 6.6 256/538] perf time-utils: Fix 32-bit nsec parsing
Date: Wed,  2 Oct 2024 14:58:15 +0200
Message-ID: <20241002125802.362280458@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



