Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C427B31F9B1;
	Sat, 12 Sep 2026 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241175; cv=none; b=XFGW/h2fxqFbS+1U4UQJ58fCMH9uvCX1jbTdJ5uZYQWLLL0wlwnhB2yOC1eLkpES9i25MsUT4sxY0GfB1AfR8pDVA8sTURaBdxE9ki/PV7BU0ERlfTiTy0C/yPY6AL9iI/8MMni+dYXgfMDO/eWo5z3CR+PdoL21dsUHClxOEbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241175; c=relaxed/simple;
	bh=WsRyIRNeOo9T8Z2+jEpUc7dvJ5N/MwY1C5hEnBgd0lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB8UwK0lK0MPvXKq4/Id7BvMaZ2mhMNeN5UxVNBKsPzsI3kYcwTnc6LbCf+FfF6ixtVxKkyyipHRgKRq7xPOpXH+SMjymAes5rPI3eScdDSI2tVkhocweb1tTZ2vkAwxnet5R/9Qf7LTwSJXzI5WYBv6xGun7al6OymCAYS+S9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng5VzHeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng5VzHeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85A01F000FF;
	Sat, 12 Sep 2026 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241174;
	bh=DJGlJHHd4NP98EM/VpLcSGBpm2pww4WN91KTP2sVVlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng5VzHeqz2fhor0AnEax6lvrO8UWs7iYXnNW5JpsQWhEV5sFbn7bB/ljO7orfqQN0
	 hzITO9SnLWyiukRtNaoFdE/xp1jXVcN6Co7LeM56jR7tW0YocHL0pmxziAaheEpORc
	 /Bl79/yX5FJL3NU6uAaJl2tXxiy5S8CmluOj5Om0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 082/798] cpufreq: schedutil: Fix rate limit overflow
Date: Sat, 12 Sep 2026 08:55:10 +0200
Message-ID: <20260912065518.841609041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hui Su <sh_def@163.com>

commit 3bff8f8e95fdc6ad19c8a1a8f87029094747e4bf upstream.

rate_limit_us is an unsigned int, while NSEC_PER_USEC is defined as
1000L. On 32-bit systems, the multiplication is therefore performed
using 32-bit unsigned arithmetic before the result is assigned to
freq_update_delay_ns.

For example, writing 4294968 to rate_limit_us wraps the delay from
4294968000 ns to 704 ns. This makes schedutil update far more often
than configured.

Add sugov_update_rate_limit_us() to widen rate_limit_us to s64 before
converting it to nanoseconds. Use the helper when updating the tunable
through sysfs and when starting the governor, so both paths perform the
conversion without overflow.

Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260806142304.1761454-1-sh_def@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -66,6 +66,17 @@ static DEFINE_PER_CPU(struct sugov_cpu,
 
 /************************ Governor internals ***********************/
 
+static void sugov_update_rate_limit_us(struct sugov_policy *sg_policy)
+{
+	/*
+	 * Cast rate_limit_us before multiplication to force 64-bit arithmetic.
+	 * Otherwise, on 32-bit platforms, both operands are converted to
+	 * 32-bit unsigned long and the multiplication may overflow.
+	 */
+	sg_policy->freq_update_delay_ns =
+		(s64)sg_policy->tunables->rate_limit_us * NSEC_PER_USEC;
+}
+
 static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 {
 	s64 delta_ns;
@@ -618,7 +629,7 @@ rate_limit_us_store(struct gov_attr_set
 	tunables->rate_limit_us = rate_limit_us;
 
 	list_for_each_entry(sg_policy, &attr_set->policy_list, tunables_hook)
-		sg_policy->freq_update_delay_ns = rate_limit_us * NSEC_PER_USEC;
+		sugov_update_rate_limit_us(sg_policy);
 
 	return count;
 }
@@ -848,7 +859,7 @@ static int sugov_start(struct cpufreq_po
 	struct sugov_policy *sg_policy = policy->governor_data;
 	unsigned int cpu;
 
-	sg_policy->freq_update_delay_ns	= sg_policy->tunables->rate_limit_us * NSEC_PER_USEC;
+	sugov_update_rate_limit_us(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;


