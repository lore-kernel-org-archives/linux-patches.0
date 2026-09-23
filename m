Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7123535FD0;
	Wed, 23 Sep 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174153; cv=none; b=Bsk0xmvF9FfuwklJ7oVDQSw9GJ3k3yZb92KNyUd9KqI0AlMTwh6MFeKEwsMEbiRzLM8a+0lThpRxeeaie/TS7mcbg/M/wdTTz50+nObdpc/XFXMXtxntrA4wpRKxfwofclPF2BY93CttYrzRe8h6oEMSt+sFOtig29wHi141pro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174153; c=relaxed/simple;
	bh=hgbZqiZwGGDMcOxD3yT3orxvvi26GOa8N8v4R+32Q0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ot2KiKzoRigOHMnzY/fdhCdG5PlUu3K4K9cfTRLJj4HlRcESQS8VvmccQ/XAwbg84AWc52Qwqywq3mNLyGmZOHC86iTWlbLF6Ecut9il+l/cYrRADwJ9Z3TOV2yrWcQOyDfY8ka9IJQNXYuyuKZAXcgGBUcYGPRpLT4ub05lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJfxjtMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJfxjtMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B8E1F000FF;
	Wed, 23 Sep 2026 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174151;
	bh=1205NuELqqPj7f6usVeBFK+E49ounS5+0DFfXtbVmp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJfxjtMsy5U3o6NV1oNrEDdeqz1ruC+4lKW6GQwhiob8olKU89lVWXGE2+pnaLiD5
	 Y7FLqC0lm/h3ed7I3I5Ce77sFXq8I0YfiwiUl11Sa5kB834JUAu1YR69mPJgP/8Txe
	 uqFfFqQlFGg/RV6GhZHCwmy5eBFBX6M5VRHtb+WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/398] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Wed, 23 Sep 2026 16:01:40 +0200
Message-ID: <20260923140644.108822029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2c486bb616a7c..cd787e24c9ac6 100644
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



