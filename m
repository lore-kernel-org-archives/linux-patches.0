Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212110;
	b=CTAZju0xcjFdV9ieyzNI8lJzHBWU0yxahMT4zhNnp56/jumMqEHzAQrQ8EaQGW3mSLYB
	 pGNdiSfeCKdh1+1tHTfoVFVjcSxLgwfDD0iM9lpIGciadtewzRIN+n8ecBwha5w4PCyTq
	 5WuKsXRXNXuCLhTj7x9aOoP0I6eEPKqqfq9b/qQ/2vEdTOoLh+camC5G7R/brXYpWAk3I
	 BDvmdibp3rtZxl8YbzNOR/Bejl5WdLBvklSJDm1BSGqR2fA7EA00qaqNgQRR2zLVbTRTF
	 NU2JYYxR3ExbM283pduIvxmvMhh4Vs02AIJESHN7U4GmdO8dJJ4DcMPvYagJ7Cz1HhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zr2wNX318D5td3GNQApa4EuT3+rv/fDXJw6mBI3o09k=;
	b=caWBrbC3sAnr93RUoV4cVr78PAIj97UHOHkoN45nJR26W/H37ES6vXFaODuIDQakE95k
	 8iik3Zfs0t9329WGKxiGmk7rNhNPshzQ53bTS2rJDF5/1XW5UdQw6BZsrAnARiZ1EO25q
	 ED8kBpGL2mCT/9QxCIDcyy+L0j1Pcc8YOdnF2KfhbTdSAHKZOKWAhjcJ7g9WmdH8x22CY
	 0WHf2dBnoamxWP+5fv8F6oi1hN535I5LPuhlX14MDw5U8QcvAFKpB1lFC+3rlowgGpCh2
	 8hi9J365PkT3MN1Bmze+Z9g0iDfob+sLc9J7IlIR+z2gVujJec7ciooWZAq8R6ivqRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTOMFHPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF51606A31A;
	Wed, 28 Oct 2026 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTOMFHPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348981F01825;
	Wed, 28 Oct 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212109;
	bh=Zr2wNX318D5td3GNQApa4EuT3+rv/fDXJw6mBI3o09k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTOMFHPkNshtDuRei8PuvtGWAkSC2py4iArQxpc/xiRMXOHHqwBFgB1TCp2MzZHdn
	 QbTq1UWvBiTLUUMIBzFE68Uz0m6PXeifPo3ivLkTyeE2sxgWfXMChZ2ymI3JAdAZ2F
	 iBPK/pWI4EjpkP6+cDlxJ54ZeZN4r/eZCazyQvaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0041/1887] scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
Date: Wed, 28 Oct 2026 17:35:37 +0100
Message-ID: <20261028170500.158685808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 19788a55cab61d78e33e0914a5a31d27843e8a4a ]

The response queue MSI-X handler qla2xxx_msix_rsp_q() schedules
qla_do_work() via queue_work(ha->wq, &qpair->q_work). qla_do_work()
dereferences the qpair (vha, rsp) and takes qpair->qp_lock.

During teardown, qla2xxx_delete_qpair() deletes the response queue, which
calls free_irq() in qla25xx_free_rsp_que(), and then frees the queue and
the qpair. free_irq() waits for running hardirq handlers but does not
cancel work already placed on ha->wq. A still-pending q_work then runs
qla_do_work() against the freed qpair and response queue, causing a
use-after-free. This is especially likely during full adapter teardown,
where destroy_workqueue(ha->wq) forces pending work to run after the queue
pairs have been freed.

Flush the work item with cancel_work_sync() in qla25xx_free_rsp_que()
after free_irq() has released the interrupt (so no new work can be
queued) and before the response queue and qpair memory are freed (so the
flushed handler still sees valid memory). Guard on rsp->qpair and ha->wq
to match the INIT_WORK() condition and avoid operating on an
uninitialized work_struct.

Fixes: 68ca949cdb04 ("[SCSI] qla2xxx: Add CPU affinity support.")
Reported-by: Sashiko <sashiko-dev@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-5-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index b25439db6867d..11434b695b037 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -615,6 +615,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->handle = NULL;
 	}
 
+	/* Flush any queued response work before freeing the queue/qpair. */
+	if (rsp->qpair && ha->wq)
+		cancel_work_sync(&rsp->qpair->q_work);
+
 	if (rsp->ring)
 		dma_free_coherent(&ha->pdev->dev,
 				  (rsp->length + 1) * rsp_entry_size,
-- 
2.53.0



