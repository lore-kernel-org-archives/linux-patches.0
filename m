Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576872E8E12;
	Tue, 17 Jun 2025 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178877; cv=none; b=pSOMYWGsZo5XGGiRaE9J06TZXQTv5BfZoeplcJ2+Zcj+h5A/6j5vTmHJqe25yEIhVu4kiqmwp0yRnRjxjXdgKGdNGH2jI8qCocMzBIU8l9q0wOiWruAJTpVPdWni2adHWJdhXPvT/ZwWfkmGHpWqw5zmq1A0q6C4O/QiHnOZ4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178877; c=relaxed/simple;
	bh=Zll0u9TdgTT20sfGDYyhSm/0WFgwx0aAoXhlVvbPX9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFK81DWI5LRZWprnsFBekUIlzHZ71VoXzxpXuzjv07+ET4YkT5IevZCafngpjz6Ywm7mGrKxA8UvKNE+TsmVndf7XW4SolvqQyctYIkYGavN+0Hg8oCwNHK08hrFB0Dt29W50+tiVNpkz6ZPLqvGhlONoQnYEs78WlRN36Gh1iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXAGXPNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXAGXPNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B07EC4CEE3;
	Tue, 17 Jun 2025 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178877;
	bh=Zll0u9TdgTT20sfGDYyhSm/0WFgwx0aAoXhlVvbPX9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXAGXPNkky/ri/xMpafnAtvPvlpdAqxe/NXouCRfBFO/nTxp5pqMq0Aw4YQQOE1x7
	 oA4Ro7AXrqRQ930hTWIe+mUsLwgnSPTs3yaPWOPZMcvXmHD2diq20ZBEGU0m2yRagp
	 tvWpK09J6atH+TBVaociNV6XKkjU5opMDVFObROw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Moyer <jmoyer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 549/780] loop: add file_start_write() and file_end_write()
Date: Tue, 17 Jun 2025 17:24:17 +0200
Message-ID: <20250617152513.866140025@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e2b1f377f5856..f8d136684109a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -308,11 +308,14 @@ static void lo_complete_rq(struct request *rq)
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
@@ -387,9 +390,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
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



