Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90A01D094D;
	Wed,  2 Oct 2024 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877613; cv=none; b=EoQUnWmclO9+zH1hzcUmcEGtC26XncBKYrmVZcfoKOeAQ4GrxJNQyAQ2LLIGtWEhBWOKysZYvGr/OMBvuUNavHFJUl/Iffuvm5XO0HCzZbJMyIhtB2hZARyVaN/Ol28ulIYs47HVrvsxMPiAjOTVKCvD/U/ppIkzruurL3eBm/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877613; c=relaxed/simple;
	bh=AtoL2QiH64IQf4Lb3/5f2TkPm1DMMpursYF/w4b3cXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paoMm/3lxyjpF6B8P1CqifqHWPS9KpblfnaL+HNiFmKFrDrZT+nW2EsH0AefhKb4Z14ZYuPaYIv5c5ilQL+dy0k0SZ8tmcpPvyRtW98Njip6hVR4PlFernlE3+nsZMOaGfPeOwyJHO3d8MYfOzbp7OI/mxdg1CdQ5hEgAjYA9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVMO6nqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVMO6nqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C09AC4CEC2;
	Wed,  2 Oct 2024 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877613;
	bh=AtoL2QiH64IQf4Lb3/5f2TkPm1DMMpursYF/w4b3cXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVMO6nqi/ff4kXwBWILKABE43O2BS3XjV9B+ztPyqsS6ALNhFUjubcpsQ1jtpRKBT
	 cy8NQ4kTtE695DTSE7oBq01Hy+fSItPIJ+RD0LqduVdo3f2DxayyV5MTw0W4MA+CVT
	 39M0Qyf5nukLojNqB7uM2YGR+P3ElPWZciqBXV70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 103/634] nbd: fix race between timeout and normal completion
Date: Wed,  2 Oct 2024 14:53:23 +0200
Message-ID: <20241002125815.181671347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c9ea57c91f03bcad415e1a20113bdb2077bcf990 ]

If request timetout is handled by nbd_requeue_cmd(), normal completion
has to be stopped for avoiding to complete this requeued request, other
use-after-free can be triggered.

Fix the race by clearing NBD_CMD_INFLIGHT in nbd_requeue_cmd(), meantime
make sure that cmd->lock is grabbed for clearing the flag and the
requeue.

Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Fixes: 2895f1831e91 ("nbd: don't clear 'NBD_CMD_INFLIGHT' flag if request is not completed")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240830034145.1827742-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b87aa80a46dda..0e8ddf30563d0 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -181,6 +181,17 @@ static void nbd_requeue_cmd(struct nbd_cmd *cmd)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
 
+	lockdep_assert_held(&cmd->lock);
+
+	/*
+	 * Clear INFLIGHT flag so that this cmd won't be completed in
+	 * normal completion path
+	 *
+	 * INFLIGHT flag will be set when the cmd is queued to nbd next
+	 * time.
+	 */
+	__clear_bit(NBD_CMD_INFLIGHT, &cmd->flags);
+
 	if (!test_and_set_bit(NBD_CMD_REQUEUED, &cmd->flags))
 		blk_mq_requeue_request(req, true);
 }
@@ -480,8 +491,8 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 					nbd_mark_nsock_dead(nbd, nsock, 1);
 				mutex_unlock(&nsock->tx_lock);
 			}
-			mutex_unlock(&cmd->lock);
 			nbd_requeue_cmd(cmd);
+			mutex_unlock(&cmd->lock);
 			nbd_config_put(nbd);
 			return BLK_EH_DONE;
 		}
-- 
2.43.0



