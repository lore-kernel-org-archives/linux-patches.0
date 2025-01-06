Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCD3BA34;
	Mon,  6 Jan 2025 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178535; cv=none; b=bzexttOUrfACYJSEk341JTA03ZT7tbqeQbKqqrNrB3G4jIoLCPXZi2vOPxaaMBOc+CH6L4TK+XdYuZDrsOUddckz2bmpRXyb25XO4rYYUMTTNND60O/eJ/xA1HuP8B9EqvusggY8UUzE1z+3ZT6DiNFbkT+KHyLWR13cMDq6nzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178535; c=relaxed/simple;
	bh=hQowDun4hc9/WMaNIlg6J3YCXYYD704tl7QncQJEFAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXHSTQJaEu+bt1qOKr4QlbHVMQWMIrkfnjZVFHzSfwB75f6vkI3DvIAaTHBvbPmxoinLJHKdP1cqQM/Sz6+J7HkcRZQSDoQQ3OBPTtAS/ScUhn6W08w1/Gnc932+Zy167UmnTt2q/odsKTxAtsTEyd/OEqU1Ygc5rj45GE4ZXNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjoKyi6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjoKyi6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43825C4CEE2;
	Mon,  6 Jan 2025 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178534;
	bh=hQowDun4hc9/WMaNIlg6J3YCXYYD704tl7QncQJEFAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjoKyi6lpGQe7EGDxQ9lS/eTi+dLbIZdEwfIHjUipmxPasveHo8XZ2J/Jr5xcWxOb
	 tVyytXLg43mChhfVMiZrmQ3g7MbsacJ0ZnDMU1IRAfaFWPbeIoMYND7Nm8IYhkWvOC
	 CqHwD4g403sgJoOa53BXzVagQ3ilHIWZXsY699s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Walters <walters@verbum.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/168] erofs: fix incorrect symlink detection in fast symlink
Date: Mon,  6 Jan 2025 16:15:20 +0100
Message-ID: <20250106151138.926592798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 9ed50b8231e37b1ae863f5dec8153b98d9f389b4 upstream.

Fast symlink can be used if the on-disk symlink data is stored
in the same block as the on-disk inode, so we don’t need to trigger
another I/O for symlink data.  However, currently fs correction could be
reported _incorrectly_ if inode xattrs are too large.

In fact, these should be valid images although they cannot be handled as
fast symlinks.

Many thanks to Colin for reporting this!

Reported-by: Colin Walters <walters@verbum.org>
Reported-by: https://honggfuzz.dev/
Link: https://lore.kernel.org/r/bb2dd430-7de0-47da-ae5b-82ab2dd4d945@app.fastmail.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
[ Note that it's a runtime misbehavior instead of a security issue. ]
Link: https://lore.kernel.org/r/20240909031911.1174718-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 638bb70d0d65..c68258ae70d3 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -219,11 +219,14 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 			      unsigned int m_pofs)
 {
 	struct erofs_inode *vi = EROFS_I(inode);
+	loff_t off;
 	char *lnk;
 
-	/* if it cannot be handled with fast symlink scheme */
-	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= PAGE_SIZE || inode->i_size < 0) {
+	m_pofs += vi->xattr_isize;
+	/* check if it cannot be handled with fast symlink scheme */
+	if (vi->datalayout != EROFS_INODE_FLAT_INLINE || inode->i_size < 0 ||
+	    check_add_overflow(m_pofs, inode->i_size, &off) ||
+	    off > i_blocksize(inode)) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
@@ -232,17 +235,6 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 	if (!lnk)
 		return -ENOMEM;
 
-	m_pofs += vi->xattr_isize;
-	/* inline symlink data shouldn't cross page boundary as well */
-	if (m_pofs + inode->i_size > PAGE_SIZE) {
-		kfree(lnk);
-		erofs_err(inode->i_sb,
-			  "inline data cross block boundary @ nid %llu",
-			  vi->nid);
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
-	}
-
 	memcpy(lnk, data + m_pofs, inode->i_size);
 	lnk[inode->i_size] = '\0';
 
-- 
2.39.5



