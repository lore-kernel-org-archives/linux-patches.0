Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10F815CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7EEC433D7;
	Tue,  8 Nov 2022 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915279;
	bh=S4z4PxEU7wxPDUYX2EomEjIjowN2/myOOIIHw8Jsk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRe6IDb/u+Ml8UMXFUPsDa6Ed/D8uU5CaYfM9DxmeUeMiXOM52gUCsEPzdIY6gAPT
	 m4SBqSHOv1/cItFyaE2LkA2wP60SHs6EmAWBMmDe0KI1zaC7e2qkcNX8Pf5a6xEtua
	 MVWvebmKcqACZ3dfxNT1qzih38ZhGEM/+IvkOYRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/74] RDMA/core: Fix null-ptr-deref in ib_core_cleanup()
Date: Tue,  8 Nov 2022 14:38:35 +0100
Message-Id: <20221108133333.957359057@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

[ Upstream commit 07c0d131cc0fe1f3981a42958fc52d573d303d89 ]

KASAN reported a null-ptr-deref error:

  KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
  CPU: 1 PID: 379
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  RIP: 0010:destroy_workqueue+0x2f/0x740
  RSP: 0018:ffff888016137df8 EFLAGS: 00000202
  ...
  Call Trace:
   ib_core_cleanup+0xa/0xa1 [ib_core]
   __do_sys_delete_module.constprop.0+0x34f/0x5b0
   do_syscall_64+0x3a/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7fa1a0d221b7
  ...

It is because the fail of roce_gid_mgmt_init() is ignored:

 ib_core_init()
   roce_gid_mgmt_init()
     gid_cache_wq = alloc_ordered_workqueue # fail
 ...
 ib_core_cleanup()
   roce_gid_mgmt_cleanup()
     destroy_workqueue(gid_cache_wq)
     # destroy an unallocated wq

Fix this by catching the fail of roce_gid_mgmt_init() in ib_core_init().

Fixes: 03db3a2d81e6 ("IB/core: Add RoCE GID table management")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221025024146.109137-1-chenzhongjin@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 10 +++++++++-
 drivers/infiniband/core/nldev.c  |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index de66d7da1bf6..372ca5347d3c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2762,10 +2762,18 @@ static int __init ib_core_init(void)
 
 	nldev_init();
 	rdma_nl_register(RDMA_NL_LS, ibnl_ls_cb_table);
-	roce_gid_mgmt_init();
+	ret = roce_gid_mgmt_init();
+	if (ret) {
+		pr_warn("Couldn't init RoCE GID management\n");
+		goto err_parent;
+	}
 
 	return 0;
 
+err_parent:
+	rdma_nl_unregister(RDMA_NL_LS);
+	nldev_exit();
+	unregister_pernet_device(&rdma_dev_net_ops);
 err_compat:
 	unregister_blocking_lsm_notifier(&ibdev_lsm_nb);
 err_sa:
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index e4905d9fecb0..81b70f1f1290 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2098,7 +2098,7 @@ void __init nldev_init(void)
 	rdma_nl_register(RDMA_NL_NLDEV, nldev_cb_table);
 }
 
-void __exit nldev_exit(void)
+void nldev_exit(void)
 {
 	rdma_nl_unregister(RDMA_NL_NLDEV);
 }
-- 
2.35.1



