Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE281F4629;
	Wed,  7 May 2025 18:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643597; cv=none; b=jXDZYy0uuvwLpIQP3XDFdAH0d8+B/1rh8EfUpQVF7g69eOLZpHzfZG1eOLMskk05xvRDM0olXz/0tIZH5pLeH523NtkT/ngYruUrD49+ZNuMQrSNecflqkBAwXKTshdyVk+C7pmp2lw62m5ucaO567eOGRL+tF7UFuqhGMNusuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643597; c=relaxed/simple;
	bh=4auQwhttyekaJKrfq86RhCOSZ4xWqws/l8PAzF057x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLaliBtdL8RZLOdAyUb4dyj/1vo+ztqXkNZlEJu+iCIjTlmkpDHsfCuBv2Ba2ebd5NxuQzXTGDdVVDKdk+st2m3ncGB+Cs/V3QhBECuQXmQc/zvs/Ts391iPJqRUOtfZ0H5COKei1UHruu4TrxjkCQe5+3EtXpBxC4ZAS12V95E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL6gFBFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL6gFBFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF29C4CEE2;
	Wed,  7 May 2025 18:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643597;
	bh=4auQwhttyekaJKrfq86RhCOSZ4xWqws/l8PAzF057x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL6gFBFG7pWLh/Pjf6DmlMLsyuH3/2rIISIw5ii21RmTMr5vynd2v5ZFSfhvD7Tc9
	 QXLegu64L+GCM5Ce9GS8G45rReH48trcXBGlk+kBdcptKfsPxUILUnz13Lud6lA7H2
	 jMyym5U5Jnz5vEIjVVc1OHqne4rZxs0rZcPAUC6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 25/97] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Wed,  7 May 2025 20:39:00 +0200
Message-ID: <20250507183808.000939840@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 86de848403abda05bf9c16dcdb6bef65a8d88c41 ]

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -718,12 +718,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);


