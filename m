Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FAE54654;
	Tue, 26 Aug 2025 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213791; cv=none; b=ezFTXqcqPw/1Emi6UU8qOdKB9bU08nFqAd9J0sqlmGqmuaFcC1sVksjv7JcJBc4kqY36dncfZv6BXw3GCvdtiW42d28p641H8yfOM+o9WwWX8s+gNw+SwD0BLe02WMxnQKRPwvlbMBR9IrOHh6yI/Pu5n96c5d9uYdnx992UGtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213791; c=relaxed/simple;
	bh=Yc/Ce2N6yVLbn4v2daxfO4awpNv6sEFahrYaN76wElY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvIt7FDlF+XonCCcjgBOH9UTx1qTW1WHKV+Nqeh5AFx/bNuVv5QPR3U6nKflc6Msg2mExDnWdkarmLlP7ioe4mc2WzQabr0LSnV1mG1k4LlMM9/x/octcpHMCJieg5QO0Tz0KXRZh+sjL21rUUY4Vs6YxWedCryOXXrefjmVPuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/5z0knc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/5z0knc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5224C4CEF1;
	Tue, 26 Aug 2025 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213791;
	bh=Yc/Ce2N6yVLbn4v2daxfO4awpNv6sEFahrYaN76wElY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/5z0kncQVjhN5+aarDF8DwLNC9PP2/X793dToK4lAsepfU7fx8mI/2M//mFq21sK
	 DLL9YcCTRZfTxCv55ynBaG3jQdsifBiExHfot1JG/bEAvkr/nCbiwStJiSk8SDKVQh
	 553s16X0mIBOHMTQJsSHx68Pf4D6B7NQI2+TLbBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cen zhang <zzzccc427@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 449/587] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags
Date: Tue, 26 Aug 2025 13:09:58 +0200
Message-ID: <20250826111004.380566460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d2845519b0723c5d5a0266cbf410495f9b8fd65c ]

Fix up xfs_inumbers to now pass in the XFS_IBULK* flags into the flags
argument to xfs_inobt_walk, which expects the XFS_IWALK* flags.

Currently passing the wrong flags works for non-debug builds because
the only XFS_IWALK* flag has the same encoding as the corresponding
XFS_IBULK* flag, but in debug builds it can trigger an assert that no
incorrect flag is passed.  Instead just extra the relevant flag.

Fixes: 5b35d922c52798 ("xfs: Decouple XFS_IBULK flags from XFS_IWALK flags")
Cc: <stable@vger.kernel.org> # v5.19
Reported-by: cen zhang <zzzccc427@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_itable.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -422,11 +422,15 @@ xfs_inumbers(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
 	/*
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
@@ -435,7 +439,7 @@ xfs_inumbers(
 	if (error)
 		goto out;
 
-	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 	xfs_trans_cancel(tp);
 out:


