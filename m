Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3213C3D6;
	Mon,  6 Jan 2025 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178874; cv=none; b=l+LwhzXXjAQVImHKjcO7ttKqfYsntlVUajy8fuhICcTgLwQtiiDsom2PNOwcZRLJy5LKF1HvKWRov4bxmrvvRsr7vMiSQJHCzX4aFCBP9do9lDN5KQ8iGs38OzMF3AFcg22TdyBPcEu72KdRKilz++ROfMyExyvPiA1f2lFc0Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178874; c=relaxed/simple;
	bh=2K4lNlza5EKwh9h9zDmpI1UwsC+sp12qRy5jhkE5Zxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCbC4fvuckcfV0hoD+QXJSXPmwlERD373wc870548+/FitjhLciCzb8NJZStWiKBoTLRDseOcfVFAgm0Eyhn+bfUZiWOoKdkQp9AllYwRY5y5MBikZUwzmm/pphEpB+kE8ihD7SV9rn+PoKqILAKo4T8eVJhEInBsHNuxqocA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up9skVvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up9skVvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3227C4CED2;
	Mon,  6 Jan 2025 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178874;
	bh=2K4lNlza5EKwh9h9zDmpI1UwsC+sp12qRy5jhkE5Zxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up9skVvkgEq1/quG+zeS4JJCXAPadic+bP/YgKGfxBep5yCJVQvqqk0sJGbnebBao
	 Sf3gZdNoQwJORY4MLM0lO/1I5zfLjYaj0jlxiNDKz65ux7P0hqr9LOEv8ypoOG2CIG
	 +fqIj4IFyJGjjzEqm4HzY8FlE2A3rwy1bn58SkFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/168] RDMA/bnxt_re: Fix the locking while accessing the QP table
Date: Mon,  6 Jan 2025 16:17:09 +0100
Message-ID: <20250106151143.019235292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 9272cba0ded71b5a2084da3004ec7806b8cb7fd2 ]

QP table handling is synchronized with destroy QP and Async
event from the HW. The same needs to be synchronized
during create_qp also. Use the same lock in create_qp also.

Fixes: 76d3ddff7153 ("RDMA/bnxt_re: synchronize the qp-handle table array")
Fixes: f218d67ef004 ("RDMA/bnxt_re: Allow posting when QPs are in error")
Fixes: 84cf229f4001 ("RDMA/bnxt_re: Fix the qp table indexing")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-6-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index dea70db9ee97..27cf6e62422a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1144,9 +1144,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		rq->dbinfo.db = qp->dpi->dbr;
 		rq->dbinfo.max_slot = bnxt_qplib_set_rq_max_slot(rq->wqe_size);
 	}
+	spin_lock_bh(&rcfw->tbl_lock);
 	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
 	rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
 	rcfw->qp_tbl[tbl_indx].qp_handle = (void *)qp;
+	spin_unlock_bh(&rcfw->tbl_lock);
 
 	return 0;
 fail:
-- 
2.39.5



