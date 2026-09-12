Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC6422E08;
	Sat, 12 Sep 2026 10:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208125; cv=none; b=ZcXtJMdoqdfkb7iJ00VCyFgEWo7O98Hty+0hsllLTBDxzOKvfpHauwstNY09cAXkB53jn8xq1+S1J4Y73nmrvRG0vQLJQ5qFoAJp2nu4OH8iniwZnLbhCSzWPBI8BCh2auQZts/arZGATbhClIBCj+EaOIDq72t0NfPC0sn1Mb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208125; c=relaxed/simple;
	bh=BLeHgtVRXoBNcbp73kVn+QN2L7GekQNvfl9gjfBIDHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNRARIJx6XH7gVduxqVBXTwHXv8qs/G9CM794OAxLOaeFZ0XToeUuTeKQhd7sAh+Yy4NcGVUbuOe/5XNJ1Y/YKf7A+5jYTXlrODRpMjjtEYrBnxPW581ATPyYrA3Fp8TjehlZlFrzA8WhIAq18LrPOXbwUM/Ssv11yS/KOFG8u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+oBpJ1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+oBpJ1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7AD1F000FF;
	Sat, 12 Sep 2026 10:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208124;
	bh=0NlqeCBxqgu40OgUD6SNuu7W8obXLdMwuRwAN8EJ7Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+oBpJ1yaMzEDry50B6xXaO7m+2hpYzyx9SbyK447SsM3aLE6NgYIE5prR0UiISIE
	 gHrlo85eYZDLzcvAS6mN3Aki5wAWLsjjZOZgGvLU7Q/HFnGliZfNi6jrkTjC/enEpG
	 XI4diB9uU9qqEHwgmLWd7kvs2RB15Vwag4eHnmYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0511/1518] RDMA/mana_ib: drain QP references after partial table insertion
Date: Sat, 12 Sep 2026 08:44:40 +0200
Message-ID: <20260912065635.004938933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index f00bf3b015e73..285b3702198b7 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -459,6 +459,12 @@ static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp
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
@@ -477,6 +483,7 @@ static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *q
 
 remove_sq:
 	xa_erase_irq(&mdev->qp_table_wq, qids);
+	mana_table_drain_qp_ref(qp);
 	return err;
 }
 
@@ -524,8 +531,7 @@ static void mana_table_remove_qp(struct mana_ib_dev *mdev,
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



