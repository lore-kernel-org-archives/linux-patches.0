Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CBA5187DA;
	Wed, 30 Sep 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788164; cv=none; b=ngX2dhErav6fMnsGwPBBV9UkAKC0YAUGNhdw0kRz08JaijI15VH6X4aNZlXisKeZKmUP3XYS6FJ9k7mjqV4W6jnxiFNYhkdYWKVX3+14J4J+hrLq07OeA1h0xA6B3HCQsUd06nO8cI5w/gWWZJNMaaAhFQlkz9W+pg06odn9/f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788164; c=relaxed/simple;
	bh=H2XLnqZqZ6JTekjErRcgu19UnnyhJRF1niy4k5oKurs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su02aqaCyZHRRbD6q6vdsurr/I7nzz1yxZZPflVYunU81rY8pwkRHADY0MpXiVKXFwFyTI7i6J6KU2U2Kd9qf4w5KRK425fAX8UtHDUBePU/A3XTcxp7bjVZahwtcDF58gt3O7INUjzGewyN6DuAbAv8w07Lb18kQO/QzosJs50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3qsbFBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3qsbFBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC7C1F000FF;
	Wed, 30 Sep 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788163;
	bh=TMAfbqbqTZ13shFG6ZFiwAwTW9UIfzcEtu6A8VBzzBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3qsbFBp+v+hhyqp5vnlhh/7aFp4UJhQlKZMuYS0RertfAlXihuz5FfzPTwUApdUX
	 R027025wXNC4wF5fgNS8B9MXbSJqT8jSPBCu0Qv/orQQhBWoebVMYqojJbbryQtN9h
	 eQuw1XzvlRDY4bXKbC5xQOpg9JbZjIW8Fn8JXON8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/877] RDMA/rxe: validate access flags before swapping the MRs PD
Date: Wed, 30 Sep 2026 17:15:40 +0200
Message-ID: <20260930152415.374321851@linuxfoundation.org>
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
index 9466fed6726b4..da3bad301efab 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1326,19 +1326,20 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
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



