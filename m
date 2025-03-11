Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2EC25D8FF;
	Tue, 11 Mar 2025 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706380; cv=none; b=p61Z2rBrtATByQAwbnnpNGSRZy9faQo9BRYj6wnqOXLWso3sBqkhzG4HHCH22iX/9SO8n8Wc4IP/+VpuvHv80mRH7GrZA7as0FeiI533ZFz8S41kSrLKjBC5i5Kp8mYvOx52VrbeokweH24R47CrowL05M7Ocm572IdzRPLNgmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706380; c=relaxed/simple;
	bh=UiW1J0+llqVSMA8olZhYa1Cwhb6hMfUy83PewC0Gyzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L44dHfW7ZYVE/PAEGZe2zoy+BVfJPr9fBLMOLZkCb2y5+8X1wpyt1OfgmHaRbV0zH6ZPy4JvUp+KbBovBk3F27LuCz3hEH/V7Qq+UkAVNoRbDhqHQxXw0heu7sYisxN1ion9umeRyYJzLRIuzFLkusF9tEi2xklz+jFsIrSwhdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5PywHun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5PywHun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20791C4CEE9;
	Tue, 11 Mar 2025 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706380;
	bh=UiW1J0+llqVSMA8olZhYa1Cwhb6hMfUy83PewC0Gyzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5PywHunVaTHhSGhN1DbBMMy52zKHWO5I/G/1ZSdKyQ5GYvPUB6QC+WvyUxG2S0Co
	 RR2c893qlp1FSgt+DULmaR9ltoiL1myXbX95nyv1TC3xIOprYm/l+2gVmn6DedN7zs
	 EB66tkrac2UjnVYwtpqsyodmInOP7LK1I5WyJqiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Rongguang <herongguang@linux.alibaba.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/462] cpupower: fix TSC MHz calculation
Date: Tue, 11 Mar 2025 15:54:54 +0100
Message-ID: <20250311145759.465317596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: He Rongguang <herongguang@linux.alibaba.com>

[ Upstream commit 9d6c0e58514f8b57cd9c2c755e41623d6a966025 ]

Commit 'cpupower: Make TSC read per CPU for Mperf monitor' (c2adb1877b7)
changes TSC counter reads per cpu, but left time diff global (from start
of all cpus to end of all cpus), thus diff(time) is too large for a
cpu's tsc counting, resulting in far less than acutal TSC_Mhz and thus
`cpupower monitor` showing far less than actual cpu realtime frequency.

/proc/cpuinfo shows frequency:
cat /proc/cpuinfo | egrep -e 'processor' -e 'MHz'
...
processor : 171
cpu MHz   : 4108.498
...

before fix (System 100% busy):
    | Mperf              || Idle_Stats
 CPU| C0   | Cx   | Freq  || POLL | C1   | C2
 171|  0.77| 99.23|  2279||  0.00|  0.00|  0.00

after fix (System 100% busy):
    | Mperf              || Idle_Stats
 CPU| C0   | Cx   | Freq  || POLL | C1   | C2
 171|  0.46| 99.54|  4095||  0.00|  0.00|  0.00

Fixes: c2adb1877b76 ("cpupower: Make TSC read per CPU for Mperf monitor")
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../cpupower/utils/idle_monitor/mperf_monitor.c   | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index ae6af354a81db..08a399b0be286 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -33,7 +33,7 @@ static int mperf_get_count_percent(unsigned int self_id, double *percent,
 				   unsigned int cpu);
 static int mperf_get_count_freq(unsigned int id, unsigned long long *count,
 				unsigned int cpu);
-static struct timespec time_start, time_end;
+static struct timespec *time_start, *time_end;
 
 static cstate_t mperf_cstates[MPERF_CSTATE_COUNT] = {
 	{
@@ -174,7 +174,7 @@ static int mperf_get_count_percent(unsigned int id, double *percent,
 		dprint("%s: TSC Ref - mperf_diff: %llu, tsc_diff: %llu\n",
 		       mperf_cstates[id].name, mperf_diff, tsc_diff);
 	} else if (max_freq_mode == MAX_FREQ_SYSFS) {
-		timediff = max_frequency * timespec_diff_us(time_start, time_end);
+		timediff = max_frequency * timespec_diff_us(time_start[cpu], time_end[cpu]);
 		*percent = 100.0 * mperf_diff / timediff;
 		dprint("%s: MAXFREQ - mperf_diff: %llu, time_diff: %llu\n",
 		       mperf_cstates[id].name, mperf_diff, timediff);
@@ -207,7 +207,7 @@ static int mperf_get_count_freq(unsigned int id, unsigned long long *count,
 	if (max_freq_mode == MAX_FREQ_TSC_REF) {
 		/* Calculate max_freq from TSC count */
 		tsc_diff = tsc_at_measure_end[cpu] - tsc_at_measure_start[cpu];
-		time_diff = timespec_diff_us(time_start, time_end);
+		time_diff = timespec_diff_us(time_start[cpu], time_end[cpu]);
 		max_frequency = tsc_diff / time_diff;
 	}
 
@@ -226,9 +226,8 @@ static int mperf_start(void)
 {
 	int cpu;
 
-	clock_gettime(CLOCK_REALTIME, &time_start);
-
 	for (cpu = 0; cpu < cpu_count; cpu++) {
+		clock_gettime(CLOCK_REALTIME, &time_start[cpu]);
 		mperf_get_tsc(&tsc_at_measure_start[cpu]);
 		mperf_init_stats(cpu);
 	}
@@ -243,9 +242,9 @@ static int mperf_stop(void)
 	for (cpu = 0; cpu < cpu_count; cpu++) {
 		mperf_measure_stats(cpu);
 		mperf_get_tsc(&tsc_at_measure_end[cpu]);
+		clock_gettime(CLOCK_REALTIME, &time_end[cpu]);
 	}
 
-	clock_gettime(CLOCK_REALTIME, &time_end);
 	return 0;
 }
 
@@ -349,6 +348,8 @@ struct cpuidle_monitor *mperf_register(void)
 	aperf_current_count = calloc(cpu_count, sizeof(unsigned long long));
 	tsc_at_measure_start = calloc(cpu_count, sizeof(unsigned long long));
 	tsc_at_measure_end = calloc(cpu_count, sizeof(unsigned long long));
+	time_start = calloc(cpu_count, sizeof(struct timespec));
+	time_end = calloc(cpu_count, sizeof(struct timespec));
 	mperf_monitor.name_len = strlen(mperf_monitor.name);
 	return &mperf_monitor;
 }
@@ -361,6 +362,8 @@ void mperf_unregister(void)
 	free(aperf_current_count);
 	free(tsc_at_measure_start);
 	free(tsc_at_measure_end);
+	free(time_start);
+	free(time_end);
 	free(is_valid);
 }
 
-- 
2.39.5



