Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A31DE89E;
	Mon,  6 Jan 2025 15:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178394; cv=none; b=h7LYhbQSNhd+UT+2hrKWg1u0RrNowPwutVilBS9eqaCNkhpoOPnaxImuhByb/jS8jVH/PxhLnjducgobxkrQCjJ6wkYTv/gIWRQMsh/0uuZCzZXHfXsJ/f+0HuuGwbPEVjrj/AGn3qTYsNocIq2B2771oajftNy2nwbMQmMmPow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178394; c=relaxed/simple;
	bh=jpa4puM+FzTpMEA3eSPzWCGlLXQguurZ5wMhqrz89hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riM9O+OuJ9ka5ZGob5EZbD1fFkLYFkYu1MTGojRR1MAG0bo74LPOvgunlM5UWX+8DN0kNsJsaYzlNN+3NbLqfYoXzxN+PB4+TofBN3NVDtasWOzXtKXXIXPYxbolXRXflmT3csmsg9I8rRx2Dj9y2MYIU8lwAiVmUcrIFCohuoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABsyhdl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABsyhdl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D3C4CED2;
	Mon,  6 Jan 2025 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178394;
	bh=jpa4puM+FzTpMEA3eSPzWCGlLXQguurZ5wMhqrz89hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABsyhdl7iITpD7gxEpa7+PFbxyT9SzNnGCNbopPbCFzf/oVjnCXMiRgTerRe6bB2C
	 70smVKlYWUTp9iEU3uxgl+EqvGnuwlmCZgevG84YG+x9kurDKexkt9D1TNwnJ/t9Qs
	 1+llviAzQRnLY7ksNmJnJCT7W1UDTJiemMDzdLkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/138] RDMA/bnxt_re: Fix the locking while accessing the QP table
Date: Mon,  6 Jan 2025 16:17:08 +0100
Message-ID: <20250106151137.168827095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f79371a1386..4ed78d25b6e9 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1126,9 +1126,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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



