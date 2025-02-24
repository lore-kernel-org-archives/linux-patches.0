Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE97254845;
	Mon, 24 Feb 2025 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407851; cv=none; b=IPYVJlbqvcjELN+CmrjAjisUIzOqWa2sB55/ASgXKh6T4jlrv3JnnMl8H6dZVoNmV1plWAnYv/922W+Sjw99IranpZDdxXkbSWvkzGVnRimPQM62j7FNwYcNY+c1Vr/dbK6sRl+1OXivjoQm+dmlFMn2YSbZZgZx3rRfNwOUXJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407851; c=relaxed/simple;
	bh=HSx+LVZP5gtcvuRpUZpyzzLrh9VW8HoEzDvbFotnGpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG1PMzCLa3ki4GRT5XUySIDqsrEpJuWmC3qoKZC/xGNzj7viVe3D4C4uHglt4nqo0kVdTSgLmIkCGBSB+f3Mobr9l2sVcUcpbSl5zw+1htrZ6eXiZHgal1i+ERYw9mm42clDbZRz/B+ksCoGFqG9OIOWratfZMJSESN9ebrr25Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibdp72fN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibdp72fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE70C4CEE8;
	Mon, 24 Feb 2025 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407850;
	bh=HSx+LVZP5gtcvuRpUZpyzzLrh9VW8HoEzDvbFotnGpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibdp72fNjVNSApgpvNaOnifP1b38oLPFApa+qjGl9F/wt3CMydMK6uosdtqw9JPhq
	 3m9bGDjAN5N9Kbi2nGf77B3u2EvCzw2INrkSHTxHxjwN5WLYPsE9EohJSQM8AhGMuZ
	 M3ThoY95RoTNm6uNmttduMfv445rQ3/uxz699lbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 004/140] xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
Date: Mon, 24 Feb 2025 15:33:23 +0100
Message-ID: <20250224142603.178880987@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit de55149b6639e903c4d06eb0474ab2c05060e61d upstream.

While refactoring code, I noticed that when xfs_iroot_realloc tries to
shrink a bmbt root block, it allocates a smaller new block and then
copies "records" and pointers to the new block.  However, bmbt root
blocks cannot ever be leaves, which means that it's not technically
correct to copy records.  We /should/ be copying keys.

Note that this has never resulted in actual memory corruption because
sizeof(bmbt_rec) == (sizeof(bmbt_key) + sizeof(bmbt_ptr)).  However,
this will no longer be true when we start adding realtime rmap stuff,
so fix this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -449,15 +449,15 @@ xfs_iroot_realloc(
 	}
 
 	/*
-	 * Only copy the records and pointers if there are any.
+	 * Only copy the keys and pointers if there are any.
 	 */
 	if (new_max > 0) {
 		/*
-		 * First copy the records.
+		 * First copy the keys.
 		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+		op = (char *)XFS_BMBT_KEY_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_KEY_ADDR(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
 
 		/*
 		 * Then copy the pointers.


