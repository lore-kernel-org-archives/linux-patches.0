Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7968C2EAE5;
	Thu, 12 Dec 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016010; cv=none; b=BQ25BtwVjZWoSiq1chnAaRRQC0iwSHjGu6nKOVDkWBDODD7fAwsEKvSc22VBH52NZjJVaG7enyir/9lMJEeRILRAdQWHl3dre/qVR85U7PlnJwosYpafkPs31l+fiOapPWhatXnVTIa/fanOczOD90gI7JyXVrMnkPyxZfG09gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016010; c=relaxed/simple;
	bh=qizGT6EDJKsninS3o1N5zqa6K3ny2w9o9YmEZXOZI14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVYM9CouJ9buY6aVvc5dPqe1bNpFyfibztv+fH2DA9Z+x4aV9LkG1sfMfBRq+ygQwE8rVIrSCF3bAZYhJXgKtdD1c+MqoDcvcUcVwAbogVN86HJpbxqZAOGrMoS6IiDL+Y8nFgae+b4KxEMMscK5PWTo3GTzOFDyzGnO8vB1iWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgseFGUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgseFGUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC14BC4CECE;
	Thu, 12 Dec 2024 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016010;
	bh=qizGT6EDJKsninS3o1N5zqa6K3ny2w9o9YmEZXOZI14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgseFGUXWeRKTkbwQkuZWWWfRZ4oxmZGXi/j5mDLVY/YTT2jKByFs7J0OnlCtRlNA
	 NLzTX2DBMg1WZOAZVWoagllK34F9tE+WJa51VlBrncEHnY7M1yHXROEFgfG5uBEasu
	 HxeNhB3rpbK0CHF+zOD/J6IM/UwTp7xapx5CwTc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yingfu.zhou" <yingfu.zhou@shopee.com>,
	"Chunguang.xu" <chunguang.xu@shopee.com>,
	"Yue.zhao" <yue.zhao@shopee.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/466] nvme-rdma: unquiesce admin_q before destroy it
Date: Thu, 12 Dec 2024 15:54:36 +0100
Message-ID: <20241212144311.045849513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunguang.xu <chunguang.xu@shopee.com>

[ Upstream commit 5858b687559809f05393af745cbadf06dee61295 ]

Kernel will hang on destroy admin_q while we create ctrl failed, such
as following calltrace:

PID: 23644    TASK: ff2d52b40f439fc0  CPU: 2    COMMAND: "nvme"
 #0 [ff61d23de260fb78] __schedule at ffffffff8323bc15
 #1 [ff61d23de260fc08] schedule at ffffffff8323c014
 #2 [ff61d23de260fc28] blk_mq_freeze_queue_wait at ffffffff82a3dba1
 #3 [ff61d23de260fc78] blk_freeze_queue at ffffffff82a4113a
 #4 [ff61d23de260fc90] blk_cleanup_queue at ffffffff82a33006
 #5 [ff61d23de260fcb0] nvme_rdma_destroy_admin_queue at ffffffffc12686ce
 #6 [ff61d23de260fcc8] nvme_rdma_setup_ctrl at ffffffffc1268ced
 #7 [ff61d23de260fd28] nvme_rdma_create_ctrl at ffffffffc126919b
 #8 [ff61d23de260fd68] nvmf_dev_write at ffffffffc024f362
 #9 [ff61d23de260fe38] vfs_write at ffffffff827d5f25
    RIP: 00007fda7891d574  RSP: 00007ffe2ef06958  RFLAGS: 00000202
    RAX: ffffffffffffffda  RBX: 000055e8122a4d90  RCX: 00007fda7891d574
    RDX: 000000000000012b  RSI: 000055e8122a4d90  RDI: 0000000000000004
    RBP: 00007ffe2ef079c0   R8: 000000000000012b   R9: 000055e8122a4d90
    R10: 0000000000000000  R11: 0000000000000202  R12: 0000000000000004
    R13: 000055e8122923c0  R14: 000000000000012b  R15: 00007fda78a54500
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

This due to we have quiesced admi_q before cancel requests, but forgot
to unquiesce before destroy it, as a result we fail to drain the
pending requests, and hang on blk_mq_freeze_queue_wait() forever. Here
try to reuse nvme_rdma_teardown_admin_queue() to fix this issue and
simplify the code.

Fixes: 958dc1d32c80 ("nvme-rdma: add clean action for failed reconnection")
Reported-by: Yingfu.zhou <yingfu.zhou@shopee.com>
Signed-off-by: Chunguang.xu <chunguang.xu@shopee.com>
Signed-off-by: Yue.zhao <yue.zhao@shopee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 24a2759798d01..913e6e5a80705 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1091,13 +1091,7 @@ static int nvme_rdma_setup_ctrl(struct nvme_rdma_ctrl *ctrl, bool new)
 	}
 destroy_admin:
 	nvme_stop_keep_alive(&ctrl->ctrl);
-	nvme_quiesce_admin_queue(&ctrl->ctrl);
-	blk_sync_queue(ctrl->ctrl.admin_q);
-	nvme_rdma_stop_queue(&ctrl->queues[0]);
-	nvme_cancel_admin_tagset(&ctrl->ctrl);
-	if (new)
-		nvme_remove_admin_tag_set(&ctrl->ctrl);
-	nvme_rdma_destroy_admin_queue(ctrl);
+	nvme_rdma_teardown_admin_queue(ctrl, new);
 	return ret;
 }
 
-- 
2.43.0



