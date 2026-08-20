Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643A35C681;
	Thu, 20 Aug 2026 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247494; cv=none; b=phqxtghvG0Dfx2/R5SxZm9hbajU5Bb60MGCwLkUvxkSedri//Go47+Yet824YfVVbaaFb4t3VfxlqsT/p4cXDOsJnjdVgIri+D4wpG7McXNdkdKFcRDklPISdbPK8BB6BUPKfvs50Ie+qaKDvmgsEv05IRJM8MxB8TGPL+ZqlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247494; c=relaxed/simple;
	bh=3ItIg4ChSUSUsLQCRwBOsgjPK2VRYzUV4jv6dyOjI1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXVJbct3OBbY12S7ejrXu5SircyJ2GXrpiGfwXfiDX3GNbriA2y1cO2HFwhBOikFFzOgBxCHUWc+1TvKOXfurejOm4Io3d9iMYzjkH+nxrICrBkbYuu3XGFA29qLojaHQe+XFz8ZZQltlQxLet0BAOBMGjJl1SrTfifyu4xF35k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypQhlKLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypQhlKLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D47C1F000E9;
	Thu, 20 Aug 2026 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247492;
	bh=gOiRomVD9zdylc8NCNIkLpimtj7APtny1Q2ghzf11Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypQhlKLjJ6FPKR95jjzAGgBpAitLVpxJMLJXr6sKl7GkcTnl29v8mEp9QGKU8zRMC
	 On9I+OtIw/w3xTKQ0RuOVxB+I8gSpF1DrRCcEeBkqTRWJ1mE0eN33OxCJsC/mnwPkV
	 qFHb5gue+25iYX+cVP9Xo2evWzGY8h5A90bT3giA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 064/166] xfs: only check mergeability of bnobt records
Date: Thu, 20 Aug 2026 16:55:23 +0200
Message-ID: <20260820145213.071662776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 97efed1091a50e4dbf31307015138b43a972d2e4 upstream.

In the cntbt (free space by block count) btree, records are not supposed
to be in startblock order.  Hence the mergeability check is pointless.
Remove it, since it does nothing, as LOLLM points out.

Cc: stable@vger.kernel.org # v6.4
Fixes: d5784ae82778d9 ("xfs: flag free space btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -124,7 +124,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
-	struct xchk_alloc	*ca = bs->private;
+	struct xchk_alloc		*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(bs->cur, &irec) != NULL) {
@@ -132,7 +132,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;


