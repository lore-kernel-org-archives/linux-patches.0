Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D989376;
	Wed,  2 Oct 2024 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876110; cv=none; b=VYwBUgqCuzgUnBqqB1J4ojzKMxdSpMlcP1m7tLjXI0Q0qXv+C84oKisEDSPZ5n6+c8Jp/8winSErgt6U0X3zhIgDgQ4Pddr4yYeIAjffXYr8dr0gnQqBjAuGOrrjvu64MfLJoMKZju5zGWAmYDUw9nDlCk547a15OvKpjRThSDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876110; c=relaxed/simple;
	bh=C5uPzb9Cgz9mleIjK8ulWRllVvA+MEDpPyfbjGUrgzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAcuVOR+Zq1hHTYz6gbGrmE8ocQXFd3JGzSxrnhSXpEFTLdxmJ5WligSYEYi5pXOA438HmlSDoc75jX/v5mFWvjfuR+V8akj0ay0G7rlz/X0sUJKk+XVHLBKRQfWnxnTpBQokwNgnDpOpjAv1XwAoFk+ywECFM4F/bP4Ec92X+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5oA/2GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5oA/2GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596B2C4CEC5;
	Wed,  2 Oct 2024 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876109;
	bh=C5uPzb9Cgz9mleIjK8ulWRllVvA+MEDpPyfbjGUrgzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5oA/2GT6J4nVtLkvlFAtJN1pIsPVCY3BpV+Yl+9rpnN0j8Ro21J1G4y3ySYd+FYi
	 ljymN0cxPcfheE/tbBEgYGPKZNjYBLUIacj0CJuAqTZWhULLsKFLlM5WwjC1pjnplF
	 2Kvh7WC+C1Wn+WWFNlruHPz6dFnjCsbe0YFW+Ayk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong@bytedance.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	David Ahern <dsa@cumulusnetworks.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 332/695] perf sched timehist: Fix missing free of session in perf_sched__timehist()
Date: Wed,  2 Oct 2024 14:55:30 +0200
Message-ID: <20241002125835.703025803@linuxfoundation.org>
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

From: Yang Jihong <yangjihong@bytedance.com>

[ Upstream commit 6bdf5168b6fb19541b0c1862bdaa596d116c7bfb ]

When perf_time__parse_str() fails in perf_sched__timehist(),
need to free session that was previously created, fix it.

Fixes: 853b74071110bed3 ("perf sched timehist: Add option to specify time window of interest")
Signed-off-by: Yang Jihong <yangjihong@bytedance.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240806023533.1316348-1-yangjihong@bytedance.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 8750b5f2d49b4..928b9041535d3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3121,7 +3121,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	if (perf_time__parse_str(&sched->ptime, sched->time_str) != 0) {
 		pr_err("Invalid time string\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (timehist_check_attr(sched, evlist) != 0)
-- 
2.43.0



