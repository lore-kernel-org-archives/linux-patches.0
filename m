Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93465158A29;
	Tue,  9 Jul 2024 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524128; cv=none; b=sYVjvGFL6rYJa3D6W8ppssbSgf7iy5T66JqLn+qO22S4Nvp5nU23n8oahVN6dWDxUW1NXv63nXjNp10BFnGr41kAb4DSKW5L0wrSjxXraJuF+//ACRAltNAM9VPR+3fgjQRA/2Dnr4HFTZggi1WmD1HD98T1IalybHZ2NSDc8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524128; c=relaxed/simple;
	bh=zPsOZJ2aKSGb71pwbPwBT+HB8iueNflTrDUm18nQbrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTaukVz/i29eKzn90SA9XzcSuQ+mEc7gcjptDs+q+48sac4ww4ne1sbiwyD6STRO4Nrpp6go8dGUjXAQVVfu6aMKWB9eKcDFPk95thP4pbdH6C6EikS0Zn0BSfiY4v1/1HXVlLE/3cG8pxPWiT0AD6FfsOglQqwN3geio/EIuZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFY6GMIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFY6GMIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B089C3277B;
	Tue,  9 Jul 2024 11:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524128;
	bh=zPsOZJ2aKSGb71pwbPwBT+HB8iueNflTrDUm18nQbrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFY6GMIBj8qk+Lr2/j7PY+t6j4lT74SghEwZElBkFKDpdmcJyl/wVyo4s0yAwCKA8
	 IhsKniwpNgA6Y/S6cY2uBM8GOvQbdn4svWDhvPpaH3m3x3kQCKX+EDei7XTzXszReN
	 NpzdOYvXCYm1QVnAz6oyKTgJYuY10thXkfIcm0is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 080/197] tools/power turbostat: Avoid possible memory corruption due to sparse topology IDs
Date: Tue,  9 Jul 2024 13:08:54 +0200
Message-ID: <20240709110712.065083819@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>

[ Upstream commit 3559ea813ad3a9627934325c68ad05b18008a077 ]

Save the highest core and package id when parsing topology to
allocate enough memory when get_rapl_counters() is called with a core or
a package id as a domain.

Note that RAPL domains are per-package on Intel, but per-core on AMD.
Thus, the RAPL code effectively runs in different modes on those two
product lines.

Signed-off-by: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 25417c3a47ab6..5d80d193e5bee 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1022,6 +1022,7 @@ struct rapl_counter_info_t {
 
 /* struct rapl_counter_info_t for each RAPL domain */
 struct rapl_counter_info_t *rapl_counter_info_perdomain;
+unsigned int rapl_counter_info_perdomain_size;
 
 #define RAPL_COUNTER_FLAG_USE_MSR_SUM (1u << 1)
 
@@ -1415,6 +1416,8 @@ struct topo_params {
 	int allowed_cpus;
 	int allowed_cores;
 	int max_cpu_num;
+	int max_core_id;
+	int max_package_id;
 	int max_die_id;
 	int max_node_num;
 	int nodes_per_pkg;
@@ -3369,15 +3372,18 @@ void write_rapl_counter(struct rapl_counter *rc, struct rapl_counter_info_t *rci
 	rc->scale = rci->scale[idx];
 }
 
-int get_rapl_counters(int cpu, int domain, struct core_data *c, struct pkg_data *p)
+int get_rapl_counters(int cpu, unsigned int domain, struct core_data *c, struct pkg_data *p)
 {
 	unsigned long long perf_data[NUM_RAPL_COUNTERS + 1];
-	struct rapl_counter_info_t *rci = &rapl_counter_info_perdomain[domain];
+	struct rapl_counter_info_t *rci;
 
 	if (debug)
 		fprintf(stderr, "%s: cpu%d domain%d\n", __func__, cpu, domain);
 
 	assert(rapl_counter_info_perdomain);
+	assert(domain < rapl_counter_info_perdomain_size);
+
+	rci = &rapl_counter_info_perdomain[domain];
 
 	/*
 	 * If we have any perf counters to read, read them all now, in bulk
@@ -4181,7 +4187,7 @@ void free_fd_rapl_percpu(void)
 	if (!rapl_counter_info_perdomain)
 		return;
 
-	const int num_domains = platform->has_per_core_rapl ? topo.num_cores : topo.num_packages;
+	const int num_domains = rapl_counter_info_perdomain_size;
 
 	for (int domain_id = 0; domain_id < num_domains; ++domain_id) {
 		if (rapl_counter_info_perdomain[domain_id].fd_perf != -1)
@@ -4189,6 +4195,8 @@ void free_fd_rapl_percpu(void)
 	}
 
 	free(rapl_counter_info_perdomain);
+	rapl_counter_info_perdomain = NULL;
+	rapl_counter_info_perdomain_size = 0;
 }
 
 void free_all_buffers(void)
@@ -6479,17 +6487,18 @@ void linux_perf_init(void)
 
 void rapl_perf_init(void)
 {
-	const int num_domains = platform->has_per_core_rapl ? topo.num_cores : topo.num_packages;
+	const unsigned int num_domains = (platform->has_per_core_rapl ? topo.max_core_id : topo.max_package_id) + 1;
 	bool *domain_visited = calloc(num_domains, sizeof(bool));
 
 	rapl_counter_info_perdomain = calloc(num_domains, sizeof(*rapl_counter_info_perdomain));
 	if (rapl_counter_info_perdomain == NULL)
 		err(-1, "calloc rapl_counter_info_percpu");
+	rapl_counter_info_perdomain_size = num_domains;
 
 	/*
 	 * Initialize rapl_counter_info_percpu
 	 */
-	for (int domain_id = 0; domain_id < num_domains; ++domain_id) {
+	for (unsigned int domain_id = 0; domain_id < num_domains; ++domain_id) {
 		struct rapl_counter_info_t *rci = &rapl_counter_info_perdomain[domain_id];
 
 		rci->fd_perf = -1;
@@ -6509,7 +6518,7 @@ void rapl_perf_init(void)
 		bool has_counter = 0;
 		double scale;
 		enum rapl_unit unit;
-		int next_domain;
+		unsigned int next_domain;
 
 		memset(domain_visited, 0, num_domains * sizeof(*domain_visited));
 
@@ -6522,6 +6531,8 @@ void rapl_perf_init(void)
 			next_domain =
 			    platform->has_per_core_rapl ? cpus[cpu].physical_core_id : cpus[cpu].physical_package_id;
 
+			assert(next_domain < num_domains);
+
 			if (domain_visited[next_domain])
 				continue;
 
@@ -7104,6 +7115,8 @@ void topology_probe(bool startup)
 		if (cpus[i].thread_id == 0)
 			topo.num_cores++;
 	}
+	topo.max_core_id = max_core_id;
+	topo.max_package_id = max_package_id;
 
 	topo.cores_per_node = max_core_id + 1;
 	if (debug > 1)
-- 
2.43.0



