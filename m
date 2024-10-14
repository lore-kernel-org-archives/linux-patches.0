Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D71CEAC4;
	Mon, 14 Oct 2024 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919618; cv=none; b=fc3sU9JKjlsTK9GIxDUn09Vl5RQDOM28YQ4baPdr9btqD1eDVkgPnq9YinEMJogsZqx8dILEw1C6iKiiyMYH0bNHKUOstdGahcFEOjNS0BsK8ViHwtxBOJlr2Kh9o8KSfFvL/jfpo2+Y03XYUlju35Zqa6bBorIyfkF8lhAVLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919618; c=relaxed/simple;
	bh=5T59jWTg6/F1hWc/L6SHxGi23LZmAQ24Unf+jvmsL/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkkOmKvUa0/gw6HcHeC7mUaVP4/i0wmodNLzaKf7Rh9UxqXHfb3WmmP0olfT2hLODRYT9cPFHmKhh5M8K89GUr+0uzH3LMCVwKcAfKwuPsXrnZjsLiuHKvH+LeCuf75YDqEZPJwGvEVKxzCK8X9alvV8DgKFyNljsgxCTnnDQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo2DROrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo2DROrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A312CC4CEC3;
	Mon, 14 Oct 2024 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919618;
	bh=5T59jWTg6/F1hWc/L6SHxGi23LZmAQ24Unf+jvmsL/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo2DROrBT2qNtNWvrFes7mNkXS7PL6e2phisaWLE5nztkQ4PEfWZz3i2Ga7ZOaAIb
	 B7lqkW1NRHIdyYAGpdxJg5Pvqw9xjSIwGOzbCwjvyciuiwQilr4SbUWkat+RZeYGy1
	 acWL3Or9rRsK+0UkRCiZe11utUu/le5iR8LZSzd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-erofs@lists.ozlabs.org, LKML" <linux-kernel@vger.kernel.org>,
	Colin Walters <walters@verbum.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 658/798] erofs: fix incorrect symlink detection in fast symlink
Date: Mon, 14 Oct 2024 16:20:12 +0200
Message-ID: <20241014141243.902543910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240909031911.1174718-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/inode.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -212,12 +212,14 @@ static int erofs_fill_symlink(struct ino
 			      unsigned int m_pofs)
 {
 	struct erofs_inode *vi = EROFS_I(inode);
-	unsigned int bsz = i_blocksize(inode);
+	loff_t off;
 	char *lnk;
 
-	/* if it cannot be handled with fast symlink scheme */
-	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= bsz || inode->i_size < 0) {
+	m_pofs += vi->xattr_isize;
+	/* check if it cannot be handled with fast symlink scheme */
+	if (vi->datalayout != EROFS_INODE_FLAT_INLINE || inode->i_size < 0 ||
+	    check_add_overflow(m_pofs, inode->i_size, &off) ||
+	    off > i_blocksize(inode)) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
@@ -226,16 +228,6 @@ static int erofs_fill_symlink(struct ino
 	if (!lnk)
 		return -ENOMEM;
 
-	m_pofs += vi->xattr_isize;
-	/* inline symlink data shouldn't cross block boundary */
-	if (m_pofs + inode->i_size > bsz) {
-		kfree(lnk);
-		erofs_err(inode->i_sb,
-			  "inline data cross block boundary @ nid %llu",
-			  vi->nid);
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
-	}
 	memcpy(lnk, kaddr + m_pofs, inode->i_size);
 	lnk[inode->i_size] = '\0';
 


