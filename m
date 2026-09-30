Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98FE2DB79F;
	Wed, 30 Sep 2026 19:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795738; cv=none; b=GHFOy61EvrO0adYpjJ/k6xpBKYHN9kZYlAxD7LeDUgLdGDTxnYlInMtDKProJh2Li1YknyKTYda9eP9UkhclRFYoot6HmVB6CGVQPqqJFZuwBIlfuwCVkcL8OgI/YLKUGNGQSdRUzewpV+q13R4iSlIlGrlUN6YRNoT/Z7fMgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795738; c=relaxed/simple;
	bh=Itcb/0+mYzy5yr52zQKQ3a6PZE8m655VGfYd6Op+F1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di0vHqF8ap86PTAinqHV2qLW0U/wmKcbRodXJb39g+qa2HH3E2jAO1be+Cxxq8B7kgXTuRqcQifAct8VyREC2ada6BdrhN4ElG96Hd32JjsxhCZBbIOP9g1oa79NNq3C9RBeq05KcO0rPDDn3bfyWTSuEIHIZ3gHp0HkzZWf2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv0THM2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv0THM2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D7A1F000FF;
	Wed, 30 Sep 2026 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795736;
	bh=QUmbF0uYgxWsPGqAtayeazX8Y4+IXqfRfML7YOHQKAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv0THM2BsUaXGIVyw3HEAGkejFakHm0Vxuz/EGDzq1+YC2rMmsP+pZwRGxJBCRInW
	 b4zb0Ftm9k6XvQe9bXgAYMrg7H0Bz3n70GV12/deYv5WEQ63bX8FJ8kv4HWKzm8jmQ
	 AqjiDpsWbuRw00VkJYxoGpOkCIbGgMAxEsj+n6qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 0620/1193] cpufreq: zero-initialize policy cpumask before sysfs publication
Date: Wed, 30 Sep 2026 17:21:44 +0200
Message-ID: <20260930152448.018384225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1264,7 +1264,7 @@ static struct cpufreq_policy *cpufreq_po
 	if (!policy)
 		return NULL;
 
-	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&policy->cpus, GFP_KERNEL))
 		goto err_free_policy;
 
 	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL))


