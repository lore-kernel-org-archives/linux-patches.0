Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E171684AC;
	Tue, 11 Mar 2025 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706389; cv=none; b=EeIc4sTMjzDMOjzuhL4ZyJcgQTEkD1RdqvBlr1Zv8N+hsvxZZ8cAyMUcZ5HLqOtimUWqier9oHb8trrlU3w9hQVsMl7vxnEZtawgzXxsoW0O5JT3UF3m9POujN86OoReLvU8crRlwOo/kgTk9gNWjKI4Jd5EnYyuCzXsO6b4hcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706389; c=relaxed/simple;
	bh=BKuvdQ625HzHD1tp0laeWm2sV3OS6ExCTRTpZfcdO3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIzekadTsy8wEXrz9q4ph2sxXthVHnQwdmjvH34rDsGnTusW0WFU4Ph0V3Gu9vmVcDiR8x+Q5qSmvdxenpCTrYkaKuZ+5Ldrc8pY+LVkuXfK61aTWaNnMcHQGRwHHEiRqoqbMdCE0jH167E0Il/xviq8WvRc7ECTKqCWBhCJiGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBt4Zw+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBt4Zw+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C964C4CEEA;
	Tue, 11 Mar 2025 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706389;
	bh=BKuvdQ625HzHD1tp0laeWm2sV3OS6ExCTRTpZfcdO3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBt4Zw+9Q3CB1ExPBlogNzbI569X+jjzhe2W7AeGo8LCiY3WVfQ6SQU+HbEK6V58E
	 4vKqThVNk/BvinW7kQ/h5mO6LZJMy8nrQriGSC/g5HnSCJDAf0PpElAOtXFGO1ONLR
	 t5aoGbHQZxb0zHyiHiUd2iK2rp6nQHVf2meefySs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sultan Alsawaf (unemployed)" <sultan@kerneltoast.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/462] cpufreq: schedutil: Fix superfluous updates caused by need_freq_update
Date: Tue, 11 Mar 2025 15:54:57 +0100
Message-ID: <20250311145759.584064501@linuxfoundation.org>
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
index 04295212ab500..d8b9e1d25200f 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -90,7 +90,7 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 
 	if (unlikely(sg_policy->limits_changed)) {
 		sg_policy->limits_changed = false;
-		sg_policy->need_freq_update = true;
+		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
 		return true;
 	}
 
@@ -103,7 +103,7 @@ static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
 				   unsigned int next_freq)
 {
 	if (sg_policy->need_freq_update)
-		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
+		sg_policy->need_freq_update = false;
 	else if (sg_policy->next_freq == next_freq)
 		return false;
 
-- 
2.39.5



