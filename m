Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837B226A1A3;
	Tue,  8 Apr 2025 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116190; cv=none; b=Gl0fLrAcVCi8iMQ7P+idPi+SVomdZKCc58DSV/ByPpwjhRFIqxkS3BuR+WHjO9dvzAb65MtzqjnszEiCAvVwulVyn8+TzJtCBD6VfvxP/mP8LYiTPGnifjwW6jJfADAQi7PaUB7MXVXzKmfP99UgWuZugIk1snccbn2yb/pbYnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116190; c=relaxed/simple;
	bh=JJbxtf3u44Rp5fPF2YbnhjPZjPyQqckiXhNfigu0Z0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfPCUKKwe/rK6KAnl8QlNYOQYCMMYlFDihdX3fR/k168w9dly8APvuw93ixgHWD3ffZaFUeZQZ5EPnTGYmfz6+2lC7h+ScDENTRVOd0Q/etgLXqmJx9up8tXmmy2uASQHCETE1m33rm97E5zFvwCw3p2g54I3YFQpV8t6LnaUvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SprhRixN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SprhRixN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078D6C4CEE5;
	Tue,  8 Apr 2025 12:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116190;
	bh=JJbxtf3u44Rp5fPF2YbnhjPZjPyQqckiXhNfigu0Z0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SprhRixN0YW34ji2tx5QLSJl3PYJcsJuhxEli7jQZfSx3a9uRn0DueLTHWL7vxVLP
	 JEAyQd0Rg9QVPkUovQ1Qf8zkySABawwLttYuwFyCk7db4kC5lTqpbASXtCQS2jvcSy
	 CplkwXdlgh7D/3/277UM0hb8UlLNPAudZBVDlTLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/423] cpufreq: governor: Fix negative idle_time handling in dbs_update()
Date: Tue,  8 Apr 2025 12:45:34 +0200
Message-ID: <20250408104845.903705647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit 3698dd6b139dc37b35a9ad83d9330c1f99666c02 ]

We observed an issue that the CPU frequency can't raise up with a 100% CPU
load when NOHZ is off and the 'conservative' governor is selected.

'idle_time' can be negative if it's obtained from get_cpu_idle_time_jiffy()
when NOHZ is off.  This was found and explained in commit 9485e4ca0b48
("cpufreq: governor: Fix handling of special cases in dbs_update()").

However, commit 7592019634f8 ("cpufreq: governors: Fix long idle detection
logic in load calculation") introduced a comparison between 'idle_time' and
'samling_rate' to detect a long idle interval.  While 'idle_time' is
converted to int before comparison, it's actually promoted to unsigned
again when compared with an unsigned 'sampling_rate'.  Hence, this leads to
wrong idle interval detection when it's in fact 100% busy and sets
policy_dbs->idle_periods to a very large value.  'conservative' adjusts the
frequency to minimum because of the large 'idle_periods', such that the
frequency can't raise up.  'Ondemand' doesn't use policy_dbs->idle_periods
so it fortunately avoids the issue.

Correct negative 'idle_time' to 0 before any use of it in dbs_update().

Fixes: 7592019634f8 ("cpufreq: governors: Fix long idle detection logic in load calculation")
Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Link: https://patch.msgid.link/20250213035510.2402076-1-zhanjie9@hisilicon.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_governor.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index af44ee6a64304..1a7fcaf39cc9b 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -145,7 +145,23 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 		time_elapsed = update_time - j_cdbs->prev_update_time;
 		j_cdbs->prev_update_time = update_time;
 
-		idle_time = cur_idle_time - j_cdbs->prev_cpu_idle;
+		/*
+		 * cur_idle_time could be smaller than j_cdbs->prev_cpu_idle if
+		 * it's obtained from get_cpu_idle_time_jiffy() when NOHZ is
+		 * off, where idle_time is calculated by the difference between
+		 * time elapsed in jiffies and "busy time" obtained from CPU
+		 * statistics.  If a CPU is 100% busy, the time elapsed and busy
+		 * time should grow with the same amount in two consecutive
+		 * samples, but in practice there could be a tiny difference,
+		 * making the accumulated idle time decrease sometimes.  Hence,
+		 * in this case, idle_time should be regarded as 0 in order to
+		 * make the further process correct.
+		 */
+		if (cur_idle_time > j_cdbs->prev_cpu_idle)
+			idle_time = cur_idle_time - j_cdbs->prev_cpu_idle;
+		else
+			idle_time = 0;
+
 		j_cdbs->prev_cpu_idle = cur_idle_time;
 
 		if (ignore_nice) {
@@ -162,7 +178,7 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 			 * calls, so the previous load value can be used then.
 			 */
 			load = j_cdbs->prev_load;
-		} else if (unlikely((int)idle_time > 2 * sampling_rate &&
+		} else if (unlikely(idle_time > 2 * sampling_rate &&
 				    j_cdbs->prev_load)) {
 			/*
 			 * If the CPU had gone completely idle and a task has
@@ -189,30 +205,15 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 			load = j_cdbs->prev_load;
 			j_cdbs->prev_load = 0;
 		} else {
-			if (time_elapsed >= idle_time) {
+			if (time_elapsed > idle_time)
 				load = 100 * (time_elapsed - idle_time) / time_elapsed;
-			} else {
-				/*
-				 * That can happen if idle_time is returned by
-				 * get_cpu_idle_time_jiffy().  In that case
-				 * idle_time is roughly equal to the difference
-				 * between time_elapsed and "busy time" obtained
-				 * from CPU statistics.  Then, the "busy time"
-				 * can end up being greater than time_elapsed
-				 * (for example, if jiffies_64 and the CPU
-				 * statistics are updated by different CPUs),
-				 * so idle_time may in fact be negative.  That
-				 * means, though, that the CPU was busy all
-				 * the time (on the rough average) during the
-				 * last sampling interval and 100 can be
-				 * returned as the load.
-				 */
-				load = (int)idle_time < 0 ? 100 : 0;
-			}
+			else
+				load = 0;
+
 			j_cdbs->prev_load = load;
 		}
 
-		if (unlikely((int)idle_time > 2 * sampling_rate)) {
+		if (unlikely(idle_time > 2 * sampling_rate)) {
 			unsigned int periods = idle_time / sampling_rate;
 
 			if (periods < idle_periods)
-- 
2.39.5



