Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A57F4F7997;
	Tue, 13 Oct 2026 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894743; cv=none; b=fdln4Emj+EwQAQaLgDJKvsI6ydfpHCOCTyah9Bov8k/Zcy/ZtZDXDA6DTE0h3bZ2v2Tolu9ki1AeiJA+IehCfGZ8D+6+1TwlsTxURjy9lQ8WI1eLhHzLNonGY/edLscRI/KcWysqxHgtO5BAMHCLwRJhIgHKX1eEORVM3N0auz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894743; c=relaxed/simple;
	bh=xCX3OP+k/viPG2J1eJyK1/th4nlxdD51P/VbdbnLbN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIzwkYEBMjRnfRvzuNH6c5vcl9ZGgrW1kL3fCxThyHTxOrG+Jb3JKiJouZhH6fxSlYV4NFKHWCws06739RfLsYqcYB2aVLHVit/2TxFNTVdvkxAZERokp70DNXbZWxFMPHDAe+rq8eNiUQey4edpymmMl6Xls6G94/uBu2nIc24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYYW3BnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYYW3BnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215741F00893;
	Tue, 13 Oct 2026 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894741;
	bh=5S1lU9lrLm1A6fNdGTux67U9gsc9J0JF2KsjrED3eiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYYW3BnN3FFvzyizsxQYdirIFFQCqmw5dSZUUg42i8wzjW2pKU38iNsE+lS4RoAex
	 hg1cHYDfB92+HfjZkNqyEb4ZBpp+VRfvlhbY1xT/LOVBUKqTpLbHqYzLFMyLg2D15x
	 axhOZTmYSlxSQ6U8UKkapEnEZFk6BAVoZnR8vfNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/497] xfs: dont let memory failures leak blocks and kill repairs
Date: Tue, 13 Oct 2026 13:32:54 +0200
Message-ID: <20261013112908.052760382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit ab1c416d2377cdc16123ef521aac4da1c468c3d4 ]

LOLLM complains that a memory allocation failure in
xrep_newbt_add_blocks results in online repair leaking blocks that were
previously allocated to write a new btree, but the problem is worse than
that -- a limitation of the codebase is that the callers cannot undo the
transaction /and/ return the error -- either you undo all changes and
commit the transaction, or you error out and the filesystem goes down.

However, the new btree space reservation object isn't that big (~48
bytes).  Let's just do a NOFAIL allocation and the problem goes away.

Cc: stable@vger.kernel.org # v6.8
Fixes: be408417630427 ("xfs: implement block reservation accounting for btrees we're staging")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Changed kmalloc_obj() to kmalloc(sizeof(struct xrep_newbt_resv), ...) to preserve the branch’s existing allocation syntax. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/newbt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 2aa14b7ab6306..1e362e6eb87a0 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -147,9 +147,11 @@ xrep_newbt_add_blocks(
 	struct xrep_newbt_resv		*resv;
 	int				error;
 
-	resv = kmalloc(sizeof(struct xrep_newbt_resv), XCHK_GFP_FLAGS);
-	if (!resv)
-		return -ENOMEM;
+	/*
+	 * We have no way to clean up the allocated space *and* return an
+	 * ENOMEM if we fail to allocate this control structure.
+	 */
+	resv = kmalloc(sizeof(struct xrep_newbt_resv), GFP_KERNEL | __GFP_NOFAIL);
 
 	INIT_LIST_HEAD(&resv->list);
 	resv->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-- 
2.53.0



