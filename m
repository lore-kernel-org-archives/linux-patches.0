Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2518119E992;
	Tue, 12 Nov 2024 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407533; cv=none; b=dM6gqV6F5BeX0S8M4rl3ZcHANcMWKZhN7+JEkqExF3sF9fgfRzURi9J5K4b5QYMK62u+POzVARn7eC9uGHjfokWAyaTxg5ieE7uVuV9y/WvvwdZ8W48YCCj6yC/IA9FNX4oZiOAQg2xmidAxl33s6KzrsBMxpK974N1zPYKkGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407533; c=relaxed/simple;
	bh=Q3zIB7a/7bDHvlaS4yfm4q75HLWYlllQfRnwyWr8jKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMZNrp58VjR+WvfalmM69YkIQPJbDrx/vKSII9ge0HjWYbm3wnrpj9IAj/Tw3zSfZLs5sQeLCteNFh2uQlCr5LHejOB11H1t7AhINIrNLSK6i7bBGiq+yLXkzvnOLRzYgQCtPbxhoY30wuDxUvWi6AVPb8ygnP1Y2q5/3RJf6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qimcLsFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qimcLsFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939D5C4CECD;
	Tue, 12 Nov 2024 10:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407533;
	bh=Q3zIB7a/7bDHvlaS4yfm4q75HLWYlllQfRnwyWr8jKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qimcLsFGxWgu5XB0og0sSD0WFORGuPHHVnYEzIlEe/2jeaFw8RNyMUh9DQ03r/bmM
	 bYOMHBI0VSiDWP+f63gP+i5ImLeGMeC5QVsmToUH8vC2RKHdlipmmvc+LBB68dBu3N
	 umOdezcnyHwG9TbCFURUK5RWA+OvDFiaWu38lNt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 81/98] filemap: Fix bounds checking in filemap_read()
Date: Tue, 12 Nov 2024 11:21:36 +0100
Message-ID: <20241112101847.336751176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ace149e0830c380ddfce7e466fe860ca502fe4ee upstream.

If the caller supplies an iocb->ki_pos value that is close to the
filesystem upper limit, and an iterator with a count that causes us to
overflow that limit, then filemap_read() enters an infinite loop.

This behaviour was discovered when testing xfstests generic/525 with the
"localio" optimisation for loopback NFS mounts.

Reported-by: Mike Snitzer <snitzer@kernel.org>
Fixes: c2a9737f45e2 ("vfs,mm: fix a dead loop in truncate_inode_pages_range()")
Tested-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2738,7 +2738,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
-	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	folio_batch_init(&fbatch);
 
 	do {


