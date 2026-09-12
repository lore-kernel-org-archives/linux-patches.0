Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46948284B37;
	Sat, 12 Sep 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227290; cv=none; b=BFzURqUG02ntw73wfY7aZCO0BUvau8dY2u9lwtE6W+PbxjkI0cUKfo16d2k/Z3LJPDqJ6TiWyjEq2XnPS2T/b62Ugq5QkABoiiKCy/FMdaHdhdJ+/mR5Vg8QMol+Tsriwr8N6nigNO8HC+gZpxf27qzQRLSlZZoth1e5D3YZ3Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227290; c=relaxed/simple;
	bh=oKF+AZMjEyS1FrDRBZaleLdMyJtDP/VbOcO4e5XnNXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf7eEQIDwMBAIJsblcN0AcRgPYWevLcplDk9hzc6F39FWoNHQo9hobp+/pxO0Hrt+4ktRfbt4Upo/wodCYIkVNufVyt7MMVWRJVc7XeA6eLsf4aNzMmj+Oi88qfX7blTisyqcEY8PUy1W2oznLK5Ih8WtQGVd6JFJ8BErhYLlEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT9EdV/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT9EdV/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E661F000FF;
	Sat, 12 Sep 2026 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227289;
	bh=ZTy4KaUtOKRH6hO1AJQxZ24NfmLlkk3xwC5peQQ1ycQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT9EdV/sMP2JUCNaRBfoWEytZgiy9RNxCYhUJyMSZMAffHV9PXzHd8ghlern/Nbf/
	 oAIAyN5RY+LfzzYS86gzwINPQtL7skVKif4LRfQl4SD8HaSRqf1wYXTGJWy+OUfbeD
	 6HM6UyR1SBtlveYfZAZddIq8syTl5s+0WjsbxjoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 0108/1191] cpufreq: schedutil: Fix rate limit overflow
Date: Sat, 12 Sep 2026 08:47:16 +0200
Message-ID: <20260912065550.609681563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -60,6 +60,17 @@ static DEFINE_PER_CPU(struct sugov_cpu,
 
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
@@ -547,7 +558,7 @@ rate_limit_us_store(struct gov_attr_set
 	tunables->rate_limit_us = rate_limit_us;
 
 	list_for_each_entry(sg_policy, &attr_set->policy_list, tunables_hook)
-		sg_policy->freq_update_delay_ns = rate_limit_us * NSEC_PER_USEC;
+		sugov_update_rate_limit_us(sg_policy);
 
 	return count;
 }
@@ -778,7 +789,7 @@ static int sugov_start(struct cpufreq_po
 	void (*uu)(struct update_util_data *data, u64 time, unsigned int flags);
 	unsigned int cpu;
 
-	sg_policy->freq_update_delay_ns	= sg_policy->tunables->rate_limit_us * NSEC_PER_USEC;
+	sugov_update_rate_limit_us(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;


