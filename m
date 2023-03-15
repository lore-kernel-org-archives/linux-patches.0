Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C94431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE2EC433EF;
	Wed, 15 Mar 2023 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883311;
	bh=Kxzp0WkM7C8HohFwB+qHemJadR7+CtPtYdWoZ57ZbdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iVa2RcyFZ1UjZIE9iEWy/WeGwiVWbQc6sV98yWFzbMiFD839T4Fdl6VdHoA0u4ww
	 9oCefOJ9H5OlsfMVDjHOhnVk3JIPsc98wyn6wohKfLgkhbYgNlppykqtxDfG9wzQpQ
	 Q8eQxRRUou4/NboBy9Vvvzihkma781yQzR2IdQRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/145] xfs: remove XFS_PREALLOC_SYNC
Date: Wed, 15 Mar 2023 13:12:41 +0100
Message-Id: <20230315115742.118046006@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit 472c6e46f589c26057596dcba160712a5b3e02c5 upstream.

[partial backport for dependency -
 xfs_ioc_space() still uses XFS_PREALLOC_SYNC]

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 13 +++++++------
 fs/xfs/xfs_pnfs.c |  6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 240eb932c014b..752b676c92e3f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
 		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1059,9 +1057,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1084,8 +1079,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 8865f7d4404ae..3a82a13d880c2 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.39.2



