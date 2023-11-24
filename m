Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE739FC2;
	Fri, 24 Nov 2023 18:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6+Ipc21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333B0C433C7;
	Fri, 24 Nov 2023 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850346;
	bh=AxGS71vs0H65iyeDjSm2dMUZdUgd4jiytNFGROudH4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6+Ipc21XlGkP0ZZ9f/prYw2DU+Le3ZrgN4/TQdY1VEqjwSApw/5IttnmDlae7dAT
	 UfzfYAZwXJ6ZjVEEHZEqe8xAY9JylOB5jCEulS7LyTkBj/GAVfvT6IZeGd2gGsqJMt
	 mDiFNzIjSB/2C4QpewsACDzeVZifx+yo888vCaQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 013/491] cpu/hotplug: Dont offline the last non-isolated CPU
Date: Fri, 24 Nov 2023 17:44:09 +0000
Message-ID: <20231124172025.086674667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 26119d2154102..189ba5fd9af4b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1503,11 +1503,14 @@ static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
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



