Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98831A47;
	Mon, 28 Oct 2024 06:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097920; cv=none; b=jugCQ/ojARMbixza9wJLMGzrfm9VBU+GMRjoD5wrRB0jlyv5uM1yflQXuR+lib9cGvujUKbcIaU4FHPTS0rONmAD2c2g9Jy6NSp/rQXZaIDN2HXw2/FDJLhv/5RNfs07qPOnnrZwpoeRMCD1MMEw6kYxQjImj5ZXK/Kl5JzkLRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097920; c=relaxed/simple;
	bh=uTXQEdgCM9lwq1HCXTp4rk1LB7Z3hh8AmGPc9l6RZ0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRK5s8HQ/nLFh40bAfalTg9SjcFsdPHKVyq/5IqiuUnk3/RF4DvxLKUCN6v6miHvaas8OHhcBfnmfxGxah6RWWZFZjw/RY+3jWa0Kyx5is5rjEW+t4y9/bTH1ThXuQru3TF4ItfUSTQTeMOVHy+J6sgHyUUcdOHPdhcK9h1A/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYGerZH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYGerZH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3840BC4CEC3;
	Mon, 28 Oct 2024 06:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097920;
	bh=uTXQEdgCM9lwq1HCXTp4rk1LB7Z3hh8AmGPc9l6RZ0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYGerZH2uVKGUSAAHlPHnh4SuW2wzmQFcX986SlTNxCh7+gZSE0SI1XMuu3xSuAnn
	 uf81EvTVrd93z6QG7vG0sw5PdxQHIrQkIh2lFDL5yfWJnZk+yawIWr7IhBWaMmxbIG
	 MxMgLHZY72JSPZffMGnVgD6q5hoDAFAoBKE85nCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 206/208] RDMA/bnxt_re: Fix unconditional fence for newer adapters
Date: Mon, 28 Oct 2024 07:26:26 +0100
Message-ID: <20241028062311.718598259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

commit 8eaca6b5997bd8fd7039f2693e4ecf112823c816 upstream.

Older adapters required an unconditional fence for
non-wire memory operations. Newer adapters doesn't require
this and therefore, disabling the unconditional fence.

Fixes: 1801d87b3598 ("RDMA/bnxt_re: Support new 5760X P7 devices")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-4-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2563,11 +2563,6 @@ static int bnxt_re_build_inv_wqe(const s
 	wqe->type = BNXT_QPLIB_SWQE_TYPE_LOCAL_INV;
 	wqe->local_inv.inv_l_key = wr->ex.invalidate_rkey;
 
-	/* Need unconditional fence for local invalidate
-	 * opcode to work as expected.
-	 */
-	wqe->flags |= BNXT_QPLIB_SWQE_FLAGS_UC_FENCE;
-
 	if (wr->send_flags & IB_SEND_SIGNALED)
 		wqe->flags |= BNXT_QPLIB_SWQE_FLAGS_SIGNAL_COMP;
 	if (wr->send_flags & IB_SEND_SOLICITED)
@@ -2590,12 +2585,6 @@ static int bnxt_re_build_reg_wqe(const s
 	wqe->frmr.levels = qplib_frpl->hwq.level;
 	wqe->type = BNXT_QPLIB_SWQE_TYPE_REG_MR;
 
-	/* Need unconditional fence for reg_mr
-	 * opcode to function as expected.
-	 */
-
-	wqe->flags |= BNXT_QPLIB_SWQE_FLAGS_UC_FENCE;
-
 	if (wr->wr.send_flags & IB_SEND_SIGNALED)
 		wqe->flags |= BNXT_QPLIB_SWQE_FLAGS_SIGNAL_COMP;
 
@@ -2726,6 +2715,18 @@ bad:
 	return rc;
 }
 
+static void bnxt_re_legacy_set_uc_fence(struct bnxt_qplib_swqe *wqe)
+{
+	/* Need unconditional fence for non-wire memory opcode
+	 * to work as expected.
+	 */
+	if (wqe->type == BNXT_QPLIB_SWQE_TYPE_LOCAL_INV ||
+	    wqe->type == BNXT_QPLIB_SWQE_TYPE_FAST_REG_MR ||
+	    wqe->type == BNXT_QPLIB_SWQE_TYPE_REG_MR ||
+	    wqe->type == BNXT_QPLIB_SWQE_TYPE_BIND_MW)
+		wqe->flags |= BNXT_QPLIB_SWQE_FLAGS_UC_FENCE;
+}
+
 int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr)
 {
@@ -2805,8 +2806,11 @@ int bnxt_re_post_send(struct ib_qp *ib_q
 			rc = -EINVAL;
 			goto bad;
 		}
-		if (!rc)
+		if (!rc) {
+			if (!bnxt_qplib_is_chip_gen_p5_p7(qp->rdev->chip_ctx))
+				bnxt_re_legacy_set_uc_fence(&wqe);
 			rc = bnxt_qplib_post_send(&qp->qplib_qp, &wqe);
+		}
 bad:
 		if (rc) {
 			ibdev_err(&qp->rdev->ibdev,


