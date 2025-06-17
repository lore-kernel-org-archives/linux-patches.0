Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4153F2E8E13;
	Tue, 17 Jun 2025 16:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177477; cv=none; b=UzWs8IMr0WxLatzp+UPNPsYEnZnIdsS4glxLsjuqEBPpzSPlwKUCboLoNmK+zj/4KdjE5wyxWh3Q7Dluva9FwZN6shhoAS0yeVgfi1kd+pyeHBcJOPX4dYwabX8wFaHK9cZZ4EwZbQKTB4tG/0aPhucc3Hheg5AMjkhWAMtf1Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177477; c=relaxed/simple;
	bh=uappo9mZnpU0lnX3XihahV/x8cg4aGsZij9ogvFX5yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STsedrou7STw6aNWcWuGxC9C+h7WFN2Pm2c1yZ10zrsDBfnSHD/HESvjc2e370Vym1MxCbe3JL1TfhPfQGbbtc/jPmAACdFVXWZdS9oUpxF1ADDotlcsQUFKn9eaDU1kp6tk1oVpupkP9qvYu8iZx6y+haFZrEhDa0E7Gx2nVFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MuKx2fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MuKx2fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58B7C4CEE3;
	Tue, 17 Jun 2025 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177477;
	bh=uappo9mZnpU0lnX3XihahV/x8cg4aGsZij9ogvFX5yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MuKx2fj0afG1bUvME97oLVe9Vl5j2PQGRURCeJ3magM7BIf5rasd63u0BWVLfbnQ
	 eEyhPAtu0jyVDjrpGrA4yMoMi0iAkGqYHJjmTQ8bCm4EjfCN2pYtLgaamEOvHtIg8W
	 a2SloO77sZSwxoUE2slfGSJa+XaaI3oglEQuWb+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Moyer <jmoyer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/512] loop: add file_start_write() and file_end_write()
Date: Tue, 17 Jun 2025 17:25:09 +0200
Message-ID: <20250617152433.496225620@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 39d86db34e41b96bd86f1955cd0ce6cd9c5fca4c ]

file_start_write() and file_end_write() should be added around ->write_iter().

Recently we switch to ->write_iter() from vfs_iter_write(), and the
implied file_start_write() and file_end_write() are lost.

Also we never add them for dio code path, so add them back for covering
both.

Cc: Jeff Moyer <jmoyer@redhat.com>
Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250527153405.837216-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0843d229b0f76..e9a197474b9d8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -323,11 +323,14 @@ static void lo_complete_rq(struct request *rq)
 static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	struct loop_device *lo = rq->q->queuedata;
 
 	if (!atomic_dec_and_test(&cmd->ref))
 		return;
 	kfree(cmd->bvec);
 	cmd->bvec = NULL;
+	if (req_op(rq) == REQ_OP_WRITE)
+		file_end_write(lo->lo_backing_file);
 	if (likely(!blk_should_fake_timeout(rq->q)))
 		blk_mq_complete_request(rq);
 }
@@ -402,9 +405,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		cmd->iocb.ki_flags = 0;
 	}
 
-	if (rw == ITER_SOURCE)
+	if (rw == ITER_SOURCE) {
+		file_start_write(lo->lo_backing_file);
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
-	else
+	} else
 		ret = file->f_op->read_iter(&cmd->iocb, &iter);
 
 	lo_rw_aio_do_completion(cmd);
-- 
2.39.5



