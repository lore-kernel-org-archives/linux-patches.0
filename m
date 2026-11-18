Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033306;
	b=OAtpzR/CHtj8zsxgUgB2WWxnHjFUDZot3yGDNyZi/sHBbsziNT+pm02Or2zfVPMje6RU
	 FBFimhnD5vKVbZamaOTQJtfHdSrhmPMGLAnz0a30uk58QBa2vEUTLFDeBJQpSu1NvC1Qj
	 mDnuo9r2vpWa6ltLIydR95rFj6hLqyG0+kctID8ewdBiron4dRSbuDxFPhyHeg0gbvuW1
	 krypfE4B0jeXtQgB9fMKs8qjbf31hmXjIQDiPKnMmxoA3qwWLRzRP5l5uHrPPo3L5lhTF
	 kau/u6OFA6H4ksDAPctX6wgibMR5bzAsSIP27aj/Qs8Zp0ShAuMg+eG+EEHRzGLlSvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3kbQKeZJgy72aeZ5aj/YBAb/rhzqZzNNmvmt6gLUcjs=;
	b=tTN9x2ycv08WZtNiinhWh5XryvwJ9bLVVPRSjeFSrWRE4z6SGEXmewt2SHOklZlzYcNj
	 +HTS49i0hlWAqIodtmafERSMNvkOXM6UT+t1kMLyUHQ1D2CECQcHqf/urffEDwEVIdLJc
	 voV3mJiGTbh5/XRaser+RGOGreiq/Ccow7UBLa3M4F5JVngpZCj4r/tF7wC2x/mb+eHS1
	 F7nG56UtmKU89O2fMh8iQ1qsuzmvabEeNHYtgpnzZ3Q0e78L/T3Oa6aV7DPqDryncIeY6
	 0NeTbnGVPKxU3AN99xyrkKZa1cXOHWPaOUew4HWD8A5QJcUbrcTGz+N6B3j8MUO4oFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AkV/Wglb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B17606A31C;
	Wed, 18 Nov 2026 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkV/Wglb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9EC1F000C4;
	Wed, 18 Nov 2026 20:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033306;
	bh=3kbQKeZJgy72aeZ5aj/YBAb/rhzqZzNNmvmt6gLUcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkV/Wglb4smaoJJ4/AC/sBeuMz6msdgoQPfIHsJp1OWCLU7ErSt2GPAr+0LjZwoZg
	 SnihWDyV77CxrRRDAeryishDB5Lgex/d4a3YZiCf+SNr4lDp8ADoDe5nrojXBDy4Dy
	 jWKOXKFWupKiYmPq/IcBuKiYNiUW09vs3By3oe0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1721/1756] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Wed, 18 Nov 2026 16:04:08 +0100
Message-ID: <20261118150118.100825743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]

Locked QP and CQ lookups from EQ interrupts can deadlock with
create-path XArray updates. If an interrupt arrives while the create
path holds the plain xa_lock, the lookup spins forever trying to
acquire the same lock.

Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
including the GSI QP store and error paths. Initialize both arrays with
XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.

[ The GSI QP create path is not present in 6.6.y, so omit that hunk. ]

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_main.c  |  4 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 37723054f0645..94b7f3c4bb9c7 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -578,8 +578,8 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	INIT_LIST_HEAD(&dev->cep_list);
 
 	spin_lock_init(&dev->lock);
-	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
 	dev->next_alloc_cqn = 1;
 	dev->next_alloc_qpn = 1;
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 057efff532b4f..75880864eba48 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -982,9 +982,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	kref_init(&qp->ref);
 	init_completion(&qp->safe_free);
 
-	ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
-			      XA_LIMIT(1, dev->attrs.max_qp - 1),
-			      &dev->next_alloc_qpn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
+				  XA_LIMIT(1, dev->attrs.max_qp - 1),
+				  &dev->next_alloc_qpn, GFP_KERNEL);
 	if (ret < 0) {
 		ret = -ENOMEM;
 		goto err_out;
@@ -1045,7 +1045,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	else
 		free_kernel_qp(qp);
 err_out_xa:
-	xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
 err_out:
 	return ret;
 }
@@ -1945,9 +1945,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 
-	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
-			      XA_LIMIT(1, dev->attrs.max_cq - 1),
-			      &dev->next_alloc_cqn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
+				  XA_LIMIT(1, dev->attrs.max_cq - 1),
+				  &dev->next_alloc_cqn, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -1995,7 +1995,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 err_out_xa:
-	xa_erase(&dev->cq_xa, cq->cqn);
+	xa_erase_irq(&dev->cq_xa, cq->cqn);
 
 	return ret;
 }
-- 
2.53.0



