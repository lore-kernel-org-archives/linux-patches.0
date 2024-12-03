Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB4F1F759C;
	Tue,  3 Dec 2024 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242173; cv=none; b=WYBS1KXH22iIzGevECAF8M/PRBOleFB8KQuBZnCeWXcFNM/p8+Re/3wtjVz2/IJKFN+oKBSYqXlTs1mQHp3h4loLYw6eag1G+cMc5LeIAxLx+Z7tKLX33uwwv/Q+zJQtP9OMNUXOyI9G6y2bP70Q32GtMFn+XfXcoeJNuOPCQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242173; c=relaxed/simple;
	bh=Gq12G96hvRf600rs4co9QQ2eW8oNcSTIms2Lb/bVQCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEVjly4FG5zHRZcF/MEBUAc8hGyOlDJlZUkEBqURhvL8zin++gdfVAJ3osHmGSJv8WqFnA9zVr+gf6te6lagboAc4zqHtJXnuidbqSCVb5PtNwcUhYxxx9TFB6UMguMIo13w5mvA2AzHMvFV9OBuzZdZp4xEI0oh2szSMLKDPls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1KQT0OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1KQT0OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4763C4CECF;
	Tue,  3 Dec 2024 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242173;
	bh=Gq12G96hvRf600rs4co9QQ2eW8oNcSTIms2Lb/bVQCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1KQT0OX7DShq01pVILrEkfs/1CJy/G//JgQodezo73Y3aOpqPAfmOtnGTUCSYqxj
	 e8wrXSdXtV77ClVwz1315TJXA917TTQ0MIWhrfIReSwPaiVEC9YTK44NblkoFl7Y2T
	 iFhD5q7JNAYviughOOWDpV1/Y9PgVU6wMgGDOPzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 629/826] xfs: fix simplify extent lookup in xfs_can_free_eofblocks
Date: Tue,  3 Dec 2024 15:45:56 +0100
Message-ID: <20241203144808.288987663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Darrick J. Wong <djwong@kernel.org>

commit 62027820eb4486f075b89ec31c1548c6cb1bb13f upstream.

In commit 11f4c3a53adde, we tried to simplify the extent lookup in
xfs_can_free_eofblocks so that it doesn't incur the overhead of all the
extra stuff that xfs_bmapi_read does around the iext lookup.

Unfortunately, this causes regressions on generic/603, xfs/108,
generic/219, xfs/173, generic/694, xfs/052, generic/230, and xfs/441
when always_cow is turned on.  In all cases, the regressions take the
form of alwayscow files consuming rather more space than the golden
output is expecting.  I observed that in all these cases, the cause of
the excess space usage was due to CoW fork delalloc reservations that go
beyond EOF.

For alwayscow files we allow posteof delalloc CoW reservations because
all writes go through the CoW fork.  Recall that all extents in the CoW
fork are accounted for via i_delayed_blks, which means that prior to
this patch, we'd invoke xfs_free_eofblocks on first close if anything
was in the CoW fork.  Now we don't do that.

Fix the problem by reverting the removal of the i_delayed_blks check.

Cc: <stable@vger.kernel.org> # v6.12-rc1
Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4719ec90029c..edaf193dbd5c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -546,10 +546,14 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Check if there is an post-EOF extent to free.
+	 * Check if there is an post-EOF extent to free.  If there are any
+	 * delalloc blocks attached to the inode (data fork delalloc
+	 * reservations or CoW extents of any kind), we need to free them so
+	 * that inactivation doesn't fail to erase them.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
+	if (ip->i_delayed_blks ||
+	    xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
 		found_blocks = true;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return found_blocks;
-- 
2.47.1



