Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1F200A3;
	Mon,  6 Jan 2025 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176740; cv=none; b=cRDWMuAisUSB6fdEee2Shn1aU8ATTGy2Zyvdhi4jGcBHiV1/uqaSIe1Ma2WHyxwdUcFSFvcnH59/GRiCWh/GNwsX2J33k/EQS2DVyAZhONf7BJP/ktNZ68S/FJEcWXJ4XedLPAz/Z4uSqqwvOp7i03qIyyScP+bCo3FVFrr2s8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176740; c=relaxed/simple;
	bh=x+yQuJvfmYTA4774P2y8BMLeQEjX5HezsxA3ns+nHyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwNcmy9yDhwpfpOhWi+RSeJmNRJ+S9qpjbQ/T7c+8ZiprC0N337YrPBPMB+vRkxtor42NjicpDEtiWvLEr7YLVAW5z+txQqSxGJN+9/PDTfFawi9M8p98VrJNHOUhXENb6gpA7HgETxtzVaQH0wCw29nb77V+6dBHiRk4cS2+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHEOuUwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHEOuUwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF78C4CED2;
	Mon,  6 Jan 2025 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176739;
	bh=x+yQuJvfmYTA4774P2y8BMLeQEjX5HezsxA3ns+nHyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHEOuUwq4dpiDk4jIVmpjgIsg9yQZdCiv7TiQj529Y5TzY2p+D5dSUs9mVH1OXITa
	 YELdkqx+7jgo2il3dDyXdhRPzsCL8LDxJfTsjBv+b4SpzvA3BPd4CMIKqcxInw8Clu
	 XvE59bkeSjlAKKmUDhRhX5/8CJJPY1fhgirW6jkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/81] RDMA/bnxt_re: Fix the locking while accessing the QP table
Date: Mon,  6 Jan 2025 16:15:48 +0100
Message-ID: <20250106151130.050723086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7bd7ac8d52e6..23f9a48828dc 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1149,9 +1149,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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



