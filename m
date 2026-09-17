Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1918D4BA1F4;
	Thu, 17 Sep 2026 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660226; cv=none; b=YPGWbN02+HM1BPEAls51nBcxiEZB8MznehrVTIyg8Lc/4qgYxe91GonzWJkEhJbDx6o5BQt0hEIvY9JjW2YwoKcNj58XltJXMRmW8d/jx0oga/T2QffHRTBMHhX6DrqoxDmoZBUYs8rt5uFBehnqvpHRlq3mC9UpcUi1RfQSTdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660226; c=relaxed/simple;
	bh=L39cWHvuk5Uis3xl+WT0dqvETjV7vYnLFZjYvIOCh9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly4JVLhRe8Oo3VlHnETUJM/jHL8W0yfB/bhoFjz6BM/du5QHw4Ryz60Ejjl8QzTmCyrOVTahq6v3WRcIWaXZbYZy/4R9lM4OnMUg5VyPi/Ya6u/Wotr9FyQX1AuRfZDGmA8KgPG/zg4A5aTtLbtbdJ8nAdTNsJMTzx98ojKwZMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+onUllE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+onUllE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662131F00893;
	Thu, 17 Sep 2026 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660220;
	bh=gJBtWSv9WDQDez0UNKcF/1ruxmWhxLcZcFyhoB5cb6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+onUllEeDIBwxIuuFA4XqoDaHlws4hFc7Qz55pMtluaCT9jA5y4NAXcubY7Bq14f
	 ka4gQXEgGOemVatwh+Ie/svJtnfd5TeodzC0tbLWTZ38ngkmfLro6QSIHttV2qaYkp
	 WjWQESWClVq9m3xaLQ/VFN0OZH2ujoz7GXEPA3z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 519/733] cpufreq: zero-initialize policy cpumask before sysfs publication
Date: Thu, 17 Sep 2026 16:13:47 +0100
Message-ID: <20260917151405.089889603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

commit 54d37bcf2f497140b9207968557ddb484058e749 upstream.

cpufreq_policy_alloc() allocates policy->cpus with alloc_cpumask_var(),
i.e. without __GFP_ZERO, unlike the sibling related_cpus and real_cpus
masks. With CONFIG_CPUMASK_OFFSTACK=y the mask is a separate
kmalloc_node() allocation, so its bitmap holds whatever the slab allocator
left behind:

  cpufreq_online()
    cpufreq_policy_alloc()
      alloc_cpumask_var(&policy->cpus)    /* bitmap is uninitialized */
      kobject_init_and_add()              /* policy%u/ appears in sysfs */
    cpufreq_policy_online()
      cpumask_copy(policy->cpus, cpumask_of(cpu))  /* first valid value */

This leaves a window in which the sysfs attributes are already reachable
while policy->cpus is still garbage. show()/store() gate on
policy_is_inactive(), i.e. cpumask_empty(policy->cpus), so a non-zero
bitmap makes them run the attribute callbacks on a policy that is not
initialized yet.

Fix this by using zalloc_cpumask_var() for policy->cpus.

Fixes: 2fc3384dc75b ("cpufreq: Initialize policy->kobj while allocating policy")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20260901143635.4106960-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1249,7 +1249,7 @@ static struct cpufreq_policy *cpufreq_po
 	if (!policy)
 		return NULL;
 
-	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&policy->cpus, GFP_KERNEL))
 		goto err_free_policy;
 
 	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL))


