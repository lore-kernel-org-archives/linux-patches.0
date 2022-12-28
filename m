Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9773C433D2;
	Wed, 28 Dec 2022 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239048;
	bh=3QB2lwfGhwZf5YvU0afz5ahSmlHQgkwc5a63NM7OXb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRLWPzs0UOGH4zMKoksa1zHuAcc9yw7V7J2ZchrGv5iuzMuGMbrvspXG/2fuL9TP8
	 /sWVoXIf0amQuMg4fI7W5UIarY4TCvK+s1VV1Pdi6ddvSbqSY2nhH8ENDOZIYLB08J
	 YrMHpg7ZoLMy/Junwyv24IYzog4eDe7yHuRh7ebY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/731] perf: Fix possible memleak in pmu_dev_alloc()
Date: Wed, 28 Dec 2022 15:33:09 +0100
Message-Id: <20221228144258.929048601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 5422bd77c7d4..e95088144471 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11175,13 +11175,15 @@ static int pmu_dev_alloc(struct pmu *pmu)
 
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



