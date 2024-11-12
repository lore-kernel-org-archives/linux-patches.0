Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85657215015;
	Tue, 12 Nov 2024 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407849; cv=none; b=b0FhDFSlzQYnR+7dyjNtvexOo88M3IN+3ncXmzkFTw+0hwJXqPUAGqWMg20QCUVkm7CcRBGDFF6Hm4pQCRwpvEdlF9POeysXVqcB/Ytf6FfYbTltWRbbCJe06x4b0U2tKFUZOR+p6DJbC/VX1GKjMnT56e1v+oenVZdaHQ2tIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407849; c=relaxed/simple;
	bh=WHDrcxKcBdMnvRld4FXz79+dG81xHW2dgqeOUyogj0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnAiJiM12NS0A/6kRa2sphhipot1KPkHkIAzVfrzyjCOT9tjq5vOKGncSfmMDRSvkhcw0F64sXPc9EDOM9qoh0gYNORZ/DeGQ0h/Zidzvc9qQfqC0WSoSYLAJ7b7+Zjf26N0a8tTn2DBxsZDkzhJt4y5wsKCJylv3FIHTI/yhz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFShHbKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFShHbKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22CFC4CED7;
	Tue, 12 Nov 2024 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407849;
	bh=WHDrcxKcBdMnvRld4FXz79+dG81xHW2dgqeOUyogj0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFShHbKR0mDNWXLrXg04ObrluYT3ePtDlsZJxSaLfHVRuArJAFiC27iYP5FwTqv7v
	 7WJdAc/nbb3gdR/pYjE7myFs5rNBISC57c8H1noPDrNt6qYItqvMW1nVYfWBzw4Dji
	 KpxG2wPZl/FhP0l1Ja9zSYgmZc/dyZHmCT4Fnagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 102/119] filemap: Fix bounds checking in filemap_read()
Date: Tue, 12 Nov 2024 11:21:50 +0100
Message-ID: <20241112101852.622199814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
@@ -2660,7 +2660,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
-	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	folio_batch_init(&fbatch);
 
 	do {


