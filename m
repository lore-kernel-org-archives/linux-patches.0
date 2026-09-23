Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD79531B0B;
	Wed, 23 Sep 2026 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172733; cv=none; b=brh+8qxV8sOUIEOwjQcCNVQjJobx1PvIw2brFTHgJTDRbP3Yaf1SOhKK8O53uc4sWCun6COc/HP6BuDtI9mxtyS8N4pMlq56ZB5e7Lt3H7nve+7motbm/x/8xfooQfbcxUbUBY3H7eb8SNJkjDVu9N9eVU4GAnAj8EpIL0av1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172733; c=relaxed/simple;
	bh=wwqcgmzOElUyh+PmZSebLpMIT+DrCjfzDLPVQf3Wsf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4xYcC6dv2Kqnx77tJacKyhsESoaY3t43Q/VBu/TobPYJ83FbNMvuA1IR/yatX/aKAi/h0aXMjJacowF5/L8C9r/Y0Y5ory6JswbIhC2h9ypb36nQDjcKFgZmzBkKlLNllhNa0H1D9f9p2perqgEt8RdBuQ99iomRPe7OYDLgKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBIzpDgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBIzpDgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2EE1F000FF;
	Wed, 23 Sep 2026 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172732;
	bh=b5xl2psrtcd5drfQj3w61OAe+7MHPKCG7z4/cYmKMpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBIzpDgj1qu1NED9/o4lwg6HP/xJSvtdZVbg8OrVwpF5oXJKPRQIx6k1E1aYArn3Q
	 cRjtUczj9jQ8w9jQ8N+Inx2HA+yHRZTniwHpGAtCeXBvSxWDVt3sCoUC6YSOzx+Zgt
	 HFCNtF06siJrTNW1hnnUOphJO/PJkhxdYlPffqbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 019/438] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Wed, 23 Sep 2026 16:00:40 +0200
Message-ID: <20260923140645.273853201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

[ Upstream commit d10e2a08799e858d3e71ea4169bcd018f216d444 ]

mr_check_range() validates that [iova, iova+length) falls within the
registered MR range using wraparound-prone arithmetic:

    if (iova < mr->ibmr.iova ||
        iova + length > mr->ibmr.iova + mr->ibmr.length)

A remote peer can craft an RDMA-Write/Read RETH so that iova + length
wraps to 0 (e.g. iova=0xfffffffffffffff8, length=8), bypassing the
check. rxe_mr_iova_to_index() then computes a huge index (int idx, only
guarded by WARN_ON) and rxe_mr_copy_xarray() dereferences
mr->page_info[huge], causing an out-of-bounds read/write and a kernel
oops that is triggerable by an unauthenticated remote peer.

Rewrite the check in overflow-safe form; the first two clauses guarantee
that the subsequent subtractions do not underflow:

    if (iova < mr->ibmr.iova ||
        length > mr->ibmr.length ||
        iova - mr->ibmr.iova > mr->ibmr.length - length)

With the fix, mr_check_range() returns -EINVAL for the crafted iova and
the responder reports REMOTE_ACCESS_ERROR instead of triggering the OOB.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Link: https://patch.msgid.link/20260814093740.292954-1-gang.yan@linux.dev
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Shukai Ni <shukai.ni@kuleuven.be>
Tested-by: Shukai Ni <shukai.ni@kuleuven.be>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 875eceb55fdfa..71d9ea4772890 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -33,7 +33,8 @@ int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length)
 	case IB_MR_TYPE_USER:
 	case IB_MR_TYPE_MEM_REG:
 		if (iova < mr->ibmr.iova ||
-		    iova + length > mr->ibmr.iova + mr->ibmr.length) {
+		    length > mr->ibmr.length ||
+		    iova - mr->ibmr.iova > mr->ibmr.length - length) {
 			rxe_dbg_mr(mr, "iova/length out of range\n");
 			return -EINVAL;
 		}
-- 
2.53.0



