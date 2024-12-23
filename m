Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A32517A597;
	Mon, 23 Dec 2024 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970823; cv=none; b=DsjSvXvfBqS8mRc8GYD7iNJV5QRaRL3AhiqX3emHJgkXLBLp0Ak4rowKI3f7Gpde0vK2YgI0Ic/pJuEA4E7QgbFl6YovtHrBZBSRtvObvZjAAHmp8wHY5Hf22jNYrS7T6CezxbfBpIlQWVxvae9q11g4J3k+vaY80fUXJ/mSsck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970823; c=relaxed/simple;
	bh=wfUZ2w0VVePuOjVrxvJsjSIJYDPgII9dyLZhQuS3blo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAMc47xsBmeD8+wJhkAfODhshY8fuLVdXuYDpTeoO9VYlM38DnQ96uxF4PGsfBzeYNBC0wr3NA8TaS1TtNiAzEqMWqjN5mjWT/S8HZ1ZKi+scRyOhhV/83l5p/6r5FmtvC2k2A0yozDXud3v2Tt4Xg/GFueiZtSS7+Gn+QktjFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs0naG2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs0naG2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D1C4CED3;
	Mon, 23 Dec 2024 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970823;
	bh=wfUZ2w0VVePuOjVrxvJsjSIJYDPgII9dyLZhQuS3blo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs0naG2ptSSIm8vw+Kg9m2DJyNdvd1L4D4ImBuMqVTBYiI5GSYaz6AwmlCg34Zs22
	 14rb8smfbtQWlzxrxEP55G9Jn1NTlXTNk6otBYdO3wtJmHlxYDvuox1Ad+OkMbe5H9
	 AfQD6TyTddwKskcDX5Fie9JWLjQTb93uadVMRizw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Sander <r.sander@heinlein-support.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 80/83] io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
Date: Mon, 23 Dec 2024 16:59:59 +0100
Message-ID: <20241223155356.745702403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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
@@ -757,6 +757,14 @@ static int __io_read(struct io_kiocb *re
 
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


