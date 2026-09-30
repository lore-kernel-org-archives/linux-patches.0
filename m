Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2EC4FD27B;
	Wed, 30 Sep 2026 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793677; cv=none; b=fC0BEemOB2Y9tHOj6VBphL7uM0Vk4nk3NUCbNFC9WxSwdGq/30YLxd7x2Jn3sV8I77/p/DJbsN3GfZ1gcOzeFrCWvWsSbzL7h9aINMTMI4TKf9i9ZrxRo8bVboFaFf19Pwr94HoLpzR6ItdPEviK5nogy2Dk9WFoOXWKvKcE7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793677; c=relaxed/simple;
	bh=2/SQZVLMd1sscNgqSUpFozjWoPMYdcQLL5GvwabOk9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+EYbFAHhdYR8Pq7aVqOHIImkw82jJJKn78UHipNPqtvFk7ZYIhp8G+8zd0FoKqI/MfoAV3bk9vfisw7doYDWAOh1LRRKPkLEEKGfaLrFygynlWNH5fOBpyx+O4KXLoPjnImF/gkGE8PMEUKjpcw//Si5+h28m4M+bjeL2QAZCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7blfxQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7blfxQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46FF1F000FF;
	Wed, 30 Sep 2026 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793676;
	bh=6lJ10+c3VLr7fFvPlPM2tiMfhvqAvZgnnoTwH3tGQ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7blfxQjcsQQ1/YjjHZ/L5TX+PjoalkB+cgu58dgprxhGyGeYOiuLoFmczGe/tYmT
	 zS8Ykx9bq02p6keB7a+rxz7p0xU3xiFRW3+Z6/qMx9OlJ06ZeYKUFisu0VfFaw5tRD
	 bxAlpk6pgmroApna9+xSpJUH7Y6DHacA6JqY9dxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 339/395] xfs: use the correct reservations for rtrmap/refcount recovery
Date: Wed, 30 Sep 2026 17:30:01 +0200
Message-ID: <20260930152348.021689666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -510,6 +510,7 @@ xfs_refcount_recover_work(
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_cui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -545,8 +546,11 @@ xfs_refcount_recover_work(
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
@@ -575,6 +575,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	unsigned int			dblocks;
 	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
@@ -598,8 +599,11 @@ xfs_rmap_recover_work(
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
 


