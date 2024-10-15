Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9571D4154;
	Tue, 15 Oct 2024 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992794; cv=none; b=SlIddUR4RzLLtPvonOO9Jd0Ixffp3RQr1svXyqXc4T8HkDwxIbrctwWGH+biejk9w66XUK7WCMiLH9bB2ov6uDoDSzEV/T074PjhE8leiIdz7vkz+KimVAWcVCNjppVRBYRvGXlf8OOwGehtM3hl9USMRp5h3RrNGBs+cVfb48o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992794; c=relaxed/simple;
	bh=ynPTKy9HC7D+BMMvggHLWYba/UMpSOZEMIJXpVfYAq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0X2zD61+bm2xOf7CyHadib9tM8RWT9gvPZjTDvtxNgqFLzMQ9/VmLOTnK8HU1xHRU0T5na9HiTVEXqI2cRaH3xMEMR4EbpAMh5+6AXacrPVl+Gtj3vMKtdP0+KqDPyClTzwxYg1udxbJ995LjUfNSkkkAte0K7lg61jzS0aGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPe/gHFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPe/gHFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56954C4CEC6;
	Tue, 15 Oct 2024 11:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992794;
	bh=ynPTKy9HC7D+BMMvggHLWYba/UMpSOZEMIJXpVfYAq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPe/gHFz1xMWnOJPkuKic0rh7g764tP7VOK7HRSCQ16W/hNodXegXDRhrI7TcFNkB
	 tglTWQmcAMgLBz7PGiSaOXjxXJe18NFjq7k7PZF6Mg67kFSqt3FAYfFatJu5bgC7WA
	 Vsi9yEz6w2Ztyjva5EiswKNWmAVNWBCkTSJPCfJc=
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
Subject: [PATCH 5.15 220/691] perf sched timehist: Fix missing free of session in perf_sched__timehist()
Date: Tue, 15 Oct 2024 13:22:48 +0200
Message-ID: <20241015112449.091634342@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 635a6b5a9ec97..7ef1fa6821ae3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3027,7 +3027,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	if (perf_time__parse_str(&sched->ptime, sched->time_str) != 0) {
 		pr_err("Invalid time string\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (timehist_check_attr(sched, evlist) != 0)
-- 
2.43.0



