Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D3280CE0;
	Wed, 23 Apr 2025 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420477; cv=none; b=F/5v+pvDUjwlqpXK8P15zj3g9VypHtlToymSfEsd485wE2m1D1z1COl/F17rU8+2K+MDpH2Pw9syB+mKqe93mBI1SNlnA3CQPgQxjGy8ZPsYCVKsVoYCZ6kEKFUg/Xca72gDhlIBcXGk6ht1kb2Z89qQ69vR3HZrnCwQa7tP0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420477; c=relaxed/simple;
	bh=DgWoxXnZdti9NrIq81PytnCKhkQ6+1oE4OFQwPA5BGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISFyvwnM5FSElfOec1KdB7kzXO/rgULPsEDZeI5VRKGDm0BFIPVB8nzA4OwSzGgFzN2pSc/yMsqR++XPdLvbnO1yEgYzquQwVtuvveByvDPTkW6yBzmhJPg0ifDHhhAGY5FJcdVepkKZgQOdVlRHccHQBlSh52lx1wMb33nUxIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJQ+meqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJQ+meqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA3C4CEE8;
	Wed, 23 Apr 2025 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420477;
	bh=DgWoxXnZdti9NrIq81PytnCKhkQ6+1oE4OFQwPA5BGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJQ+meqmy8ueEfp78Bpk4/4nyfCLKayb5IoFBEPwv5CCCCjNMtJvACfPUGsIaSsrS
	 ArRWce2JxkJhqxNHahp5VyoJcX/JTs2yfovPA7ET/KW1OT9jMaNyLDhBNMmoJJGuSu
	 V/yLm3QUvw6gJ/gaJCT8OMj6nvIek1hTCjpAWovA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/241] cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS
Date: Wed, 23 Apr 2025 16:42:39 +0200
Message-ID: <20250423142624.460882439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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
index 1a19d69b91ed3..b713ce0a57020 100644
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



