Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E63CAA41;
	Wed, 30 Sep 2026 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795607; cv=none; b=pybyk/7sk+BPiQ6wZbfHXMJuPC2RFx3ebR67airh4UJ7nhRqulujZkgJil2Y339bSaQkFzaWD8ESendt0G3PD6HH3fvNHiHtlQhc4YCAroDlDQFnWtyVomGmUndt8nbF//iSh+ZIbqv9oV13IzSlodoMhVNQFghFDpj/p5/UFLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795607; c=relaxed/simple;
	bh=dqqwefU+oHZTZ+SYImGqBCMMcf7THJDijj/mry7p7sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwrEQD7OX3IT97qz9LOA/pgoRy3rpCt/JYY7I98ZmdowSPgUhTqAMxbvKwVIkr0SdrbJAbzeyE8Ez/f+X9hXIzH3miR5ndXq1WXLH5qn4Dqc/AVwUdt0dyGyE2NhEDPPLQ5xHdqg0IY46DAZyFWHfahXQBLfgT/KCGMx9+T5OpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQO1V21i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQO1V21i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C429B1F00898;
	Wed, 30 Sep 2026 19:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795606;
	bh=Ie1he4VaKa1gXuR3P0QwMlGp368zqGSsPn+QUiGlabA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQO1V21ij5maIFjbSSn16lCQ5M6tr1k2w4oBpkcVcj2aq8OZCZ0MryjF8OrS3omCo
	 yBp13JV+/oyfjQV3qkL4e2TW6GPYF548pn5c0MdbZ43EdoSGvAioN0m9GOAYMvaCFV
	 sXTEbNtJLGHA7sGid6jTGAQiNldlOJKNbXuuDzoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 0621/1193] cpufreq: initialize policy rwsem before sysfs publication
Date: Wed, 30 Sep 2026 17:21:45 +0200
Message-ID: <20260930152448.040372088@linuxfoundation.org>
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
@@ -1273,6 +1273,8 @@ static struct cpufreq_policy *cpufreq_po
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_rwsem(&policy->rwsem);
+
 	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
@@ -1287,8 +1289,6 @@ static struct cpufreq_policy *cpufreq_po
 		goto err_free_real_cpus;
 	}
 
-	init_rwsem(&policy->rwsem);
-
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;


