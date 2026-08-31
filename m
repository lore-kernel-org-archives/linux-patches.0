Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0005044C51E;
	Mon, 31 Aug 2026 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183703; cv=none; b=INC6aZ9pMlLRSRDVeY/czpqhi7XOMh7x3WbeiQpGtVFPqunF52EjBaIES65jcgbJ86uqEnYifIJXGusCNA8/UVOsoFBOpWzBw+mZtjn/4B+hNfm3x9HOQeM56Kx99zWRVX8fQ5FGMUBjfztVJIs4ueqDxzU5ckiqKgP7wpd9jVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183703; c=relaxed/simple;
	bh=jC6MrLqylI4Qw1fcFMR+7mNrLbSuTRVNZyIIdM2yE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOubs/LTdW+3Ssw8Ow+QmSBM8GBuqYd707J8rKAz5JoME71vTfet3O06PGlz0FD7kzVivsXl3Q9794VyABBHN8tqlaRjbf6b51SWykbduguSghD9CdnvdS5EKnRqI7s7GEi4STmiFxqaBqlJgdx5YZ3gvi4vRRrL6rcxAHaRgig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ83ybjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ83ybjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5854C1F00ACF;
	Mon, 31 Aug 2026 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183700;
	bh=yDbfwHDq8tuUy9BQF0yQbnpfEVRI3nuPygkVcSx8zsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQ83ybjXbE7cFiL9Klo7V8tHskU441B8OPqjZgKv6aDiPXvHQhAC8/NXf7qf0+CAU
	 /kvX1aVi/3Rm/Sn1R6lMeKhyBfN2cQLyW1nQC/R/BDUtvifDjERlxhXCE5G2eSxs5B
	 50p1TUJ0YQ+9XYr0eZYHgy37X9t1a4mXXv4+S1mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 14/76] ext4: move partial block zeroing earlier in ext4_zero_range()
Date: Mon, 31 Aug 2026 15:33:46 +0200
Message-ID: <20260831133359.918150052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit b16e9d27a643a3cf8907c994d25ed52717f36418 ]

In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
handles unaligned edges, into the same branch where the unaligned range
is preallocated, immediately after ext4_alloc_file_blocks(). This is
safe because there is no dependency between partial block handling and
the subsequent full block handling.

This change will be used by later patches that handle unaligned
FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
zeroed result.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-5-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d19d239ada9b ("ext4: write back partial-zeroed edges in WRITE_ZEROES")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4796,10 +4796,16 @@ static long ext4_zero_range(struct file
 	}
 
 	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
-	/* Preallocate the range including the unaligned edges */
+	/*
+	 * Preallocate the range including the unaligned edges, and zero
+	 * out partial blocks if they already contain data.
+	 */
 	if (!IS_ALIGNED(offset | end, blocksize)) {
 		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
 					     flags);
+		if (!ret)
+			ret = ext4_zero_partial_blocks(inode, offset, len,
+						       &partial_zeroed);
 		if (ret)
 			return ret;
 	}
@@ -4832,10 +4838,6 @@ static long ext4_zero_range(struct file
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
-	if (ret)
-		return ret;
 	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);


