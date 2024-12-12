Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AE5222D73;
	Thu, 12 Dec 2024 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023632; cv=none; b=jLZQsKZvSLd1FmdLE5zcabmlDVwk8TrSJgyF/HYXmQtPjNuNArj6d9Fhrd2Tsd90ciciJ4i4vHH3+yBZkMrjSXsgBk+NHJjy5txo4ha30/QMTyWrPl2cRsRAGR/4Nuv+nNmXbxxbRkW0dOPiVitOQpBOttaHQINV9VJUQ9Mz2Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023632; c=relaxed/simple;
	bh=2IFZ9pFZXHYVHfaTrFFocpoTZ9yaL6sHH703U1u22mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoBN7X22Zg3lokFrYAnnM5TCQVUoW8q8QCyeyguLjdmOnTcz5Mumkbhc5tc9xbwL2nvEmfDbacPzPF2Ycw1Frpic+kLpgo1TUiWF5Z8IV6nG4al1GZ4bmi35BSfdGOHq4VWtnk5aiSBhoDhm7x2RrThguH+QiuS7V560xjW1Yd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5DuJfZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5DuJfZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65925C4CECE;
	Thu, 12 Dec 2024 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023631;
	bh=2IFZ9pFZXHYVHfaTrFFocpoTZ9yaL6sHH703U1u22mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5DuJfZlRVGPXhYmj+Buw4RGe7jVxw+y1b22dl63qIHzEcGpE6pQ0dZao0wZPY6va
	 0SvQNG8DXPItJqk1/qeGdpIfmo+ea+BKsKiK5luaY6ZAiuUaMjyQdtE+UebAf4uF4G
	 fYzxgtwPHyNqP2d3MMca9nhyKya4LqPczioJxf5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 031/459] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Thu, 12 Dec 2024 15:56:09 +0100
Message-ID: <20241212144254.752169537@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1077,9 +1077,7 @@ static int shmem_getattr(const struct pa
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
 	}
-	inode_lock_shared(inode);
 	generic_fillattr(inode, stat);
-	inode_unlock_shared(inode);
 
 	if (is_huge_enabled(sb_info))
 		stat->blksize = HPAGE_PMD_SIZE;


