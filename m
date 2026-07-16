Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB63148C2;
	Thu, 16 Jul 2026 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210359; cv=none; b=RUrOl2Iu2cDSVe0W+S7JFz8BSU05qZLyFQ75auWQ4GgCV/uoLJ+PmWXu5Rg5UXdTMKK4Jr+doRinfEH2YQaOOIJzvqCnYVY56FH769BAxNyA/irl2AWeE++vC6SYD5bWt9piOxRo5RbfCofEC2pSrnTy6JWhGqHAwGqJ0gTN+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210359; c=relaxed/simple;
	bh=gqTWuAhdd+j1SpTy9mEjRBHgt0R7mOLwH4Gxcy3b7Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaSz6iIjbfNgUCL7l1Qf9dcP+ybOHyLuawF5s+y+PemMWN6oaX9EbVWekij2LBahQEXm4h4DhwlaT61tAfnqfbmZLUVN8RqQ+kQaq3lMMGNHJgAip3DXN05cR1k+5vbo2e+jjrJ00WOiIl2/BimSfB8VavlqKlBPhxG3B63Z2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocXB8YpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocXB8YpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59831F000E9;
	Thu, 16 Jul 2026 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210358;
	bh=b4ObLLgipWmHK9pG5a95PsWhPStsV29k9PgFyCxZEDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocXB8YpWifSDHnpuWlzQYoJ8pyMIJ+GCrx2xxDxDv8n6Rqoo0oUstJ52VgZo90d0+
	 fy6NEOjAwX/gYadSl6tKGV2xvHfsRrruPt4Iora1ZBwkG1L1xmHJ7kwzif42SQ+Con
	 AeowKl5XVfglR5k2pRdY7Fn6f72iTrdorcxaJxuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/480] f2fs: detect more inconsistent cases in sanity_check_node_footer()
Date: Thu, 16 Jul 2026 15:26:05 +0200
Message-ID: <20260716133045.088966626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 93ffb6c28ff180560d2d7313ac106efcd9e012b8 ]

Let's enhance sanity_check_node_footer() to detect more inconsistent
cases as below:

Node Type			Node Footer Info
===================		=============================
NODE_TYPE_REGULAR		inode = true and xnode = true
NODE_TYPE_INODE			inode = false or xnode = true
NODE_TYPE_XATTR			inode = true or xnode = false
NODE_TYPE_NON_INODE		inode = false

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 8712353ed80f ("f2fs: fix to do sanity check on f2fs_get_node_folio_ra()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1504,20 +1504,29 @@ int f2fs_sanity_check_node_footer(struct
 					struct folio *folio, pgoff_t nid,
 					enum node_type ntype, bool in_irq)
 {
+	bool is_inode, is_xnode;
+
 	if (unlikely(nid != nid_of_node(folio)))
 		goto out_err;
 
+	is_inode = IS_INODE(folio);
+	is_xnode = f2fs_has_xattr_block(ofs_of_node(folio));
+
 	switch (ntype) {
+	case NODE_TYPE_REGULAR:
+		if (is_inode && is_xnode)
+			goto out_err;
+		break;
 	case NODE_TYPE_INODE:
-		if (!IS_INODE(folio))
+		if (!is_inode || is_xnode)
 			goto out_err;
 		break;
 	case NODE_TYPE_XATTR:
-		if (!f2fs_has_xattr_block(ofs_of_node(folio)))
+		if (is_inode || !is_xnode)
 			goto out_err;
 		break;
 	case NODE_TYPE_NON_INODE:
-		if (IS_INODE(folio))
+		if (is_inode)
 			goto out_err;
 		break;
 	default:


