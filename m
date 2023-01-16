Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A556C433EF;
	Mon, 16 Jan 2023 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888642;
	bh=+cSfEyRhlmEnP4Zli75QPHccPLPUg1Z6ii7+mUegCt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldxvy5e6F4FaZg5cAMoa3gHm6XXTaEBgCzZYnuEDmBl6ECCeRlmc23iySomaI0L7r
	 U/m6q7vU/CLNHvQeCq4Uz6vVp6k91mUKwZPyGw/gRIG/znWDpTMGNmAbPEA8o8pp8g
	 kdlMAgV52+cfCXMmL9P51UN5Gmp2K2A1X70sw3l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/338] perf: Fix possible memleak in pmu_dev_alloc()
Date: Mon, 16 Jan 2023 16:48:38 +0100
Message-Id: <20230116154822.751768516@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e8d7a90c08ce963c592fb49845f2ccc606a2ac21 ]

In pmu_dev_alloc(), when dev_set_name() failed, it will goto free_dev
and call put_device(pmu->dev) to release it.
However pmu->dev->release is assigned after this, which makes warning
and memleak.
Call dev_set_name() after pmu->dev->release = pmu_dev_release to fix it.

  Device '(null)' does not have a release() function...
  WARNING: CPU: 2 PID: 441 at drivers/base/core.c:2332 device_release+0x1b9/0x240
  ...
  Call Trace:
    <TASK>
    kobject_put+0x17f/0x460
    put_device+0x20/0x30
    pmu_dev_alloc+0x152/0x400
    perf_pmu_register+0x96b/0xee0
    ...
  kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
  unreferenced object 0xffff888014759000 (size 2048):
    comm "modprobe", pid 441, jiffies 4294931444 (age 38.332s)
    backtrace:
      [<0000000005aed3b4>] kmalloc_trace+0x27/0x110
      [<000000006b38f9b8>] pmu_dev_alloc+0x50/0x400
      [<00000000735f17be>] perf_pmu_register+0x96b/0xee0
      [<00000000e38477f1>] 0xffffffffc0ad8603
      [<000000004e162216>] do_one_initcall+0xd0/0x4e0
      ...

Fixes: abe43400579d ("perf: Sysfs enumeration")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221111103653.91058-1-chenzhongjin@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7ad142a5327e..eb67ef450615 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9180,13 +9180,15 @@ static int pmu_dev_alloc(struct pmu *pmu)
 
 	pmu->dev->groups = pmu->attr_groups;
 	device_initialize(pmu->dev);
-	ret = dev_set_name(pmu->dev, "%s", pmu->name);
-	if (ret)
-		goto free_dev;
 
 	dev_set_drvdata(pmu->dev, pmu);
 	pmu->dev->bus = &pmu_bus;
 	pmu->dev->release = pmu_dev_release;
+
+	ret = dev_set_name(pmu->dev, "%s", pmu->name);
+	if (ret)
+		goto free_dev;
+
 	ret = device_add(pmu->dev);
 	if (ret)
 		goto free_dev;
-- 
2.35.1



