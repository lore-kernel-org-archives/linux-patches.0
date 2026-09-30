Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45022515961;
	Wed, 30 Sep 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788005; cv=none; b=C4nv0+w+/J/kUhRBSEPV/i6BJU2z4Lft+HBxK/AHWr79wSm3eu4J/4Q3DYupTpyXlOlFPVulGTnnUwVlFBt7TWiYBV+maF1m5jdVZynh9wFoPSfztaPZ0KXOlmaZRN3sbZxIxJIkV4vamKKSTIGQgskOiMIllbpmlw4dAn6jvwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788005; c=relaxed/simple;
	bh=yVl/qyQykh3Qzz0qsjOsHZbuRqMBjMa58EoRsgXbJps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY+WXJyehf98H59XmQ2qXrFVDBBx4zyUz5OHUbVl+e6nWtBua4Ukx8Cd83bkEJAVRxDHPZ4iyizTGoefvU3rPbKvVaynaKPPVqYpsAKZp7krN16cZE5IRslMhl68NsrKSrsbg8ihhECvsY/hq6I8nygH9lbCaitAtX+cTHKR6AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHKrcJHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHKrcJHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF421F00898;
	Wed, 30 Sep 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788004;
	bh=qnAr9//3mw1YY0uRUHfTbxVhWXo6ut2RQkkKSW7b5Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHKrcJHjE6lSXgR/ha8w/9FKabbh6RBrTMBrMb3C3ufUW1MCBqKtABG8qPV5N/gDv
	 ygCk3darl/16omtVefdYiPYjMdfQh/pOP5J4BoFFuW5vxtLheKMTY7r2szGO3trXx1
	 MxAM/hlTHBHXfFttANggzgJ4nFL12ZTba4McEtYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 429/457] xfs: dont let memory failures leak blocks and kill repairs
Date: Wed, 30 Sep 2026 17:28:54 +0200
Message-ID: <20260930152355.249853071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit ab1c416d2377cdc16123ef521aac4da1c468c3d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/newbt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -193,9 +193,11 @@ xrep_newbt_add_blocks(
 	struct xrep_newbt_resv		*resv;
 	int				error;
 
-	resv = kmalloc_obj(struct xrep_newbt_resv, XCHK_GFP_FLAGS);
-	if (!resv)
-		return -ENOMEM;
+	/*
+	 * We have no way to clean up the allocated space *and* return an
+	 * ENOMEM if we fail to allocate this control structure.
+	 */
+	resv = kmalloc_obj(struct xrep_newbt_resv, GFP_KERNEL | __GFP_NOFAIL);
 
 	INIT_LIST_HEAD(&resv->list);
 	resv->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);


