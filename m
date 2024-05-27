Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FB8168C4;
	Mon, 27 May 2024 19:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837686; cv=none; b=PE2xvjE93wimqGol4VWNa4eDMdyjceXM2Lc0UuQPlCQWkunlOaK5gt1w2i9NbpyFJX3oSzOSOY/dflI4554pmlUXu9qa/5Xqrxt9thktUQyAFq6xSbvFVSIvMotwZhDUJ9Si1XqP8AE5hRmbBQ++baDtOKOWkdxnHCU1YBbOxGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837686; c=relaxed/simple;
	bh=tOLKF7Bi5dUvk1W9uHcIwSLOnkw/VHrhVfrSScY6vYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFWKZgzrMPloXbICFfoTMQl9D8E1jL/L6IDNRDRPJb7TZPX20jbSRB/qFbn4e9DNHSgUOrxfYKMuWS9Ih3QI++9RwwRFBK1dLbjZ7Ng4xSC4CNjBnhcV6s3PHrB5rhTESS0pjPOO/zxjyLIjfOKVMLxs71bQyDogoUmnhG0QWaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0+3VzEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0+3VzEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C01C2BBFC;
	Mon, 27 May 2024 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837686;
	bh=tOLKF7Bi5dUvk1W9uHcIwSLOnkw/VHrhVfrSScY6vYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0+3VzEYvT3DB1UMAF4oahTRQ+N4hOXMIWyynQ3P/Q26k9yMYHbEq+6Gc04TbTAP0
	 YSxBrSUFFxtOPNEGcptV020ztxn8x7hOWSThD+tg1GX/5mXaonfGlPsRAvChdSF0h6
	 NX9TxflV3zGDVDrPxkEMYYBdWtdfsBQs2NUJwM7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 105/493] nvmet-tcp: fix possible memory leak when tearing down a controller
Date: Mon, 27 May 2024 20:51:47 +0200
Message-ID: <20240527185633.954738813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 6825bdde44340c5a9121f6d6fa25cc885bd9e821 ]

When we teardown the controller, we wait for pending I/Os to complete
(sq->ref on all queues to drop to zero) and then we go over the commands,
and free their command buffers in case they are still fetching data from
the host (e.g. processing nvme writes) and have yet to take a reference
on the sq.

However, we may miss the case where commands have failed before executing
and are queued for sending a response, but will never occur because the
queue socket is already down. In this case we may miss deallocating command
buffers.

Solve this by freeing all commands buffers as nvmet_tcp_free_cmd_buffers is
idempotent anyways.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index c8655fc5aa5b8..8d4531a1606d1 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -348,6 +348,7 @@ static int nvmet_tcp_check_ddgst(struct nvmet_tcp_queue *queue, void *pdu)
 	return 0;
 }
 
+/* If cmd buffers are NULL, no operation is performed */
 static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd)
 {
 	kfree(cmd->iov);
@@ -1580,13 +1581,9 @@ static void nvmet_tcp_free_cmd_data_in_buffers(struct nvmet_tcp_queue *queue)
 	struct nvmet_tcp_cmd *cmd = queue->cmds;
 	int i;
 
-	for (i = 0; i < queue->nr_cmds; i++, cmd++) {
-		if (nvmet_tcp_need_data_in(cmd))
-			nvmet_tcp_free_cmd_buffers(cmd);
-	}
-
-	if (!queue->nr_cmds && nvmet_tcp_need_data_in(&queue->connect))
-		nvmet_tcp_free_cmd_buffers(&queue->connect);
+	for (i = 0; i < queue->nr_cmds; i++, cmd++)
+		nvmet_tcp_free_cmd_buffers(cmd);
+	nvmet_tcp_free_cmd_buffers(&queue->connect);
 }
 
 static void nvmet_tcp_release_queue_work(struct work_struct *w)
-- 
2.43.0



