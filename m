Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E38221F1F;
	Tue, 17 Jun 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174487; cv=none; b=e5MujeY+nrrYkDpNpJW/0jChdDPFqTX2VzRnM26g5lrgXcmh6uDGd+5rG0nKyX2FOBQ9E9qxN0jIi53raxPPbuWM12s1gWJpJKDFlbJl2UJaOUE0eT3OjJS3/XvI3oUH8LxMDqfbU9wKfNbjnlaqZ01COckXP+GhRmm72bC9d18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174487; c=relaxed/simple;
	bh=jHbCFU8AlipbQvhbFwm3Gny1/QvpF2RiI/QppTNdOtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYyO+pFF8YKQdWeVPY77bKu9HqYrlLEAGzb+FqjM8cTxTO/hMXZwvokwErm8v7FclUeUsuQLP88W9prAGDCMPl9ALWSgNjOj3cbGvDHfiOvoHuV2ueO74pNF6dsD9gmXCgYp5ZfPdY1ZWxjjWrJB7yaj/lXK4RoiyjCclO3vDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnpucTzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnpucTzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC4FC4CEE3;
	Tue, 17 Jun 2025 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174486;
	bh=jHbCFU8AlipbQvhbFwm3Gny1/QvpF2RiI/QppTNdOtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnpucTzXSIucF8RrZT0bjR47/LcbTtLywL+ypesgKxHUDP3FHfd17yqLU82OBUZ8b
	 piTTxkTxIkb1YgVTwZcaGzPZLyZD6u7A0lwLT9pU/vGvc5bdv0vbtXXOk6uAWhkx4/
	 qWgv5mryQLCwuHkGJ8IDZNxSrMgmGdybSGMDTU2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/356] perf/amlogic: Replace smp_processor_id() with raw_smp_processor_id() in meson_ddr_pmu_create()
Date: Tue, 17 Jun 2025 17:23:10 +0200
Message-ID: <20250617152341.239754868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 097469a2b0f12b91b4f27b9e9e4f2c46484cde30 ]

The Amlogic DDR PMU driver meson_ddr_pmu_create() function incorrectly uses
smp_processor_id(), which assumes disabled preemption. This leads to kernel
warnings during module loading because meson_ddr_pmu_create() can be called
in a preemptible context.

Following kernel warning and stack trace:
[   31.745138] [   T2289] BUG: using smp_processor_id() in preemptible [00000000] code: (udev-worker)/2289
[   31.745154] [   T2289] caller is debug_smp_processor_id+0x28/0x38
[   31.745172] [   T2289] CPU: 4 UID: 0 PID: 2289 Comm: (udev-worker) Tainted: GW 6.14.0-0-MANJARO-ARM #1 59519addcbca6ba8de735e151fd7b9e97aac7ff0
[   31.745181] [   T2289] Tainted: [W]=WARN
[   31.745183] [   T2289] Hardware name: Hardkernel ODROID-N2Plus (DT)
[   31.745188] [   T2289] Call trace:
[   31.745191] [   T2289]  show_stack+0x28/0x40 (C)
[   31.745199] [   T2289]  dump_stack_lvl+0x4c/0x198
[   31.745205] [   T2289]  dump_stack+0x20/0x50
[   31.745209] [   T2289]  check_preemption_disabled+0xec/0xf0
[   31.745213] [   T2289]  debug_smp_processor_id+0x28/0x38
[   31.745216] [   T2289]  meson_ddr_pmu_create+0x200/0x560 [meson_ddr_pmu_g12 8095101c49676ad138d9961e3eddaee10acca7bd]
[   31.745237] [   T2289]  g12_ddr_pmu_probe+0x20/0x38 [meson_ddr_pmu_g12 8095101c49676ad138d9961e3eddaee10acca7bd]
[   31.745246] [   T2289]  platform_probe+0x98/0xe0
[   31.745254] [   T2289]  really_probe+0x144/0x3f8
[   31.745258] [   T2289]  __driver_probe_device+0xb8/0x180
[   31.745261] [   T2289]  driver_probe_device+0x54/0x268
[   31.745264] [   T2289]  __driver_attach+0x11c/0x288
[   31.745267] [   T2289]  bus_for_each_dev+0xfc/0x160
[   31.745274] [   T2289]  driver_attach+0x34/0x50
[   31.745277] [   T2289]  bus_add_driver+0x160/0x2b0
[   31.745281] [   T2289]  driver_register+0x78/0x120
[   31.745285] [   T2289]  __platform_driver_register+0x30/0x48
[   31.745288] [   T2289]  init_module+0x30/0xfe0 [meson_ddr_pmu_g12 8095101c49676ad138d9961e3eddaee10acca7bd]
[   31.745298] [   T2289]  do_one_initcall+0x11c/0x438
[   31.745303] [   T2289]  do_init_module+0x68/0x228
[   31.745311] [   T2289]  load_module+0x118c/0x13a8
[   31.745315] [   T2289]  __arm64_sys_finit_module+0x274/0x390
[   31.745320] [   T2289]  invoke_syscall+0x74/0x108
[   31.745326] [   T2289]  el0_svc_common+0x90/0xf8
[   31.745330] [   T2289]  do_el0_svc+0x2c/0x48
[   31.745333] [   T2289]  el0_svc+0x60/0x150
[   31.745337] [   T2289]  el0t_64_sync_handler+0x80/0x118
[   31.745341] [   T2289]  el0t_64_sync+0x1b8/0x1c0

Changes replaces smp_processor_id() with raw_smp_processor_id() to
ensure safe CPU ID retrieval in preemptible contexts.

Cc: Jiucheng Xu <jiucheng.xu@amlogic.com>
Fixes: 2016e2113d35 ("perf/amlogic: Add support for Amlogic meson G12 SoC DDR PMU driver")
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Link: https://lore.kernel.org/r/20250407063206.5211-1-linux.amoon@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/amlogic/meson_ddr_pmu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/amlogic/meson_ddr_pmu_core.c b/drivers/perf/amlogic/meson_ddr_pmu_core.c
index bbc7285fd934a..5f8699612a9ad 100644
--- a/drivers/perf/amlogic/meson_ddr_pmu_core.c
+++ b/drivers/perf/amlogic/meson_ddr_pmu_core.c
@@ -510,7 +510,7 @@ int meson_ddr_pmu_create(struct platform_device *pdev)
 
 	fmt_attr_fill(pmu->info.hw_info->fmt_attr);
 
-	pmu->cpu = smp_processor_id();
+	pmu->cpu = raw_smp_processor_id();
 
 	name = devm_kasprintf(&pdev->dev, GFP_KERNEL, DDR_PERF_DEV_NAME);
 	if (!name)
-- 
2.39.5



