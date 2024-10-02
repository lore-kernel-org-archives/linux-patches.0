Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACC71D043F;
	Wed,  2 Oct 2024 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876683; cv=none; b=c8NjgNufyME51+5KcROlrJbc6CvpvhQkuj+F8SQX1D/395ZHx9WprQUMwPJIYJxef0dkvYUKcfWmt2A1Je94QYIkMYVJmigyL87AbEHKmKTgx882ksJju+lMwEFXniQBc0HpYccoHuNex4cUFPUu26JRZ/L1keOfk4iO2QxH3P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876683; c=relaxed/simple;
	bh=2W/IiVTTKZuvfBAaCZ2ZQN0N4MMAEJzC0EvzfIRMGfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXtiO2HgnNADanuBOi8JsK9pws/Rhp44G9VxGH7EKpcBJyOwhxeH1xlZ4DH6NeVEkrDcO9td/5DuSLf2SEtyMtSrUqSS4JpvwL4gochi/r9be6OaSYemGNm1sMV8p+iicqVIGgvlgT5+eu20aXxC4NX4kQqXpW0Ak4WGT4JrHKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVkaekoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVkaekoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3ACC4CEC5;
	Wed,  2 Oct 2024 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876682;
	bh=2W/IiVTTKZuvfBAaCZ2ZQN0N4MMAEJzC0EvzfIRMGfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVkaekoqnZEZHUTX1a/xn/DE+cKLE2ZqHipO6z4lOB1LceQKRWHxnnjhgb+Nvj5qM
	 x3n/aYHzdvX6AUFrY93N2IFmgZkEh9jXi5jATdOeXVDrAEe31zDveTXykBPKKJdV/W
	 EJ0v9xS7qNCugIPeoVE+upP8SCe4TU1PFevoCADY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Sander <r.sander@heinlein-support.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 496/695] io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
Date: Wed,  2 Oct 2024 14:58:14 +0200
Message-ID: <20241002125842.274049455@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit c0a9d496e0fece67db777bd48550376cf2960c47 upstream.

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
@@ -855,6 +855,14 @@ static int __io_read(struct io_kiocb *re
 
 	ret = io_iter_do_read(rw, &io->iter);
 
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
 		/* If we can poll, just do that. */


