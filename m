Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10F8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D17C433D6;
	Thu, 27 Oct 2022 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889983;
	bh=dIErurHeTRZzIJzLvubxKsey3hnWmB1+wNvnq21QcMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6CQcU2dk3JO4l2/+8vO5YKEZhhsYyZBdpQiYqPEw2H7S9jIcqQVU1ggE4gTUZqyM
	 ZQ//KLsxpzyhP3qTqmGawtBDYnV+dRTxvX8iREMmJ/8vqR5OL01dE2CSX8EGrKuDcm
	 U7qfCaTe7wrIbUT+AxJE0MV/i5YVac5Xli3FqrnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 73/94] nvmet: fix workqueue MEM_RECLAIM flushing dependency
Date: Thu, 27 Oct 2022 18:55:15 +0200
Message-Id: <20221027165100.142589757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit ddd2b8de9f85b388925e7dc46b3890fc1a0d8d24 ]

The keep alive timer needs to stay on nvmet_wq, and not
modified to reschedule on the system_wq.

This fixes a warning:
------------[ cut here ]------------
workqueue: WQ_MEM_RECLAIM
nvmet-wq:nvmet_rdma_release_queue_work [nvmet_rdma] is flushing
!WQ_MEM_RECLAIM events:nvmet_keep_alive_timer [nvmet]
WARNING: CPU: 3 PID: 1086 at kernel/workqueue.c:2628
check_flush_dependency+0x16c/0x1e0

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: 8832cf922151 ("nvmet: use a private workqueue instead of the system workqueue")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 14677145bbba..aecb5853f8da 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1176,7 +1176,7 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
 	 * reset the keep alive timer when the controller is enabled.
 	 */
 	if (ctrl->kato)
-		mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+		mod_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static void nvmet_clear_ctrl(struct nvmet_ctrl *ctrl)
-- 
2.35.1



