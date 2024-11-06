Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF2D1E04AD;
	Wed,  6 Nov 2024 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898048; cv=none; b=QIsnShrhnlflB/A8JObjbHQ/D81Kc73jGJJbaCXX05tGoIaRbv6D9Q6D7FXppAL0hQ74u2O3/iOcrK0/MgNB+nanm2j31VuE9YMxGEPERndY0RUa266tFK5Ajw5idnfiU5H3VQDeO4PfNZUPNoK6dmFuuVyRi0ePUxo7o2oCNZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898048; c=relaxed/simple;
	bh=gLOrQq+g8uHCivL7FgTQ/4Au2rtenjlGW76iKZ2PKbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaBZYUow/K44lzfRZ07irzta6H6yuLgyH1AlGN8vNyFzBtTewaGKFo4ndHKIkwzqWep/EmxEnzAY/g4JKz/A5KEis/deRFcBrca4+85khPF4C3lWF2HfK+vyzEMZQ421sgpEU+rzF4FlhoYlvjZRzTjIhbJ3np4aEck8NmoDzmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBanb65U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBanb65U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05220C4CECD;
	Wed,  6 Nov 2024 13:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898047;
	bh=gLOrQq+g8uHCivL7FgTQ/4Au2rtenjlGW76iKZ2PKbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBanb65UARuE4srjCrayxX1gxqSp8sku3U4bibGG6XbiKDy8cVk39eiGPx4W8SxMt
	 dzcVjEnrm50601QJLMXMomrfZSuKSJXtY81cS2bBMLSOFDFNxYn9HyzTvSzh26ElRm
	 7JzhINCHCOgMF94xrSgcL8y1wgDUwwLIio27qNHs=
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
Subject: [PATCH 5.4 105/462] perf sched timehist: Fix missing free of session in perf_sched__timehist()
Date: Wed,  6 Nov 2024 12:59:58 +0100
Message-ID: <20241106120334.099736227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0826893098ce4..9e2c7779f5b0a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3000,7 +3000,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 
 	if (perf_time__parse_str(&sched->ptime, sched->time_str) != 0) {
 		pr_err("Invalid time string\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (timehist_check_attr(sched, evlist) != 0)
-- 
2.43.0



