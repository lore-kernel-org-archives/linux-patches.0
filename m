Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210738;
	b=IRLR/rclUpaWQ38yI8lxFWBoj5HkM8jUuoTCYAIuKlLc7SI6JvamGAV9XcOObMsrpoKM
	 vY/cq+MwyMdz4V+CTe6uXQXDLLXYSuJPhreDxEDP9+O4SWRGeCptlKS//g5WJVIr3E0PV
	 YGy5OVEB0HTPTDauucT507gf+eD6IYZ/mVqEJ7FK0YS2LQBRAZ+jek3f638HN/QTElt1y
	 WdaW3W1XrUI6OaIa6TR7ifVImXTA/LHh5Z+VKxYVzxXfsZkJ3zyKkzV0msi1neMbDXhDw
	 HQjrkgZNgDuvKXZY/khgKlMBrvFu3AZ/Estue0xXCRcJuok16dy++vQo9Thrs/duAFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ph1IkWaa6H+LtBgrmYMnTdVHzaHxiULeob7wuG/eMeo=;
	b=SXnf+ErAOlIkG8W4H1hBCB5ZGls9xSb96zadWVpXOMb8LAFRMZZ24tuMR61KrF9kwgfO
	 fCX/ecB2FNzrkkqaHdJc9uLPmeCPZ9lxlahLXOWfy6BmJaa0u5b/DQz/cTHuhyHpk2Ly9
	 hiFJLP1qhMU8yYImGzRaLUCoNgvhi4a6hy0Sh8YF+xBONJ2gZa9nIRmKA0/yRxjSWTT5i
	 cFCBECJVVkYec+SJ3HqIdX7XTg7Xhx7yWcgXfXgcesSsSwq9lGQf2/HCJwBGp2wfOvD8U
	 OZ0gQmzu1hH8AfQ8/gLU68SLhCxCjeHeOgL436/g0PHl8F4cuaoUVbnRVRcOSiV4LMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xc37V4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB17606A31A;
	Wed, 28 Oct 2026 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xc37V4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7061F01825;
	Wed, 28 Oct 2026 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210737;
	bh=Ph1IkWaa6H+LtBgrmYMnTdVHzaHxiULeob7wuG/eMeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1xc37V4iRieImh0PYGOvlz75O59r8wE6n/uTDMaioXqDDreKNE5/Y+Fy0zQh3nNU
	 y52ullEvY48hPkYnqRQPN5/0+d/NW7pnmV2flNcb6CLBTf3R9Ha8UL6+O1Bed2R7qu
	 JtTiaR93Ua65rjLT2V85uzg2nK9i5o1eyWgWe/ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/571] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Wed, 28 Oct 2026 17:53:54 +0100
Message-ID: <20261028170010.090389506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index afde7a71474f0..73aec10e2f22f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9938,9 +9938,26 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
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



