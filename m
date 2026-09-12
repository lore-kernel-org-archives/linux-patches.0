Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C532D8DA8;
	Sat, 12 Sep 2026 14:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222052; cv=none; b=the7VWpuaapA95871uUWNKTIekZdhhjP2QWf8JqSHju8dhCCUzQ1UVqzedcZvIMQjHdl1/70zzW0c63Ri8OC6SAYhkrPiscNJAeEFsC63X1Dyb8Rj1eWILcRCVXCbaoWegCbxOE53xilPq54IQ8SQPFfKe6GWHE2S0MJ7pguE9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222052; c=relaxed/simple;
	bh=f3nsGSwV8Rlj/KODV5xgjc2Hgo5/rWWpVhGqbfG6wFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz5tlEmPDKV7AZ/8Sn5QKXdW0yc/l0NOQ/wyYT7590mQSnOCeTYx8ECcIULX7jcaTmeX/H8uveZ7geuXHFZpYvQrafHJLv5OAEVjr4M2kjpQv6c/5JpyZFKK010xM4iOe6TVQnG+ozWBj3eoLXVxOVOwjRTdI5KlAXZ+vVKEPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w94100O8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w94100O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB14E1F000FF;
	Sat, 12 Sep 2026 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222051;
	bh=f/cQYcIT5GU6XPK+i1VC3LQ33e8Q+JPlUuFd+33pABM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w94100O8yUgU7GBiND6QWIzsabw0usKaFUdkFlInLzqgTp4lxpAgw6poHlnpo8OCs
	 SC9AXlbpuawW7WQlM3NFGPuxO2UH/SmUOfktU5NoP3+vt3lVrWUTS8dCj5dtQT78xx
	 v10DvUKp/gSzlxd8a0sqJuiuoTkYLYN+o7vNSS5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0491/1424] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Sat, 12 Sep 2026 08:48:43 +0200
Message-ID: <20260912065618.284599952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 505753ec2594c6af09a601f0dd60be7d840c1d2d upstream.

qla2xxx_delete_qpair() deletes the request queue before the response
queue. qla25xx_delete_req_que() frees the request queue memory
(kfree(req) in qla25xx_free_req_que()), but the response-queue MSI-X is
only released later, in qla25xx_free_rsp_que(). In that window the
response interrupt can still fire, qla2xxx_msix_rsp_q() queues
qpair->q_work, and qla_do_work() -> qla24xx_process_response_queue()
dereferences the now-freed rsp->req (LOGINOUT/CT/ELS entries and the
status path), a use-after-free.

The cancel_work_sync() added for the qpair teardown lives in the
response free path, which runs after the request queue is already freed,
so it does not protect rsp->req.

Release the response-queue interrupt and flush qpair->q_work before
deleting the request queue, so no late completion can reach the freed
request queue. Clearing have_irq makes the subsequent
qla25xx_free_rsp_que() skip its free_irq(), and the firmware
queue-delete order (request then response) is preserved; the
request-delete mailbox completes on the default vector and is unaffected
by dropping the qpair response interrupt early.

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-18-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9853,11 +9853,28 @@ int qla2xxx_delete_qpair(struct scsi_qla
 {
 	int ret = QLA_FUNCTION_FAILED;
 	struct qla_hw_data *ha = qpair->hw;
+	struct rsp_que *rsp = qpair->rsp;
 
 	qpair->delete_in_progress = 1;
 
 	qla_free_buf_pool(qpair);
 
+	/*
+	 * The response-queue interrupt schedules qla_do_work(), which
+	 * dereferences qpair->rsp->req.  Release the interrupt and flush
+	 * any pending work before the request queue is freed below so a
+	 * late completion cannot touch the freed request queue.  The
+	 * firmware queue-delete order (request then response) is kept.
+	 */
+	if (rsp && rsp->msix && rsp->msix->have_irq) {
+		free_irq(rsp->msix->vector, rsp->msix->handle);
+		rsp->msix->have_irq = 0;
+		rsp->msix->in_use = 0;
+		rsp->msix->handle = NULL;
+	}
+	if (rsp && ha->wq)
+		cancel_work_sync(&qpair->q_work);
+
 	ret = qla25xx_delete_req_que(vha, qpair->req);
 	if (ret != QLA_SUCCESS)
 		goto fail;


