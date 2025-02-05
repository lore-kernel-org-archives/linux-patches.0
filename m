Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40403149DE8;
	Wed,  5 Feb 2025 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763566; cv=none; b=A0GMUBxEDVeOisD86VHC3dcBJUhqTYI/UiUaiJ2JyM6FMCETdouYkwhLsIL5db9Af5Kr2iMzlLjcK9ND9R6LA/kvu8BMmEBtnDiRefnrAkQYq7ohbRBdCmH+aVNJ/HgnJsPD3PTWBCvzCL+9hoyHlwM1ii8oMPYmlHMcCggHXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763566; c=relaxed/simple;
	bh=AIsufjBM7tUwoHTv12yMzRrez0i5IXLWzz0DgJ0OQ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ8RZXNxLpW1EsAjaNYfr47BX5PiM/uStzMxNP3ZPSgVpc3EGEfexLtw3vNnHQpXO4kqessrT3WYZYIaWWsXT0U9GWNT/NPGtHkxLfqnp/tU6tucHdhnlTCIjkph/y4y1NxBb93OC8GvVGVm4bKVB9w7aEtUah+L2nM8VwawB50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaed/MqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaed/MqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0844C4CEE2;
	Wed,  5 Feb 2025 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763566;
	bh=AIsufjBM7tUwoHTv12yMzRrez0i5IXLWzz0DgJ0OQ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaed/MqPw+cdhmLZgJPDZhdWa3wXTIXLXCH+soKL28vzaVy8/x2myrvzHO0cgJ4s3
	 UVdmmfeqqL8lavHlUbpVXbQb8KfiSLmAvu3Irrlbk12UD3PtyXTQoPorw9ZvPexj6N
	 jRRWHtddYFp6E7iCjJ7cXG8AHX6A9VUMntFETCvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sultan Alsawaf (unemployed)" <sultan@kerneltoast.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/393] cpufreq: schedutil: Fix superfluous updates caused by need_freq_update
Date: Wed,  5 Feb 2025 14:40:01 +0100
Message-ID: <20250205134423.432194694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>

[ Upstream commit 8e461a1cb43d69d2fc8a97e61916dce571e6bb31 ]

A redundant frequency update is only truly needed when there is a policy
limits change with a driver that specifies CPUFREQ_NEED_UPDATE_LIMITS.

In spite of that, drivers specifying CPUFREQ_NEED_UPDATE_LIMITS receive a
frequency update _all the time_, not just for a policy limits change,
because need_freq_update is never cleared.

Furthermore, ignore_dl_rate_limit()'s usage of need_freq_update also leads
to a redundant frequency update, regardless of whether or not the driver
specifies CPUFREQ_NEED_UPDATE_LIMITS, when the next chosen frequency is the
same as the current one.

Fix the superfluous updates by only honoring CPUFREQ_NEED_UPDATE_LIMITS
when there's a policy limits change, and clearing need_freq_update when a
requisite redundant update occurs.

This is neatly achieved by moving up the CPUFREQ_NEED_UPDATE_LIMITS test
and instead setting need_freq_update to false in sugov_update_next_freq().

Fixes: 600f5badb78c ("cpufreq: schedutil: Don't skip freq update when limits change")
Signed-off-by: Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20241212015734.41241-2-sultan@kerneltoast.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 458d359f5991c..a49f136014ce6 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -83,7 +83,7 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 
 	if (unlikely(sg_policy->limits_changed)) {
 		sg_policy->limits_changed = false;
-		sg_policy->need_freq_update = true;
+		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
 		return true;
 	}
 
@@ -96,7 +96,7 @@ static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
 				   unsigned int next_freq)
 {
 	if (sg_policy->need_freq_update)
-		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
+		sg_policy->need_freq_update = false;
 	else if (sg_policy->next_freq == next_freq)
 		return false;
 
-- 
2.39.5



