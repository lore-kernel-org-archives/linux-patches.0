Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D7B388895;
	Sat, 12 Sep 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224380; cv=none; b=msLhIjWvJLqRi6BRbhZLW3jTELr6Eweis1vgyxun7LD94K0Dy8Q7cDKw4eQlMUDjjMDg1CgI15ViYEYEmyKj1RmlWy/KG4kwE9SXWYIRJxoFauMstiI/nQGdOEBqYUgF+AFJkORiPh4+SjYAFDG9qPjCtaXzZeoL2zxcR2qFwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224380; c=relaxed/simple;
	bh=a3Jw17N3FIUngjOQjg+//vVndQ5tBwPLJ0wGqaQDZ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAfJeoBNaVVbHJ7o4vnLL0chjmQk9wue/EzszuMRzjiQ7Uu62ddzApmq7Oj3hmsRbzbUGmU69RPy4fqhdGWGjGL54j3FjAmPRw3IjoLr1qJXxdzGMb2kxgPjXUurctJwKea+whvbUUF9t+GjcTtAB0kfVi1nqOqZwQKPbfAz2Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+g0HFpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+g0HFpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED771F00893;
	Sat, 12 Sep 2026 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224377;
	bh=EXR5ZlQPnTPcYhTD48LNpHty5FDc6/FuhqNNk5u0AzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+g0HFpvKsyF61VK/dBZxMV3JVeQyhBgaobW4pM4LdELFOVpaSepxcIGpbdJB1JWb
	 HDkAUhCmPGRcC422RJTPqpAOR7FLDVbw/RsQMSSMaZi5DbdbN/MjwITzcaiea4ttQw
	 J3f30lc52EMa3qF+OqfaP6OS0nSAANeIFPE+N4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0980/1424] ACPI: processor: idle: Optimize ACPI idle driver registration
Date: Sat, 12 Sep 2026 08:56:52 +0200
Message-ID: <20260912065629.262202659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 7a8c994cbb2db3c5335cee35fd486557f5aaf7e1 ]

Currently, the ACPI idle driver is registered from within a CPU
hotplug callback. Although this didn't cause any functional issues,
this is questionable and confusing. And it is better to register
the cpuidle driver when all of the CPUs have been brought up.

So add a new function to initialize acpi_idle_driver based on the
power management information of an available CPU and register cpuidle
driver in acpi_processor_driver_init().

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20250728070612.1260859-3-lihuisong@huawei.com
[ rjw: Added missing inline modifiers ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

This commit has four changes under the commit 7a8c994cbb2d (ACPI:
processor: idle: Optimize ACPI idle driver registration):

 1) move acpi_processor_register_idle_driver() ahead of the
    driver_register().
 2) add acpi_processor_cstate_first_run_checks() before calling
    acpi_processor_get_power_info().
 3) squash the commit 9d68320b2bca (ACPI: processor: idle: Fix
    function defined but not used warning) into this change.
 4) use for_each_possible_cpu(cpu) to scan all possible cpus.

[ rjw: New comment edits, changelog tweak ]

Stable-dep-of: 06f32dd67e6b ("ACPI: processor: Unregister cpufreq notifier on init failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 10 ++++-
 drivers/acpi/processor_idle.c   | 66 +++++++++++++++++++++------------
 include/acpi/processor.h        |  2 +
 3 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 4bd16b3f07814..ccf8d93c314b7 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -269,9 +269,11 @@ static int __init acpi_processor_driver_init(void)
 		acpi_processor_ignore_ppc_init();
 	}
 
+	acpi_processor_register_idle_driver();
+
 	result = driver_register(&acpi_processor_driver);
 	if (result < 0)
-		return result;
+		goto unregister_idle_drv;
 
 	result = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
 					   "acpi/cpu-drv:online",
@@ -284,8 +286,13 @@ static int __init acpi_processor_driver_init(void)
 
 	acpi_processor_throttling_init();
 	return 0;
+
 err:
 	driver_unregister(&acpi_processor_driver);
+
+unregister_idle_drv:
+	acpi_processor_unregister_idle_driver();
+
 	return result;
 }
 
