Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2B33D88
	for <patches@lists.linux.dev>; Fri,  6 May 2022 22:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651877660; x=1683413660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=caep34WgZSvPyz713lBbhCJDWIsKpnx2psF2WpckZJs=;
  b=hgunUojY/5RBz8YljXT8jl7DcKQUURKfs7V+A96NO1ToATWKa1UYVfRG
   XfQ53x3ikZobFlzc7U4931Lpqa0BGncdqkvDgmadqcmgCWZPujAY8g3an
   ZSxNGai6lSKGnk+/yjfZAs0Qi4YyIhbmJQSdoJqlNjfoX8YHHtPVet7I2
   NuiEU/uLUxtMBzvU7scDlxl5gjQDyAAHnndTBsqO4IOCQehTxUkQC0TQd
   +F+YSdqw4I+4OgdIL/OfycmNcKnB4IwNdj/SLUvEKav4B3it0BTQ9Q6cW
   86pUtpF8uZd3241f7UvaNCglRAdRjL8lTQQp0/1LxN5wdbL8OGYZ3JBVO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355030693"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355030693"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="695383623"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v7 03/12] stop_machine: Add stop_core_cpuslocked() for per-core operations
Date: Fri,  6 May 2022 15:54:01 -0700
Message-Id: <20220506225410.1652287-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506225410.1652287-1-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

Hardware core level testing features require near simultaneous execution
of WRMSR instructions on all threads of a core to initiate a test.

Provide a customized cut down version of stop_machine_cpuslocked() that
just operates on the threads of a single core.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/stop_machine.h | 16 ++++++++++++++++
 kernel/stop_machine.c        | 19 +++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 46fb3ebdd16e..ea7a74ea7389 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -124,6 +124,22 @@ int stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus);
  */
 int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus);
 
+/**
+ * stop_core_cpuslocked: - stop all threads on just one core
+ * @cpu: any cpu in the targeted core
+ * @fn: the function to run
+ * @data: the data ptr for @fn()
+ *
+ * Same as above, but instead of every CPU, only the logical CPUs of a
+ * single core are affected.
+ *
+ * Context: Must be called from within a cpus_read_lock() protected region.
+ *
+ * Return: 0 if all executions of @fn returned 0, any non zero return
+ * value if any returned non zero.
+ */
+int stop_core_cpuslocked(unsigned int cpu, cpu_stop_fn_t fn, void *data);
+
 int stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
 				   const struct cpumask *cpus);
 #else	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index cbc30271ea4d..579761729836 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -633,6 +633,25 @@ int stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
+int stop_core_cpuslocked(unsigned int cpu, cpu_stop_fn_t fn, void *data)
+{
+	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
+
+	struct multi_stop_data msdata = {
+		.fn = fn,
+		.data = data,
+		.num_threads = cpumask_weight(smt_mask),
+		.active_cpus = smt_mask,
+	};
+
+	lockdep_assert_cpus_held();
+
+	/* Set the initial state and stop all online cpus. */
+	set_state(&msdata, MULTI_STOP_PREPARE);
+	return stop_cpus(smt_mask, multi_cpu_stop, &msdata);
+}
+EXPORT_SYMBOL_GPL(stop_core_cpuslocked);
+
 /**
  * stop_machine_from_inactive_cpu - stop_machine() from inactive CPU
  * @fn: the function to run
-- 
2.35.1

