Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796AC8F71
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB1AC433C9;
	Sun, 16 Jul 2023 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537258;
	bh=eabeJB7uLLN9FUZUildGHQX/XARv5wy9RMu+doEdHak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMFPe0l1jqOpKW1j0YwtJnqdMU5Nf+W6iLKnkl6rQV4aQ8UVUDcHcCsn+XDLDBqe6
	 gCKFvg3lCmxLR99x3fr4O4SiQWemD4GIpPdN/nRwZx0cHa+At2y3V3Z+2t55GJE4z4
	 iAq5Yd4msZVg9pD+Jy/qWTGyN+E2PbutnH7JXC30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 032/800] nvme-core: fix dev_pm_qos memleak
Date: Sun, 16 Jul 2023 21:38:05 +0200
Message-ID: <20230716194949.844891322@linuxfoundation.org>
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

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 7ed5cf8e6d9bfb6a78d0471317edff14f0f2b4dd ]

Call dev_pm_qos_hide_latency_tolerance() in the error unwind patch to
avoid following kmemleak:-

blktests (master) # kmemleak-clear; ./check nvme/044;
blktests (master) # kmemleak-scan ; kmemleak-show
nvme/044 (Test bi-directional authentication)                [passed]
    runtime  2.111s  ...  2.124s
unreferenced object 0xffff888110c46240 (size 96):
  comm "nvme", pid 33461, jiffies 4345365353 (age 75.586s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000069ac2cec>] kmalloc_trace+0x25/0x90
    [<000000006acc66d5>] dev_pm_qos_update_user_latency_tolerance+0x6f/0x100
    [<00000000cc376ea7>] nvme_init_ctrl+0x38e/0x410 [nvme_core]
    [<000000007df61b4b>] 0xffffffffc05e88b3
    [<00000000d152b985>] 0xffffffffc05744cb
    [<00000000f04a4041>] vfs_write+0xc5/0x3c0
    [<00000000f9491baf>] ksys_write+0x5f/0xe0
    [<000000001c46513d>] do_syscall_64+0x3b/0x90
    [<00000000ecf348fe>] entry_SYSCALL_64_after_hwframe+0x72/0xdc

Link: https://lore.kernel.org/linux-nvme/CAHj4cs-nDaKzMx2txO4dbE+Mz9ePwLtU0e3egz+StmzOUgWUrA@mail.gmail.com/
Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 43bb5071b222c..3395e27438393 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5250,6 +5250,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	return 0;
 out_free_cdev:
 	nvme_fault_inject_fini(&ctrl->fault_inject);
+	dev_pm_qos_hide_latency_tolerance(ctrl->device);
 	cdev_device_del(&ctrl->cdev, ctrl->device);
 out_free_name:
 	nvme_put_ctrl(ctrl);
-- 
2.39.2



