Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE452E8E10;
	Tue, 17 Jun 2025 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177783; cv=none; b=UwASpKd2S/ELxMLiC6iL3HC7KccqTzrkXJh9ed85PvNLXuuho//jAssNgYrOTb0F3DyX257/wLzkgax2XtSMBvKv/BjmhS/5qqy/lcDWYq5aJyiET0T08xpAaNbC5asqsTA6s8MroSdp/8ECANxM2VC8gcDEaA7/0fyV+/z2upA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177783; c=relaxed/simple;
	bh=JloIw3dDZ+y6fgnb2drFfArk8Y3a/eJoNVmj8rFdzOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoC/Bp1lAzMGQ0ivXan8D/LoXUTnqDC0qFjyWKQ4jA80gqJ+LqbidC309gfECqiBxZa+AAlbMog/KzPNniMFuQGdgZNPfzyjvDcNrqUEM+JyHM/QzJXfCi+XwbncRwtQjK8byNVoT0fW1QHIoGYN50E8RTFUti+0PCzMhHiRV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9ZJaHSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9ZJaHSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A2EC4CEE3;
	Tue, 17 Jun 2025 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177783;
	bh=JloIw3dDZ+y6fgnb2drFfArk8Y3a/eJoNVmj8rFdzOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9ZJaHSm+44IZ7QfOEGguJWCLDQBcwHOoVLOjDXk1+YXJ4KrVlGyDpgWsrtjyNoU2
	 uKu8vVZTql4yFdqv1/rwRoa9vhdOhlivYpXxsxYeozKntLGENIeMyHH++EXa38XAuC
	 SrgasAwC0ilzc9z1BlqKKulqPUC754RqS5PKq7lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 396/512] tools/power turbostat: Fix AMD package-energy reporting
Date: Tue, 17 Jun 2025 17:26:02 +0200
Message-ID: <20250617152435.635709054@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit adb49732c8c63665dd3476e8e6b7c67a0f851245 ]

commit 05a2f07db888 ("tools/power turbostat: read RAPL counters via
perf") that adds support to read RAPL counters via perf defines the
notion of a RAPL domain_id which is set to physical_core_id on
platforms which support per_core_rapl counters (Eg: AMD processors
Family 17h onwards) and is set to the physical_package_id on all the
other platforms.

However, the physical_core_id is only unique within a package and on
platforms with multiple packages more than one core can have the same
physical_core_id and thus the same domain_id. (For eg, the first cores
of each package have the physical_core_id = 0). This results in all
these cores with the same physical_core_id using the same entry in the
rapl_counter_info_perdomain[]. Since rapl_perf_init() skips the
perf-initialization for cores whose domain_ids have already been
visited, cores that have the same physical_core_id always read the
perf file corresponding to the physical_core_id of the first package
and thus the package-energy is incorrectly reported to be the same
value for different packages.

Note: This issue only arises when RAPL counters are read via perf and
not when they are read via MSRs since in the latter case the MSRs are
read separately on each core.

Fix this issue by associating each CPU with rapl_core_id which is
unique across all the packages in the system.

Fixes: 05a2f07db888 ("tools/power turbostat: read RAPL counters via perf")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 41 +++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 12424bf08551d..4c322586730d4 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4491,6 +4491,38 @@ unsigned long pmt_read_counter(struct pmt_counter *ppmt, unsigned int domain_id)
 	return (value & value_mask) >> value_shift;
 }
 
+
+/* Rapl domain enumeration helpers */
+static inline int get_rapl_num_domains(void)
+{
+	int num_packages = topo.max_package_id + 1;
+	int num_cores_per_package;
+	int num_cores;
+
+	if (!platform->has_per_core_rapl)
+		return num_packages;
+
+	num_cores_per_package = topo.max_core_id + 1;
+	num_cores = num_cores_per_package * num_packages;
+
+	return num_cores;
+}
+
+static inline int get_rapl_domain_id(int cpu)
+{
+	int nr_cores_per_package = topo.max_core_id + 1;
+	int rapl_core_id;
+
+	if (!platform->has_per_core_rapl)
+		return cpus[cpu].physical_package_id;
+
+	/* Compute the system-wide unique core-id for @cpu */
+	rapl_core_id = cpus[cpu].physical_core_id;
+	rapl_core_id += cpus[cpu].physical_package_id * nr_cores_per_package;
+
+	return rapl_core_id;
+}
+
 /*
  * get_counters(...)
  * migrate to cpu
@@ -4544,7 +4576,7 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 		goto done;
 
 	if (platform->has_per_core_rapl) {
-		status = get_rapl_counters(cpu, c->core_id, c, p);
+		status = get_rapl_counters(cpu, get_rapl_domain_id(cpu), c, p);
 		if (status != 0)
 			return status;
 	}
@@ -4610,7 +4642,7 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 		p->sys_lpi = cpuidle_cur_sys_lpi_us;
 
 	if (!platform->has_per_core_rapl) {
-		status = get_rapl_counters(cpu, p->package_id, c, p);
+		status = get_rapl_counters(cpu, get_rapl_domain_id(cpu), c, p);
 		if (status != 0)
 			return status;
 	}
@@ -7570,7 +7602,7 @@ void linux_perf_init(void)
 
 void rapl_perf_init(void)
 {
-	const unsigned int num_domains = (platform->has_per_core_rapl ? topo.max_core_id : topo.max_package_id) + 1;
+	const unsigned int num_domains = get_rapl_num_domains();
 	bool *domain_visited = calloc(num_domains, sizeof(bool));
 
 	rapl_counter_info_perdomain = calloc(num_domains, sizeof(*rapl_counter_info_perdomain));
@@ -7611,8 +7643,7 @@ void rapl_perf_init(void)
 				continue;
 
 			/* Skip already seen and handled RAPL domains */
-			next_domain =
-			    platform->has_per_core_rapl ? cpus[cpu].physical_core_id : cpus[cpu].physical_package_id;
+			next_domain = get_rapl_domain_id(cpu);
 
 			assert(next_domain < num_domains);
 
-- 
2.39.5



