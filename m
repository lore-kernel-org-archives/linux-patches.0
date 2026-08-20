Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF937CD28;
	Thu, 20 Aug 2026 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238995; cv=none; b=fo0qAgWpd35Z/nDjGIUv0qd92zQjiDglNBQKwLu7urbBhQPnWYRJgqfQRTtxGSQHCtxN/ogWYGZUJgkBc857++4AOC4R0esoDwiYYiGOaCb7v5/oeVNCRVcFg8n2PQkk2P4W2+8WRcLFgjYtjNFhYG4ktxO2PmgwlZC7/ex8XpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238995; c=relaxed/simple;
	bh=YgW2G6BbNyHfzKB9jZH7lBb7esjiEyhhxwrARSGuVEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P58XR93Z+iuvis2oFa4O+aiDMzJP/NUmQ26Mx2pd4Z4eicv3c5XEb89N/JQvGJ07JYEOlEH4hnblThXDkSYfgB5u+4xWYhB0LWTJ2IFUXaVdyleAtDsO5M3DUYGlUtEQA2hfsQ4yn6v3H6ORdDUs5HuP7Eb01T78VSwkE8JfL5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPkODzPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPkODzPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0E11F000E9;
	Thu, 20 Aug 2026 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238994;
	bh=5gOPA8icNY2QotsmsAGbqdxEhB7tok83IzICCR6td3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPkODzPZ5uwFFR6Q3vYHqscLFTVUiUHjUV5o6q8uWQ544ypHLy/mPyX2hcgsXg6Rs
	 B8zTff7LGGlNmdvBJQuJgSAsWmxiHi+WP175AJtkgg0EmO9OHJjja3P/EtGosFJun/
	 aobTjRF/uq6VeGcLGdL8d8Gtu6okCVc6TbdvmlCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 112/217] xfs: dont double-lock when deleting a self-referential directory
Date: Thu, 20 Aug 2026 16:54:40 +0200
Message-ID: <20260820145241.112304033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 5fc643fb86599e29b38e7b2c2680b4b15bf8f772 upstream.

LOLLM notices that the dirtree scrubber can detect a directory that
refers to itself.  In this case, it's not correct for the directory tree
repair code to try to iolock/ilock both sc->ip and dp, because they're
the same inode.  Fix this by detecting that corner case and handling it
appropriately.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -349,6 +349,8 @@ xrep_dirtree_unlink_iolock(
 
 	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
 
+	if (sc->ip == dp)
+		return 0;
 	if (xfs_ilock_nowait(dp, XFS_IOLOCK_EXCL))
 		return 0;
 
@@ -400,8 +402,18 @@ xrep_dirtree_unlink(
 	 * directory code can handle a reservationless update.
 	 */
 	resblks = xfs_remove_space_res(mp, step->name_len);
-	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
-			&resblks, &sc->tp, &dontcare);
+	if (sc->ip == dp) {
+again:
+		error = xfs_trans_alloc_inode(dp, &M_RES(mp)->tr_remove,
+				resblks, 0, false, &sc->tp);
+		if ((error == -ENOSPC || error == -EDQUOT) && resblks > 0) {
+			resblks = 0;
+			goto again;
+		}
+	} else {
+		error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
+				&resblks, &sc->tp, &dontcare);
+	}
 	if (error)
 		goto out_iolock;
 
@@ -489,9 +501,11 @@ out_trans_cancel:
 	xchk_trans_cancel(sc);
 out_ilock:
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 out_iolock:
-	xfs_iunlock(dp, XFS_IOLOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL);
 	return error;
 }
 


