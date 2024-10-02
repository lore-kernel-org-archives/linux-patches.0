Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBAE1D014A;
	Wed,  2 Oct 2024 13:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875541; cv=none; b=nSXDA6prwTzixvMISHNxBM82LgQyQL0NKEGetmiXz/6aziLov8z38Xy7fwcBMbMGjosEGP9Xf8gGz/gY3unDcppMksghAEbv3mLTv7LWXF9tIQwwfX1URV1zrZ2F1ZjXP3qxjbflTncY3yxgCMK58AUnViCmMakJDW54Ij6GzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875541; c=relaxed/simple;
	bh=CibM0L9ZyG25kT34XFQsh8u9kvsP2AQ4bieTetkfzy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dlm3E0DKl4HF/sLcnnGkmDsvJcgbXL/OoIM64VOZYlch9oUHVJgJhY1+rWuy+zzZ+yleJZO2ZBvemBC4xSXbe51wej94+HI1apYJMT1xZU6JrxgUBd5XIbL4zEoBL7K6raT7HIpWAeg8GXJdPJ4qerwBXSXFwO+Tq8IZfYS6YGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1dQOKSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1dQOKSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF82C4CEC5;
	Wed,  2 Oct 2024 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875541;
	bh=CibM0L9ZyG25kT34XFQsh8u9kvsP2AQ4bieTetkfzy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1dQOKSG8S2aCXyT18wp+/cDHyrFyzFutmIeEZc4xPfHKWLpA6aDiWotnTM5QDqns
	 bRXKpZld263mIX+TW96FAQCmOrKgSlNGd/fFK223rAouJXQnAPpUQTUtVo8DK/UPSU
	 J6rXMgoSWwwXNP8ySphs/FwY84xCf49Qre/4+FAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 119/695] nbd: fix race between timeout and normal completion
Date: Wed,  2 Oct 2024 14:51:57 +0200
Message-ID: <20241002125827.223359150@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 41a90150b501d..69b9851b67982 100644
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
@@ -488,8 +499,8 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
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



