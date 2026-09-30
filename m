Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70695516140;
	Wed, 30 Sep 2026 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784838; cv=none; b=fDRwDPIFrlma7/F5K914a9pCsg57K5YQ7IQuxK2xBJwJVtVqTOjcUK3WWYRu8bmjR1X1JUutgMdeinF+nyHbAdWwpQvKaRXvR5CT1bCa/9jrDh+ZXpg68l5q+hGDMKZac4YJt8tKDMV5vnsZQOKu3t40C/iq7DuRecVWjnsa+Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784838; c=relaxed/simple;
	bh=KvQbCrqHsHW/NSR7NytHFkJ6dPgeKnC1V/LEHt6Q4cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0WLAlMn1BRG1vJLOIrmGp8sDZDXtvj9Xu6/iL4RlL3OV64nOQXXm7DAiEUA2BYfMx9IREGu8Uo+M7i/jUH5muklLvyu10F1eNRmzuw+5WegMM1fIv1KSZ/ej8qRUHvYAIUig3FlkCIJ4urAHpNtEPhykbdp2ojq+5pEwjCtfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKwqCUMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKwqCUMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7081F000FF;
	Wed, 30 Sep 2026 16:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784830;
	bh=a3MHZHLLN29xJ0fAYToBtJr27NlsQJiBh5aEosQUsFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKwqCUMhLgWXqSlQwRIqH6NVXg972eL75kh/UzraFGjz8fNwFr6eWWBefrzhVdDNB
	 dajpjHOATYrNaAuh9WVIEfNh9/jxXLnh3PPSJNiKBqb0F+Z1L2v7vb9DxCMHKKIH9Q
	 ZVxFgLEgVOoZ06VwNfFskJPRUziBYWkOUtMYE0OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/982] scsi: core: Do not block on tag allocation in scsi_eh_lock_door()
Date: Wed, 30 Sep 2026 17:17:08 +0200
Message-ID: <20260930152423.080328531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 732cb6bb37fd26863d5786522fb1997e7f5865b4 ]

scsi_eh_lock_door() is called from scsi_restart_operations() while the
host is still in the SHOST_RECOVERY state, i.e. before the host is
switched back to SHOST_RUNNING and scsi_run_host_queues() restarts the
queues. It allocates a request via scsi_alloc_request() with no flags,
so blk_mq_get_tag() may block waiting for a free sched tag when all tags
are already in use.

Those tags can be held by commands that were just requeued by
scsi_eh_flush_done_q() during error handling. Such commands cannot be
dispatched until the host leaves SHOST_RECOVERY and
scsi_run_host_queues() is called - which only happens *after*
scsi_eh_lock_door() returns.

This forms a circular dependency:

  - scsi_eh_lock_door(), running in the SCSI error handler thread, waits
    for a sched tag held by a requeued command;

  - the requeued command cannot complete and release its sched tag until
    the error handler thread leaves scsi_restart_operations() and restart
    the queues.

For devices with a single driver tag (e.g. USB storage) it is a
guaranteed deadlock and I/O that can never be submitted. This problem
has also been reproduced in our environment.

Locking the door is a best-effort operation, and scsi_eh_lock_door()
already returns silently when the request allocation fails. Pass
BLK_MQ_REQ_NOWAIT to scsi_alloc_request() so the allocation fails
instead of blocking when no tag is available. This breaks the circular
dependency and allows the error handler to finish restarting the queues,
after which the pending commands are dispatched normally.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260723041238.1584632-1-wozizhi@huaweicloud.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 79dc157661ce9..f6d3f35647636 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2060,7 +2060,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
-- 
2.53.0



