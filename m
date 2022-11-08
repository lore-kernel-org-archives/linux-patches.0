Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFC15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6EAC433D6;
	Tue,  8 Nov 2022 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916456;
	bh=kgdNKkMdbVUH+A5hiiRRk5kKcAHcjCvwWUgzTqkCS88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhMqwi7zEwXVaLJt99k2Y9FaOlRkDgkwiZ0VwbSDbXybkRHc6X0RCjXWAHwX4D3u7
	 PSYQ6FeJxqjThSB7Wgf+REYihmrs1fqcivEeFhNzQYNGDTeYTWf8ssR5w7e4Sj7zcI
	 msqtH3wxSSGHexDQWnM/cOyuk7SdIUHr+YfLAE0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixing Liu <liuyixing1@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 007/197] RDMA/hns: Fix NULL pointer problem in free_mr_init()
Date: Tue,  8 Nov 2022 14:37:25 +0100
Message-Id: <20221108133355.106847671@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 12bcaf87d8b66d8cd812479c8a6349dcb245375c ]

Lock grab occurs in a concurrent scenario, resulting in stepping on a NULL
pointer.  It should be init mutex_init() first before use the lock.

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Call trace:
   __mutex_lock.constprop.0+0xd0/0x5c0
   __mutex_lock_slowpath+0x1c/0x2c
   mutex_lock+0x44/0x50
   free_mr_send_cmd_to_hw+0x7c/0x1c0 [hns_roce_hw_v2]
   hns_roce_v2_dereg_mr+0x30/0x40 [hns_roce_hw_v2]
   hns_roce_dereg_mr+0x4c/0x130 [hns_roce_hw_v2]
   ib_dereg_mr_user+0x54/0x124
   uverbs_free_mr+0x24/0x30
   destroy_hw_idr_uobject+0x38/0x74
   uverbs_destroy_uobject+0x48/0x1c4
   uobj_destroy+0x74/0xcc
   ib_uverbs_cmd_verbs+0x368/0xbb0
   ib_uverbs_ioctl+0xec/0x1a4
   __arm64_sys_ioctl+0xb4/0x100
   invoke_syscall+0x50/0x120
   el0_svc_common.constprop.0+0x58/0x190
   do_el0_svc+0x30/0x90
   el0_svc+0x2c/0xb4
   el0t_64_sync_handler+0x1a4/0x1b0
   el0t_64_sync+0x19c/0x1a0

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Link: https://lore.kernel.org/r/20221024083814.1089722-3-xuhaoyue1@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8507d788cc94..105888c6ccb7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2805,8 +2805,12 @@ static int free_mr_modify_qp(struct hns_roce_dev *hr_dev)
 
 static int free_mr_init(struct hns_roce_dev *hr_dev)
 {
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
 	int ret;
 
+	mutex_init(&free_mr->mutex);
+
 	ret = free_mr_alloc_res(hr_dev);
 	if (ret)
 		return ret;
-- 
2.35.1



