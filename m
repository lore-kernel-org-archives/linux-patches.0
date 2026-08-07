Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918BD390608;
	Fri,  7 Aug 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117115; cv=none; b=mu91eCP+p7ELJR6NAPrttEKe584TKYQNTzYh1/1b2noMvdBeZ9WPr5i2IgqFyEHrqY6cRaRTnX3s/b0tte+0wT/SZkJMflY0mtYIz5VKVEEznBGpN5rpoExOKd8CO20sr4A8Jt38+EEDK8OtJDBXTA22949LU/mmVCIMRaaNVdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117115; c=relaxed/simple;
	bh=fZ7jXpdxd4tup5Pxk5L/EqXTNT3qESY5KVqn1JCJ8tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEAYuncMaLQhitu0K0VqYN20sHaf6dFGp+q7xRSaIioFephLnlY6ZOhI4PgyvlyAD79nC/2zQrv55Uf5HnngiBCcdqqAu0AWEd0vUG0POOSJDkZDHHNj6w4sCmgpEIMacQUSWLpEsjKWLOkv3cPJKGu6/ZkdedkFU9nR0yNGZyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8Yq/Y9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8Yq/Y9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28351F000E9;
	Fri,  7 Aug 2026 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117114;
	bh=Zu6tffF6YJZvMOjMoLDv/DZMQVmir5CthhQWu+aeL84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8Yq/Y9CAxqggOudOMIndKxP3O+XXah25wtRpG+ngzwgcNrYXb/b+Y+Q7Kmc8gkoh
	 OTRknlsDNrCp8oyOqwDnsaKq8QECpTJGcb6SxE8u8g6V+k4MP8FeSWCuodHUHJQQ6y
	 uNmO0GjuV72Qj0Rmn8zkju7wj6Vi1oBnYArV169E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 203/438] ACPI: CPPC: Check all controls for fast switching
Date: Fri,  7 Aug 2026 16:36:39 +0200
Message-ID: <20260807143432.348664499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 11055a46f398779b69aa36afb7c9f4124529a075 upstream.

ACPI 6.2, Section 6.2.11.2 permits _CPC registers to use flexible
address spaces. Linux advertises that capability through _OSC and parses
the address space of each _CPC register independently. A directly
accessible DESIRED_PERF combined with PCC-backed limits is therefore a
valid configuration.

cppc_allow_fast_switch() only checks DESIRED_PERF, although the fast-switch
callback passes DESIRED_PERF, MIN_PERF and MAX_PERF to cppc_set_perf(). If
a limit uses PCC, that function can sleep while called from scheduler
context.

Allow fast switching only when every supported control used by the
callback has an address space already accepted for fast access. Check the
complete policy domain, including initialized CPUs that are currently
offline and may later become the policy's managing CPU.

Fixes: 658fa7b1c47a ("ACPI: CPPC: Add cppc_get_perf() API to read performance controls")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260722093825.1030594-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c       |   22 +++++++++++++++++-----
 drivers/cpufreq/cppc_cpufreq.c |    2 +-
 include/acpi/cppc_acpi.h       |    5 +++--
 3 files changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -475,17 +475,29 @@ bool acpi_cpc_valid(void)
 }
 EXPORT_SYMBOL_GPL(acpi_cpc_valid);
 
-bool cppc_allow_fast_switch(void)
+bool cppc_allow_fast_switch(const struct cpumask *cpus)
 {
-	struct cpc_register_resource *desired_reg;
+	struct cpc_register_resource *desired_reg, *min_reg, *max_reg;
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpus) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
+		if (!cpc_ptr)
+			return false;
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
-		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-				!CPC_IN_SYSTEM_IO(desired_reg))
+		min_reg = &cpc_ptr->cpc_regs[MIN_PERF];
+		max_reg = &cpc_ptr->cpc_regs[MAX_PERF];
+
+		if (!CPC_SUPPORTED(desired_reg) ||
+		    (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
+		     !CPC_IN_SYSTEM_IO(desired_reg)) ||
+		    (CPC_SUPPORTED(min_reg) &&
+		     !CPC_IN_SYSTEM_MEMORY(min_reg) &&
+		     !CPC_IN_SYSTEM_IO(min_reg)) ||
+		    (CPC_SUPPORTED(max_reg) &&
+		     !CPC_IN_SYSTEM_MEMORY(max_reg) &&
+		     !CPC_IN_SYSTEM_IO(max_reg)))
 			return false;
 	}
 
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -694,7 +694,7 @@ static int cppc_cpufreq_cpu_init(struct
 		goto out;
 	}
 
-	policy->fast_switch_possible = cppc_allow_fast_switch();
+	policy->fast_switch_possible = cppc_allow_fast_switch(policy->cpus);
 	policy->dvfs_possible_from_any_cpu = true;
 
 	/*
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -166,7 +166,7 @@ extern u64 cppc_get_dmi_max_khz(void);
 extern unsigned int cppc_perf_to_khz(struct cppc_perf_caps *caps, unsigned int perf);
 extern unsigned int cppc_khz_to_perf(struct cppc_perf_caps *caps, unsigned int freq);
 extern bool acpi_cpc_valid(void);
-extern bool cppc_allow_fast_switch(void);
+bool cppc_allow_fast_switch(const struct cpumask *cpus);
 extern int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data);
 extern int cppc_get_transition_latency(int cpu);
 extern bool cpc_ffh_supported(void);
@@ -230,7 +230,8 @@ static inline bool acpi_cpc_valid(void)
 {
 	return false;
 }
-static inline bool cppc_allow_fast_switch(void)
+
+static inline bool cppc_allow_fast_switch(const struct cpumask *cpus)
 {
 	return false;
 }


