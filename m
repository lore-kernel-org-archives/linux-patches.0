Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9791C6BE;
	Wed,  5 Feb 2025 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768091; cv=none; b=eS3CRX0FvxMF8HyFr7Pv8kp6rqO+bB26v4y8VOnu32Lq4J7UWyAfYSkmr1qVwAhttfMqgtMgu3Q/JuEOHS/OAltpivvoxyeT6rQRyMbsUyj/QsXvMM/HBGtO38sYN4aYQ+1b0ClRo3zhYFaN0ALLdnBHTt7dgJoP1cA1kBGVCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768091; c=relaxed/simple;
	bh=amukkJXM2K7Yc2rAhK1QqEiP1SqIzh9Dz6cfiD683M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pqxv+VbjVRqsL+xjOYO4tPIhDigEJW/s74FDi8L160S5g9WqbYwWiEGmCT78h7SxLeSaTz+7APhnGN7JsI2NENmpnCctyUuPU2pgtLl10/V0nkJmfrhfoMHTVgX8BDuL8CFXucNUPP7YGyqDp5gUZJlZlc23O71XoXvTGp2xvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plRP1HCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plRP1HCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E6DC4CED1;
	Wed,  5 Feb 2025 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768091;
	bh=amukkJXM2K7Yc2rAhK1QqEiP1SqIzh9Dz6cfiD683M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plRP1HCo2wnI8iBQfMwJQ4NOR2wA2f9IbluM7EFhAhtcElz6W5VKoHZqPwax5amru
	 6vpyEdtaF1eR3/FMU8uqEoUC3d2iCFjfXn4SEu3DWZNxCAozk2RDBqR1BuqEuNi4tk
	 wII3kx/m6rN5nVeaBDr8OlyZ7osulE2s0+d1D6UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 523/590] tools/power turbostat: Allow using cpu device in perf counters on hybrid platforms
Date: Wed,  5 Feb 2025 14:44:38 +0100
Message-ID: <20250205134515.274223379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>

[ Upstream commit ae2cdf8d92ffc326104524a1f9da4cf75b6ea996 ]

Intel hybrid platforms expose different perf devices for P and E cores.
Instead of one, "/sys/bus/event_source/devices/cpu" device, there are
"/sys/bus/event_source/devices/{cpu_core,cpu_atom}".

This, however makes it more complicated for the user,
because most of the counters are available on both and had to be
handled manually.

This patch allows users to use "virtual" cpu device that is seemingly
translated to cpu_core and cpu_atom perf devices, depending on the type
of a CPU we are opening the counter for.

