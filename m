Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D48812C544;
	Mon, 23 Dec 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970535; cv=none; b=B8LqJx1p53tdiwbIOrPy+hBlNcerYKjpYwmy/UoJ3OE1Y5m+6KMNfD5dEfvsyEdXs1lN5c95QLXuN3BHiXq7WwAWaTQD+/lZogG/WJud4pqq5yt1uXn4ZHEO+nU5wwDphx31KIsBZnXGdkpyU5slZRIVciEZjPLOguaWzyU2HMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970535; c=relaxed/simple;
	bh=aJwkM4yN29hRjxEqq4X31TBh+n0evvJhQi2L0R9j9Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tt6gHPOR0gwTJffZYb8PodSIWc1eKDl1sP55V+88n1uNDKLNpzySJLcEsUxVqAepuM+rezPC9oRl/9TXjxon1y794m2JDoa56s4P7uOctgA/sBQI0BwjT1vDr/SFODG8/703deR7jWa/UUvlXarS7g9i8BslZTcEM96DSVriKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fswglmil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fswglmil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95508C4CED3;
	Mon, 23 Dec 2024 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970535;
	bh=aJwkM4yN29hRjxEqq4X31TBh+n0evvJhQi2L0R9j9Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fswglmileqp9nkznNuvBV9Q+TQfxRtbXWbaO336fao4CPnO17ZiY1Ib3T6bVkNncT
	 t0MxexNiQAfYStZMfn3ZvrV233I6cVMVn66/Yhb86p7S70CuhnkTuRBLKEZuoZEOV8
	 CSYHh5mY3xPBRDuYMDDrUYT8MHA5l6snAma8eBpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Sander <r.sander@heinlein-support.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 112/116] io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
Date: Mon, 23 Dec 2024 16:59:42 +0100
Message-ID: <20241223155403.906097186@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit c0a9d496e0fece67db777bd48550376cf2960c47 upstream.

Some file systems, ocfs2 in this case, will return -EOPNOTSUPP for
an IOCB_NOWAIT read/write attempt. While this can be argued to be
correct, the usual return value for something that requires blocking
issue is -EAGAIN.

A refactoring io_uring commit dropped calling kiocb_done() for
negative return values, which is otherwise where we already do that
transformation. To ensure we catch it in both spots, check it in
__io_read() itself as well.

Reported-by: Robert Sander <r.sander@heinlein-support.de>
Link: https://fosstodon.org/@gurubert@mastodon.gurubert.de/113112431889638440
Cc: stable@vger.kernel.org
Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -778,6 +778,14 @@ static int __io_read(struct io_kiocb *re
 
 	ret = io_iter_do_read(rw, &s->iter);
 
+	/*
+	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
+	 * issue, even though they should be returning -EAGAIN. To be safe,
+	 * retry from blocking context for either.
+	 */
+	if (ret == -EOPNOTSUPP && force_nonblock)
+		ret = -EAGAIN;
+
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* if we can poll, just do that */


