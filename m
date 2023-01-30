Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F85D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A5EC433D2;
	Mon, 30 Jan 2023 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087211;
	bh=YCFfEabIbt+SX4g+RzLZtUyy6+cBtZ2YEqSOFBiNtIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1wScm0yXR4EKKStfcLA5ZALGDNy2B9PiR2Nkir/7mrvIV+Bf6oOM/8mNxj/TvVM0
	 Vqk+wjR8k7a/jMSlRLoMV5c+BSM+dMwp2PNRDv4MNrjp09jtId9ECivD3DNpeiyV7m
	 4zsadEivwgt61IBNf4+YpeRmevKMpPfS72VS7hAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/313] driver core: Fix test_async_probe_init saves device in wrong array
Date: Mon, 30 Jan 2023 14:49:27 +0100
Message-Id: <20230130134342.805986593@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 9be182da0a7526f1b9a3777a336f83baa2e64d23 ]

In test_async_probe_init, second set of asynchronous devices are saved
in sync_dev[sync_id], which should be async_dev[async_id].
This makes these devices not unregistered when exit.

> modprobe test_async_driver_probe && \
> modprobe -r test_async_driver_probe && \
> modprobe test_async_driver_probe
 ...
> sysfs: cannot create duplicate filename '/devices/platform/test_async_driver.4'
> kobject_add_internal failed for test_async_driver.4 with -EEXIST,
  don't try to register things with the same name in the same directory.

Fixes: 57ea974fb871 ("driver core: Rewrite test_async_driver_probe to cover serialization and NUMA affinity")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221125063541.241328-1-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/test/test_async_driver_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index 4d1976ca5072..929410d0dd6f 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -145,7 +145,7 @@ static int __init test_async_probe_init(void)
 	calltime = ktime_get();
 	for_each_online_cpu(cpu) {
 		nid = cpu_to_node(cpu);
-		pdev = &sync_dev[sync_id];
+		pdev = &async_dev[async_id];
 
 		*pdev = test_platform_device_register_node("test_async_driver",
 							   async_id,
-- 
2.39.0



