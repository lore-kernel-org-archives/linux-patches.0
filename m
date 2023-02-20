Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7EFC433D2;
	Mon, 20 Feb 2023 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900909;
	bh=58hEnuvL5xJ1u3CRIRgsTnT8+r56GxNDzMJJVJx0I5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzf+E3+hby18pQFXgoYYRjpWvfMYZmv7Mu0s+W+OtlRSBvKxa28Twzz3WQDS+4zjw
	 eXEWCEBSuyPgXnsbkLBMHM590Oq73X0LZASkP/XuJ2pwkZpT9XMbT16bcUFlxMJA7j
	 S8CYs0XaPESVNmKL6pqxalmUyleRjAPwVHjjNCpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 114/156] xfs: xfs_defer_capture should absorb remaining transaction reservation
Date: Mon, 20 Feb 2023 14:35:58 +0100
Message-Id: <20230220133607.313268132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 929b92f64048d90d23e40a59c47adf59f5026903 upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

Doing this means that the log item recovery functions get to determine
the transaction reservation instead of abusing tr_itruncate in yet
another part of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |    3 +++
 fs/xfs/libxfs/xfs_defer.h |    3 +++
 fs/xfs/xfs_log_recover.c  |   17 ++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -593,6 +593,9 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
 
+	/* Preserve the log reservation size. */
+	dfc->dfc_logres = tp->t_log_res;
+
 	return dfc;
 }
 
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,6 +77,9 @@ struct xfs_defer_capture {
 	/* Block reservations for the data and rt devices. */
 	unsigned int		dfc_blkres;
 	unsigned int		dfc_rtxres;
+
+	/* Log reservation saved from the transaction. */
+	unsigned int		dfc_logres;
 };
 
 /*
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4769,9 +4769,20 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-				dfc->dfc_blkres, dfc->dfc_rtxres,
-				XFS_TRANS_RESERVE, &tp);
+		struct xfs_trans_res	resv;
+
+		/*
+		 * Create a new transaction reservation from the captured
+		 * information.  Set logcount to 1 to force the new transaction
+		 * to regrant every roll so that we can make forward progress
+		 * in recovery no matter how full the log might be.
+		 */
+		resv.tr_logres = dfc->dfc_logres;
+		resv.tr_logcount = 1;
+		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
+				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 


