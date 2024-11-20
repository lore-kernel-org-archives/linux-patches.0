Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82271AA1E6;
	Wed, 20 Nov 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107588; cv=none; b=vCji5zAmCWwERCRA7j1C+KwacUl34wESIw0Zb0Gwat+/E16kUIHnoPFX2MbAIlNAsvTuVHUtG2vLsGfwgWgJaBIuooftXFlfxKFsYPvLlQYiIj9a2a+8iWcd+fEDoLmyv7DD5eX3S0/SF27llnZr1SJsPK61v02IsSZ3sXEbo5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107588; c=relaxed/simple;
	bh=cyvv44L/x++9tW9RBp9mnUWFXIKj7rfwbTue36dNfvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncO+BqbsVIQy08YWI7EniwnFLjWD8Ha0sZ8EjAfm6uYQ/n0tcmRJNojMRdR4OPNBcS4xclLiUpTnYfr1XpidslMts5ekZkGtBvwCLjZnwYQFxm8h2/M+E+mcsXR20MifMlTwbU15VK8H5TSQb2mDtbd9qsmtRY3C4mOamubuIVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS+IiQwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS+IiQwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90749C4CECD;
	Wed, 20 Nov 2024 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107588;
	bh=cyvv44L/x++9tW9RBp9mnUWFXIKj7rfwbTue36dNfvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS+IiQwF4iI0csnLPp+Vj2l5I7izGt8gGsTkYa+ws0UK8is7iHjoXmKFT4s2Cixtn
	 aJv8jsBbyP0uF6qFQdQC+6HBPOcR0uCZlAriftVOwYkyNDutSBSo91LhEwpOrw4RbR
	 ivyVQFtnYGBm+8T3dhGjqjOB83lY0C+YFJeRqALc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 31/82] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Wed, 20 Nov 2024 13:56:41 +0100
Message-ID: <20241120125630.313017665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1158,9 +1158,7 @@ static int shmem_getattr(struct mnt_idma
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
-	inode_lock_shared(inode);
 	generic_fillattr(idmap, request_mask, inode, stat);
-	inode_unlock_shared(inode);
 
 	if (shmem_is_huge(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;


