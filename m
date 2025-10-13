Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10E13126D6;
	Mon, 13 Oct 2025 15:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370036; cv=none; b=g/sFLmqiSf0QzRWwf0k05OitBtEd/WDq1KX16am2TIiUW3qGhAtgWaHz8zwyAHo9pRMoLw8OV9B6EmiqPZrER/pWxXgNNgT3Oi0D/NvyBPLQ/iBMDOPte5QuYbYDCBpW8PyCK8CKioTMoX4kyA/lJjq6W2W9nVvemY5EMoYBoNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370036; c=relaxed/simple;
	bh=0DieFhYgMyKItRBqncuKw3PYaHXveKwm3Ix9t0Q7m90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JALsWVaDYPYhut/jpCAb7DUKAbM+yE+p1Uf7bz1JNdO12ymcq++0PGl92GTaOMZhLS9kpprE34MqcobHAtO42F3heW62oV9JvUPbSOPZx4nDs3775+PoVdzDqkNizXTd2aJfuwrvtM3ob/xkytxCqYTzEqE6sD3lqZSNyn0WpTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO+VTX19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO+VTX19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F30C4CEE7;
	Mon, 13 Oct 2025 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370035;
	bh=0DieFhYgMyKItRBqncuKw3PYaHXveKwm3Ix9t0Q7m90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO+VTX19cCfOcFehxMIJSg490b3NIbPqnCagf7ywEwEKULguJLU66qzcIM/8DbNU2
	 hkCWk/eWwPOAkdgNSdKMUntf3tFfZVILPAJn2ixEAd+6Wx+/0TiyzLfGsqznWP6rGe
	 IZb9F6lb8r43jdIIwKG9ASmr0ZnMgQOXbHXCYsmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 448/563] RDMA/siw: Always report immediate post SQ errors
Date: Mon, 13 Oct 2025 16:45:09 +0200
Message-ID: <20251013144427.511111342@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Metzler <bernard.metzler@linux.dev>

[ Upstream commit fdd0fe94d68649322e391c5c27dd9f436b4e955e ]

In siw_post_send(), any immediate error encountered during processing of
the work request list must be reported to the caller, even if previous
work requests in that list were just accepted and added to the send queue.

Not reporting those errors confuses the caller, which would wait
indefinitely for the failing and potentially subsequently aborted work
requests completion.

This fixes a case where immediate errors were overwritten by subsequent
code in siw_post_send().

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://patch.msgid.link/r/20250923144536.103825-1-bernard.metzler@linux.dev
Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 35c3bde0d00af..efa2f097b5828 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -769,7 +769,7 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	struct siw_wqe *wqe = tx_wqe(qp);
 
 	unsigned long flags;
-	int rv = 0;
+	int rv = 0, imm_err = 0;
 
 	if (wr && !rdma_is_kernel_res(&qp->base_qp.res)) {
 		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
@@ -955,9 +955,17 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	 * Send directly if SQ processing is not in progress.
 	 * Eventual immediate errors (rv < 0) do not affect the involved
 	 * RI resources (Verbs, 8.3.1) and thus do not prevent from SQ
-	 * processing, if new work is already pending. But rv must be passed
-	 * to caller.
+	 * processing, if new work is already pending. But rv and pointer
+	 * to failed work request must be passed to caller.
 	 */
+	if (unlikely(rv < 0)) {
+		/*
+		 * Immediate error
+		 */
+		siw_dbg_qp(qp, "Immediate error %d\n", rv);
+		imm_err = rv;
+		*bad_wr = wr;
+	}
 	if (wqe->wr_status != SIW_WR_IDLE) {
 		spin_unlock_irqrestore(&qp->sq_lock, flags);
 		goto skip_direct_sending;
@@ -982,15 +990,10 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 
 	up_read(&qp->state_lock);
 
-	if (rv >= 0)
-		return 0;
-	/*
-	 * Immediate error
-	 */
-	siw_dbg_qp(qp, "error %d\n", rv);
+	if (unlikely(imm_err))
+		return imm_err;
 
-	*bad_wr = wr;
-	return rv;
+	return (rv >= 0) ? 0 : rv;
 }
 
 /*
-- 
2.51.0



