Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208363;
	b=YXamMF0PobK/wOLFm6RRY01/El/ixfmwlJjJTOoPi+hxBlyK+HK7HYXTFxjdY/akXFGo
	 OSwb2nDKFWiMQ1eiJRslHlnfwUwJbWVya731lwJvV1jInTzhAc/SBX9zJ7YkCRfoBJV7W
	 CBh4Qq/KDD/+TlggfwLsFrLjjQJNy361KzTIeRlKuKxa+SbqACqeOr2aKNCUyGObL/DDa
	 K/3CUM4UudBm77ME03HazmtQwSdFeBbbg8UMNMBhfqQap9GAEf/XV7PuffAw6DNw5aTGJ
	 tNahHbjrDJyEan73baatfhcAp4pP2Zrm+0v8I8J83FJmi5fB6Gv4XDYgAcmMmJvz+FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jwIrXB/t4DcdOGkAdUgh188h2bNavCoVl3yS4GJ6kU=;
	b=bdMad0FrEQguzE0xL5nYeIFy4BKeUdqPaQWezYs8mhCpUYpL2/tUAWCBDUpfCw718WeX
	 7LTnM/v7KmUewMZOWGFsv6VXPQdrf1PbYcM4C0Wq2/8X0ZpXlOK+VHOYPhyGqo5k3gTWa
	 5U3NWCGyrQ1YtL5kTMQ+AHLyx6NcmtLbjT79upE5Eva+f3W4ADSAM8WAgyNfEIO2nyePE
	 TRfqF2eMI0N3ctjUopM0j7sOSqE7w0RkTcTMrRrP+oT8xvbb9CQmITLjhSqmI3iIdNvh+
	 m45wQ937ynNklnodVDW/BI5uc2FXb8ZMtkR5fTdFI7iSLlLHvDJQRCQbO5OdO3uydzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvxvwAMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FD6606A31A;
	Wed, 28 Oct 2026 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvxvwAMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75CB1F01828;
	Wed, 28 Oct 2026 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208363;
	bh=9jwIrXB/t4DcdOGkAdUgh188h2bNavCoVl3yS4GJ6kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvxvwAMlTDS9hqJvNh/xN1qdSrWiOv2EV8PhT1ezK1JAJuELPViUP/o9VtzQdMtZv
	 sckOwyHWn6jgrpM5GdIgEwX6ZPuHR6qJ4Sbxf+n71OYFMIURrA66ozlet6gsD0VFqu
	 Vg75JvXUgcEp9RFm+a+fBaq5Lw7mngTaMyjD9Ons=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/516] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Wed, 28 Oct 2026 17:54:03 +0100
Message-ID: <20261028170005.678494504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 505753ec2594c6af09a601f0dd60be7d840c1d2d ]

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
[ adjusted context due to missing qla_free_buf_pool() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 51817a8da8442..e56347f76e9fb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9364,9 +9364,26 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 {
 	int ret = QLA_FUNCTION_FAILED;
 	struct qla_hw_data *ha = qpair->hw;
+	struct rsp_que *rsp = qpair->rsp;
 
 	qpair->delete_in_progress = 1;
 
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
-- 
2.53.0



