Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB93728B4E6;
	Wed, 23 Apr 2025 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422501; cv=none; b=PTBwd75F904MvT+T3SxBPCQxzimPKoQyG0NGqKU+y2/p9ipCutMWyDQ6tRyd0WSeYvC+d65Pr5Jht7FnP2s58Fp3evGa5IT8SKAipRNlKOS5scUkFjshhCcftaNj4t5Q/ofdr6DFsQKZuV474KrUojC1D9jmQZXhlYeG34tcAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422501; c=relaxed/simple;
	bh=4w/SbY7zFNaEQeaa8HfabppZUJCHnM9+x68Pjc8hAPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMc3r9xyH4qEKOjh4YYAjdOlp8NytNe6EKDQhjBI3NeuJRBPBeWYKdo8i0NkQapMe2ED4/M9ssu6CB1kBTvFeOONGGc0R4/wwjT90qY2gGTNvn0L0HYVacwytTjDAOTqUKxozGvWohAftsZSuitavztD5TRv4bZ+DaWlpg8ohco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REwKiyMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REwKiyMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD326C4CEE3;
	Wed, 23 Apr 2025 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422501;
	bh=4w/SbY7zFNaEQeaa8HfabppZUJCHnM9+x68Pjc8hAPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REwKiyMZn1j5UMSE3/U0922DSzXvnVbrk8W2WqO9DbNNh7KOst5327khBbIlhrOYm
	 JrjNg5cQwvcg37X7391m0IaZYcD4h58PuFvI1HYq+PJFLH5dyApZ1syxeMmXUv0XYG
	 T7xxL7uaW51s/OkV2pKZMvb873cLCu321K4jggBs=
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
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 6.6 374/393] nvme-rdma: unquiesce admin_q before destroy it
Date: Wed, 23 Apr 2025 16:44:30 +0200
Message-ID: <20250423142658.780460334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunguang.xu <chunguang.xu@shopee.com>

commit 5858b687559809f05393af745cbadf06dee61295 upstream.

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
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/rdma.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1083,13 +1083,7 @@ destroy_io:
 		nvme_rdma_free_io_queues(ctrl);
 	}
 destroy_admin:
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
 


