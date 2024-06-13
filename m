Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658581EEE0;
	Thu, 13 Jun 2024 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282301; cv=none; b=Gy3xo0ihLo8ozHSnie5EbYmLTYZnHGSJzv3reeCLrsGhLC+QkqivPKEbPObbMKGD08birXqALl28iyoomzD8skDV4Kn5oQ5ZxDh9nU9kHexV/H3kvQVnmQlVRhLOzJO8vybMQsmmUEK956AzEqzDPG73tl3Lj5oqtKfAr5wCF7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282301; c=relaxed/simple;
	bh=w8tu01ZpV+TY586ErRHk1IJ/gSDOqeuFJqcZla5KIxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMviVqeYhMa58h4+3HNfeeI94Kqt3ci8+urY4PNwC48hQF01yLSPLC3t/zz7OzqxsaGpMpDZpHIWGDQgoqwlGRd7AaKHGEG+YJLTVOK1EfuxZ2QFuZOt7ECLaDnaxw/Ndldqt/s6OhVeh409gqlUzFlt6zvI+/G2L4osljGan2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaNhEmzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaNhEmzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B337BC2BBFC;
	Thu, 13 Jun 2024 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282301;
	bh=w8tu01ZpV+TY586ErRHk1IJ/gSDOqeuFJqcZla5KIxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaNhEmzyWSMZRFeRE1sVkzU/k07uKNKojyPvpITtBSsnJ9TYKYNuZCfz2NyucyB2m
	 SIVZYHM0zH88a0vFbt8O6zI43xg9xpTK0lnopfik/6ehkyjzP4cPXviobo4XyVPrVz
	 XaQHQUGGji+aqPV+zSXNc56EhGawKqSy1khQZvrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/402] perf report: Avoid SEGV in report__setup_sample_type()
Date: Thu, 13 Jun 2024 13:33:08 +0200
Message-ID: <20240613113311.155836768@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

[ Upstream commit 45b4f402a6b782352c4bafcff682bfb01da9ca05 ]

In some cases evsel->name is lazily initialized in evsel__name(). If not
initialized passing NULL to strstr() leads to a SEGV.

Fixes: ccb17caecfbd542f ("perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508035301.1554434-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6583ad9cc7deb..35bf3b01d9cc7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -410,7 +410,7 @@ static int report__setup_sample_type(struct report *rep)
 		 * compatibility, set the bit if it's an old perf data file.
 		 */
 		evlist__for_each_entry(session->evlist, evsel) {
-			if (strstr(evsel->name, "arm_spe") &&
+			if (strstr(evsel__name(evsel), "arm_spe") &&
 				!(sample_type & PERF_SAMPLE_DATA_SRC)) {
 				evsel->core.attr.sample_type |= PERF_SAMPLE_DATA_SRC;
 				sample_type |= PERF_SAMPLE_DATA_SRC;
-- 
2.43.0



