Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892CC1A704B;
	Wed, 20 Nov 2024 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107518; cv=none; b=JVwqRlX4f3df78X+qYCh6jfSo7ZokR/btUN1yLJkbZ21LW/NqKuFv9wxxWrtWEKY9ZGy7MLW86eeUKsXWXKRlHcHYeDT3qgZOLbZmgQQ6dX+QHZ0BAWyMav1zpxBxsBekr1ed07579Uh65eyxMSScj3LKg6geKrCOjnWFKkSzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107518; c=relaxed/simple;
	bh=DwlPtRSSWvl/bX1vm+4vyLGpGTl3POX8ueUMBo08lxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR5mwNfiDRPtfW++uyqVxGVa+SfiFPGTxYpTQfD0JMN3FW2ERIWE7CU9E0YzCfdysJhwC9izmRYSRB5UfTlhfvLtk7eoC/32k5XjoRSYGGVeRtYk1HOkDpZ7aisNmwo832d+CPn7ted0VM6UTRX8ht9vFtZEgJHlfywxE6v5IXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGAwLQP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGAwLQP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1EFC4CED1;
	Wed, 20 Nov 2024 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107518;
	bh=DwlPtRSSWvl/bX1vm+4vyLGpGTl3POX8ueUMBo08lxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGAwLQP+2g5C0R13xCzCV6WHCTHYi/eRPSBE8zCkEV581fsUrXFCeGSmbhAAWjkqY
	 ZJUJXtn6U/Ao14RNOx+Jktk26ZZC+aqfFHhwouO+zhS0WXZNOJZzs7Sy6vbaFQFsIJ
	 WQJ+QUoHCDsgahZNLpUV7GdQesdIIRIYHzsOLyHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 048/107] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Wed, 20 Nov 2024 13:56:23 +0100
Message-ID: <20241120125630.759755487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1163,9 +1163,7 @@ static int shmem_getattr(struct mnt_idma
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
-	inode_lock_shared(inode);
 	generic_fillattr(idmap, request_mask, inode, stat);
-	inode_unlock_shared(inode);
 
 	if (shmem_huge_global_enabled(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;


