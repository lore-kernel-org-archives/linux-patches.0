Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8415198D;
	Wed,  5 Feb 2025 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764889; cv=none; b=bFA8X1lEzrxYENasVBrAQFfrACdJ4+K+t3bNo+48vINgoWytO0Qz/hUJODLuUECbuJrb3aq0G5/fhwj5Kn1Q9HgiwQdPgIH7qschUKTEyc2lwgqSjuEsYRtrb3Y0udE9DthSVKpvWqeRs7m1Fkogfkdkp54GK3hnNy1vCFhhO7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764889; c=relaxed/simple;
	bh=tQvV4JRgfGS5hnBcL5AsrsO3J1MoQQ2VS4d3oLQpyD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhJlPiFFGk8uTT0IK895YeH+XxrtaxiGhf9IMWJEH7EsUG2/d52dIMosMbZmE4OCB7fi7+w7KeZWBniyiL2HhNxriCofdm9ppLUT3wzpuOIrz8QaJrmxra51CY1KK2HH99xhAE7btGQS5MKKrPvWvkWkN2aCz9asy7r0Ea4J7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etth00QB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etth00QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1679CC4CED1;
	Wed,  5 Feb 2025 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764889;
	bh=tQvV4JRgfGS5hnBcL5AsrsO3J1MoQQ2VS4d3oLQpyD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etth00QBKqffxGUBgXoXNUhFXxuTG32wxa7tqHQ6uTAfLdqJ74N+Fvz33ciWyh9/4
	 pf1ivdrVzDglJHqjwVd6V8bg5vzF8duvRriKV+2MYH8nXzTSR94tO+CxZ/RwknnWsw
	 Qc+HP0t7hC93/HNJUjumN9WZMejmvOE8ZPHxREaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sultan Alsawaf (unemployed)" <sultan@kerneltoast.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 122/623] cpufreq: schedutil: Fix superfluous updates caused by need_freq_update
Date: Wed,  5 Feb 2025 14:37:44 +0100
Message-ID: <20250205134500.888903613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 28c77904ea749..e51d5ce730be1 100644
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



