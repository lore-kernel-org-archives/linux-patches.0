Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0030FC0F;
	Mon, 27 Oct 2025 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590498; cv=none; b=ZRn9DT9qNkASeA/KFnh2wzCtx6a8K3mFs9vgs0LBUd2JdQ73iWqGUAVFk4ZEQlT53oi0PkTIjjHdobaKOh2eLW727KYpyJcSWAvekZqlOIAGuNHmdcSrrv97qK5BHEH8UlAfxMZGvrZTrTKHY9EOTNOmufQMVJn+d8GwlH8/E7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590498; c=relaxed/simple;
	bh=e4nTp3USOQHomT52tXqRub/ofrJJemGMAYS6hplYSuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCCrmwWiGm9eqhUzxEDGiMxBwO0O7axEIxRKPK/tsrQX3LlsHzg2SceGkcJtjeHottfYruxzWC04S0+eqSZOystIaeaAWvxuhHQefb3y3iJQcWj8YEPMaEfpZ47N8PR/gayDSejCljLNiX5oQ9k/fzIlZF2IPTnU/RjKhE/Cf1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7AE72yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7AE72yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2639BC4CEF1;
	Mon, 27 Oct 2025 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590498;
	bh=e4nTp3USOQHomT52tXqRub/ofrJJemGMAYS6hplYSuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7AE72ytCbPCi1q6cD5RyNPdCFWWHBc7+nF8VteCszoxrRDJvcv6+ZjS9+rfM9qTo
	 rj+iyBre11G1ufn+7RvmfDNn/hlHAcv1jh6wHN7wKSb3DCuZ8xtGxPso/BIgpmmJeg
	 iN4s4cfJHRVJz3Cig8s9lUz//oVvNvYEwqly9SYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/224] RDMA/siw: Always report immediate post SQ errors
Date: Mon, 27 Oct 2025 19:33:32 +0100
Message-ID: <20251027183510.772293643@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 236f9efaa75ce..b5a845985ba4c 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -779,7 +779,7 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	struct siw_wqe *wqe = tx_wqe(qp);
 
 	unsigned long flags;
-	int rv = 0;
+	int rv = 0, imm_err = 0;
 
 	if (wr && !qp->kernel_verbs) {
 		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
@@ -965,9 +965,17 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
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
@@ -992,15 +1000,10 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 
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