Signed-off-by: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Stable-dep-of: 2f60f03934a5 ("tools/power turbostat: Fix PMT mmaped file size rounding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 |  25 ++++++
 tools/power/x86/turbostat/turbostat.c | 105 ++++++++++++++++++++++++--
 2 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 067717bce1d4a..56c7ff6efcdab 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -33,6 +33,9 @@ name as necessary to disambiguate it from others is necessary.  Note that option
 		msr0xXXX is a hex offset, eg. msr0x10
 		/sys/path... is an absolute path to a sysfs attribute
 		<device> is a perf device from /sys/bus/event_source/devices/<device> eg. cstate_core
+			On Intel hybrid platforms, instead of one "cpu" perf device there are two, "cpu_core" and "cpu_atom" devices for P and E cores respectively.
+			Turbostat, in this case, allow user to use "cpu" device and will automatically detect the type of a CPU and translate it to "cpu_core" and "cpu_atom" accordingly.
+			For a complete example see "ADD PERF COUNTER EXAMPLE #2 (using virtual "cpu" device)".
 		<event> is a perf event for given device from /sys/bus/event_source/devices/<device>/events/<event> eg. c1-residency
 			perf/cstate_core/c1-residency would then use /sys/bus/event_source/devices/cstate_core/events/c1-residency
 
@@ -387,6 +390,28 @@ CPU     pCPU%c1 CPU%c1
 
 .fi
 
+.SH ADD PERF COUNTER EXAMPLE #2 (using virtual cpu device)
+Here we run on hybrid, Raptor Lake platform.
+We limit turbostat to show output for just cpu0 (pcore) and cpu12 (ecore).
+We add a counter showing number of L3 cache misses, using virtual "cpu" device,
+labeling it with the column header, "VCMISS".
+We add a counter showing number of L3 cache misses, using virtual "cpu_core" device,
+labeling it with the column header, "PCMISS". This will fail on ecore cpu12.
+We add a counter showing number of L3 cache misses, using virtual "cpu_atom" device,
+labeling it with the column header, "ECMISS". This will fail on pcore cpu0.
+We display it only once, after the conclusion of 0.1 second sleep.
+.nf
+sudo ./turbostat --quiet --cpu 0,12 --show CPU --add perf/cpu/cache-misses,cpu,delta,raw,VCMISS --add perf/cpu_core/cache-misses,cpu,delta,raw,PCMISS --add perf/cpu_atom/cache-misses,cpu,delta,raw,ECMISS sleep .1
+turbostat: added_perf_counters_init_: perf/cpu_atom/cache-misses: failed to open counter on cpu0
+turbostat: added_perf_counters_init_: perf/cpu_core/cache-misses: failed to open counter on cpu12
+0.104630 sec
+CPU                 ECMISS                  PCMISS                  VCMISS
+-       0x0000000000000000      0x0000000000000000      0x0000000000000000
+0       0x0000000000000000      0x0000000000007951      0x0000000000007796
+12      0x000000000001137a      0x0000000000000000      0x0000000000011392
+
+.fi
+
 .SH ADD PMT COUNTER EXAMPLE
 Here we limit turbostat to showing just the CPU number 0.
 We add two counters, showing crystal clock count and the DC6 residency.
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index a5ebee8b23bbe..38363f11f49f0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -31,6 +31,9 @@
 )
 // end copied section
 
+#define CPUID_LEAF_MODEL_ID			0x1A
+#define CPUID_LEAF_MODEL_ID_CORE_TYPE_SHIFT	24
+
 #define X86_VENDOR_INTEL	0
 
 #include INTEL_FAMILY_HEADER
@@ -89,6 +92,9 @@
 #define PERF_DEV_NAME_BYTES 32
 #define PERF_EVT_NAME_BYTES 32
 
+#define INTEL_ECORE_TYPE	0x20
+#define INTEL_PCORE_TYPE	0x40
+
 enum counter_scope { SCOPE_CPU, SCOPE_CORE, SCOPE_PACKAGE };
 enum counter_type { COUNTER_ITEMS, COUNTER_CYCLES, COUNTER_SECONDS, COUNTER_USEC, COUNTER_K2M };
 enum counter_format { FORMAT_RAW, FORMAT_DELTA, FORMAT_PERCENT, FORMAT_AVERAGE };
@@ -1848,6 +1854,7 @@ struct cpu_topology {
 	int logical_node_id;	/* 0-based count within the package */
 	int physical_core_id;
 	int thread_id;
+	int type;
 	cpu_set_t *put_ids;	/* Processing Unit/Thread IDs */
 } *cpus;
 
@@ -5659,6 +5666,32 @@ int init_thread_id(int cpu)
 	return 0;
 }
 
