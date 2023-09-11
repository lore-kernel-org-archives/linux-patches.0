Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96F1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C242DC433C8;
	Mon, 11 Sep 2023 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441860;
	bh=BHeKoNpG4vxnTcX/vfhBydn+JQDr+HjzJyJL/3FDg8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuTsg1wbOuPiKxIuwMwSEyCcFYy0hYo2yFWx5pkK1hAbncoGXts9BngKFpT4PXqH0
	 BBztl17ZV91iqdOwCr8qSgNu/91grMfQRprWOjTyrhm5Da6I22e5nMc+JRJV0ZIsi/
	 bH/Xrf/x3WiOVOHO9bA1IoYhkhsmzVTZOvqIRBqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 562/739] coresight: trbe: Fix TRBE potential sleep in atomic context
Date: Mon, 11 Sep 2023 15:46:01 +0200
Message-ID: <20230911134706.776965586@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit c0a232f1e19e378c5c4e5973a996392942c80090 ]

smp_call_function_single() will allocate an IPI interrupt vector to
the target processor and send a function call request to the interrupt
vector. After the target processor receives the IPI interrupt, it will
execute arm_trbe_remove_coresight_cpu() call request in the interrupt
handler.

According to the device_unregister() stack information, if other process
is useing the device, the down_write() may sleep, and trigger deadlocks
or unexpected errors.

  arm_trbe_remove_coresight_cpu
    coresight_unregister
      device_unregister
        device_del
          kobject_del
            __kobject_del
              sysfs_remove_dir
                kernfs_remove
                  down_write ---------> it may sleep

Add a helper arm_trbe_disable_cpu() to disable TRBE precpu irq and reset
per TRBE.
Simply call arm_trbe_remove_coresight_cpu() directly without useing the
smp_call_function_single(), which is the same as registering the TRBE
coresight device.

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Link: https://lore.kernel.org/r/20230814093813.19152-2-hejunhao3@huawei.com
[ Remove duplicate cpumask checks during removal ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[ v3 - Remove the operation of assigning NULL to cpudata->drvdata ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230818084052.10116-1-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 32 +++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 8e4eb37e66e82..e20c1c6acc731 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1225,6 +1225,16 @@ static void arm_trbe_enable_cpu(void *info)
 	enable_percpu_irq(drvdata->irq, IRQ_TYPE_NONE);
 }
 
+static void arm_trbe_disable_cpu(void *info)
+{
+	struct trbe_drvdata *drvdata = info;
+	struct trbe_cpudata *cpudata = this_cpu_ptr(drvdata->cpudata);
+
+	disable_percpu_irq(drvdata->irq);
+	trbe_reset_local(cpudata);
+}
+
+
 static void arm_trbe_register_coresight_cpu(struct trbe_drvdata *drvdata, int cpu)
 {
 	struct trbe_cpudata *cpudata = per_cpu_ptr(drvdata->cpudata, cpu);
@@ -1329,18 +1339,12 @@ static void arm_trbe_probe_cpu(void *info)
 	cpumask_clear_cpu(cpu, &drvdata->supported_cpus);
 }
 
-static void arm_trbe_remove_coresight_cpu(void *info)
+static void arm_trbe_remove_coresight_cpu(struct trbe_drvdata *drvdata, int cpu)
 {
-	int cpu = smp_processor_id();
-	struct trbe_drvdata *drvdata = info;
-	struct trbe_cpudata *cpudata = per_cpu_ptr(drvdata->cpudata, cpu);
 	struct coresight_device *trbe_csdev = coresight_get_percpu_sink(cpu);
 
-	disable_percpu_irq(drvdata->irq);
-	trbe_reset_local(cpudata);
 	if (trbe_csdev) {
 		coresight_unregister(trbe_csdev);
-		cpudata->drvdata = NULL;
 		coresight_set_percpu_sink(cpu, NULL);
 	}
 }
@@ -1369,8 +1373,10 @@ static int arm_trbe_remove_coresight(struct trbe_drvdata *drvdata)
 {
 	int cpu;
 
-	for_each_cpu(cpu, &drvdata->supported_cpus)
-		smp_call_function_single(cpu, arm_trbe_remove_coresight_cpu, drvdata, 1);
+	for_each_cpu(cpu, &drvdata->supported_cpus) {
+		smp_call_function_single(cpu, arm_trbe_disable_cpu, drvdata, 1);
+		arm_trbe_remove_coresight_cpu(drvdata, cpu);
+	}
 	free_percpu(drvdata->cpudata);
 	return 0;
 }
@@ -1409,12 +1415,8 @@ static int arm_trbe_cpu_teardown(unsigned int cpu, struct hlist_node *node)
 {
 	struct trbe_drvdata *drvdata = hlist_entry_safe(node, struct trbe_drvdata, hotplug_node);
 
-	if (cpumask_test_cpu(cpu, &drvdata->supported_cpus)) {
-		struct trbe_cpudata *cpudata = per_cpu_ptr(drvdata->cpudata, cpu);
-
-		disable_percpu_irq(drvdata->irq);
-		trbe_reset_local(cpudata);
-	}
+	if (cpumask_test_cpu(cpu, &drvdata->supported_cpus))
+		arm_trbe_disable_cpu(drvdata);
 	return 0;
 }
 
-- 
2.40.1



