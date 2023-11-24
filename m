Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDBF33CFD;
	Fri, 24 Nov 2023 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw1X3eQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0764CC433C8;
	Fri, 24 Nov 2023 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851573;
	bh=Ih9liR/MLdMp4zNz7T/zVyzz4i4TQhvFK2BdW51MUKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw1X3eQR+RQ3ZcZeNW7RaO5joZjcF2XfogmcoQv9buhyV5+Gvm3i3jPghxL0q6yFK
	 3hKZ0A2tB3txvMpk/JgFzgCsCa8LW7ZodNuXQ6JNwEvOW+m1reoOtydKrjqo+FKdhO
	 vD68g/D2oEfiILfyw1iza/txjIq9ad7xynTGAjNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/372] cpu/hotplug: Dont offline the last non-isolated CPU
Date: Fri, 24 Nov 2023 17:46:37 +0000
Message-ID: <20231124172010.786724283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

[ Upstream commit 38685e2a0476127db766f81b1c06019ddc4c9ffa ]

If a system has isolated CPUs via the "isolcpus=" command line parameter,
then an attempt to offline the last housekeeping CPU will result in a
WARN_ON() when rebuilding the scheduler domains and a subsequent panic due
to and unhandled empty CPU mas in partition_sched_domains_locked().

cpuset_hotplug_workfn()
  rebuild_sched_domains_locked()
    ndoms = generate_sched_domains(&doms, &attr);
      cpumask_and(doms[0], top_cpuset.effective_cpus, housekeeping_cpumask(HK_FLAG_DOMAIN));

Thus results in an empty CPU mask which triggers the warning and then the
subsequent crash:

WARNING: CPU: 4 PID: 80 at kernel/sched/topology.c:2366 build_sched_domains+0x120c/0x1408
Call trace:
 build_sched_domains+0x120c/0x1408
 partition_sched_domains_locked+0x234/0x880
 rebuild_sched_domains_locked+0x37c/0x798
 rebuild_sched_domains+0x30/0x58
 cpuset_hotplug_workfn+0x2a8/0x930

Unable to handle kernel paging request at virtual address fffe80027ab37080
 partition_sched_domains_locked+0x318/0x880
 rebuild_sched_domains_locked+0x37c/0x798

Aside of the resulting crash, it does not make any sense to offline the last
last housekeeping CPU.

Prevent this by masking out the non-housekeeping CPUs when selecting a
target CPU for initiating the CPU unplug operation via the work queue.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/202310171709530660462@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index f8eb1825f704f..0e4d362e90825 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1243,11 +1243,14 @@ static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
 	/*
 	 * Ensure that the control task does not run on the to be offlined
 	 * CPU to prevent a deadlock against cfs_b->period_timer.
+	 * Also keep at least one housekeeping cpu onlined to avoid generating
+	 * an empty sched_domain span.
 	 */
-	cpu = cpumask_any_but(cpu_online_mask, cpu);
-	if (cpu >= nr_cpu_ids)
-		return -EBUSY;
-	return work_on_cpu(cpu, __cpu_down_maps_locked, &work);
+	for_each_cpu_and(cpu, cpu_online_mask, housekeeping_cpumask(HK_TYPE_DOMAIN)) {
+		if (cpu != work.cpu)
+			return work_on_cpu(cpu, __cpu_down_maps_locked, &work);
+	}
+	return -EBUSY;
 }
 
 static int cpu_down(unsigned int cpu, enum cpuhp_state target)
-- 
2.42.0



