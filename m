Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ECD50AC15;
	Wed, 30 Sep 2026 15:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783163; cv=none; b=D0wqyIa0r0ENy2lHhClNyoO4raWEVXly16sUzbpAajTo+fBPVyjZveP/KvBsZdyLOHdjA0cqFKFyHBB3ic/zq/bmERAIjbhwBJ5PK6hqmhh3/mbr/6OhblXSCuKwT61BSBhtQ5auY97QtwFxBVUJr4qL0RWbHH2F3p2BNU30ioA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783163; c=relaxed/simple;
	bh=79pT4sJ5bd13ldryrUdH5dOJodqKTfcBueFLQKBFFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcH4YvlOEJvcD/qLdVhkv+xTLnIeeQm/fw8qNb3ekD2x17SH2IURIrsXpV5I83i4i6i/tGVhdFs9oXleaVOiqPeGnD7AS7I15bU/Mj9CtKZvg79JMdWZtkiwe/vc2Ndltt77spB6N881eEmLWoF/3wtNNi39sCUC5PTa5jinhv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBitN7c7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBitN7c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952B11F00893;
	Wed, 30 Sep 2026 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783160;
	bh=oQDuQZN4TTKWVmXt5NvM7FHVvjPpnylIb8Q/qWQTfB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBitN7c71U8gEzigbm+0LEQHWiKLVmBHRFSszkwX7f17BJK73qUTb/loKFfCJQsyj
	 zRUML4ShWyqsOjLFFK8jQ6JSSoQKS88kRwEkdJwuTWb2UVR2VNaeZXkL7sfBeHsL37
	 iNSxjg7J1F4TMEfYEGkx985kRQBgjH3PG0WGHisQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 299/595] cpufreq: initialize policy rwsem before sysfs publication
Date: Wed, 30 Sep 2026 17:23:12 +0200
Message-ID: <20260930152354.122500087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 3e5d1bf4bd687beb2cb4e32a07af695455925588 upstream.

cpufreq_policy_alloc() initializes policy->rwsem after
kobject_init_and_add() has created the policy sysfs directory and its
default attributes. A sysfs access can therefore reach a policy callback
before the semaphore has been initialized.

Initialize policy->rwsem before publishing the policy kobject so sysfs
callbacks always see an initialized semaphore.

Fixes: 2fc3384dc75b ("cpufreq: Initialize policy->kobj while allocating policy")
Cc: All Applicable <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20260830155301.2713780-1-runyu.xiao@seu.edu.cn/
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20260902041915.3453421-1-runyu.xiao@seu.edu.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1213,6 +1213,8 @@ static struct cpufreq_policy *cpufreq_po
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_rwsem(&policy->rwsem);
+
 	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
@@ -1227,8 +1229,6 @@ static struct cpufreq_policy *cpufreq_po
 		goto err_free_real_cpus;
 	}
 
-	init_rwsem(&policy->rwsem);
-
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;


