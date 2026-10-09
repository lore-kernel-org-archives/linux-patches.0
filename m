Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9634E433D;
	Fri,  9 Oct 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555326; cv=none; b=g90rriObKHs0OqTI21UpAnJGICCEtPONQNiU0c9xauj6yTRAsXi+siBn0CPnUzwVnUGb7mRO26wI+Km0Kcn/VxlPw8fwUg/iz4vM4eVwHX/55OCy5LbKMDjko2uznPWi3wFKHJUhFRgkIJ3DmwMwcvA0Fo6HxFzOyCQhDdLvLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555326; c=relaxed/simple;
	bh=0AlomNefV/L5CrqAYpRf+gkw8peNpLZVcHG5BZWieck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEOZsBJFLvndlfzDGU3t435XLIRvHKTd0hl5kZXnzfZE/gSkrYNPwhgIDiqoLBveqryrFWx16IC6uoXpVdC6o6oRZD26LsXefhSC6Ge6yZXop1w5HjiiOEEeSeV2P9YuCDt5IGXioM2CMvexLua/MKSTuH4a4ifdP/Pc9MDqkfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OPAvtf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OPAvtf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4141F000FF;
	Fri,  9 Oct 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555316;
	bh=sV+rnsJD35bkikDq0UaCXEn7boalcwikBeWMCzzA0hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OPAvtf3dbhzxDRaeuyVEAXMiDkShqKd1aR5wl+nqlf7KS6J0zF8Rt2g0t+kRg+vC
	 dlWJKWQsI3shas+qj/LWv21+/OEJa/U4L9r6TC2OEzF/MhJR0JNkDp/l7/1hB+my9e
	 Q9cUWCCfyPv7szie+ExXiXJoAXvl4SolgmA1ZEAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/403] xfs: dont let memory failures leak blocks and kill repairs
Date: Fri,  9 Oct 2026 16:06:08 +0200
Message-ID: <20261009140952.292713586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 951ae8b71566c..2a9547789c5c1 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -195,9 +195,11 @@ xrep_newbt_add_blocks(
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



