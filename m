Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0F127D76E;
	Wed, 23 Apr 2025 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419942; cv=none; b=BLWpNdJoxZOzufUCLMYM/GXRjl/2oolr2xmP/uWWWgSGEs5GZvhapAwqAMY5Le7yWFOoOSXQbrZ+u9e3/xdS1gflT3wFzLvFtWnkerScAn2T/yhs0G3pYUP/TcFl6gwm3vY63Hn8iHdLB2u1Dmle4uJV33Na4gvbdK9oF0hwAmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419942; c=relaxed/simple;
	bh=bnQXU5UAsgS5be1MwPF7KHMf37WNSWlb3L9O1TWlJmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvrHBPv/06HIVcx3EZZ45Iy8TqK/xmN5E7ewpyw4iJ2u+DQVhLPnAHdCg2/rl2yh4RtTh9Ki/cteegahKEjv3aIZkSY2cO4R2OypGfmzp1Hytu6fOs4c9GDo9D6fBOrtp+SG0y/USvzGMK/xkaLLSyG1ZFjCq7bFlAf3hYNEL3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/qyy0ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/qyy0ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F440C4CEE2;
	Wed, 23 Apr 2025 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419942;
	bh=bnQXU5UAsgS5be1MwPF7KHMf37WNSWlb3L9O1TWlJmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/qyy0evFpnajwh3C0j1+YIO08w1F16gCJWuYDdE1I1f5Vk2s5+gMjswXa0hbCvTV
	 oWW9ssmBC4hTSZgc9AmJcY4uruyMV16y4Y2l5sqYhR6hXK2RFX3ymGDCaAqZBomcTi
	 NErXjN8aJuwcQIWo5OJmIN+GwNeKZnNQT/k9rZxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/223] cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS
Date: Wed, 23 Apr 2025 16:42:34 +0200
Message-ID: <20250423142620.465410144@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit cfde542df7dd51d26cf667f4af497878ddffd85a ]

Commit 8e461a1cb43d ("cpufreq: schedutil: Fix superfluous updates caused
by need_freq_update") modified sugov_should_update_freq() to set the
need_freq_update flag only for drivers with CPUFREQ_NEED_UPDATE_LIMITS
set, but that flag generally needs to be set when the policy limits
change because the driver callback may need to be invoked for the new
limits to take effect.

However, if the return value of cpufreq_driver_resolve_freq() after
applying the new limits is still equal to the previously selected
frequency, the driver callback needs to be invoked only in the case
when CPUFREQ_NEED_UPDATE_LIMITS is set (which means that the driver
specifically wants its callback to be invoked every time the policy
limits change).

Update the code accordingly to avoid missing policy limits changes for
drivers without CPUFREQ_NEED_UPDATE_LIMITS.

Fixes: 8e461a1cb43d ("cpufreq: schedutil: Fix superfluous updates caused by need_freq_update")
Closes: https://lore.kernel.org/lkml/Z_Tlc6Qs-tYpxWYb@linaro.org/
Reported-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/3010358.e9J7NaK4W3@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index e51d5ce730be1..3a807c2e50854 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -83,7 +83,7 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 
 	if (unlikely(sg_policy->limits_changed)) {
 		sg_policy->limits_changed = false;
-		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
+		sg_policy->need_freq_update = true;
 		return true;
 	}
 
@@ -95,10 +95,22 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
 				   unsigned int next_freq)
 {
-	if (sg_policy->need_freq_update)
+	if (sg_policy->need_freq_update) {
 		sg_policy->need_freq_update = false;
-	else if (sg_policy->next_freq == next_freq)
+		/*
+		 * The policy limits have changed, but if the return value of
+		 * cpufreq_driver_resolve_freq() after applying the new limits
+		 * is still equal to the previously selected frequency, the
+		 * driver callback need not be invoked unless the driver
+		 * specifically wants that to happen on every update of the
+		 * policy limits.
+		 */
+		if (sg_policy->next_freq == next_freq &&
+		    !cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS))
+			return false;
+	} else if (sg_policy->next_freq == next_freq) {
 		return false;
+	}
 
 	sg_policy->next_freq = next_freq;
 	sg_policy->last_freq_update_time = time;
-- 
2.39.5



