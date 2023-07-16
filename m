Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7908F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A43C433C8;
	Sun, 16 Jul 2023 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537356;
	bh=Au5jDblx6OLCDtz5UnUeiu7omMplJieYrkMD1LWZCwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqJNnjp/MmediozQFnvuhEhUDTyJtFM/sZLbWLpTeD9X3BUF7OmdrJZPHBcihSY6K
	 Cz4330aJPq/DQDYrN0KY3Wmnq9H7T9wl0gjboHglCx+Eg7BZzWA5V1lyX7GNQor6nV
	 XCxWe/+rtrhr5t2cvaGh5FvaVSEzq5u03wvdUbhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 067/800] drivers/perf: hisi: Dont migrate perf to the CPU going to teardown
Date: Sun, 16 Jul 2023 21:38:40 +0200
Message-ID: <20230716194950.652041803@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 7a6a9f1c5a0a875a421db798d4b2ee022dc1ee1a ]

The driver needs to migrate the perf context if the current using CPU going
to teardown. By the time calling the cpuhp::teardown() callback the
cpu_online_mask() hasn't updated yet and still includes the CPU going to
teardown. In current driver's implementation we may migrate the context
to the teardown CPU and leads to the below calltrace:

...
[  368.104662][  T932] task:cpuhp/0         state:D stack:    0 pid:   15 ppid:     2 flags:0x00000008
[  368.113699][  T932] Call trace:
[  368.116834][  T932]  __switch_to+0x7c/0xbc
[  368.120924][  T932]  __schedule+0x338/0x6f0
[  368.125098][  T932]  schedule+0x50/0xe0
[  368.128926][  T932]  schedule_preempt_disabled+0x18/0x24
[  368.134229][  T932]  __mutex_lock.constprop.0+0x1d4/0x5dc
[  368.139617][  T932]  __mutex_lock_slowpath+0x1c/0x30
[  368.144573][  T932]  mutex_lock+0x50/0x60
[  368.148579][  T932]  perf_pmu_migrate_context+0x84/0x2b0
[  368.153884][  T932]  hisi_pcie_pmu_offline_cpu+0x90/0xe0 [hisi_pcie_pmu]
[  368.160579][  T932]  cpuhp_invoke_callback+0x2a0/0x650
[  368.165707][  T932]  cpuhp_thread_fun+0xe4/0x190
[  368.170316][  T932]  smpboot_thread_fn+0x15c/0x1a0
[  368.175099][  T932]  kthread+0x108/0x13c
[  368.179012][  T932]  ret_from_fork+0x10/0x18
...

Use function cpumask_any_but() to find one correct active cpu to fixes
this issue.

Fixes: 8404b0fbc7fb ("drivers/perf: hisi: Add driver for HiSilicon PCIe PMU")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20230608114326.27649-1-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index 6fee0b6e163bb..e10fc7cb9493a 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -683,7 +683,7 @@ static int hisi_pcie_pmu_offline_cpu(unsigned int cpu, struct hlist_node *node)
 
 	pcie_pmu->on_cpu = -1;
 	/* Choose a new CPU from all online cpus. */
-	target = cpumask_first(cpu_online_mask);
+	target = cpumask_any_but(cpu_online_mask, cpu);
 	if (target >= nr_cpu_ids) {
 		pci_err(pcie_pmu->pdev, "There is no CPU to set\n");
 		return 0;
-- 
2.39.2



