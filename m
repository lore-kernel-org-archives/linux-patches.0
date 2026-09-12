Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC666282F1B;
	Sat, 12 Sep 2026 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199053; cv=none; b=TYuhc6jO/2VEFPsc6Nu697fbrU9eNhEIqboAbup2ZJaZELsxNISv8XiMZXmEx2ah4++oKSUJWkeGLwaWcYHfo1475OKLlcIzWKaRkJzIaiMPGrocXflDC1pqEtJKWOCzDAJ7YeL0DIXVCbx/ROO6B6EIJKwh7kAEycrwr6suvXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199053; c=relaxed/simple;
	bh=qcww3a2Un2sNQAbLITeHFyij+JnPX7xWEY9b+ItBhj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv+/XlAFmI+H4oW5cjnA/1plOMqIbHJ7df8V9Jj/JrSmajpcPK3Y5qi4h2tddMX4owCKcb1gpDk6KnHfZPdW/m88tbqGcpJ/PjyQmtebmYcOSoYAPRQj0fDPw7gHhBNXaqrgiWiJckMJ01ezmDmNNu8Wpf/ma3SZHvNMRuWgHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ep/SDuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ep/SDuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D277F1F000FF;
	Sat, 12 Sep 2026 07:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199052;
	bh=59ZCJ4+KvAQwhMv81IqTcfUVeeuuLpdAshEFq1wilOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Ep/SDuMRWHyMXaCaWHELL8vGRonGNjB1gCRlUyv6E8ks0wy7vZGuhJGfrSJoL+yz
	 xZKy3DunRAASv5WMGtvDLGsYZxn+BYbrqm9VCnQrNmffXtTci2UR/T8KVw1iY1XpyQ
	 KFsKZlhU/fKwwzdGj8jtUX+yc/odEcwm3e6wGAFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0463/1815] perf stat: Fix duplicate output with --for-each-cgroup
Date: Sat, 12 Sep 2026 08:36:53 +0200
Message-ID: <20260912065659.758490590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit c16af17927e0b9105f2964338f9341e0faf7edaa ]

Currently it produces following output with duplicate events when
 --for-each-cgroup option is used.  It seems perf stat adds them when
it handles default events but didn't copy some fields in evsel__clone().

  $ sudo perf stat -a --for-each-cgroup / true

   Performance counter stats for 'system wide':

           8,440,165      duration_time                    /
           8,439,895      duration_time                    /
           8,440,015      duration_time                    /
           8,440,024      duration_time                    /
           8,440,075      duration_time                    /
           8,440,095      duration_time                    /
                 330      context-switches                 /             #    679.4 cs/sec  cs_per_second
              485.69 msec cpu-clock                        /             #     57.5 CPUs  CPUs_utilized
                  70      cpu-migrations                   /             #    144.1 migrations/sec  migrations_per_second
                  71      page-faults                      /             #    146.2 faults/sec  page_faults_per_second
          12,183,711      branch-misses                    /             #     10.9 %  branch_miss_rate         (5.15%)
         111,981,297      branches                         /                                                       (5.15%)
          95,844,809      branches                         /             #    197.3 M/sec  branch_frequency     (35.49%)
          65,611,429      cpu-cycles                       /             #      0.1 GHz  cycles_frequency       (98.32%)
          24,170,987      cpu-cycles                       /                                                       (95.12%)
          18,552,509      instructions                     /             #      0.8 instructions  insn_per_cycle  (95.12%)
          22,405,293      cpu-cycles                       /                                                       (64.78%)
           6,840,383      stalled-cycles-frontend          /             #     0.31 frontend_cycles_idle        (64.78%)
       <not counted>      cpu-cycles                       /
     <not supported>      stalled-cycles-backend           /             #      nan backend_cycles_idle
     <not supported>      stalled-cycles-backend           /             #      nan stalled_cycles_per_instruction
     <not supported>      instructions                     /
     <not supported>      stalled-cycles-frontend          /

         0.006546057 seconds time elapsed

  Some events weren't counted. Try disabling the NMI watchdog:
  	echo 0 > /proc/sys/kernel/nmi_watchdog
  	perf stat ...
  	echo 1 > /proc/sys/kernel/nmi_watchdog

But I'm worrying about opening same events multiple times.  Probably due
to grouping, but I'm not sure if it's beneficial in the end.  Without
duplication, it seems it won't cause multiplexing (assuming no other
users at the same time).

Fixes: a3248b5b5427d ("perf jevents: Add metric DefaultShowEvents")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6b747b0864b38..a8119f56100a3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -612,7 +612,13 @@ struct evsel *evsel__clone(struct evsel *orig)
 	evsel->sample_read = orig->sample_read;
 	evsel->collect_stat = orig->collect_stat;
 	evsel->weak_group = orig->weak_group;
+	evsel->bpf_counter = orig->bpf_counter;
 	evsel->use_config_name = orig->use_config_name;
+	evsel->skippable = orig->skippable;
+	evsel->dont_regroup = orig->dont_regroup;
+	evsel->default_metricgroup = orig->default_metricgroup;
+	evsel->default_show_events = orig->default_show_events;
+
 	evsel->pmu = orig->pmu;
 	evsel->first_wildcard_match = orig->first_wildcard_match;
 
@@ -621,6 +627,10 @@ struct evsel *evsel__clone(struct evsel *orig)
 
 	evsel->alternate_hw_config = orig->alternate_hw_config;
 
+	evsel->retire_lat = orig->retire_lat;
+	if (evsel->retire_lat)
+		evsel->retirement_latency = orig->retirement_latency;
+
 	return evsel;
 
 out_err:
-- 
2.53.0



