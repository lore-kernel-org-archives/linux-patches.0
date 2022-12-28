Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469711C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2F3C433D2;
	Wed, 28 Dec 2022 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244397;
	bh=2q1vrMX8UCs1gsDCdclOCLM0Gx3S0BaTH5j2LUQGrb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bw2d0Y3ntjdE/5mFTb/XHZoJcjBrKf8VMTbh1B5Gxcrw9FZ+0VD0KD9sLHWG0uWyp
	 0G6IBdnN2g8ImNJB4vQvllkeHjiN/uisnE7jYU7wzt9h/nqvZrKHH08kXSR5SmhVMj
	 wJgCxjnCaiI1xtJfuqGg2Jxcs3sGC7ACBWy5K5GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yang Shen <shenyang39@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0703/1073] coresight: trbe: remove cpuhp instance node before remove cpuhp state
Date: Wed, 28 Dec 2022 15:38:11 +0100
Message-Id: <20221228144347.126510652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit 20ee8c223f792947378196307d8e707c9cdc2d61 ]

cpuhp_state_add_instance() and cpuhp_state_remove_instance() should
be used in pairs. Or there will lead to the warn on
cpuhp_remove_multi_state() since the cpuhp_step list is not empty.

The following is the error log with 'rmmod coresight-trbe':
Error: Removing state 215 which has instances left.
Call trace:
  __cpuhp_remove_state_cpuslocked+0x144/0x160
  __cpuhp_remove_state+0xac/0x100
  arm_trbe_device_remove+0x2c/0x60 [coresight_trbe]
  platform_remove+0x34/0x70
  device_remove+0x54/0x90
  device_release_driver_internal+0x1e4/0x250
  driver_detach+0x5c/0xb0
  bus_remove_driver+0x64/0xc0
  driver_unregister+0x3c/0x70
  platform_driver_unregister+0x20/0x30
  arm_trbe_exit+0x1c/0x658 [coresight_trbe]
  __arm64_sys_delete_module+0x1ac/0x24c
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0x58/0x1a0
  do_el0_svc+0x38/0xd0
  el0_svc+0x2c/0xc0
  el0t_64_sync_handler+0x1ac/0x1b0
  el0t_64_sync+0x19c/0x1a0
 ---[ end trace 0000000000000000 ]---

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221122090355.23533-1-shenyang39@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 2b386bb848f8..1fc4fd79a1c6 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1434,6 +1434,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
 
 static void arm_trbe_remove_cpuhp(struct trbe_drvdata *drvdata)
 {
+	cpuhp_state_remove_instance(drvdata->trbe_online, &drvdata->hotplug_node);
 	cpuhp_remove_multi_state(drvdata->trbe_online);
 }
 
-- 
2.35.1



