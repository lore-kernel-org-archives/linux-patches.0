Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DB93B3C0E;
	Wed, 23 Sep 2026 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173000; cv=none; b=gPF7IeppbjBvhiKkI9NyZPQggB5junvke2AiMTVZu8+C/YZwgyl4ygh9Yh4leGxcTQvJ9KStc3FJIWe3KJ8yfJjw4gHURmumODy6elDP/WlVAv6l3LdWXlGlWyqLLWtE5/bRWSW9qj4vrxN4Ubc+zVaPxFVzNRldQsQBlg7h9ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173000; c=relaxed/simple;
	bh=mLnMUwcsqAyGIVHXWDOkPt2UpHXBmdOavc+rWeDbYUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCSIFZ2fSMRwE1Sd66p8V+TPeNPCthc9Z/oYO6bDssR/LmxdkLhr6dL3m1hnRwEPxO5JTiDC08fTZ9N5CY/iDzGw54PJJe+U9nCftGIQsVBvybx+judEllOh86RUrv31PXO1EHnsI8epI4sbnmk3AupM6d4N8Bf6tkag0dch3uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9XHSPRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9XHSPRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759F91F00901;
	Wed, 23 Sep 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172999;
	bh=raSs/CPoFgcQVhMNQx+ADpwuZMLFpI9qhIcwamrV2A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9XHSPRARX7/pR/FRoczAyGPam5bcLNqMPfTh3BYJPeA99RU/NPVX8hlmrVq1j3Vb
	 Cmy5iW/hQpo7ZrJFD/KkDFknfvo5SVuJSVbrV6SljnG7dzBy4+Pmo6kgoOnTftD8Kb
	 xKT7ai8hCYUiPhSMRVOGzyKeyjgWY40lKXs08Sw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 125/438] ntfs: ignore interrupted inode reads as corruption
Date: Wed, 23 Sep 2026 16:02:26 +0200
Message-ID: <20260923140648.020752856@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 8c5dc7587fdd45f957af81a9adc1e16863f300fc ]

Do not mark the volume in error or report an inode as corrupt when
reading it was interrupted by a signal. -EINTR and -ERESTARTSYS indicate
a transient read failure rather than on-disk NTFS corruption.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 21 +++++++++++++--------
 fs/ntfs/mft.c   |  3 ++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b6e161d51dce2..cfb753be4f6b1 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1232,7 +1232,8 @@ static int ntfs_read_locked_inode(struct inode *vi)
 	if (m)
 		unmap_mft_record(ni);
 err_out:
-	if (err != -EOPNOTSUPP && err != -ENOMEM && vol_err == true) {
+	if (err != -EOPNOTSUPP && err != -ENOMEM &&
+	    err != -EINTR && err != -ERESTARTSYS && vol_err == true) {
 		ntfs_error(vol->sb,
 			"Failed with error code %i.  Marking corrupt inode 0x%llx as bad.  Run chkdsk.",
 			err, ni->mft_no);
@@ -1458,12 +1459,13 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 		ntfs_attr_put_search_ctx(ctx);
 	unmap_mft_record(base_ni);
 err_out:
-	if (err != -ENOENT)
+	if (err != -ENOENT && err != -EINTR && err != -ERESTARTSYS)
 		ntfs_error(vol->sb,
 			"Failed with error code %i while reading attribute inode (mft_no 0x%llx, type 0x%x, name_len %i).  Marking corrupt inode and base inode 0x%llx as bad.  Run chkdsk.",
 			err, ni->mft_no, ni->type, ni->name_len,
 			base_ni->mft_no);
-	if (err != -ENOENT && err != -ENOMEM)
+	if (err != -ENOENT && err != -ENOMEM &&
+	    err != -EINTR && err != -ERESTARTSYS)
 		NVolSetErrors(vol);
 	return err;
 }
@@ -1667,8 +1669,9 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 	/* Get the index bitmap attribute inode. */
 	bvi = ntfs_attr_iget(base_vi, AT_BITMAP, ni->name, ni->name_len);
 	if (IS_ERR(bvi)) {
-		ntfs_error(vi->i_sb, "Failed to get bitmap attribute.");
 		err = PTR_ERR(bvi);
+		if (err != -EINTR && err != -ERESTARTSYS)
+			ntfs_error(vi->i_sb, "Failed to get bitmap attribute.");
 		goto unm_err_out;
 	}
 	bni = NTFS_I(bvi);
@@ -1712,10 +1715,12 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 	if (m)
 		unmap_mft_record(base_ni);
 err_out:
-	ntfs_error(vi->i_sb,
-		"Failed with error code %i while reading index inode (mft_no 0x%llx, name_len %i.",
-		err, ni->mft_no, ni->name_len);
-	if (err != -EOPNOTSUPP && err != -ENOMEM)
+	if (err != -EINTR && err != -ERESTARTSYS)
+		ntfs_error(vi->i_sb,
+			"Failed with error code %i while reading index inode (mft_no 0x%llx, name_len %i.",
+			err, ni->mft_no, ni->name_len);
+	if (err != -EOPNOTSUPP && err != -ENOMEM &&
+	    err != -EINTR && err != -ERESTARTSYS)
 		NVolSetErrors(vol);
 	return err;
 }
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 60f10bb0004fd..8dcbc93a8ccac 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -213,7 +213,8 @@ struct mft_record *map_mft_record(struct ntfs_inode *ni)
 		return m;
 
 	atomic_dec(&ni->count);
-	ntfs_error(ni->vol->sb, "Failed with error code %lu.", -PTR_ERR(m));
+	if (PTR_ERR(m) != -EINTR && PTR_ERR(m) != -ERESTARTSYS)
+		ntfs_error(ni->vol->sb, "Failed with error code %lu.", -PTR_ERR(m));
 	return m;
 }
 
-- 
2.53.0



