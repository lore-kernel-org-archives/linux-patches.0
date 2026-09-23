Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E572D6E64;
	Wed, 23 Sep 2026 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172730; cv=none; b=B5PHLU+fc1tMbVUm94BS6VcZ9POrriTWenzaCIeBYmylUOpyEdDGUrTLOr80eWUlInFxs/kKPuIV4ah8vBK2n3WFsWtaZtkP3tt5qOeRFJj7QvWUNAWzmCbLpcVy0SvlU0AW1F4e63Jlz/N4r5KYPTQqJ44KsEA1EjSmlEM2NrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172730; c=relaxed/simple;
	bh=tFsqQcM7cA4YPi6cfG+LP/SomdaXLy2Tig3ghlmN9kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghp4NaXCvvGOp1r9A2CfcCvIOZf33ac2K7Cv8OeWi/BiblTHt7cKF5ZLTQ4EI/hByR3o7K/AhN+d/hjv0TIhMFXzwUomRAkvcMKEY9Zb8HO2dC1qvO41z/gjIYTJ2cJ/e/W7lg1NqN9OVW6IcGen9Zg1f+QqN6WFP7R45smhmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEiR7zIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEiR7zIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B24B1F000FF;
	Wed, 23 Sep 2026 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172729;
	bh=nSoKlnNaeZErKUGkDXRJRwnfTn7Va5rxdSOQloyJwW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEiR7zInv3udDjGaoMENTIWkhQhW84WwILtsv5kB/wLPsuW2bVN0zkUZfgqY2n9DK
	 GzqNu/Ea5++siYiUh75CZ+zjD1z3CI86owbX3uxcxGhcuJOjC4JGZFO1wybS6j1r8L
	 OGl6y8etpv6FQwakNXbK2wsYSDEIfDANmmFgrLWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 018/438] RDMA/rxe: validate access flags before swapping the MRs PD
Date: Wed, 23 Sep 2026 16:00:39 +0200
Message-ID: <20260923140645.248067951@linuxfoundation.org>
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
index 1ec130fee8ea7..f8c29fc5961d7 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1327,19 +1327,20 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
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



