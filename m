Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA516C854;
	Thu, 12 Dec 2024 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025060; cv=none; b=TvUa3Fxl0kMzzRLEkYDyJkrDJ2iKyiZKnG2m6SLmMnGF0cvMddjKBZONEVncOpqM3qc1Ztdx4F1FMeUOMeiSEB/mq9ebjvN3aLHpBKvJVw1E12+4vdA6WGn/arL3Ax2SBCr8Kid2JPFN0icYWd+1VfjvayyeO5cfOuqRsNzxl9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025060; c=relaxed/simple;
	bh=Pu6VwJU0mYTMrMBPsVisIOt/TDfLI7YhX/YTA+a+0Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLN1g3twFTB3/7ZlOCZFpIl5QQAYVz4+Ifr6E6OHacrBrpkW5PyMr0NudLQPKNFBTi9vypwaDcmmCq9V3G2l1mUIptjHHitTEdZH8PKJG26rzWgTSOiGp6O2MwPWssYNt0m+dCatVKGAHsDuaRXfrA7md0qXEnoC1a2fVlW9GKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sX5iZDuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sX5iZDuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F7C4CECE;
	Thu, 12 Dec 2024 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025059;
	bh=Pu6VwJU0mYTMrMBPsVisIOt/TDfLI7YhX/YTA+a+0Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sX5iZDuENs0t4WYn0wdcXXEteHkd/jn6Yqsjeh3nGgIkctbI1wiqUwo6xUBSXC9aC
	 U3BUCu8Ulj+yGrg95mdMMD7wSLj04FcltoaVAgeNAc6OR9nidIOYa+1Q/Z1Hlj0Ous
	 NzDBt59gdJpPiKd9VFNJq7ITS7PSmKGkKQEd/cPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 012/321] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Thu, 12 Dec 2024 15:58:50 +0100
Message-ID: <20241212144230.133065632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit d1aa0c04294e29883d65eac6c2f72fe95cc7c049 upstream.

Revert d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()") as
suggested by Chuck [1].  It is causing deadlocks when accessing tmpfs over
NFS.

As Hugh commented, "added just to silence a syzbot sanitizer splat: added
where there has never been any practical problem".

Link: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net [1]
Fixes: d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()")
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1011,9 +1011,7 @@ static int shmem_getattr(const struct pa
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
 	}
-	inode_lock_shared(inode);
 	generic_fillattr(inode, stat);
-	inode_unlock_shared(inode);
 
 	if (is_huge_enabled(sb_info))
 		stat->blksize = HPAGE_PMD_SIZE;


