Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC4BAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FC4C433C1;
	Thu, 27 Oct 2022 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890209;
	bh=b51TQJWG8fhXT+y35Ohu45gaplUlOoroMMn+ycw+31U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPIpGY+u19ukUw4WFUeWolyYGJGS6rtHebMe4ptSb7OxX/JgeLBvMH365jM46L4JH
	 KADIh0AUDmRjsTUB+5WsLYUWWjr5ieQi0wGtN00HA5MqDsI9opf9DS1I+67SFomywt
	 9bJMvzGAjYZUv4v1rr5cUlF+YGj5ernRB5ccGl/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/79] nvmet: fix workqueue MEM_RECLAIM flushing dependency
Date: Thu, 27 Oct 2022 18:55:54 +0200
Message-Id: <20221027165056.774307574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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
index 0a0c1d956c73..87a347248c38 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1168,7 +1168,7 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
 	 * reset the keep alive timer when the controller is enabled.
 	 */
 	if (ctrl->kato)
-		mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+		mod_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static void nvmet_clear_ctrl(struct nvmet_ctrl *ctrl)
-- 
2.35.1



