Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862C9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AC6C433C9;
	Sun, 13 Aug 2023 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963162;
	bh=KbpsQ8ahkpKw3xyZrZBteaLeFGN9mv9oGtWv1n2oudg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfBmNdd9Pz5y1r4s48YGUb9sXtcYYzmWuOSaEUF+wU5Uf4MS1vqlb9qviBRFXjLiH
	 Zu3VbvIZHYR0RDDmT10WPE46AHqf6Gr1QrYPJkCSWdv0RyoOAkShI0uP9CS7MsaD0q
	 CUoJi/5617jU1wLltigCN4usMe/ZDP53Zg3qI1EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 75/89] nvme-rdma: fix potential unbalanced freeze & unfreeze
Date: Sun, 13 Aug 2023 23:20:06 +0200
Message-ID: <20230813211713.025457057@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

commit 29b434d1e49252b3ad56ad3197e47fafff5356a1 upstream.

Move start_freeze into nvme_rdma_configure_io_queues(), and there is
at least two benefits:

1) fix unbalanced freeze and unfreeze, since re-connection work may
fail or be broken by removal

2) IO during error recovery can be failfast quickly because nvme fabrics
unquiesces queues after teardown.

One side-effect is that !mpath request may timeout during connecting
because of queue topo change, but that looks not one big deal:

1) same problem exists with current code base

2) compared with !mpath, mpath use case is dominant

Fixes: 9f98772ba307 ("nvme-rdma: fix controller reset hang during traffic")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/rdma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -989,6 +989,7 @@ static int nvme_rdma_configure_io_queues
 		goto out_cleanup_connect_q;
 
 	if (!new) {
+		nvme_start_freeze(&ctrl->ctrl);
 		nvme_start_queues(&ctrl->ctrl);
 		if (!nvme_wait_freeze_timeout(&ctrl->ctrl, NVME_IO_TIMEOUT)) {
 			/*
@@ -997,6 +998,7 @@ static int nvme_rdma_configure_io_queues
 			 * to be safe.
 			 */
 			ret = -ENODEV;
+			nvme_unfreeze(&ctrl->ctrl);
 			goto out_wait_freeze_timed_out;
 		}
 		blk_mq_update_nr_hw_queues(ctrl->ctrl.tagset,
@@ -1038,7 +1040,6 @@ static void nvme_rdma_teardown_io_queues
 		bool remove)
 {
 	if (ctrl->ctrl.queue_count > 1) {
-		nvme_start_freeze(&ctrl->ctrl);
 		nvme_stop_queues(&ctrl->ctrl);
 		nvme_sync_io_queues(&ctrl->ctrl);
 		nvme_rdma_stop_io_queues(ctrl);


