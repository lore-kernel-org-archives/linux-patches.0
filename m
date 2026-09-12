Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2963FF1AE;
	Sat, 12 Sep 2026 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214097; cv=none; b=Utr+Y3qxp35clkCt2Vc5mmQyuXdGyNrr5GRHonCNu4GRZI+zqF2+cw9nodYAgMXr01cdolY2fuV7pcTkREAj8z9HqxyIVyVcGBVXZiSi87UBrWwcnxT0jbYRzHUYWYUXCtepYfrdNMGeQTCiUHLJf0zfMCNAooA3ok7ygg/fOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214097; c=relaxed/simple;
	bh=Tg0VOW2LddOy+H81MbulfX14cEyNSW1kkBOAMhtks6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT8Y6fvOr5TC9i5BbCoEmpclFRZfEWO0lHhKX8cIdivqg7emYCeJPCJr+MWyodl83Vlgy7eBuQMRkqe+9fTgVEmhmzwiI0pTv4BCKfsQhZNH2kLmKEHtiE/jaNMdKDKejm+HgN1DC0kp9q9wM0hM/TxpZj4HHLBc1QmyuiY9CXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKOKndHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKOKndHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937DA1F000FF;
	Sat, 12 Sep 2026 11:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214095;
	bh=eX5Z8N/+lH0sjOZoQGIyGMrvRW6AsB3BMbqn+dip9Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKOKndHiLyb02H3Oc2Fz4J8UxJ9nQPCI1vScj39qc+BZtfmv99bWa8ezws3S12QaP
	 KACAZs/3RlDw0DzNN7/HwQGmeXRJxv6OvBUVzJI2FxhJanbCA/uqS545tTM7xdbpSg
	 r4kjlwKIz00/hH6tlDSqQiq/CokSbnQeH9E3F4uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0238/1376] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Sat, 12 Sep 2026 08:44:24 +0200
Message-ID: <20260912065612.848285578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


