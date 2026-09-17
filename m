Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72FA3DA5A1;
	Thu, 17 Sep 2026 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665146; cv=none; b=Dm922zxb6dRnKR+WI9zxu3+DPTMgO+xXtexpGk3tScXrGbLsZmKQdNgL8f9TrM/tercnJahCIe4ZMfhzbCuDQiTg+eG/1PuLR0qyNROzZa4bFqgeEnERqw3uNFNBrQRFBeiuoJBpP0NjpGWijapjehWA+J0MDWXuFtekAX9DXJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665146; c=relaxed/simple;
	bh=34R6d1/rViYAeQhZ294z/Qkjo99AHnnI+LsvvLRjXWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8qT9MQwTPrPxT90A+GhIS5TXB4NV6MScc5SYCCv7AjmkGDukGRxvxe/03CwtZ0SVSgCxrsIGl3xpIlMbiohGHJPAEZOi1XA6PDKrE95dyWvyWO80nq2G1BWeiDHTYMIKB6n3j2+c9LXsumyLyw+7bnJxUfau9OROD6szTCUNnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt+MXgGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt+MXgGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFBA1F000FF;
	Thu, 17 Sep 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665144;
	bh=jEdWhlJ08tE2299nzs3TprWTMq66RaWW6qvox2XTpP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt+MXgGyzUkthQj/lzA3YK8XnKfyrvtqBykcYqc7vTsn2BHmNRSV6pS7/Zo/6Esl7
	 7OckSqtnlkKpxA76NHA6+KxsyBTTCZBvoRFT1FdsE4x1fkk2puqmttvgaIkmQSkg6V
	 LmChLIM/sNL51ErUZ0LwlZgRF0UvmfcjdKQcot7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0564/1250] scsi: core: Do not block on tag allocation in scsi_eh_lock_door()
Date: Thu, 17 Sep 2026 16:05:59 +0100
Message-ID: <20260917151607.210625874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 13d46b6e0359e..857c2acc99645 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2157,7 +2157,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
-- 
2.53.0



