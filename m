Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AA73502A8;
	Wed, 30 Sep 2026 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794817; cv=none; b=hs/l+QoiXtJF+2GsqSqKyz50hW24NIcOWlxXHaxpCLdLRxs7wifud1z/fuEgf9iNBiso+fexXkKPmPPqoDGdzeR/Ee+iz0Y5AGSUa6pY6YsYtC+ON41l47KODn1nT13HB/0HEMSymHTkjnhuXK714FTy0CQN2N3XV7j8G8aQtEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794817; c=relaxed/simple;
	bh=+4OhMgtwThtP8MQ6hUMUULCzGgew2Ev05NDjFnoGRu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3YMI5g4noZ0n2hxwgSCfyip0vm2CUGYSSZoi9bh2xN0qnku3LpmIXQ7mpVP3Z1WWlmHsjcsW0/hyrKeOjA4IW77vYmIO/CQo8WtCfIi3Q2nvwp0KDYDDFKHDSg9615ENn0wkWNSIgbCzJLuc/AVG9n4ZqitYbycSJavaHtiJnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dreWgbtu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dreWgbtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728141F000FF;
	Wed, 30 Sep 2026 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794816;
	bh=09nggyJMT/aJqEE81ODs20R3NBCPg0DQ97JNjc3llQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dreWgbtun76UaLe5Z82W3Ywbh8iHHcpdd3gQBfY337W1UB7MH1NXaKTgfaboIDhyU
	 7bLM4DrLxkE+Eyj9j0IPMkfLAbaUBlnn1aoGUNvFnLvQKI89uJNr9BDjFb4ym9JwfP
	 zr1UmX4MEkTpXvCBSL7J09vlaZSnO6pp8zkoaX3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0343/1193] scsi: core: Do not block on tag allocation in scsi_eh_lock_door()
Date: Wed, 30 Sep 2026 17:17:07 +0200
Message-ID: <20260930152441.781812188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4c05cf38aa55..bfa2e477a5b62 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2116,7 +2116,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
-- 
2.53.0



