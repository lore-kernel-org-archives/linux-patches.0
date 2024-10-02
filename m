Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55941CF5C6;
	Wed,  2 Oct 2024 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876179; cv=none; b=VX5Q7jghUFDH6CEKZELjvX0U37H1O+Frt4MYnOw5gZ5f6aEy/zTvIEMXgvgwdEXQNWEVu8uljvdF8+BZxJKdEjq6K8zySTLXYp21htbI0xOtt2GPwuLSI7U4g/RYBwudQW9eB3FcyFAVnVbQ+beOSKGyCtBVCnIITnof6JPpiXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876179; c=relaxed/simple;
	bh=W7bm4M8IVFg8K7TpWJQEEZjG+K+UmkPSjA8GArW4Uhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUBv4//fldkDMGOg1u5HWHMuGcNRZG6syYGy5kh8pE/ijl6GzcWlkOE/QxKIwmB8JFlbSxzRoF16WCuJhopZdJOcvFehGgHKRZ24Ti6GxAM2NegEKXswYxdRd171l5NoHNrxcNQOT0KsqXVEsd1y0A5ao0FxK06xCDUpo2f3l9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nl2KiuNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nl2KiuNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A841C4CEC5;
	Wed,  2 Oct 2024 13:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876179;
	bh=W7bm4M8IVFg8K7TpWJQEEZjG+K+UmkPSjA8GArW4Uhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nl2KiuNfSW6pLrf9yyavKXOlWXtdHuNjz5k+6Q5Rmh+EkDPhekU8ZR+SB24KX1V5z
	 QMJGFFLBfdKuhbzzxErLiUiSv4AE6utC6dMOalYTQY8B20HX3YVU46+Gj95uEKr+vA
	 I1OLOzpsvxGPtuBNUz8TX/6DDTFihSQT6F0abeaw=
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
Subject: [PATCH 6.11 325/695] perf mem: Free the allocated sort string, fixing a leak
Date: Wed,  2 Oct 2024 14:55:23 +0200
Message-ID: <20241002125835.421987655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 863fcd735daee..93413cfcd585a 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -372,6 +372,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 		rep_argv[i] = argv[j];
 
 	ret = cmd_report(i, rep_argv);
+	free(new_sort_order);
 	free(rep_argv);
 	return ret;
 }
-- 
2.43.0



