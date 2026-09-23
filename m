Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0AD52B1FE;
	Wed, 23 Sep 2026 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174149; cv=none; b=N7DfePSqpKqBH24zFQrPUQYLWLu88xEyyMvBOR1ifqt31HitiI3qAHPTtkHmIYQvie0PCuYWQDwYxw/k/Jzxghl+XNRGiu26t0bJicTApmqzTzFg1e93nx5sMji2h9Z4stW1tJ67bopzPV48LDCovRwKF601dklZ77n9mjrR1so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174149; c=relaxed/simple;
	bh=QhYYpx7vSf3DYiAbroZIktUG1PualkQ91N+w4Ce419o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxk9AxupV1ycoaD7+MjdYZt98RJ1HU11W0XXdVOi7NXA3G4TXCR6XoVEV0a+fRsJ8Oz7iyPltM8dyCZf4wAk/Xtsf07Pwd+89eHyrTcVTXAglWFw2Wd7AV/YqCAyXHRbKXgQA8dZGAQhxEyEfVc+Dkf+OjlVlC6Ek+28XYFzFzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egOrrVdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egOrrVdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03AC1F000FF;
	Wed, 23 Sep 2026 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174148;
	bh=VffMbus/KZfqCCItkVTzsKWMewXxRo9gddOxt6KnhRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egOrrVdCuwGwg2dqtSPkKE43eKGMIo8cJW7+6Exnb0OoBZ80CC1a1eFqKXwqY1Zrs
	 x65O9xAwdRuQPopX8NtaaeyfuHdfjtJ9rOWJGPlxbinf2jQkMp12nC5uKObAnWzbNz
	 16QEK9peYuna7UtYn313We7WxMOmGgRH0Mumi5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/398] RDMA/rxe: validate access flags before swapping the MRs PD
Date: Wed, 23 Sep 2026 16:01:39 +0200
Message-ID: <20260923140644.084005685@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit ae36a5b609ae79f4de966328b78d2584be9719a4 ]

rxe_rereg_user_mr() reassigns mr->ibmr.pd first and only then
validates the IB_MR_REREG_ACCESS argument:

	if (flags & IB_MR_REREG_PD) {
		rxe_put(old_pd);
		rxe_get(pd);
		mr->ibmr.pd = ibpd;
	}

	if (flags & IB_MR_REREG_ACCESS) {
		if (access & ~RXE_ACCESS_SUPPORTED_MR)
			return ERR_PTR(-EOPNOTSUPP);
		mr->access = access;
	}

Both flags pass the entry check because RXE_MR_REREG_SUPPORTED is
IB_MR_REREG_PD | IB_MR_REREG_ACCESS, so a caller can reach the access
check with mr->ibmr.pd already reassigned.

mr->ibmr.pd is owned by the core, which adjusts pd->usecnt only on the
success path: ib_uverbs_rereg_mr() jumps to put_new_uobj on a driver error
without undoing the reassignment, so mr->pd == new_pd while the usecnts
still charge the MR to orig_pd. ib_dereg_mr_user() then decrements
new_pd, whose count can reach zero while a memory window still references
it; uverbs_free_pd() frees the PD on that count alone and rxe_mw_cleanup()
writes to freed memory:

  BUG: KASAN: slab-use-after-free in __rxe_put+0x31/0xa0
  Write of size 4 at addr ffff8881301dd690 by task rxe_poc/591
   __rxe_put+0x31/0xa0
   rxe_mw_cleanup+0x42/0x200
   __rxe_cleanup+0x115/0x370
   rxe_dealloc_mw+0x4c/0x80
  Allocated by task 591:
   ib_uverbs_alloc_pd+0x258/0x540
  Freed by task 591:
   ib_dealloc_pd_user+0x174/0x210
   uverbs_free_pd+0x8d/0xc0
   ib_uverbs_dealloc_pd+0x18e/0x1d0

Validate the access flags before mutating any state so the callback either
applies every requested change or none.

Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 23304765decff..a1c75ccea40d5 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1346,19 +1346,20 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
 	if (err)
 		return ERR_PTR(err);
 
+	if ((flags & IB_MR_REREG_ACCESS) &&
+	    (access & ~RXE_ACCESS_SUPPORTED_MR)) {
+		rxe_err_mr(mr, "access = %#x not supported\n", access);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (flags & IB_MR_REREG_PD) {
 		rxe_put(old_pd);
 		rxe_get(pd);
 		mr->ibmr.pd = ibpd;
 	}
 
-	if (flags & IB_MR_REREG_ACCESS) {
-		if (access & ~RXE_ACCESS_SUPPORTED_MR) {
-			rxe_err_mr(mr, "access = %#x not supported\n", access);
-			return ERR_PTR(-EOPNOTSUPP);
-		}
+	if (flags & IB_MR_REREG_ACCESS)
 		mr->access = access;
-	}
 
 	return NULL;
 }
-- 
2.53.0



