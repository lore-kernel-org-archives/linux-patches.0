Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64180171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8811C433EF;
	Mon, 22 May 2023 19:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783779;
	bh=cbub/WuzpW8apRWPgbsfqYmzWdPLROE4q4Mnsb75sSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX/I4KvCiAU2WQHzx3U59kyC88jY1x7yo8vqLb0Z/Ks2Tb1Dv+HCSqtHzw6fCyfZR
	 p7HDfKjtEc4BJ4/UK0w8PTv+dcxStjYSfw0PJFPvK2OewFPqD6J4fYQN8vNQHL7+z0
	 w8J4IBY8dHO9/lqEgUImbhyTIJM5HFlY/BWhnoms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Renninger <trenn@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Wyes Karny <wyes.karny@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/292] cpupower: Make TSC read per CPU for Mperf monitor
Date: Mon, 22 May 2023 20:08:37 +0100
Message-Id: <20230522190409.965014704@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wyes Karny <wyes.karny@amd.com>

[ Upstream commit c2adb1877b76fc81ae041e1db1a6ed2078c6746b ]

System-wide TSC read could cause a drift in C0 percentage calculation.
Because if first TSC is read and then one by one mperf is read for all
cpus, this introduces drift between mperf reading of later CPUs and TSC
reading.  To lower this drift read TSC per CPU and also just after mperf
read.  This technique improves C0 percentage calculation in Mperf monitor.

Before fix: (System 100% busy)

              | Mperf              || RAPL        || Idle_Stats
 PKG|CORE| CPU| C0   | Cx   | Freq  || pack | core  || POLL | C1   | C2
   0|   0|   0| 87.15| 12.85|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   0| 256| 84.62| 15.38|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   1|   1| 87.15| 12.85|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   1| 257| 84.08| 15.92|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   2|   2| 86.61| 13.39|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   2| 258| 83.26| 16.74|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   3|   3| 86.61| 13.39|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   3| 259| 83.60| 16.40|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   4|   4| 86.33| 13.67|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   4| 260| 83.33| 16.67|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   5|   5| 86.06| 13.94|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   5| 261| 83.05| 16.95|  2695||168659003|3970468||  0.00|  0.00| 0.00
   0|   6|   6| 85.51| 14.49|  2695||168659003|3970468||  0.00|  0.00| 0.00

After fix: (System 100% busy)

             | Mperf              || RAPL        || Idle_Stats
 PKG|CORE| CPU| C0   | Cx   | Freq  || pack | core  || POLL | C1   | C2
   0|   0|   0| 98.03|  1.97|  2415||163295480|3811189||  0.00|  0.00| 0.00
   0|   0| 256| 98.50|  1.50|  2394||163295480|3811189||  0.00|  0.00| 0.00
   0|   1|   1| 99.99|  0.01|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   1| 257| 99.99|  0.01|  2375||163295480|3811189||  0.00|  0.00| 0.00
   0|   2|   2| 99.99|  0.01|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   2| 258|100.00|  0.00|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   3|   3|100.00|  0.00|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   3| 259| 99.99|  0.01|  2435||163295480|3811189||  0.00|  0.00| 0.00
   0|   4|   4|100.00|  0.00|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   4| 260|100.00|  0.00|  2435||163295480|3811189||  0.00|  0.00| 0.00
   0|   5|   5| 99.99|  0.01|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   5| 261|100.00|  0.00|  2435||163295480|3811189||  0.00|  0.00| 0.00
   0|   6|   6|100.00|  0.00|  2401||163295480|3811189||  0.00|  0.00| 0.00
   0|   6| 262|100.00|  0.00|  2435||163295480|3811189||  0.00|  0.00| 0.00

Cc: Thomas Renninger <trenn@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>

Fixes: 7fe2f6399a84 ("cpupowerutils - cpufrequtils extended with quite some features")
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../utils/idle_monitor/mperf_monitor.c        | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index e7d48cb563c0e..ae6af354a81db 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -70,8 +70,8 @@ static int max_freq_mode;
  */
 static unsigned long max_frequency;
 