+int set_my_cpu_type(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int max_level;
+
+	__cpuid(0, max_level, ebx, ecx, edx);
+
+	if (max_level < CPUID_LEAF_MODEL_ID)
+		return 0;
+
+	__cpuid(CPUID_LEAF_MODEL_ID, eax, ebx, ecx, edx);
+
+	return (eax >> CPUID_LEAF_MODEL_ID_CORE_TYPE_SHIFT);
+}
+
+int set_cpu_hybrid_type(int cpu)
+{
+	if (cpu_migrate(cpu))
+		return -1;
+
+	int type = set_my_cpu_type();
+
+	cpus[cpu].type = type;
+	return 0;
+}
+
 /*
  * snapshot_proc_interrupts()
  *
@@ -8287,6 +8320,8 @@ void topology_probe(bool startup)
 
 	for_all_proc_cpus(init_thread_id);
 
+	for_all_proc_cpus(set_cpu_hybrid_type);
+
 	/*
 	 * For online cpus
 	 * find max_core_id, max_package_id
@@ -8551,6 +8586,35 @@ void check_perf_access(void)
 		bic_enabled &= ~BIC_IPC;
 }
 
+bool perf_has_hybrid_devices(void)
+{
+	/*
+	 *  0: unknown
+	 *  1: has separate perf device for p and e core
+	 * -1: doesn't have separate perf device for p and e core
+	 */
+	static int cached;
+
+	if (cached > 0)
+		return true;
+
+	if (cached < 0)
+		return false;
+
+	if (access("/sys/bus/event_source/devices/cpu_core", F_OK)) {
+		cached = -1;
+		return false;
+	}
+
+	if (access("/sys/bus/event_source/devices/cpu_atom", F_OK)) {
+		cached = -1;
+		return false;
+	}
+
+	cached = 1;
+	return true;
+}
+
 int added_perf_counters_init_(struct perf_counter_info *pinfo)
 {
 	size_t num_domains = 0;
@@ -8607,29 +8671,56 @@ int added_perf_counters_init_(struct perf_counter_info *pinfo)
 			if (domain_visited[next_domain])
 				continue;
 
-			perf_type = read_perf_type(pinfo->device);
+			/*
+			 * Intel hybrid platforms expose different perf devices for P and E cores.
+			 * Instead of one, "/sys/bus/event_source/devices/cpu" device, there are
+			 * "/sys/bus/event_source/devices/{cpu_core,cpu_atom}".
+			 *
+			 * This makes it more complicated to the user, because most of the counters
+			 * are available on both and have to be handled manually, otherwise.
+			 *
+			 * Code below, allow user to use the old "cpu" name, which is translated accordingly.
+			 */
+			const char *perf_device = pinfo->device;
+
+			if (strcmp(perf_device, "cpu") == 0 && perf_has_hybrid_devices()) {
+				switch (cpus[cpu].type) {
+				case INTEL_PCORE_TYPE:
+					perf_device = "cpu_core";
+					break;
+
+				case INTEL_ECORE_TYPE:
+					perf_device = "cpu_atom";
+					break;
+
+				default: /* Don't change, we will probably fail and report a problem soon. */
+					break;
+				}
+			}
+
+			perf_type = read_perf_type(perf_device);
 			if (perf_type == (unsigned int)-1) {
 				warnx("%s: perf/%s/%s: failed to read %s",
-				      __func__, pinfo->device, pinfo->event, "type");
+				      __func__, perf_device, pinfo->event, "type");
 				continue;
 			}
 
-			perf_config = read_perf_config(pinfo->device, pinfo->event);
+			perf_config = read_perf_config(perf_device, pinfo->event);
 			if (perf_config == (unsigned int)-1) {
 				warnx("%s: perf/%s/%s: failed to read %s",
-				      __func__, pinfo->device, pinfo->event, "config");
+				      __func__, perf_device, pinfo->event, "config");
 				continue;
 			}
 
 			/* Scale is not required, some counters just don't have it. */
-			perf_scale = read_perf_scale(pinfo->device, pinfo->event);
+			perf_scale = read_perf_scale(perf_device, pinfo->event);
 			if (perf_scale == 0.0)
 				perf_scale = 1.0;
 
 			fd_perf = open_perf_counter(cpu, perf_type, perf_config, -1, 0);
 			if (fd_perf == -1) {
 				warnx("%s: perf/%s/%s: failed to open counter on cpu%d",
-				      __func__, pinfo->device, pinfo->event, cpu);
+				      __func__, perf_device, pinfo->event, cpu);
 				continue;
 			}
 
@@ -8639,7 +8730,7 @@ int added_perf_counters_init_(struct perf_counter_info *pinfo)
 
 			if (debug)
 				fprintf(stderr, "Add perf/%s/%s cpu%d: %d\n",
-					pinfo->device, pinfo->event, cpu, pinfo->fd_perf_per_domain[next_domain]);
+					perf_device, pinfo->event, cpu, pinfo->fd_perf_per_domain[next_domain]);
 		}
 
 		pinfo = pinfo->next;
-- 
2.39.5



