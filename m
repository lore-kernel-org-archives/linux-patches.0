Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A629B799;
	Sat, 12 Sep 2026 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199410; cv=none; b=VQvCwpCfSeufsb2CAmmq9mZ6+SpiTQsOQx74vaWvpHOs26iFBuG+jqSMoO5/4kTTXhLayQvIpdU9a3H6ZF5m1Ilnsoe1lPsGSbXdMsgww/dX9La/d+ieXIiYOuSMwCUaoAebkx8EwAG4D9vDK7GWO2DqYpkujKHoadGt8cbH2EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199410; c=relaxed/simple;
	bh=UHuy1fjHMkw389ETq/2ve5a7C+M4CZq0XEcqDks8ma0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rowMDjiiqqPPcsd3e0ES+qCqVtsAR2Pj94CV86lRYT55gB0ENPWu7dk+g/3u7BM0fRXdPq1X01XEbOkZcMZJ/slRiN1gb+MFHRhmlCvYfzsXvLcRkJePGRWEIwjkMQzNE4/AhRFFH+PbJ7GjwRxdx40ii9UOZ/+NwukgmEQiIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nm39TLnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nm39TLnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF541F000FF;
	Sat, 12 Sep 2026 07:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199409;
	bh=sW9SXAqeJbwD9eZFwemLJx65yCq4IF9ADJwKUlODva8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nm39TLnrYv2tDHgy+o/wSiAuC1v+LNB/zZSHyfLCXWl1sUC2apyMyu6EKd2sEyl8h
	 vchMPkPfRaqbAzcaEdCVza81CWQLZlvrottD7LIRhTYZBz9D6CtEiRVnzDH7IWhQFL
	 /4OEB497cLQvkBLIX4DgwCYs5FMH/Bol54Qlt6SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0578/1815] RDMA/mana_ib: drain QP references after partial table insertion
Date: Sat, 12 Sep 2026 08:38:48 +0200
Message-ID: <20260912065702.448949855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 97f7c2262c28ebcae64fc957ee978646684a5ed9 ]

mana_table_store_ud_qp() publishes a QP at its send-queue id before
inserting the receive-queue id, dropping the XArray lock between the two
xa_insert_irq() calls. A concurrent completion handler can look up the QP
and take a transient reference. When the second insertion fails, the
rollback erased only the send-queue entry and returned, leaving both the
initial table reference and the transient reference outstanding while RDMA
core frees the QP, causing a use-after-free.

Drain the reference as normal destruction does: drop the initial reference
and wait for qp->free, releasing the QP only after every concurrent lookup
returns its reference.

Fixes: 8001e9257eca ("RDMA/mana_ib: extend mana QP table")
Link: https://patch.msgid.link/20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com
Reviewed-by: Konstantin Taranov <kotaranov@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/qp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 60926f39ab9da..389dad4ae1ff0 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -472,6 +472,12 @@ static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp
 	xa_erase_irq(&mdev->qp_table_wq, qp->ibqp.qp_num);
 }
 
+static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
+{
+	mana_put_qp_ref(qp);
+	wait_for_completion(&qp->free);
+}
+
 static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 {
 	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
@@ -490,6 +496,7 @@ static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *q
 
 remove_sq:
 	xa_erase_irq(&mdev->qp_table_wq, qids);
+	mana_table_drain_qp_ref(qp);
 	return err;
 }
 
@@ -537,8 +544,7 @@ static void mana_table_remove_qp(struct mana_ib_dev *mdev,
 			  qp->ibqp.qp_type);
 		return;
 	}
-	mana_put_qp_ref(qp);
-	wait_for_completion(&qp->free);
+	mana_table_drain_qp_ref(qp);
 }
 
 static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
-- 
2.53.0



