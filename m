Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED742218594;
	Thu, 12 Dec 2024 16:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021728; cv=none; b=QFrvKSpb5fMSyu5Fv4O4NK+PwBQr7UK5OJYqe4Gk89wYgSNBgxi8WEtU8k9YRU5PEt9jfJHuwzlqgBOzVIDEfY9iOVpJHwmvxkHH9vf60omRqGHY7ca5o2Am9VgujG0Hs9IxOkLKKFFDo1x3w9+vUp4wk7kFftaqAE9ekTiquec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021728; c=relaxed/simple;
	bh=paxo6vwseOWkJUeTqXv4Buf10P05KHPE5vu92bG+zKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI+aw05j/rNghy9WJuJS82KaGsBY+RhdB4ykHSHvxnpOGhKO/lq1ZG0WizoLNVrgRrUzAJ+Kg6IayaZJv3sdH8QJtkDHfrEjzKVOaMgPK159V3A59UClkk5EEgt0ws1+Eqhi3eyM+iz7FVD4BUW8S/fLJPFg+A/Nvo/hYVouORc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea7C4HK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea7C4HK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A40AC4CECE;
	Thu, 12 Dec 2024 16:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021727;
	bh=paxo6vwseOWkJUeTqXv4Buf10P05KHPE5vu92bG+zKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea7C4HK0ys+RFzbj7nNJ1XgljRmE6pVOUtRFb03YUDce3O61vH8dE39xHNHFUTIFT
	 coDiibpNXXA7Oz7UdLBqDPerXCcJ1Rs4jtopJOLlCK/5IO6UbMWTLK3EZ9kD2zWDF4
	 Msu0icHgYx9iSaZSiGjbFkgvfFVioAViFdt7RORo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 045/565] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Thu, 12 Dec 2024 15:54:00 +0100
Message-ID: <20241212144313.263600491@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1077,9 +1077,7 @@ static int shmem_getattr(struct user_nam
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
 	}
-	inode_lock_shared(inode);
 	generic_fillattr(&init_user_ns, inode, stat);
-	inode_unlock_shared(inode);
 
 	if (shmem_is_huge(NULL, inode, 0))
 		stat->blksize = HPAGE_PMD_SIZE;


