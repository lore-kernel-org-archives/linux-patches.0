Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89B1C07C9;
	Tue, 15 Oct 2024 13:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997355; cv=none; b=Fd/3w9PwN5uQ7hzZ0j0+kqJOxYwm4DbYbnuIxE8jQ+f3q3S8MmEm0Vkl/uDOWXB+6CQ/kA2HZiQ2AajZo1z/MLsW7ZUqpPJ11n3eCtg+o3DLDbfE+ZbFmwklBhnJfuimIiojj6U2p0A8zduUQMbENRYgrS8zUYZycH9AKVIgmdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997355; c=relaxed/simple;
	bh=BYMsLw8KzQP1EjQEeyU+mHwVbCN6EFzsEeqzcpTIGMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmrWSByilUXJzSLX1eebqeLlWFrcvVJXqHf7hQaFFcBg5b9Dcb1W6rJLO+41xMAQbKdoN+PfUh7h1IONaE5j4V6n/kI/9UtOXo/9xQQnP04pSbQciJzGu9YD4l5v4a4XFhTo0HmGjBoI+NlRZO2sGUCMrq/F24irLFa97dOswYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iysAnpxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iysAnpxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8175FC4CECE;
	Tue, 15 Oct 2024 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997355;
	bh=BYMsLw8KzQP1EjQEeyU+mHwVbCN6EFzsEeqzcpTIGMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iysAnpxwrFAqPSdEX3YroYFUl2rLyCCo26Z6asyF9OM3Li/7L4BkF29f417BRJE/3
	 yWczOptRb4h0NMqa+xfr7mmO2kap/DqcvMA6MTTHOvC22lteAHAakktJlQUVMDOfYt
	 PrTTZ12TdiQlEyxeHMvh5gcSLwqvsTIBQJeYtHjA=
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
Subject: [PATCH 5.10 158/518] perf sched timehist: Fix missing free of session in perf_sched__timehist()
Date: Tue, 15 Oct 2024 14:41:02 +0200
Message-ID: <20241015123923.100799337@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02e5774cabb6e..51ba1c73ab718 100644
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



