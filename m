Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BD487BF;
	Wed,  5 Feb 2025 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765814; cv=none; b=jeyEoqt2PtdfoCYG1gz52488YVOUs0zV04LaP/WPNpELKalo+ySUBAD6nADxGWvYHoySCQi+9Lvbgyk3OLmp74Mwihq9ajOW+nzzeMHlXKvvvqjXH+3T9XRBuw34g71MvWtwfkmzibtblS6V9EVLvfcoRfeFANoX5pZUT5ZuT3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765814; c=relaxed/simple;
	bh=3nzlP/4gr6tiuVD4pwyPW0W33g5CWV6wzYqOLQEqDEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn8/zV8N0EOaHeLHg2qGgcMvAjmIjOS2E+Nl7yD1Mn7kPv+4lz1NAdrsXqEyxqrHSohnmx16kva+LvxLLmQ0bHSTDen+2uMTWSUp5Se+mFcSwEwDO8II0kLS4RdsLIruNieK1Zi5PLh1I/kmpqp1ifaaNioQ56ok4dfl7X9tSJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBHinnsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBHinnsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A1BC4CED1;
	Wed,  5 Feb 2025 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765813;
	bh=3nzlP/4gr6tiuVD4pwyPW0W33g5CWV6wzYqOLQEqDEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBHinnsZxf2Gc9/JMsMBbdQlEOb9NaJcCmjXFQ6+++8v04Z3hZ8pNwrysdyEXlLvB
	 rFLYnjRv5svodU3ZN7PkwIDiM8vIJf916FtTVSv9Oy0+Xc9cQawVMWbXni65y9PfHu
	 ZvxHTeqmVa8ylaxbutS+UPnBRabxvMY5dhmGMZQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 216/623] cpufreq: ACPI: Fix max-frequency computation
Date: Wed,  5 Feb 2025 14:39:18 +0100
Message-ID: <20250205134504.489887178@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 0834667545962ef1c5e8684ed32b45d9c574acd3 ]

Commit 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover
boost frequencies") introduced an assumption in acpi_cpufreq_cpu_init()
that the first entry in the P-state table was the nominal frequency.
This assumption is incorrect. The frequency corresponding to the P0
P-State need not be the same as the nominal frequency advertised via
CPPC.

Since the driver is using the CPPC.highest_perf and CPPC.nominal_perf
to compute the boost-ratio, it makes sense to use CPPC.nominal_freq to
compute the max-frequency. CPPC.nominal_freq is advertised on
platforms supporting CPPC revisions 3 or higher.

Hence, fallback to using the first entry in the P-State table only on
platforms that do not advertise CPPC.nominal_freq.

Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
Tested-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250113044107.566-1-gautham.shenoy@amd.com
[ rjw: Retain reverse X-mas tree ordering of local variable declarations ]
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 36 +++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index c9ebacf5c88e2..302df42d68875 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -623,7 +623,14 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
 #endif
 
 #ifdef CONFIG_ACPI_CPPC_LIB
-static u64 get_max_boost_ratio(unsigned int cpu)
+/*
+ * get_max_boost_ratio: Computes the max_boost_ratio as the ratio
+ * between the highest_perf and the nominal_perf.
+ *
+ * Returns the max_boost_ratio for @cpu. Returns the CPPC nominal
+ * frequency via @nominal_freq if it is non-NULL pointer.
+ */
+static u64 get_max_boost_ratio(unsigned int cpu, u64 *nominal_freq)
 {
 	struct cppc_perf_caps perf_caps;
 	u64 highest_perf, nominal_perf;
@@ -652,6 +659,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 
 	nominal_perf = perf_caps.nominal_perf;
 
+	if (nominal_freq)
+		*nominal_freq = perf_caps.nominal_freq;
+
 	if (!highest_perf || !nominal_perf) {
 		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);
 		return 0;
@@ -664,8 +674,12 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 
 	return div_u64(highest_perf << SCHED_CAPACITY_SHIFT, nominal_perf);
 }
+
 #else
-static inline u64 get_max_boost_ratio(unsigned int cpu) { return 0; }
+static inline u64 get_max_boost_ratio(unsigned int cpu, u64 *nominal_freq)
+{
+	return 0;
+}
 #endif
 
 static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
@@ -675,9 +689,9 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	struct acpi_cpufreq_data *data;
 	unsigned int cpu = policy->cpu;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	u64 max_boost_ratio, nominal_freq = 0;
 	unsigned int valid_states = 0;
 	unsigned int result = 0;
-	u64 max_boost_ratio;
 	unsigned int i;
 #ifdef CONFIG_SMP
 	static int blacklisted;
@@ -827,16 +841,20 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	}
 	freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
 
-	max_boost_ratio = get_max_boost_ratio(cpu);
+	max_boost_ratio = get_max_boost_ratio(cpu, &nominal_freq);
 	if (max_boost_ratio) {
-		unsigned int freq = freq_table[0].frequency;
+		unsigned int freq = nominal_freq;
 
 		/*
-		 * Because the loop above sorts the freq_table entries in the
-		 * descending order, freq is the maximum frequency in the table.
-		 * Assume that it corresponds to the CPPC nominal frequency and
-		 * use it to set cpuinfo.max_freq.
+		 * The loop above sorts the freq_table entries in the
+		 * descending order. If ACPI CPPC has not advertised
+		 * the nominal frequency (this is possible in CPPC
+		 * revisions prior to 3), then use the first entry in
+		 * the pstate table as a proxy for nominal frequency.
 		 */
+		if (!freq)
+			freq = freq_table[0].frequency;
+
 		policy->cpuinfo.max_freq = freq * max_boost_ratio >> SCHED_CAPACITY_SHIFT;
 	} else {
 		/*
-- 
2.39.5



