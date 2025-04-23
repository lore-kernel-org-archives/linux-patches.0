Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88E27F4D9;
	Wed, 23 Apr 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421911; cv=none; b=lodRut/r0UKMfb3uDje+anqlANOUBFZ98zEBnLGgUdu0DVb+7MD7ZhNuAWuLPb5TLFc+9OoTNntDJWQyKkTUBNW0G8jSxmaFaFILH1nDc56QGeHsyedLXAww7G/hp7zN63a+HT8hdZQRXDq7BlrG5x8zOp5eGU+9IlkcXP3y2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421911; c=relaxed/simple;
	bh=JBaxcfzVqdQ5w1B2tSuN8VKhbBbpV0cj5bVnkX4B4jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmWXYJRgt3C5ADqz7WiWUZqkZU0A2CesK59Oq9IBjN93pWWOK9YRnV1NmAlFeLP9d5Kp2l4ReR6rYjDoaoMvpwwUPPWWJb3266O53UgVvs3weiJ49ho9VCZwEOgo8N9LZi8/RLTIqtXQRzqa+7eLBI5xG+fy8xNi3wLdfYUJ6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFX8d5fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFX8d5fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB5DC4CEE2;
	Wed, 23 Apr 2025 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421910;
	bh=JBaxcfzVqdQ5w1B2tSuN8VKhbBbpV0cj5bVnkX4B4jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFX8d5fc3RbQ5XJqi9Bd3FUbk85UYmUi5grvnJSNyT78xzS1KE5iZN1RAyx0e2htE
	 AYcgkvZv8AoM42TaX/IUWdHgpafe0n4T5PXAXjnNbyxSA2r9g19ZzwV6UcWE8ugnKo
	 p9XZU2P/JmImYOpKs1ytVcu5mLIdkbPVazFj7WBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/291] cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS
Date: Wed, 23 Apr 2025 16:43:06 +0200
Message-ID: <20250423142632.435020018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 542c0e82a9005..4dcb489733181 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -84,7 +84,7 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 
 	if (unlikely(sg_policy->limits_changed)) {
 		sg_policy->limits_changed = false;
-		sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
+		sg_policy->need_freq_update = true;
 		return true;
 	}
 
@@ -96,10 +96,22 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
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



