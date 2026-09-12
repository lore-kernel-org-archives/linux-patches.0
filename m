Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFF4309EE2;
	Sat, 12 Sep 2026 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241951; cv=none; b=Jkkxps7zcbZiBAV0SJHP7bBewkspu7Z1Q2Er0omKKQq2BfUMnX1i9odFAF6Gx3XOI860Ngwr3fVGboDjxCyIOnsl2x/cBq6BCkE6KoUAEve3WCePRzYyuVs42jlKvlImb3pEnZWqF8oqxyRaYBUC1uB91ia6CKsvRZPlHaP3hAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241951; c=relaxed/simple;
	bh=iOc2tbYKp14UqnaDfEurWQ6H96FWQvt/6k+lxbQYVnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiGwJkziiplKkdBTvDDM5X0rwstH4xyOsHtdT2SxJZJcM2WU3MOuRp45ygu1dlgbDD4zpw2Wx3uRUagJg2b1EfD02tjG2DaPhI+MPO5pv9MIyHeCrhGdrTgHE190D3yh7srfJCzLSBIbLfCZSw/ZsYieyIwAdT3WVHQjt0cXadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UoRoEAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UoRoEAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198591F000FF;
	Sat, 12 Sep 2026 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241950;
	bh=Q9vyLI+JO+bSOHNm0rXdGQpp+Onrh//DZy/6Zn27s/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UoRoEAQWjNMG/fvfgcJsU+zg20w/gVeioi+wjMwmDJIEzD/9m9KUzYop3af4dpuf
	 Hst2uk69YyZET0RmaqOYvFUCSe4IZIugavX40EvNoD6mPwW7xGanWPZxvN14qHLjpb
	 yagAar+PKSEA462pLsd3IfubTfHRwB3b01OxLQig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Majd Dibbiny <majd@nvidia.com>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/798] RDMA/rxe: Missing unlock on error in get_srq_wqe()
Date: Sat, 12 Sep 2026 08:57:06 +0200
Message-ID: <20260912065521.613494300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 36941dfe0e8c3e2da7851b9648fd74bd3a3e78ce ]

This error path needs to unlock before returning.

Fixes: ec0fa2445c18 ("RDMA/rxe: Fix over copying in get_srq_wqe")
Link: https://lore.kernel.org/r/YNXUCmnPsSkPyhkm@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Majd Dibbiny <majd@nvidia.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: Clean cherry-pick. Needed as a prerequisiste for
 "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 38e6535196849..207889332b963 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -307,6 +307,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 
 	/* don't trust user space data */
 	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+		spin_unlock_bh(&srq->rq.consumer_lock);
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-- 
2.53.0



