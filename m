Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210432;
	b=HvCnYPYnrbv646e9qQWdClSLk+DV7hBztPVeogK7QVhw0UUh2n5LbkaH7D5zlDNnwhcb
	 MybUUQ85yrw7ssdsh0U54m/gQp47TNvQq0GsbpWRuw/yj6lxM9K6mGIn5ntFRopi93FdW
	 z/u6Vds781hbbtAzv3A2W5hsA2k7e2WKaDueiLKEUyLjLygOuDSUN+y78T5VSB58acD27
	 xzvE06S81+FB3JHoCE1ebCdb2ZY8PzuFU55H6+CsueB75XJykFk0PY3gnfETvZ94PAElJ
	 F0khGGLONBjgYVUk05BIFSA1v6ETUpK6+a0erv2fGwnJGm0y287KxoO58XDZRLhQ1Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8V6ph9gGC2vKITdwd39Qs3MAuSmS5YGhsTawWi4R29U=;
	b=SL9Wmk2GzdMK34DpzTiWn862J37BtwXKEAIZJFmqivaxwsxf5+WxwDdxztomMssJmm4C
	 yXQjPZVGUYGdBJ0u7d1qFOFeQL2dezg4vlPNA7cQ80uXJ5OlrNPu9eCNhA1WlKvXwQlgw
	 BZvHRXanCi5zAJ+Cx3/DDFSNNchj6Haaais6DT0LDY7A0V8m+3ZbWoo/eVUNJsuI6PIAu
	 /92o/talLaKLKZLQFeK1aKiTS6eiOIJh0s/orZkclfnzfDvmv/ezNI2Cc7QNllBnvjnIL
	 H/CRVYJqnXGaPp4/xn33GLGBoGFD3Kz/KvP3WJxNsg395dvBo5XZDH1vd8rora+O5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r27oRaB9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463FE606A31A;
	Wed, 28 Oct 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r27oRaB9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964AB1F01825;
	Wed, 28 Oct 2026 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210432;
	bh=8V6ph9gGC2vKITdwd39Qs3MAuSmS5YGhsTawWi4R29U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r27oRaB9SbhZqdfRlw/Vw/HCXw2ZfFkPmsudISqrqcAbdcReQvdK1CbT2phDzwd/3
	 E2CBmtcwbbHiqT4X5wm06lw6gAMLZMhOZ9hytAAvMSgy0K7tNKRxBXT4O7CrqSIG3v
	 9A3vVv/WSt+LAsSmlUeZSQz/lmLgsYu3x66WGPdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/571] scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
Date: Wed, 28 Oct 2026 17:52:51 +0100
Message-ID: <20261028170008.596417635@linuxfoundation.org>
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
index 4d2ce7a3de03d..68b1e5129d6c8 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -616,6 +616,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
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



