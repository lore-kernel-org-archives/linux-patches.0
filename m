Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B81A29A;
	Wed,  7 May 2025 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643541; cv=none; b=Yufw7jdWYXqkh1zLLRDZmaftTDjx93y8+CRO230ToqUQOidhz/GCgsQU6tB4IXVDt8VankvIBpHzOmJK+HZeGa+QX7pY/TMDR1pdSf6awa3ZxQt/AqJDo7KAYXHdzNI2kdE2TMlhR6ihIi2D0NY/5paKzcoOhxO51QtqsrvrOc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643541; c=relaxed/simple;
	bh=HpmRBTxqHjD/Z45+qNUAVjwwCy+ulGoB3uH1+cP/csg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGu3gSLhxT3vtCMvTUO5OUsOeJR2Rm61Ea95oGYYKbrmd4R5/6SdBthMQnwCjtbdCt+dyEVjr2Q0ppiO6HU3mwy3NX6vKRwxHKYgKXsqDDeiqh5Dpb1uUNJNJQxgbWCteFDDxEK7KgVLjmkk4b3xSmAXTxAJtVsDEF0GD/EubtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNTwPHbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNTwPHbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC36C4CEE2;
	Wed,  7 May 2025 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643539;
	bh=HpmRBTxqHjD/Z45+qNUAVjwwCy+ulGoB3uH1+cP/csg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNTwPHbtzg70NF1CwhaKklwyafz4ZwYQYy3JovRQib6PYe3EcXtjS9G4DJmR1m7i0
	 7sa6nhqd8m+zyoP+d8nXuaAeyyQAfBTwCtZ8rvcXqRTnRqWvFyKIDxxAr/5mEvP7pM
	 pGrRtiEH9zWsymu5bUkDurBEcbG09lmxGRLglcUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 37/97] xfs: allow unlinked symlinks and dirs with zero size
Date: Wed,  7 May 2025 20:39:12 +0200
Message-ID: <20250507183808.486021624@linuxfoundation.org>
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

[ Upstream commit 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3 ]

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -370,10 +370,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -511,9 +514,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)


