Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F41263C6D;
	Tue,  8 Apr 2025 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110295; cv=none; b=BsiurzQnpY5qPOaAxLplBuRPt3AJ3gC0uqMbpE4A9IoBW+Dz7FEuvX1mpxN6hTZfpwpqZTxRCZLzrmdNROESlVjJwP8TZjLAnB/57edlvtFAppLNj00xP6jpZ0OIZm9/WTYS85aFtmYDyOJAhMdODQXAUhfykoS3AzQJp9nwNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110295; c=relaxed/simple;
	bh=UjErAWgq8Efqi6tuoFktFACHEqmF9UVraFDxO0E3fDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxMDwuFrREdjEIUv0peU950Tp+6Cx828UFr+U3B33aVjgR2SAzN8DTmDXkFKyfxqVa9SlFVla94pYGUrRKros0CGQuIF2Wo+2H28345GWGiq2uDkeQLSKyCqWIvB8UrbObyMqSobGpH8M+baprA1rjG1NuL3E3r19MRadl92qug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itpKkaJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itpKkaJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C78C4CEE5;
	Tue,  8 Apr 2025 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110294;
	bh=UjErAWgq8Efqi6tuoFktFACHEqmF9UVraFDxO0E3fDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itpKkaJ5QjBRnch3QDFSOqbRpf5E+/6mkieCgeiXDHh/WGxhPZqo4ItklHjJP9phD
	 dAL1EEavYMAaP90g8MrRiNCwD0D2xtltAO74yB6p6vyl2X1o2GRI5TrHTcOyLzPpa5
	 B41mOOBK8EiEmRNHrAsllHluH84hSgcRdQzJas8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 012/731] cpufreq: governor: Fix negative idle_time handling in dbs_update()
Date: Tue,  8 Apr 2025 12:38:29 +0200
Message-ID: <20250408104914.544723316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



