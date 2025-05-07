Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2A73451;
	Wed,  7 May 2025 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643606; cv=none; b=PRW5ujfeTEIAEQY4WjaD6sqHs0SXCoIr4UA1o4f/E3CCMt/q5nC8jkf5tMbMkzQSXplJ4NO5KKpQdltt0LiGA1ssNCBwk19gQk5NovI6Mm8VjVwO1xWNPzUkc2u/KSGUFu/LH40JqIcUIalLrC75XbO2I9DjVZa+wVhrgbIGmLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643606; c=relaxed/simple;
	bh=olb3GorI29rRv/46MGjvoAK0wlLcQje2JEbDWzrYBp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jch+VHVDEOXHmUcIN/caobZ2KoschKxx9SvjLsT9Vz04ueLBg3j0RFVNby1SKqC31Veh+jHyQDR3XPmhWRlychsC7Sa0wqtsIw4NVEgTPm4YoB4HpAHScU6e+zN4oySpDCinGenmIF6LtAVzR4rUM22Zr1fUrWaYIyDIzghcYTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WlI6N1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WlI6N1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161BAC4CEE2;
	Wed,  7 May 2025 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643606;
	bh=olb3GorI29rRv/46MGjvoAK0wlLcQje2JEbDWzrYBp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WlI6N1zZICuA5w87w9XWa3N3QKu96L5Ml0Ne3sll0HLFBndKhBLJKIigNY91MO1x
	 p2qLIqENU/FIiYSazKXUoJ3xmmpd5x32N2pIQdGejvVMGoT5ksqOvBPTYzCkzyAvQx
	 4rR6A6c1RYJ3dz6C01T/l+wmfEvgBS1ZTnRNzrSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 28/97] xfs: validate recovered name buffers when recovering xattr items
Date: Wed,  7 May 2025 20:39:03 +0200
Message-ID: <20250507183808.122723382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 1c7f09d210aba2f2bb206e2e8c97c9f11a3fd880 ]

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |   58 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 11 deletions(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -717,22 +717,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -761,31 +759,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*


