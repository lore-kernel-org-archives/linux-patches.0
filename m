Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9767B18C005;
	Tue, 10 Sep 2024 09:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961267; cv=none; b=M7McJbnRBXZZTLf4dfXJECYVViJoEcRpW/756AW+DaO2Yjf8Tugsl0WJToWYTfgPPvW19AUpm+ulhBiGPOkDzdY8LmmNQ52pRMimVc2FSmP/U4ByRo/6MaGnJ7Ida5L1iyGlQQbFS13hQKh7W7RqyvFCueyB0vdlVTwEWh12sDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961267; c=relaxed/simple;
	bh=qRUEGVMC9b5co553SuUBEG/St9NIQhDRypoy25uu0eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpUe7jMvYNSum6sYA9Pr/zmG153C8l5+MNL9u3SRafDItAg9eKnjBjaDqrTZJGAX2G+Si1W1ZHS6Pg2pPk9in0Au0+D0WnBhqsuvNZ/8sDuZT7hKhNy/RBZ0YFVs3MKDJnSzTgtc/6zoT6JaF1EreQh5K04tSo1TRLIEM0hW/X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qmbguv+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmbguv+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15763C4CEC3;
	Tue, 10 Sep 2024 09:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961267;
	bh=qRUEGVMC9b5co553SuUBEG/St9NIQhDRypoy25uu0eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qmbguv+MMGC2XHnAjrTg1qdpUlr+HhoEp3/VwqDQDTvOtLfSedZTdvvzPLugwURI3
	 078hsZnEnkKn48ZI60YzOxZ1ZVrDiQCFJCtZ8uSsnDCQa8sgoC08F1mTnxJfDJ9p1D
	 Baxu98c2vV0rJwA0m0mHsA571KmW0+oF4jDvC0XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.10 003/375] xfs: xfs_finobt_count_blocks() walks the wrong btree
Date: Tue, 10 Sep 2024 11:26:40 +0200
Message-ID: <20240910092622.384379986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 95179935beadccaf0f0bb461adb778731e293da4 upstream.

As a result of the factoring in commit 14dd46cf31f4 ("xfs: split
xfs_inobt_init_cursor"), mount started taking a long time on a
user's filesystem.  For Anders, this made mount times regress from
under a second to over 15 minutes for a filesystem with only 30
million inodes in it.

Anders bisected it down to the above commit, but even then the bug
was not obvious. In this commit, over 20 calls to
xfs_inobt_init_cursor() were modified, and some we modified to call
a new function named xfs_finobt_init_cursor().

If that takes you a moment to reread those function names to see
what the rename was, then you have realised why this bug wasn't
spotted during review. And it wasn't spotted on inspection even
after the bisect pointed at this commit - a single missing "f" isn't
the easiest thing for a human eye to notice....

The result is that xfs_finobt_count_blocks() now incorrectly calls
xfs_inobt_init_cursor() so it is now walking the inobt instead of
the finobt. Hence when there are lots of allocated inodes in a
filesystem, mount takes a -long- time run because it now walks a
massive allocated inode btrees instead of the small, nearly empty
free inode btrees. It also means all the finobt space reservations
are wrong, so mount could potentially given ENOSPC on kernel
upgrade.

In hindsight, commit 14dd46cf31f4 should have been two commits - the
first to convert the finobt callers to the new API, the second to
modify the xfs_inobt_init_cursor() API for the inobt callers. That
would have made the bug very obvious during review.

Fixes: 14dd46cf31f4 ("xfs: split xfs_inobt_init_cursor")
Reported-by: Anders Blomdell <anders.blomdell@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -749,7 +749,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);


