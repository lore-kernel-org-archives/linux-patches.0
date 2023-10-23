Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE714263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APErTqgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D31C433C7;
	Mon, 23 Oct 2023 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059334;
	bh=hlH78os2GzEILz1qeMzkjIvchJ+yGRbTWQMCvSZdVFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APErTqgwKTz+yD27hcx3x57CNoAr91M0jiaG5UZiMFakmuGcTC6s4zB6ASRM3YPQf
	 eb+Tv4O3FukJ+/NcIjW3rI1W7f198/EczagHjqw4FQMFKe9HDAEPgdvTxmeYyHjFPm
	 Hb95Vn2i+Kak/OSkHqAYnEHQraCUxBCJcXFY17t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Guohua Yan <guohua.yan@unisoc.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 142/241] cpufreq: schedutil: Update next_freq when cpufreq_limits change
Date: Mon, 23 Oct 2023 12:55:28 +0200
Message-ID: <20231023104837.336150612@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 9e0bc36ab07c550d791bf17feeb479f1dfc42d89 ]

When cpufreq's policy is 'single', there is a scenario that will
cause sg_policy's next_freq to be unable to update.

When the CPU's util is always max, the cpufreq will be max,
and then if we change the policy's scaling_max_freq to be a
lower freq, indeed, the sg_policy's next_freq need change to
be the lower freq, however, because the cpu_is_busy, the next_freq
would keep the max_freq.

For example:

The cpu7 is a single CPU:

  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # while true;do done& [1] 4737
  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # taskset -p 80 4737
  pid 4737's current affinity mask: ff
  pid 4737's new affinity mask: 80
  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # cat scaling_max_freq
  2301000
  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # cat scaling_cur_freq
  2301000
  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # echo 2171000 > scaling_max_freq
  unisoc:/sys/devices/system/cpu/cpufreq/policy7 # cat scaling_max_freq
  2171000

At this time, the sg_policy's next_freq would stay at 2301000, which
is wrong.

To fix this, add a check for the ->need_freq_update flag.

[ mingo: Clarified the changelog. ]

Co-developed-by: Guohua Yan <guohua.yan@unisoc.com>
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Signed-off-by: Guohua Yan <guohua.yan@unisoc.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230719130527.8074-1-xuewen.yan@unisoc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 4492608b7d7f1..458d359f5991c 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -350,7 +350,8 @@ static void sugov_update_single_freq(struct update_util_data *hook, u64 time,
 	 * Except when the rq is capped by uclamp_max.
 	 */
 	if (!uclamp_rq_is_capped(cpu_rq(sg_cpu->cpu)) &&
-	    sugov_cpu_is_busy(sg_cpu) && next_f < sg_policy->next_freq) {
+	    sugov_cpu_is_busy(sg_cpu) && next_f < sg_policy->next_freq &&
+	    !sg_policy->need_freq_update) {
 		next_f = sg_policy->next_freq;
 
 		/* Restore cached freq as next_freq has changed */
-- 
2.40.1