@@ -303,6 +310,7 @@ static void __exit acpi_processor_driver_exit(void)
 	cpuhp_remove_state_nocalls(hp_online);
 	cpuhp_remove_state_nocalls(CPUHP_ACPI_CPUDRV_DEAD);
 	driver_unregister(&acpi_processor_driver);
+	acpi_processor_unregister_idle_driver();
 }
 
 module_init(acpi_processor_driver_init);
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0b0d5680832ae..1309254f51871 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1379,7 +1379,49 @@ int acpi_processor_power_state_has_changed(struct acpi_processor *pr)
 	return 0;
 }
 
-static int acpi_processor_registered;
+void acpi_processor_register_idle_driver(void)
+{
+	struct acpi_processor *pr;
+	int ret = -ENODEV;
+	int cpu;
+
+	/*
+	 * ACPI idle driver is used by all possible CPUs.
+	 * Use the processor power info of one in them to set up idle states.
+	 * Note that the existing idle handler will be used on platforms that
+	 * only support C1.
+	 */
+	for_each_possible_cpu(cpu) {
+		pr = per_cpu(processors, cpu);
+		if (!pr)
+			continue;
+
+		acpi_processor_cstate_first_run_checks();
+		ret = acpi_processor_get_power_info(pr);
+		if (!ret) {
+			pr->flags.power_setup_done = 1;
+			acpi_processor_setup_cpuidle_states(pr);
+			break;
+		}
+	}
+
+	if (ret) {
+		pr_debug("No ACPI power information from any CPUs.\n");
+		return;
+	}
+
+	ret = cpuidle_register_driver(&acpi_idle_driver);
+	if (ret) {
+		pr_debug("register %s failed.\n", acpi_idle_driver.name);
+		return;
+	}
+	pr_debug("%s registered with cpuidle.\n", acpi_idle_driver.name);
+}
+
+void acpi_processor_unregister_idle_driver(void)
+{
+	cpuidle_unregister_driver(&acpi_idle_driver);
+}
 
 int acpi_processor_power_init(struct acpi_processor *pr)
 {
@@ -1394,22 +1436,7 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 	if (!acpi_processor_get_power_info(pr))
 		pr->flags.power_setup_done = 1;
 
-	/*
-	 * Install the idle handler if processor power management is supported.
-	 * Note that we use previously set idle handler will be used on
-	 * platforms that only support C1.
-	 */
 	if (pr->flags.power) {
-		/* Register acpi_idle_driver if not already registered */
-		if (!acpi_processor_registered) {
-			acpi_processor_setup_cpuidle_states(pr);
-			retval = cpuidle_register_driver(&acpi_idle_driver);
-			if (retval)
-				return retval;
-			pr_debug("%s registered with cpuidle\n",
-				 acpi_idle_driver.name);
-		}
-
 		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 		if (!dev)
 			return -ENOMEM;
@@ -1422,14 +1449,11 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		 */
 		retval = cpuidle_register_device(dev);
 		if (retval) {
-			if (acpi_processor_registered == 0)
-				cpuidle_unregister_driver(&acpi_idle_driver);
 
 			per_cpu(acpi_cpuidle_device, pr->id) = NULL;
 			kfree(dev);
 			return retval;
 		}
-		acpi_processor_registered++;
 	}
 	return 0;
 }
@@ -1443,10 +1467,6 @@ int acpi_processor_power_exit(struct acpi_processor *pr)
 
 	if (pr->flags.power) {
 		cpuidle_unregister_device(dev);
-		acpi_processor_registered--;
-		if (acpi_processor_registered == 0)
-			cpuidle_unregister_driver(&acpi_idle_driver);
-
 		kfree(dev);
 	}
 
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 3f34ebb275253..f85bbb7b8c6ca 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -418,6 +418,8 @@ int acpi_processor_power_init(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr);
 int acpi_processor_power_state_has_changed(struct acpi_processor *pr);
 int acpi_processor_hotplug(struct acpi_processor *pr);
+void acpi_processor_register_idle_driver(void);
+void acpi_processor_unregister_idle_driver(void);
 #else
 static inline int acpi_processor_power_init(struct acpi_processor *pr)
 {
-- 
2.53.0



