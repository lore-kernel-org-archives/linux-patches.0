Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B0E23237F;
	Mon, 10 Mar 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628772; cv=none; b=CL9+cF67vUp5Q01JYbKUxYx/l2HE7d1e7LxdaUstmEMB9MdAdel11sqOMMz2aeC3Adcd4hlUb9WHJiONzvkm9WtkuRKSzOmO5YnO5waApHapNxPVbdMk8kvpxTfS9QFPXUCD0PnzDl401ksipdAheOaAB7JL/zX8iSRS6BzVfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628772; c=relaxed/simple;
	bh=8eE6E7mIVk335XMnlFsG/3lAJMFI57i7bqriiHQT1xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz5ok4Z5+SVAaGgvH+6wmjT7Gdx/D4I0U3uwYShUNPYViy72q70dUN/Te/rXrvNUu+2RJ36wtKp0VLRI7KHH0vMEo93SL8qRRZJrwjKp1Alr1IUdCK5zPFw+e/FuBZ1/zFqQ+NjtxMxat0meQFr3XCIx25CfjzRSONyw0AfxDgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKn87RzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKn87RzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7738C4CEE5;
	Mon, 10 Mar 2025 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628772;
	bh=8eE6E7mIVk335XMnlFsG/3lAJMFI57i7bqriiHQT1xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKn87RzAvYqLK4VpWzGCC27rRS6iZ+ZLk5nwKv6KLrJ+pNscfWW3Pms4jaZpvHEnG
	 R8YIZjpErY3H0C0HWt34pSM87fc6gT7TsXcECTqyo9kg/fynvgt8iV9faDDUBegdl/
	 xX2A6uFvscTwIrVyVFZnIxHJN6yva7dYF0BbNOz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/620] cpufreq: ACPI: Fix max-frequency computation
Date: Mon, 10 Mar 2025 17:58:29 +0100
Message-ID: <20250310170548.071004074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 28467d83c7452..4a31bd90406c9 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -630,7 +630,14 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
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
@@ -653,6 +660,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 
 	nominal_perf = perf_caps.nominal_perf;
 
+	if (nominal_freq)
+		*nominal_freq = perf_caps.nominal_freq;
+
 	if (!highest_perf || !nominal_perf) {
 		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);
 		return 0;
@@ -665,8 +675,12 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 
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
@@ -676,9 +690,9 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
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
@@ -828,16 +842,20 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
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



