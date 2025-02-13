Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D5526B080;
	Thu, 13 Feb 2025 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458437; cv=none; b=LpTiipAUbV9hM0O9hP9ZQ6Js2mXwkQ7q2rFbm7VRKCy1QF/gbwHZ/JAZsWWdwb2e8WMqVExrbv8T1y1j2aeINmgoY3R8OmAtOP8prCCs8rwlP2bIKDVqamwO0rQUy2UEkkYO4Ks5cur7lsvniDsa8ENtS0KTVqEL4M+gFUveLZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458437; c=relaxed/simple;
	bh=aj0575NWcbe7M4ImoPMUSHOaAafs3bM3AFkgZyBOh4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCsr3yATVxBruyZ6SIXBFPzOz7UEeXOmuEapegpAHBLY2u+fM5Vzf+D9d/Ps7xCgTYVhaarBTn77TeVvIMA9YyKty6+jJtYZ1My5C7rqFC5wNhIf+JyhHQZA11dfFXHyglEAePYb0xdYdylJuA36x2Jat63iVOQNU4rUEMmzJog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMM/Wz5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMM/Wz5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9C7C4CED1;
	Thu, 13 Feb 2025 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458437;
	bh=aj0575NWcbe7M4ImoPMUSHOaAafs3bM3AFkgZyBOh4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMM/Wz5/ptZ92W3PWJcVLu82tJno3vY4zf0q/k/kMrS8k/mrQ3fVvomJ8yt2kqmMj
	 lD/lBfWWyQjgkzLeFyDtC6KlzbgCCOgAgFj4eU1jhgP0HtYFEkXs2QjqHdcIdYA0nc
	 UyHMbNS4T64Uzd6F6W1BY5FtevgsqH4ilpIG7C/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 398/422] xfs: dont lose solo superblock counter update transactions
Date: Thu, 13 Feb 2025 15:29:07 +0100
Message-ID: <20250213142451.905703331@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit c817aabd3b08e8770d89a9a29ae80fead561a1a1 upstream

Superblock counter updates are tracked via per-transaction counters in
the xfs_trans object.  These changes are then turned into dirty log
items in xfs_trans_apply_sb_deltas just prior to commiting the log items
to the CIL.

However, updating the per-transaction counter deltas do not cause
XFS_TRANS_DIRTY to be set on the transaction.  In other words, a pure sb
counter update will be silently discarded if there are no other dirty
log items attached to the transaction.

This is currently not the case anywhere in the filesystem because sb
counter updates always dirty at least one other metadata item, but let's
not leave a logic bomb.

Cc: <stable@vger.kernel.org> # v2.6.35
Fixes: 0924378a689ccb ("xfs: split out iclog writing from xfs_trans_commit()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -834,6 +834,13 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
+	/*
+	 * Commit per-transaction changes that are not already tracked through
+	 * log items.  This can add dirty log items to the transaction.
+	 */
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
+		xfs_trans_apply_sb_deltas(tp);
+
 	error = xfs_trans_run_precommits(tp);
 	if (error)
 		goto out_unreserve;
@@ -864,8 +871,6 @@ __xfs_trans_commit(
 	/*
 	 * If we need to update the superblock, then do it now.
 	 */
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
-		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
 	xlog_cil_commit(log, tp, &commit_seq, regrant);


