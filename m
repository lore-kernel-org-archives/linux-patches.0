Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A07FBE1;
	Mon, 11 Dec 2023 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCcFHG+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2457C433C8;
	Mon, 11 Dec 2023 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319793;
	bh=3Q1qSJG6tZO+o5B7q46I66UC6RXGudBbUOy4o4pQWFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCcFHG+fydbaUKBtf1/mYnizwyf0hgC2actoM5U/OCbla5sLkus67+H4t62tWzA9i
	 9Gpxe8TwNzQl++Ep+vUwva8nmS+1jQpIq4CfNDZ6S1wUTdIEVcEH5iKjPQctvrM8o/
	 wSBg0WDer7/VhwUoyZ4l6QU82sCp8wyMy4HPg8fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Will Deacon <will@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-arm-kernel@lists.infradead.org,
	Namhyung Kim <namhyung@kernel.org>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>
Subject: [PATCH 6.6 234/244] perf metrics: Avoid segv if default metricgroup isnt set
Date: Mon, 11 Dec 2023 19:22:07 +0100
Message-ID: <20231211182056.532304701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

commit e2b005d6ec0e738df584190e21d2c7ada37266a0 upstream.

A metric is default by having "Default" within its groups. The default
metricgroup name needn't be set and this can result in segv in
default_metricgroup_cmp and perf_stat__print_shadow_stats_metricgroup
that assume it has a value when there is a Default metric group. To
avoid the segv initialize the value to "".

Fixes: 1c0e47956a8e ("perf metrics: Sort the Default metricgroup")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-and-tested-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: James Clark <james.clark@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: stable@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20231204182330.654255-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/metricgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 0484736d9fe4..ca3e0404f187 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -225,7 +225,7 @@ static struct metric *metric__new(const struct pmu_metric *pm,
 
 	m->pmu = pm->pmu ?: "cpu";
 	m->metric_name = pm->metric_name;
-	m->default_metricgroup_name = pm->default_metricgroup_name;
+	m->default_metricgroup_name = pm->default_metricgroup_name ?: "";
 	m->modifier = NULL;
 	if (modifier) {
 		m->modifier = strdup(modifier);
-- 
2.43.0



