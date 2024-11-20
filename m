Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E281ABEA2;
	Wed, 20 Nov 2024 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107710; cv=none; b=h+YGNbSdZgOmSrET+Snu7/vIhoDbxCIarCNik+Py4nICPN4TKNBEgRAWU0eVfytw+bLmehFnHvUtUUatv4TMvk7W+MLU5LUTEfzyqENuqmyHA15fnj4u2yA1iCZT5waJMmSo/g+RvfA1qbZXelE81Adbp6w2zPVyiTN/VjkkcpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107710; c=relaxed/simple;
	bh=bDy159I1RQys9qSC5EjHxYDRBc6OCo+KDJpkNZfbkdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O49wDJI7hzJtCZ+R751IuzrD6QQpvar1wC1REIYyRKq0qUrl2EPdQ0OvyW+J08uhfm+SzTVHDKM/6rqTmaiw6mHGvQ3Vf75qrU2+8JuYMWafFKVUnIezqKXeCossKv3UDbXBkTuSy9GoGCBa8zqwzpGSkg6C2eBvZV72+S0sOlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOJqAkKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOJqAkKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAABC4CED1;
	Wed, 20 Nov 2024 13:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107710;
	bh=bDy159I1RQys9qSC5EjHxYDRBc6OCo+KDJpkNZfbkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOJqAkKetPR6ABsg3qcpGr6SLo8YizoQy4ZHW17hucH0WQFAicFSC8morMOSrURnC
	 w8V5vPrrwClmuecjNUSvhe+CWv3hKb6sqq3ShJOSlZvOVyBYj/xly5RwSnr9ilSYiD
	 OnEPlc0lJGp3YyPw9Wdnir04KRg3b34Y19amD1wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 61/73] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Wed, 20 Nov 2024 13:58:47 +0100
Message-ID: <20241120125811.074260757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1086,9 +1086,7 @@ static int shmem_getattr(struct user_nam
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
-	inode_lock_shared(inode);
 	generic_fillattr(&init_user_ns, inode, stat);
-	inode_unlock_shared(inode);
 
 	if (shmem_is_huge(NULL, inode, 0, false))
 		stat->blksize = HPAGE_PMD_SIZE;


