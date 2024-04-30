Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78D312C549;
	Tue, 30 Apr 2024 10:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474629; cv=none; b=A+QFlq7RBfgKAbMJofVvdeE3ZU1Rd5cAzUmPzauJGulXiGoTvJPSpWcbJxLVKlgwmXjAN2lvH+ZspZicrkEx7yRIjMad/0i1gMKb7PMVQdbGq4/TIhaRfX1uSLvNvmRzaZypMy9Xe3tRFqCMdYQY2bREb1eKh1oRbIBSiF8qa+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474629; c=relaxed/simple;
	bh=Iv1j78aFxr5U0leNWpCQ4mR4XpE+Ftr+9xM0W7PJo1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeTGr7cpMznKRZ83fvmb3NfzZGZQ8jDG2lFuizB7wVJdkwu/xHLKCCgCk5UlaNiVg85Ee9029WWVxuElbK9O46sVQp/Jbr3ITymiszrUV4d1JELGIWcKmvYjDvx7tTNXuSLM5cbELAHFGGhZuL8HKL4sGk5YDEGHdMLY91bdKNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vxx6zONS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vxx6zONS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB70C2BBFC;
	Tue, 30 Apr 2024 10:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474628;
	bh=Iv1j78aFxr5U0leNWpCQ4mR4XpE+Ftr+9xM0W7PJo1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vxx6zONSKnk/l4FkIrD11Wo9VtXBApI3s2RW4iyJOdKscTgZzmTUlehzMMfI0NIYw
	 EhTLVAtVHIdsBNjH72W1uCUmr/SO64FFtInupwpJEghn17ZiAt8cCefKrfusSQjknf
	 ZqzrkFo8cq/E83t92tATYCbTlE3lIUX+wO0eSH7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Xu <terrence.xu@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 213/228] dmaengine: idxd: Fix oops during rmmod on single-CPU platforms
Date: Tue, 30 Apr 2024 12:39:51 +0200
Message-ID: <20240430103109.952395500@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit f221033f5c24659dc6ad7e5cf18fb1b075f4a8be ]

During the removal of the idxd driver, registered offline callback is
invoked as part of the clean up process. However, on systems with only
one CPU online, no valid target is available to migrate the
perf context, resulting in a kernel oops:

    BUG: unable to handle page fault for address: 000000000002a2b8
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    PGD 1470e1067 P4D 0
    Oops: 0002 [#1] PREEMPT SMP NOPTI
    CPU: 0 PID: 20 Comm: cpuhp/0 Not tainted 6.8.0-rc6-dsa+ #57
    Hardware name: Intel Corporation AvenueCity/AvenueCity, BIOS BHSDCRB1.86B.2492.D03.2307181620 07/18/2023
    RIP: 0010:mutex_lock+0x2e/0x50
    ...
    Call Trace:
    <TASK>
    __die+0x24/0x70
    page_fault_oops+0x82/0x160
    do_user_addr_fault+0x65/0x6b0
    __pfx___rdmsr_safe_on_cpu+0x10/0x10
    exc_page_fault+0x7d/0x170
    asm_exc_page_fault+0x26/0x30
    mutex_lock+0x2e/0x50
    mutex_lock+0x1e/0x50
    perf_pmu_migrate_context+0x87/0x1f0
    perf_event_cpu_offline+0x76/0x90 [idxd]
    cpuhp_invoke_callback+0xa2/0x4f0
    __pfx_perf_event_cpu_offline+0x10/0x10 [idxd]
    cpuhp_thread_fun+0x98/0x150
    smpboot_thread_fn+0x27/0x260
    smpboot_thread_fn+0x1af/0x260
    __pfx_smpboot_thread_fn+0x10/0x10
    kthread+0x103/0x140
    __pfx_kthread+0x10/0x10
    ret_from_fork+0x31/0x50
    __pfx_kthread+0x10/0x10
    ret_from_fork_asm+0x1b/0x30
    <TASK>

Fix the issue by preventing the migration of the perf context to an
invalid target.

Fixes: 81dd4d4d6178 ("dmaengine: idxd: Add IDXD performance monitor support")
Reported-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20240313214031.1658045-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/perfmon.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/idxd/perfmon.c b/drivers/dma/idxd/perfmon.c
index fdda6d6042629..5e94247e1ea70 100644
--- a/drivers/dma/idxd/perfmon.c
+++ b/drivers/dma/idxd/perfmon.c
@@ -528,14 +528,11 @@ static int perf_event_cpu_offline(unsigned int cpu, struct hlist_node *node)
 		return 0;
 
 	target = cpumask_any_but(cpu_online_mask, cpu);
-
 	/* migrate events if there is a valid target */
-	if (target < nr_cpu_ids)
+	if (target < nr_cpu_ids) {
 		cpumask_set_cpu(target, &perfmon_dsa_cpu_mask);
-	else
-		target = -1;
-
-	perf_pmu_migrate_context(&idxd_pmu->pmu, cpu, target);
+		perf_pmu_migrate_context(&idxd_pmu->pmu, cpu, target);
+	}
 
 	return 0;
 }
-- 
2.43.0



