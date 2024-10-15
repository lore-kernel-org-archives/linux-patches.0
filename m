Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3EB1D4154;
	Tue, 15 Oct 2024 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992797; cv=none; b=qmlizCGVoE2O+x7mZIGm/1Kg/+2JsA7pG+1C+0rUFkSjA/IelFLzDyoW2oHsIRnj3NTAdQyXHxadIAHtzkPeHTNgVdK2Jhp3mB4Gigude51DgaA3p/gN8IO8nUDlUM7FOSbY/eghzSqzhUFoPFut9ajpOnHtTs2ZTkJz+/WMigM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992797; c=relaxed/simple;
	bh=l8pspx+aVKERBmQdGSuauXEE62WRAWl3auihnuOOHAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuaxovOpsTDuljX/7aqvb/yF0soBPEpXsU7TbN3eP+Fw0qdnMq/CzRwAqfseYIyeeg+G8bOl8lchCERNYEhGeu/Aj1YCT++Gu4cRzEPM6LmV/A2LzLGF8/99hW8uO9QDBnRUhAHkA0eya+PAcrdah6bqvgrbeyqYJIGf5Bo9fcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0ObS1Ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0ObS1Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8B4C4CEC6;
	Tue, 15 Oct 2024 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992797;
	bh=l8pspx+aVKERBmQdGSuauXEE62WRAWl3auihnuOOHAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0ObS1Ld3+atNK2mO/R7ZePHKX72Ka0H48EN8GH0lr+3A4j0+xx0DnV8fiOXUZrcS
	 579qCHXYZSIuLDzdeBIRibkxgtyOX661TfVfYDRK1OyNruCDV/K132Tzl34caeYNV5
	 kOC5DlFbDbRFZoPwA6+d4NxuuEOq0VYyk8zHD9nU=
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
Subject: [PATCH 5.15 221/691] perf sched timehist: Fixed timestamp error when unable to confirm event sched_in time
Date: Tue, 15 Oct 2024 13:22:49 +0200
Message-ID: <20241015112449.131425154@linuxfoundation.org>
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
index 7ef1fa6821ae3..19e96141e7b42 100644
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



