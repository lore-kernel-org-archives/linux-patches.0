Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB13F1C07CC;
	Tue, 15 Oct 2024 13:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997358; cv=none; b=Slq7lFowH6XKocz45mFnUhVQ1K8C15G/o3bMWoj1CMx7FZMkd9K/LP/0wux7som0qUQWJTSqUFFZ4AJ/xZGzjG0ZaYHAwXZ4lDs2KQ4Z9aYZNZ4Ebyf+463WwAQG+cwQBEjkxdmXJYev5seoy6n40PLggbnX5lJPFG9auxZC5sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997358; c=relaxed/simple;
	bh=k2txvPkCfwWOAy3VkGk4xyV9/r5rJXjIv0m19jEVCQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUGAUQmYusunJ0+d9untnyXQzDQ8aNDnDeky17z8b2lunP74X1qPLkJL3eBsKq7MG9lXwa82xEdoXOwWXO9j6EU01/Y77lAGaGLnedLg4fjKvuDDX3DCe87DlbflYKiDZOmFmFdWWZ2ma1IRAReD2eac6tGOAsnGSGOYjQkLpXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmt4EWC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmt4EWC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95757C4CEC6;
	Tue, 15 Oct 2024 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997358;
	bh=k2txvPkCfwWOAy3VkGk4xyV9/r5rJXjIv0m19jEVCQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmt4EWC9n3VgESSuiU1xBW9bAScEm7MX6OBQ8GEz3QU3sbXAhqT1AsN1FsXLahRXT
	 t9GImFHNrPXCFC9+X3tEapNVoDuS8HKWTdNWOnuUo64UFcVjY1ea272U/q/JGqmywy
	 BJQJdzaDGcmwhOA5pTPzJ2qUGmetMAgt9NsBoKJc=
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
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/518] perf sched timehist: Fixed timestamp error when unable to confirm event sched_in time
Date: Tue, 15 Oct 2024 14:41:03 +0200
Message-ID: <20241015123923.138967232@linuxfoundation.org>
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

[ Upstream commit 39c243411bdb8fb35777adf49ee32549633c4e12 ]

If sched_in event for current task is not recorded, sched_in timestamp
will be set to end_time of time window interest, causing an error in
timestamp show. In this case, we choose to ignore this event.

Test scenario:

  perf[1229608] does not record the first sched_in event, run time and sch delay are both 0

  # perf sched timehist
  Samples of sched_switch event do not have callchains.
             time    cpu  task name                       wait time  sch delay   run time
                          [tid/pid]                          (msec)     (msec)     (msec)
  --------------- ------  ------------------------------  ---------  ---------  ---------
   2090450.763231 [0000]  perf[1229608]                       0.000      0.000      0.000
   2090450.763235 [0000]  migration/0[15]                     0.000      0.001      0.003
   2090450.763263 [0001]  perf[1229608]                       0.000      0.000      0.000
   2090450.763268 [0001]  migration/1[21]                     0.000      0.001      0.004
   2090450.763302 [0002]  perf[1229608]                       0.000      0.000      0.000
   2090450.763309 [0002]  migration/2[27]                     0.000      0.001      0.007
   2090450.763338 [0003]  perf[1229608]                       0.000      0.000      0.000
   2090450.763343 [0003]  migration/3[33]                     0.000      0.001      0.004

Before:

  arbitrarily specify a time window of interest, timestamp will be set to an incorrect value

  # perf sched timehist --time 100,200
  Samples of sched_switch event do not have callchains.
             time    cpu  task name                       wait time  sch delay   run time
                          [tid/pid]                          (msec)     (msec)     (msec)
  --------------- ------  ------------------------------  ---------  ---------  ---------
       200.000000 [0000]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0001]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0002]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0003]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0004]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0005]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0006]  perf[1229608]                       0.000      0.000      0.000
       200.000000 [0007]  perf[1229608]                       0.000      0.000      0.000

 After:

  # perf sched timehist --time 100,200
  Samples of sched_switch event do not have callchains.
             time    cpu  task name                       wait time  sch delay   run time
                          [tid/pid]                          (msec)     (msec)     (msec)
  --------------- ------  ------------------------------  ---------  ---------  ---------

Fixes: 853b74071110bed3 ("perf sched timehist: Add option to specify time window of interest")
Signed-off-by: Yang Jihong <yangjihong@bytedance.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240819024720.2405244-1-yangjihong@bytedance.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 51ba1c73ab718..4f8658f5f9dee 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2577,9 +2577,12 @@ static int timehist_sched_change_event(struct perf_tool *tool,
 	 * - previous sched event is out of window - we are done
 	 * - sample time is beyond window user cares about - reset it
 	 *   to close out stats for time window interest
+	 * - If tprev is 0, that is, sched_in event for current task is
+	 *   not recorded, cannot determine whether sched_in event is
+	 *   within time window interest - ignore it
 	 */
 	if (ptime->end) {
-		if (tprev > ptime->end)
+		if (!tprev || tprev > ptime->end)
 			goto out;
 
 		if (t > ptime->end)
-- 
2.43.0



