Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F7229A0;
	Wed,  7 May 2025 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643515; cv=none; b=j8xzOc6hVD5SnAF6wutWMNIpux2v+mXVMA4B8cfTC0ono3LF+Rk49jBEyqfm+Nl23f7NYMKCIeDQUYE3Xs8Fk0k7tMV7DxlAkaMF75ifZLETlglOt9Nydh+flYNbL5UmNuVl1flb8RPTq+gZJQTG8AU8xRyh7bOXiyemFBxNDi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643515; c=relaxed/simple;
	bh=bFdW8/yZATfqsQ6/E9NSMNr794B7FgHtbRYaKulJAAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfmX8BL0YcTjLVFor/KWoNBuFRipvkP/6s1i4yLwmk42v5ZarKEiacdqw8MwkJFYyF1cSF0JXwqN41WwNz7xzZ4pPDYpn7QabmO5bIwuGveRNpodnw5QJC40DeFa6EkOfL9vogsR50xaROlOv9xVhVE8zOrdHhdSVQlO1UCx4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx8Ab3Ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx8Ab3Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A55EC4CEE2;
	Wed,  7 May 2025 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643515;
	bh=bFdW8/yZATfqsQ6/E9NSMNr794B7FgHtbRYaKulJAAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zx8Ab3Cto+NcZkd4ysd0kn2GYFc4rT9oBBYTBJrJ3wUfpQGGMTgYkulgkG0XBAF1U
	 oV5uE618UxolmrvEnm/0/GDcGFiDq/VaifQjqZnow6OeTeY0lfSD/KbngZ8+B/imvu
	 k5cQoGPf3TtE354DTYHQ9Ukc08u1iBE+kq216aYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 30/97] xfs: match lock mode in xfs_buffered_write_iomap_begin()
Date: Wed,  7 May 2025 20:39:05 +0200
Message-ID: <20250507183808.204379321@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit bb712842a85d595525e72f0e378c143e620b3ea2 ]

Commit 1aa91d9c9933 ("xfs: Add async buffered write support") replace
xfs_ilock(XFS_ILOCK_EXCL) with xfs_ilock_for_iomap() when locking the
writing inode, and a new variable lockmode is used to indicate the lock
mode. Although the lockmode should always be XFS_ILOCK_EXCL, it's still
better to use this variable instead of useing XFS_ILOCK_EXCL directly
when unlocking the inode.

Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1129,13 +1129,13 @@ retry:
 	 * them out if the write happens to fail.
 	 */
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_NEW);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW, seq);
 
 found_imap:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
 found_cow:
@@ -1145,17 +1145,17 @@ found_cow:
 		if (error)
 			goto out_unlock;
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 					 IOMAP_F_SHARED, seq);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0, seq);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
 }
 


