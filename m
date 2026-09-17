Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554735476FC;
	Thu, 17 Sep 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660231; cv=none; b=Z0WQETPN1CMfKw8bz57fIGSe5KcI+o6jDiK7EQ4lPCWww7xiDYdapMvQcgMa90jX47iNbgJX0fhN1QhHOB84/FgRafrJRgnsZS4TMIylHoMX3foQhgS8nIZzfwsdtZBbpeFUHEZV+i+1WGbwm+bXGaa/eOOfWZ9OsipKcWgdDqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660231; c=relaxed/simple;
	bh=1kI1LBG50o0rqE8z7OHd0nth+sX/UOrusBVkDjg4LK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf1bxOUM/8sf6h+r8lwQBsU+99fZ4VEwlfjtctEV1ptkiC121Qgm3SBC/5SgZOg3eqgJjJvQ/WuS618HDt5/lCImH6VM6IXnKyQE1UufMAidmgzBdvZIb6sOEebP7kbU4jskXLlx9+xcXwcrA4gb400q8w+OJnHQTzNNBNdBoTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSpPceQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSpPceQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607AD1F000FF;
	Thu, 17 Sep 2026 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660223;
	bh=RmLQuQQfG2WzpoKRVMnYvsqVTh2cijsYelhItSBE0ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSpPceQUOJurHg8iXiyDzNbUJ2WlOkuAGmhnnWA2bZFD1XRh5km1QWcA/YGCEAB7u
	 2kOOY+t1nbkVyqw8tSZk0ZrO+G0Z+G/FHuYKxUCRRGB793yIUpKALezDYpyvzfIyxg
	 xtbEMqim0WpQArHHiqk4cpGSB6UfxpQF3lodgT6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 520/733] cpufreq: initialize policy rwsem before sysfs publication
Date: Thu, 17 Sep 2026 16:13:48 +0100
Message-ID: <20260917151405.117983540@linuxfoundation.org>
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
@@ -1258,6 +1258,8 @@ static struct cpufreq_policy *cpufreq_po
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_rwsem(&policy->rwsem);
+
 	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
@@ -1272,8 +1274,6 @@ static struct cpufreq_policy *cpufreq_po
 		goto err_free_real_cpus;
 	}
 
-	init_rwsem(&policy->rwsem);
-
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;


