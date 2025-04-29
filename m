Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D9B239072;
	Tue, 29 Apr 2025 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949071; cv=none; b=Zdt92SNK1hv25sJvfKEsA9kNtwS6XccWoAt5gtRCudUbgeItKtPsf1YPJgUPZGihmiG3C0Tgi7yB7G05e6mDrjePe0vki6bcvxRTDYiEH77kl2eYUY3dXleVusjMvB1e/COmID7qUnf/r/pp0Js8kmttRjrTXh3B5H/C+7danKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949071; c=relaxed/simple;
	bh=PNqyWHymR0wOZ0k/qOzZbhgusK+lKCykqF9ltot5UlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl/1U1abCtrd8KrWlNYSMc2VxHyZGFFAVapeKoofyyWEmmzfDXZliDhzdw6rMkGDS9ZOxm86fe4GDo45KFPmZJWI3MIeRByDFtmjPHzP+BtLXGsPif7Jmf83MVJKALUJIXRNXP2DbdRzQVfvYSRW0JjtG6RNG/UkpzWCReOpIX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZOUgZBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZOUgZBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7125DC4CEE3;
	Tue, 29 Apr 2025 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949070;
	bh=PNqyWHymR0wOZ0k/qOzZbhgusK+lKCykqF9ltot5UlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZOUgZBAC4AguIt1yBZGzjfRm6uIkwhdRtdqHMM2MUKamgkRnfuQf9bGhnkOOmPQ0
	 Rhzh6jU7Xu/8zJXW3NM8vX0g+x/u4vjgK55PLtSUIKLMoCbTL9phE6bYe/Bk8BNEK8
	 GhUumxPQsTU1DgJs1O9VQTtIA+2na3VhRTlGL2Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 205/373] filemap: Fix bounds checking in filemap_read()
Date: Tue, 29 Apr 2025 18:41:22 +0200
Message-ID: <20250429161131.597706216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ace149e0830c380ddfce7e466fe860ca502fe4ee ]

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
(cherry picked from commit ace149e0830c380ddfce7e466fe860ca502fe4ee)
[Harshit: Minor conflict resolved due to missing commit: 25d6a23e8d28
("filemap: Convert filemap_get_read_batch() to use a folio_batch") in
5.15.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2617,7 +2617,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
-	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	pagevec_init(&pvec);
 
 	do {


