Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208169;
	b=wfuJj50ew3T8SADYoCelcy7r1yoG2x8JJR4UdbzrsSUckO3hKlj4SyXfwu0I6irz19Vc
	 Bo1peE6B0vQwIsCcvUERFzhGIPhRCDUmKn4ugz54t8jQn9TGTYCFMkzuCsIDIlI+nlCUd
	 DLDqhGFRjmjFO+yxTlCjDl1KZc/bTrBBHrbD2gI1wYtdLvVfXUwoXi+YkVoS9O9UhSqyA
	 qGZCru6new4EMBh88fN1M06NOVDDSVnMTXDElqLpjP5aK4zKQzdwFAq7pU51roYCnmZe1
	 bsOFrOint7mt4mDGVuQgCsQgT4tPNEtQY15BtyRM9BmIVqxywfoZGGRR2kOFiKfTxgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lw+wIEVQr65cEHrPEazEfwOoph7S+Dyt8wtevONQ3YY=;
	b=HCJ5uYbP5mdf8X4Sh3HSV7tveBvBmQR4sMYmldp7YG54ybM34PX8HFi/PU0QBXdvM0kf
	 oGbl/x1EEg8Q9LJnT1G0quTAVTljHoHVVcACWZHADzkZD68nJ4NAdanTm9mG0mkyTB8oU
	 knzzx08/poIZXZuOeUs/kBCyu6v4Wet4kGTNxIbfgB3SIds3SSJ658SG+I3QkpwjfEj9H
	 LJdV9XzBKJHE48hMdwL00HG+zBgN8EVjmWqEUOCMkyvKrh0zPxaxKxxsxNa4XUAJP48J7
	 l2Xjf8XXzSALcBbHKPFCwI99JC6vL7D6eSdN5dlGYq0/2vO6QmttVg5rKX04HEdBxhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXRvJJxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951D2606A31C;
	Wed, 28 Oct 2026 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXRvJJxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E61F01825;
	Wed, 28 Oct 2026 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208169;
	bh=lw+wIEVQr65cEHrPEazEfwOoph7S+Dyt8wtevONQ3YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXRvJJxTEVPNymMFIusaXj9nmG3eyFboVYmiFBe4sLXTp/6v7byBfcGHXa2/8ARUP
	 0Ahk8pEBKhhIAAffkbQkMu3sxKGUiPcHLx0fA8lkWUiepvH8VG/ic6NaFySoOTNjKy
	 sU9yF47zON+Ef7AkTb5d3440YzvJ9+Fkq3Lb9ssc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/516] scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
Date: Wed, 28 Oct 2026 17:52:57 +0100
Message-ID: <20261028170004.124127925@linuxfoundation.org>
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
index 4e2d6e0cfb9b0..bb44db0a66756 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -599,6 +599,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
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



