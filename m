Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA05A79B;
	Thu, 16 Jul 2026 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210947; cv=none; b=ZbxPJ+YLw10nhmWOZQ6KjqI0v25VhcO0c96NJCqHHpljpWVE9Gsey/TJFsmhQjAA8D7yWfoEjiFQUs3p1aovhaEtHdQPpPz90dP40wXSHgwCBOkWpNVqDfpL1mVdYtD/pC40idAxEqCJbp/ovh5G8r3WqgToeulA6zK+2IOpmhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210947; c=relaxed/simple;
	bh=Zlb42PEGaM2vOAcshm0WOE5HpBH6jWg/10Lsu5qdQ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8zgPZgHPXKpdffCCr8JZo/gPzmzlLXwAXeQSdzUJYuUJyXQATZ7qGtNSIoMs6pp+jL1CAF/ZHK+PXpBZDq207X5NP8tHiJAPANmpQBJwlwKmkOOtDPTTnUaRWeoGN5b90pBapVzMjn9tvZxTAVmaV8nVxpVhDkCjrr+QTIYiKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ymu5ZQO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ymu5ZQO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B90D1F00A3A;
	Thu, 16 Jul 2026 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210946;
	bh=b327tT7kwg5akJdnHozj9I1Hreaa5cdnPOdAwi93UqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ymu5ZQO5CDy05n1wEDtXqY/ZMo/OE4+TO2raNTnOlZXCIHTJDLzsb9AfZkYE6+b8+
	 ZTlRsl6XyRDPg9cAC/ZqV2IlmRqKO7N19hnVal2MxZuvzJkh/6Znwg/FG9mbt0aKic
	 UnWZ8tLx14TkiI9CUwetQsMqKR2AuXzfCwP+BTXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 242/480] cpufreq: qcom-cpufreq-hw: Fix possible double free
Date: Thu, 16 Jul 2026 15:29:49 +0200
Message-ID: <20260716133050.055844085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit bcb8889c4981fdde42d4fd2c29a77d510fe21da2 upstream.

qcom_cpufreq.data is allocated with devm_kzalloc() in probe() as an
array of per-domain data. qcom_cpufreq_hw_cpu_init() stores a pointer to
one element of this array in policy->driver_data.

qcom_cpufreq_hw_cpu_exit() currently calls kfree() on policy->driver_data.
This is not valid because the memory is devm-managed. For the first
domain, this can free the devm-managed allocation while the devres entry
is still active, leading to a possible double free when the platform
device is later detached. For other domains, the pointer may refer to an
element inside the array rather than the allocation base.

Remove the kfree(data) call and let devres release qcom_cpufreq.data.

This issue was found by a static analysis tool I am developing.

Fixes: 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -578,7 +578,6 @@ static void qcom_cpufreq_hw_cpu_exit(str
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
-	kfree(data);
 }
 
 static void qcom_cpufreq_ready(struct cpufreq_policy *policy)