-static unsigned long long tsc_at_measure_start;
-static unsigned long long tsc_at_measure_end;
+static unsigned long long *tsc_at_measure_start;
+static unsigned long long *tsc_at_measure_end;
 static unsigned long long *mperf_previous_count;
 static unsigned long long *aperf_previous_count;
 static unsigned long long *mperf_current_count;
@@ -169,7 +169,7 @@ static int mperf_get_count_percent(unsigned int id, double *percent,
 	aperf_diff = aperf_current_count[cpu] - aperf_previous_count[cpu];
 
 	if (max_freq_mode == MAX_FREQ_TSC_REF) {
-		tsc_diff = tsc_at_measure_end - tsc_at_measure_start;
+		tsc_diff = tsc_at_measure_end[cpu] - tsc_at_measure_start[cpu];
 		*percent = 100.0 * mperf_diff / tsc_diff;
 		dprint("%s: TSC Ref - mperf_diff: %llu, tsc_diff: %llu\n",
 		       mperf_cstates[id].name, mperf_diff, tsc_diff);
@@ -206,7 +206,7 @@ static int mperf_get_count_freq(unsigned int id, unsigned long long *count,
 
 	if (max_freq_mode == MAX_FREQ_TSC_REF) {
 		/* Calculate max_freq from TSC count */
-		tsc_diff = tsc_at_measure_end - tsc_at_measure_start;
+		tsc_diff = tsc_at_measure_end[cpu] - tsc_at_measure_start[cpu];
 		time_diff = timespec_diff_us(time_start, time_end);
 		max_frequency = tsc_diff / time_diff;
 	}
@@ -225,33 +225,27 @@ static int mperf_get_count_freq(unsigned int id, unsigned long long *count,
 static int mperf_start(void)
 {
 	int cpu;
-	unsigned long long dbg;
 
 	clock_gettime(CLOCK_REALTIME, &time_start);
-	mperf_get_tsc(&tsc_at_measure_start);
 
-	for (cpu = 0; cpu < cpu_count; cpu++)
+	for (cpu = 0; cpu < cpu_count; cpu++) {
+		mperf_get_tsc(&tsc_at_measure_start[cpu]);
 		mperf_init_stats(cpu);
+	}
 
-	mperf_get_tsc(&dbg);
-	dprint("TSC diff: %llu\n", dbg - tsc_at_measure_start);
 	return 0;
 }
 
 static int mperf_stop(void)
 {
-	unsigned long long dbg;
 	int cpu;
 
-	for (cpu = 0; cpu < cpu_count; cpu++)
+	for (cpu = 0; cpu < cpu_count; cpu++) {
 		mperf_measure_stats(cpu);
+		mperf_get_tsc(&tsc_at_measure_end[cpu]);
+	}
 
-	mperf_get_tsc(&tsc_at_measure_end);
 	clock_gettime(CLOCK_REALTIME, &time_end);
-
-	mperf_get_tsc(&dbg);
-	dprint("TSC diff: %llu\n", dbg - tsc_at_measure_end);
-
 	return 0;
 }
 
@@ -353,7 +347,8 @@ struct cpuidle_monitor *mperf_register(void)
 	aperf_previous_count = calloc(cpu_count, sizeof(unsigned long long));
 	mperf_current_count = calloc(cpu_count, sizeof(unsigned long long));
 	aperf_current_count = calloc(cpu_count, sizeof(unsigned long long));
-
+	tsc_at_measure_start = calloc(cpu_count, sizeof(unsigned long long));
+	tsc_at_measure_end = calloc(cpu_count, sizeof(unsigned long long));
 	mperf_monitor.name_len = strlen(mperf_monitor.name);
 	return &mperf_monitor;
 }
@@ -364,6 +359,8 @@ void mperf_unregister(void)
 	free(aperf_previous_count);
 	free(mperf_current_count);
 	free(aperf_current_count);
+	free(tsc_at_measure_start);
+	free(tsc_at_measure_end);
 	free(is_valid);
 }
 
-- 
2.39.2



