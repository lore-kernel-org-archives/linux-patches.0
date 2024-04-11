Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D54146A83;
	Thu, 11 Apr 2024 10:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831175; cv=none; b=XjKpcfsLZHrW/M0lk9C3Bd5pZmcYN2GPAa2saTC91HwBjL+rqvdLhgGT4lMKayxGnPxsWJOl4nZUKuqkxIDXouPJHqdA158LeTU0wAYAw6RuCmZxnX6j2w+zMiulmIihcu2kqycnbyYEb7IGyfdHqv1Vq2YrSQgR7ytRlgcvitM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831175; c=relaxed/simple;
	bh=ipyDrzPg8u8trsjLQY5tFVrH8fGX6HuTOPlhZiOi+YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr0upwfcfcEK/zqkNt9EtHlP57cuY+XUyM3oHPx6WYq3v2c1ux6Vdwq+1wh1vlyim961y/JMgPYzejIJjNBPMzpbuEZYUiJ4ehvRwD5OdEKkImSOJnq0lbUEqJNijLgqXG3AuOOtvCx5bACigJ6ppD952u2985IW6U0uZvXGzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvF/SxOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvF/SxOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BD9C433C7;
	Thu, 11 Apr 2024 10:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831175;
	bh=ipyDrzPg8u8trsjLQY5tFVrH8fGX6HuTOPlhZiOi+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvF/SxOowmEAUcO06ERjgJA9vdzpyJkBEAtP3cXgs9ZewnsCVKl34l99QtTW9QQxw
	 H5AVp1RnoBAzCf7fxoivQlbZLlj8Zai13nCBw2KmLxgPKkpIkm6XBfC6OKUDXlTrjK
	 Qz9FiBa0lDpR8ltdxR6rswujvJrVrN8JkSHb+1eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
	Roman Stratiienko <r.stratiienko@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Dhruva Gole <d-gole@ti.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/114] cpufreq: Dont unregister cpufreq cooling on CPU hotplug
Date: Thu, 11 Apr 2024 11:56:01 +0200
Message-ID: <20240411095417.899690259@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit c4d61a529db788d2e52654f5b02c8d1de4952c5b ]

Offlining a CPU and bringing it back online is a common operation and it
happens frequently during system suspend/resume, where the non-boot CPUs
are hotplugged out during suspend and brought back at resume.

The cpufreq core already tries to make this path as fast as possible as
the changes are only temporary in nature and full cleanup of resources
isn't required in this case. For example the drivers can implement
online()/offline() callbacks to avoid a lot of tear down of resources.

On similar lines, there is no need to unregister the cpufreq cooling
device during suspend / resume, but only while the policy is getting
removed.

Moreover, unregistering the cpufreq cooling device is resulting in an
unwanted outcome, where the system suspend is eventually aborted in the
process.  Currently, during system suspend the cpufreq core unregisters
the cooling device, which in turn removes a kobject using device_del()
and that generates a notification to the userspace via uevent broadcast.
This causes system suspend to abort in some setups.

This was also earlier reported (indirectly) by Roman [1]. Maybe there is
another way around to fixing that problem properly, but this change
makes sense anyways.

Move the registering and unregistering of the cooling device to policy
creation and removal times onlyy.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218521
Reported-by: Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Link: https://patchwork.kernel.org/project/linux-pm/patch/20220710164026.541466-1-r.stratiienko@gmail.com/ [1]
Tested-by: Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4bc7c793de3b9..9177265d73b47 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1576,7 +1576,8 @@ static int cpufreq_online(unsigned int cpu)
 	if (cpufreq_driver->ready)
 		cpufreq_driver->ready(policy);
 
-	if (cpufreq_thermal_control_enabled(cpufreq_driver))
+	/* Register cpufreq cooling only for a new policy */
+	if (new_policy && cpufreq_thermal_control_enabled(cpufreq_driver))
 		policy->cdev = of_cpufreq_cooling_register(policy);
 
 	pr_debug("initialization complete\n");
@@ -1660,11 +1661,6 @@ static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
 	else
 		policy->last_policy = policy->policy;
 
-	if (cpufreq_thermal_control_enabled(cpufreq_driver)) {
-		cpufreq_cooling_unregister(policy->cdev);
-		policy->cdev = NULL;
-	}
-
 	if (has_target())
 		cpufreq_exit_governor(policy);
 
@@ -1725,6 +1721,15 @@ static void cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 		return;
 	}
 
+	/*
+	 * Unregister cpufreq cooling once all the CPUs of the policy are
+	 * removed.
+	 */
+	if (cpufreq_thermal_control_enabled(cpufreq_driver)) {
+		cpufreq_cooling_unregister(policy->cdev);
+		policy->cdev = NULL;
+	}
+
 	/* We did light-weight exit earlier, do full tear down now */
 	if (cpufreq_driver->offline)
 		cpufreq_driver->exit(policy);
-- 
2.43.0



