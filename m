Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F018DF7D;
	Mon, 28 Oct 2024 06:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098394; cv=none; b=mpyhRYxB77SGe/HoSNSdwMgDlvMFiK5VFFJmtKObJx9Y+9wKefRLrHIsj4IQmin8Flh0/gINFC+d0Wt5K3orBi5rEOY3qZwfnSOwFRqFF4cxs8qD/a0JXDnQwBzAvxraJMY3PSjdyVj+5+U/WZyozsoph+c9YUN6P4AQMAfbuN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098394; c=relaxed/simple;
	bh=bpHkTo89F/aoVj2Y++tv0rBasXbuEXJ9gAg3OaLV2sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIKYR3FcY2Wrf09K+WjAtBFqTYYvPi6ly/4wRs1/1SuojuYeE4ZaCU8fmyMxMnoNywdIYO23md29zKBsctZqQvrMvrLlZKDdEaIEhvQbSB3yvqMElvhD5OTZKzI8eZ+e6Gu+GzvzqOCQD9EBCl2l57MeJkN2C0gR9RPaB1u1ncM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqTqZ9yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqTqZ9yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DACFC4CEC7;
	Mon, 28 Oct 2024 06:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098394;
	bh=bpHkTo89F/aoVj2Y++tv0rBasXbuEXJ9gAg3OaLV2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqTqZ9ySLyZea4wCk0SM0akGdFWam3NDoEOBCHcQmHCb3oYs0pe5JfVRY4/FjZRYN
	 kRhLV4Y0Ae+utnWGMoz7ey0XSgeABrGtrdOSZORvUgK9eeoBeudpEv9FD5L38IHsIO
	 Jap+UEHoa148RwByk72+6Zp0MydZ+jRoWoz1mCpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.11 206/261] perf/x86/rapl: Fix the energy-pkg event for AMD CPUs
Date: Mon, 28 Oct 2024 07:25:48 +0100
Message-ID: <20241028062317.232710660@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

commit 8d72eba1cf8cecd76a2b4c1dd7673c2dc775f514 upstream.

After commit:

  63edbaa48a57 ("x86/cpu/topology: Add support for the AMD 0x80000026 leaf")

... on AMD processors that support extended CPUID leaf 0x80000026, the
topology_die_cpumask() and topology_logical_die_id() macros no longer
return the package cpumask and package ID, instead they return the CCD
(Core Complex Die) mask and ID respectively.

This leads to the energy-pkg event scope to be modified to CCD instead of package.

So, change the PMU scope for AMD and Hygon back to package.

On a 12 CCD 1 Package AMD Zen4 Genoa machine:

  Before:

  $ cat /sys/devices/power/cpumask
  0,8,16,24,32,40,48,56,64,72,80,88.

The expected cpumask here is supposed to be just "0", as it is a package
scope event, only one CPU will be collecting the event for all the CPUs in
the package.

  After:

  $ cat /sys/devices/power/cpumask
  0

[ mingo: Cleaned up the changelog ]

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20240904100934.3260-1-Dhananjay.Ugwekar@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/rapl.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -103,6 +103,19 @@ static struct perf_pmu_events_attr event
 	.event_str	= str,							\
 };
 
+/*
+ * RAPL Package energy counter scope:
+ * 1. AMD/HYGON platforms have a per-PKG package energy counter
+ * 2. For Intel platforms
+ *	2.1. CLX-AP is multi-die and its RAPL MSRs are die-scope
+ *	2.2. Other Intel platforms are single die systems so the scope can be
+ *	     considered as either pkg-scope or die-scope, and we are considering
+ *	     them as die-scope.
+ */
+#define rapl_pmu_is_pkg_scope()				\
+	(boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||	\
+	 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+
 struct rapl_pmu {
 	raw_spinlock_t		lock;
 	int			n_active;
@@ -140,9 +153,25 @@ static unsigned int rapl_cntr_mask;
 static u64 rapl_timer_ms;
 static struct perf_msr *rapl_msrs;
 
+/*
+ * Helper functions to get the correct topology macros according to the
+ * RAPL PMU scope.
+ */
+static inline unsigned int get_rapl_pmu_idx(int cpu)
+{
+	return rapl_pmu_is_pkg_scope() ? topology_logical_package_id(cpu) :
+					 topology_logical_die_id(cpu);
+}
+
+static inline const struct cpumask *get_rapl_pmu_cpumask(int cpu)
+{
+	return rapl_pmu_is_pkg_scope() ? topology_core_cpumask(cpu) :
+					 topology_die_cpumask(cpu);
+}
+
 static inline struct rapl_pmu *cpu_to_rapl_pmu(unsigned int cpu)
 {
-	unsigned int rapl_pmu_idx = topology_logical_die_id(cpu);
+	unsigned int rapl_pmu_idx = get_rapl_pmu_idx(cpu);
 
 	/*
 	 * The unsigned check also catches the '-1' return value for non
@@ -552,7 +581,7 @@ static int rapl_cpu_offline(unsigned int
 
 	pmu->cpu = -1;
 	/* Find a new cpu to collect rapl events */
-	target = cpumask_any_but(topology_die_cpumask(cpu), cpu);
+	target = cpumask_any_but(get_rapl_pmu_cpumask(cpu), cpu);
 
 	/* Migrate rapl events to the new target */
 	if (target < nr_cpu_ids) {
@@ -565,6 +594,11 @@ static int rapl_cpu_offline(unsigned int
 
 static int rapl_cpu_online(unsigned int cpu)
 {
+	s32 rapl_pmu_idx = get_rapl_pmu_idx(cpu);
+	if (rapl_pmu_idx < 0) {
+		pr_err("topology_logical_(package/die)_id() returned a negative value");
+		return -EINVAL;
+	}
 	struct rapl_pmu *pmu = cpu_to_rapl_pmu(cpu);
 	int target;
 
@@ -579,14 +613,14 @@ static int rapl_cpu_online(unsigned int
 		pmu->timer_interval = ms_to_ktime(rapl_timer_ms);
 		rapl_hrtimer_init(pmu);
 
-		rapl_pmus->pmus[topology_logical_die_id(cpu)] = pmu;
+		rapl_pmus->pmus[rapl_pmu_idx] = pmu;
 	}
 
 	/*
 	 * Check if there is an online cpu in the package which collects rapl
 	 * events already.
 	 */
-	target = cpumask_any_and(&rapl_cpu_mask, topology_die_cpumask(cpu));
+	target = cpumask_any_and(&rapl_cpu_mask, get_rapl_pmu_cpumask(cpu));
 	if (target < nr_cpu_ids)
 		return 0;
 
@@ -675,7 +709,10 @@ static const struct attribute_group *rap
 
 static int __init init_rapl_pmus(void)
 {
-	int nr_rapl_pmu = topology_max_packages() * topology_max_dies_per_package();
+	int nr_rapl_pmu = topology_max_packages();
+
+	if (!rapl_pmu_is_pkg_scope())
+		nr_rapl_pmu *= topology_max_dies_per_package();
 
 	rapl_pmus = kzalloc(struct_size(rapl_pmus, pmus, nr_rapl_pmu), GFP_KERNEL);
 	if (!rapl_pmus)


