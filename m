Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12485187C2;
	Wed, 30 Sep 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788168; cv=none; b=Z68f1E0U+Tl7xyMbgc6k4FUof53EsowlbTFyR1+t4TXA9lZNYeA/4uuFNKaGthTd4vVzFkGsyolBrnP5kMP0PeNkcSGT5Nsi5noCp9eZZ1H+CrVARVtWEdCrSp4K9Ofzww4W5wIneNs+0/B5p1pf0b1eHbc+9OdQQz00CJhzPvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788168; c=relaxed/simple;
	bh=rKpcPR2amFMTwgHu1SrPkqt7cLuqe7guSbrqRI3DR/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQGogNErbRDEU8kSSJ6qouLDGYl9NjwSw+BzRH+uLhjfCMBnuivVWZ+o/onMfDOFfDeLrcrYy4zYyI8TILxyRFVoFXddA68nFIKqeYa3Xh6HAHN+mPQk2PcUgUN4m74PD7NKpneemjuTI8UxczFVdYCquOqFiguIgLEwoiBntEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCf69vZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCf69vZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8941F000FF;
	Wed, 30 Sep 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788166;
	bh=1Y9EI2JAC70K3bA4NUo0d4W5M04D0LLzHueSSgaBVy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCf69vZIMdr0+i4ABvUkeH99hvkmy01lrxzzvLeCTMrGdlkCekCM+OeUdnTLl8+Qh
	 OqDLq67ECLD2E11+8ENZdw8/JP/kAXKYuqG2XRY8mw63rBDN/8XDV+fffyLoYuaM00
	 e6lu6zsE/OaexQzvruBR0Prbiaau63zSoPDX0nw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/877] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Wed, 30 Sep 2026 17:15:41 +0200
Message-ID: <20260930152415.396025929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index da3dee520876a..83e325b76f67d 100644
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



