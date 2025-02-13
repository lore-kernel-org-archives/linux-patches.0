Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4ED26B088;
	Thu, 13 Feb 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458187; cv=none; b=k2O3UwxZ+9jzvvjcK6+SHNKbKRDOlahgPEG2RP36jMk3b0EXXC+uxnn2vu0ROPgomLdYNDb/vAdGY8NCfQ6UlyTPhchj7rosM08Wch+Cy329PkLPJfX2rtRP/PYwdnOLBYKS7y+bToaubvfFQOvq22fvztWiIJQ5R8vQOgVEZPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458187; c=relaxed/simple;
	bh=wL/k4N/SQBeYaemciF4NAX2bv8kJqg8Bm5FMqRGq/nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkyMmOvADrbMhW3E5ofIBcSl688dBbmpuyTmsrf67SuprNiwyY2M/Av3z1La3c2ASYMBCkcOd2KGf20r2lMU1QmwavWe9Vlu03gwvRemtuOiq1NWvk1vERW+ewpHqgMQxtBJsXylX1BRMl1I5Q+MTDBuyd+npkM8aAw5HhdOApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLeTr9JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLeTr9JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736D3C4CED1;
	Thu, 13 Feb 2025 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458186;
	bh=wL/k4N/SQBeYaemciF4NAX2bv8kJqg8Bm5FMqRGq/nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLeTr9JE0Zd9afhwKRAQYz6GsV1namoFF4ndUYY7WAjH52LfV0sBo9S0a5nc+VR7j
	 Wm7SeRVr5ySUVCamQiCVDPh4tq23DLnMAME8tccB+8Wd02uBU/oncEZEITLFQgqpJH
	 ZWwruyg/zUbdC1hx+BUgG4fVfThr23Isge5A6wok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 300/422] xfs: dont call remap_verify_area with sb write protection held
Date: Thu, 13 Feb 2025 15:27:29 +0100
Message-ID: <20250213142448.117077215@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit f5f0ed89f13e3e5246404a322ee85169a226bfb5 upstream.

The XFS_IOC_EXCHANGE_RANGE ioctl with the XFS_EXCHANGE_RANGE_TO_EOF flag
operates on a range bounded by the end of the file.  This means the
actual amount of blocks exchanged is derived from the inode size, which
is only stable with the IOLOCK (i_rwsem) held.  Do that, it currently
calls remap_verify_area from inside the sb write protection which nests
outside the IOLOCK.  But this makes fsnotify_file_area_perm which is
called from remap_verify_area unhappy when the kernel is built with
lockdep and the recently added CONFIG_FANOTIFY_ACCESS_PERMISSIONS
option.

Fix this by always calling remap_verify_area before taking the write
protection, and passing a 0 size to remap_verify_area similar to
the FICLONE/FICLONERANGE ioctls when they are asked to clone until
the file end.

(Note: the size argument gets passed to fsnotify_file_area_perm, but
then isn't actually used there).

Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
Cc: <stable@vger.kernel.org> # v6.10
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |   71 ++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 44 deletions(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -326,22 +326,6 @@ out_trans_cancel:
  * successfully but before locks are dropped.
  */
 
-/* Verify that we have security clearance to perform this operation. */
-static int
-xfs_exchange_range_verify_area(
-	struct xfs_exchrange	*fxr)
-{
-	int			ret;
-
-	ret = remap_verify_area(fxr->file1, fxr->file1_offset, fxr->length,
-			true);
-	if (ret)
-		return ret;
-
-	return remap_verify_area(fxr->file2, fxr->file2_offset, fxr->length,
-			true);
-}
-
 /*
  * Performs necessary checks before doing a range exchange, having stabilized
  * mutable inode attributes via i_rwsem.
@@ -352,11 +336,13 @@ xfs_exchange_range_checks(
 	unsigned int		alloc_unit)
 {
 	struct inode		*inode1 = file_inode(fxr->file1);
+	loff_t			size1 = i_size_read(inode1);
 	struct inode		*inode2 = file_inode(fxr->file2);
+	loff_t			size2 = i_size_read(inode2);
 	uint64_t		allocmask = alloc_unit - 1;
 	int64_t			test_len;
 	uint64_t		blen;
-	loff_t			size1, size2, tmp;
+	loff_t			tmp;
 	int			error;
 
 	/* Don't touch certain kinds of inodes */
@@ -365,24 +351,25 @@ xfs_exchange_range_checks(
 	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
 		return -ETXTBSY;
 
-	size1 = i_size_read(inode1);
-	size2 = i_size_read(inode2);
-
 	/* Ranges cannot start after EOF. */
 	if (fxr->file1_offset > size1 || fxr->file2_offset > size2)
 		return -EINVAL;
 
-	/*
-	 * If the caller said to exchange to EOF, we set the length of the
-	 * request large enough to cover everything to the end of both files.
-	 */
 	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
+		/*
+		 * If the caller said to exchange to EOF, we set the length of
+		 * the request large enough to cover everything to the end of
+		 * both files.
+		 */
 		fxr->length = max_t(int64_t, size1 - fxr->file1_offset,
 					     size2 - fxr->file2_offset);
-
-		error = xfs_exchange_range_verify_area(fxr);
-		if (error)
-			return error;
+	} else {
+		/*
+		 * Otherwise we require both ranges to end within EOF.
+		 */
+		if (fxr->file1_offset + fxr->length > size1 ||
+		    fxr->file2_offset + fxr->length > size2)
+			return -EINVAL;
 	}
 
 	/*
@@ -399,15 +386,6 @@ xfs_exchange_range_checks(
 		return -EINVAL;
 
 	/*
-	 * We require both ranges to end within EOF, unless we're exchanging
-	 * to EOF.
-	 */
-	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) &&
-	    (fxr->file1_offset + fxr->length > size1 ||
-	     fxr->file2_offset + fxr->length > size2))
-		return -EINVAL;
-
-	/*
 	 * Make sure we don't hit any file size limits.  If we hit any size
 	 * limits such that test_length was adjusted, we abort the whole
 	 * operation.
@@ -744,6 +722,7 @@ xfs_exchange_range(
 {
 	struct inode		*inode1 = file_inode(fxr->file1);
 	struct inode		*inode2 = file_inode(fxr->file2);
+	loff_t			check_len = fxr->length;
 	int			ret;
 
 	BUILD_BUG_ON(XFS_EXCHANGE_RANGE_ALL_FLAGS &
@@ -776,14 +755,18 @@ xfs_exchange_range(
 		return -EBADF;
 
 	/*
-	 * If we're not exchanging to EOF, we can check the areas before
-	 * stabilizing both files' i_size.
+	 * If we're exchanging to EOF we can't calculate the length until taking
+	 * the iolock.  Pass a 0 length to remap_verify_area similar to the
+	 * FICLONE and FICLONERANGE ioctls that support cloning to EOF as well.
 	 */
-	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)) {
-		ret = xfs_exchange_range_verify_area(fxr);
-		if (ret)
-			return ret;
-	}
+	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)
+		check_len = 0;
+	ret = remap_verify_area(fxr->file1, fxr->file1_offset, check_len, true);
+	if (ret)
+		return ret;
+	ret = remap_verify_area(fxr->file2, fxr->file2_offset, check_len, true);
+	if (ret)
+		return ret;
 
 	/* Update cmtime if the fd/inode don't forbid it. */
 	if (!(fxr->file1->f_mode & FMODE_NOCMTIME) && !IS_NOCMTIME(inode1))


