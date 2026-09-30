Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF504FECCF;
	Wed, 30 Sep 2026 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787985; cv=none; b=oddBJ2EgGSL0aL1LU3k0hG28smnaR9pRh0O5mQ0gap1b4Cso81MHW977gJzudtoCtYMxyg29cv+zl/dobrEhvxpMW/7r+2knyS3X8xTmUSdf0ACc3Z2TGj7lOSGMC7EweexvtpYCbGfhlRg8c8V4V+/WKYz9lCqSljXxS6R26fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787985; c=relaxed/simple;
	bh=bOudAfTwEfZpG7zwaOoIWlhLX3w9PMV3cSaJQHj9Ysg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTqM2SC61ouwKxIUmBPPOPOv4PY6EtYm5pbxN1aPHTHkHI6H/GQa+kMw7KoaHc0aVs63nxfr0uhl+wRwLh02OjMKOJ/s6GMMVsfwtXwehy7SaofrCKpXmXdd3VPeJabiZ2r+jtZWJ9115Kk9UefTJwZkxa2WUE/fp+LPeTC3jwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rr2nvewr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rr2nvewr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D6A1F000FF;
	Wed, 30 Sep 2026 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787984;
	bh=KJlI7NumB40wyw8tRvgvvugr+PiUV+J8BpA/4U+T2wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr2nvewrWRru5tyiz284ihOfAawxtlixjhppR4UvQ2yrmphzNC0UzA1G/iWiV+aa9
	 gGqgs7HF/hfNVyAgVczdMMM1g+vTr1cN5rUb376KHcAKcjnENpdbW4ppXMQmbSMRHh
	 9qSPJdpRI27lp9jULWQvyYwNbRNi207d0rBsWzJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 423/457] xfs: use the correct reservations for rtrmap/refcount recovery
Date: Wed, 30 Sep 2026 17:28:48 +0200
Message-ID: <20260930152355.116117565@linuxfoundation.org>
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

commit 471e0b6e2ddac9e16b8dc2153d6e5575fefb8a2f upstream.

LOLLM noticed that we might reserve the wrong number of blocks for
recovering rtrmap and rtrefcount updates after a crash.  Fix that.

Cc: stable@vger.kernel.org # v6.14
Fixes: 5e0679d1c62f25 ("xfs: support recovering rmap intent items targetting realtime extents")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_refcount_item.c |    8 ++++++--
 fs/xfs/xfs_rmap_item.c     |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -508,6 +508,7 @@ xfs_refcount_recover_work(
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_cui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -543,8 +544,11 @@ xfs_refcount_recover_work(
 	 * full btree split on either end of the refcount range.
 	 */
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
-	error = xfs_trans_alloc(mp, &resv, mp->m_refc_maxlevels * 2, 0,
-			XFS_TRANS_RESERVE, &tp);
+	if (isrt)
+		dblocks = mp->m_rtrefc_maxlevels * 2;
+	else
+		dblocks = mp->m_refc_maxlevels * 2;
+	error = xfs_trans_alloc(mp, &resv, dblocks, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -573,6 +573,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -596,8 +597,11 @@ xfs_rmap_recover_work(
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
-	error = xfs_trans_alloc(mp, &resv, mp->m_rmap_maxlevels, 0,
-			XFS_TRANS_RESERVE, &tp);
+	if (isrt)
+		dblocks = mp->m_rtrmap_maxlevels;
+	else
+		dblocks = mp->m_rmap_maxlevels;
+	error = xfs_trans_alloc(mp, &resv, dblocks, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 


