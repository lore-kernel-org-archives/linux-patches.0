Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D8B1DE8A5;
	Tue,  3 Dec 2024 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241639; cv=none; b=BIdasHuASPeKrI4Q04Am1XzCeYMTyCTZJIbtPLIBq7GM65McF7v/w7LfvpISCT+6ABL5L2nJexCvUfoz4gS2EbLYcQfF9zR83Rx2Nu7nTbH9hiKIjVrmOQEpQoYg+aNsnynIhzQab/tqdymHoIyAks1EtWp8YUZGx/pCMncFMLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241639; c=relaxed/simple;
	bh=RfEeNoP2ThHN5hwXj36cNd7N0CaTxOpkPhYehgrXj4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efn03SDrfaHlwk3CfvA7bH0+fG6aWq97ZeV72r4MvrcfrHrmdQNuyciIhk3JdY08nQ85qd2XIb21cka/jtOhDerYuvrs0yih4bfMoqRWjpSQEo/oOkIcTsCjF9W01OSVn4WJDihmA3pCAdJOS+UQfVVpmX+J/p4zuwptsQ1TzM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSA8A04M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSA8A04M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46862C4CECF;
	Tue,  3 Dec 2024 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241639;
	bh=RfEeNoP2ThHN5hwXj36cNd7N0CaTxOpkPhYehgrXj4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSA8A04MqAjyv/00E8FF9YXotVhtuvP424q5KOjX+PsorMkYsDV+0xXv4qyNpvK6C
	 Ab9O+ABHDhfC92uyAZ7IcxAYjsES2Pv2vb8dTuvB9Cx/QfmCSR+FF+AU9ww8P64fqx
	 RWJu5g4COHbIXwneenGEvRKWPfHDToYLAcVlm1Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	John Garry <john.g.garry@oracle.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 474/826] perf jevents: Dont stop at the first matched pmu when searching a events table
Date: Tue,  3 Dec 2024 15:43:21 +0100
Message-ID: <20241203144802.253432526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 8d7f85e323ea402005fa83ddbdf5d00292d77098 ]

The "perf all PMU test" fails on a Coffee Lake machine.

The failure is caused by the below change in the commit e2641db83f18
("perf vendor events: Add/update skylake events/metrics").

+    {
+        "BriefDescription": "This 48-bit fixed counter counts the UCLK cycles",
+        "Counter": "FIXED",
+        "EventCode": "0xff",
+        "EventName": "UNC_CLOCK.SOCKET",
+        "PerPkg": "1",
+        "PublicDescription": "This 48-bit fixed counter counts the UCLK cycles.",
+        "Unit": "cbox_0"
     }

The other cbox events have the unit name "CBOX", while the fixed counter
has a unit name "cbox_0". So the events_table will maintain separate
entries for cbox and cbox_0.

The perf_pmus__print_pmu_events() calculates the total number of events,
allocate an aliases buffer, store all the events into the buffer, sort,
and print all the aliases one by one.

The problem is that the calculated total number of events doesn't match
the stored events in the aliases buffer.

The perf_pmu__num_events() is used to calculate the number of events. It
invokes the pmu_events_table__num_events() to go through the entire
events_table to find all events. Because of the
pmu_uncore_alias_match(), the suffix of uncore PMU will be ignored. So
the events for cbox and cbox_0 are all counted.

When storing events into the aliases buffer, the
perf_pmu__for_each_event() only process the events for cbox.

Since a bigger buffer was allocated, the last entry are all 0.
When printing all the aliases, null will be outputted, and trigger the
failure.

The mismatch was introduced from the commit e3edd6cf6399 ("perf
pmu-events: Reduce processed events by passing PMU"). The
pmu_events_table__for_each_event() stops immediately once a pmu is set.
But for uncore, especially this case, the method is wrong and mismatch
what perf does in the perf_pmu__num_events().

With the patch,
$ perf list pmu | grep -A 1 clock.socket
   unc_clock.socket
        [This 48-bit fixed counter counts the UCLK cycles. Unit: uncore_cbox_0
$ perf test "perf all PMU test"
  107: perf all PMU test                                               : Ok

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/all/202407101021.2c8baddb-oliver.sang@intel.com/
Fixes: e3edd6cf6399 ("perf pmu-events: Reduce processed events by passing PMU")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Benjamin Gray <bgray@linux.ibm.com>
Cc: Xu Yang <xu.yang_2@nxp.com>
Cc: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241001021431.814811-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/empty-pmu-events.c | 2 +-
 tools/perf/pmu-events/jevents.py         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/empty-pmu-events.c b/tools/perf/pmu-events/empty-pmu-events.c
index c592079982fbd..873e9fb2041f0 100644
--- a/tools/perf/pmu-events/empty-pmu-events.c
+++ b/tools/perf/pmu-events/empty-pmu-events.c
@@ -380,7 +380,7 @@ int pmu_events_table__for_each_event(const struct pmu_events_table *table,
                         continue;
 
                 ret = pmu_events_table__for_each_event_pmu(table, table_pmu, fn, data);
-                if (pmu || ret)
+                if (ret)
                         return ret;
         }
         return 0;
diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index bb0a5d92df4a1..d46a22fb5573d 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -930,7 +930,7 @@ int pmu_events_table__for_each_event(const struct pmu_events_table *table,
                         continue;
 
                 ret = pmu_events_table__for_each_event_pmu(table, table_pmu, fn, data);
-                if (pmu || ret)
+                if (ret)
                         return ret;
         }
         return 0;
-- 
2.43.0



