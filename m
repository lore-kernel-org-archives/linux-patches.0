Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46D282D98;
	Mon,  6 Jan 2025 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177367; cv=none; b=IssLzWlRVPdNj0CLbCuZo3+86LkaP0WAvcoqGyKAPWjCEWlBe/YYYTiNAbCb6r+ycKIC/3Va3pBmvvDV1CNY9Y0sbx0Q1DWmC1VLVBVgm3HdSbfSxNXisbfrenAUeKqhTgMOAWhTJ3YLs4y23gd1M4npmFj38TE7qRLyeILrJcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177367; c=relaxed/simple;
	bh=3G0T8udXNz47pG1AanLYMgOUHA+AsLx9O/tG6MOliJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+52En6epG13ytOxF9scJqD0y32x5ft7um13C4NDRKUVikHK7fvxDjJInDbttiThl8gYUpLzbGGd52xBJGbs2s2UQkWJZcuWR5B8fcrDxJ+FCHq3ZNumq7nq3AclGXcQeHAABHFbs3DGSlb1FuFJTAKkdhuGEfmwJGNG9Ip1jjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JepwRjql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JepwRjql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487FFC4CED2;
	Mon,  6 Jan 2025 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177367;
	bh=3G0T8udXNz47pG1AanLYMgOUHA+AsLx9O/tG6MOliJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JepwRjqlH6dvOcBDPKzi9VimVCSVwy4R/NI1za20i+M2alBBVR6opLKk3ER4WwUnk
	 RYyCteI1ArNZ51QN4hB6vqOeuczL/yBL2DR+rMrWKTupIWci4yfIs8qPq68gA++bee
	 v6LWiduK2vPHJBIe/nKQcQ4sZaAiCUJpmw+4J2VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/222] RDMA/bnxt_re: Fix the locking while accessing the QP table
Date: Mon,  6 Jan 2025 16:15:45 +0100
Message-ID: <20250106151156.104943600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1355061d698d..871a49315c88 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1161,9 +1161,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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



