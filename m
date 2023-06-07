Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E2B3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8294EC433EF;
	Wed,  7 Jun 2023 21:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171618;
	bh=NH8M4Vkw2BQt3LsPuLdH6of9kXMYlZqorUb6IJFapBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOOstNooCHQHKywITm8Pr5eWNW1mZl4aCvIcZyQKhOPGsq2gveCBaLuxko1FJnwdF
	 qT3+ccS2gsP6II1TseahjrLaTCP4Qnw66O7wZC1u+pOq+a0A9V37tP4xWj7zmdJMde
	 lYNH1auRXfkUmHNVyBWBaz7p4uT7y2j0AiFwxpMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/159] s390/topology: honour nr_cpu_ids when adding CPUs
Date: Wed,  7 Jun 2023 22:16:22 +0200
Message-ID: <20230607200906.262696117@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit a33239be2d38ff5a44427db1707c08787508d34a ]

When SMT thread CPUs are added to CPU masks the nr_cpu_ids
limit is not checked and could be exceeded. This leads to
a warning for example if CONFIG_DEBUG_PER_CPU_MAPS is set
and the command line parameter nr_cpus is set to 1.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/topology.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 58f8291950cbf..1f4f37a26c26d 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -96,7 +96,7 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 {
 	static cpumask_t mask;
-	int i;
+	unsigned int max_cpu;
 
 	cpumask_clear(&mask);
 	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
@@ -105,9 +105,10 @@ static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 	if (topology_mode != TOPOLOGY_MODE_HW)
 		goto out;
 	cpu -= cpu % (smp_cpu_mtid + 1);
-	for (i = 0; i <= smp_cpu_mtid; i++) {
-		if (cpumask_test_cpu(cpu + i, &cpu_setup_mask))
-			cpumask_set_cpu(cpu + i, &mask);
+	max_cpu = min(cpu + smp_cpu_mtid, nr_cpu_ids - 1);
+	for (; cpu <= max_cpu; cpu++) {
+		if (cpumask_test_cpu(cpu, &cpu_setup_mask))
+			cpumask_set_cpu(cpu, &mask);
 	}
 out:
 	cpumask_copy(dst, &mask);
@@ -124,25 +125,26 @@ static void add_cpus_to_mask(struct topology_core *tl_core,
 	unsigned int core;
 
 	for_each_set_bit(core, &tl_core->mask, TOPOLOGY_CORE_BITS) {
-		unsigned int rcore;
-		int lcpu, i;
+		unsigned int max_cpu, rcore;
+		int cpu;
 
 		rcore = TOPOLOGY_CORE_BITS - 1 - core + tl_core->origin;
-		lcpu = smp_find_processor_id(rcore << smp_cpu_mt_shift);
-		if (lcpu < 0)
+		cpu = smp_find_processor_id(rcore << smp_cpu_mt_shift);
+		if (cpu < 0)
 			continue;
-		for (i = 0; i <= smp_cpu_mtid; i++) {
-			topo = &cpu_topology[lcpu + i];
+		max_cpu = min(cpu + smp_cpu_mtid, nr_cpu_ids - 1);
+		for (; cpu <= max_cpu; cpu++) {
+			topo = &cpu_topology[cpu];
 			topo->drawer_id = drawer->id;
 			topo->book_id = book->id;
 			topo->socket_id = socket->id;
 			topo->core_id = rcore;
-			topo->thread_id = lcpu + i;
+			topo->thread_id = cpu;
 			topo->dedicated = tl_core->d;
-			cpumask_set_cpu(lcpu + i, &drawer->mask);
-			cpumask_set_cpu(lcpu + i, &book->mask);
-			cpumask_set_cpu(lcpu + i, &socket->mask);
-			smp_cpu_set_polarization(lcpu + i, tl_core->pp);
+			cpumask_set_cpu(cpu, &drawer->mask);
+			cpumask_set_cpu(cpu, &book->mask);
+			cpumask_set_cpu(cpu, &socket->mask);
+			smp_cpu_set_polarization(cpu, tl_core->pp);
 		}
 	}
 }
-- 
2.39.2



