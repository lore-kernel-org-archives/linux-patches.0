Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34BB1CA8F;
	Mon,  1 Apr 2024 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988741; cv=none; b=Vr5XX/8qFmkCRW+uFqsvNBp2ah0xRTXXcm7c1/lCf7JCYbKq+8TZMd5WxTmeLxxJHgv+X9eb3J759XQUbwB7yOyaVEtzG7jMhSfJ3Eclep3i8E0h6WOxaA6Te7em4vIT18yeMllST4245S7Fn7/44So+GHOb+0tfOiZfmCUdxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988741; c=relaxed/simple;
	bh=YBrUas1maVJ0rtH7K5zii4TuPwC+Gx9h4EnNP1dHNBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrRutNpUlHMJCQbZiuugaBE+MHOewqv/BSDimBAGyNUpPvwMrsMpiNRzPfO9AglfwsTyZbknK7leXj5swvj/A+HIFrfW+V6DtQB2g6gSwgaYjQEdXVft2gvs7ixhDH4kkuKVCY9cpUWPHr4fcQfxj3DM+elKZ/YqQ5KrmmlYZbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY94Ahm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY94Ahm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF492C433F1;
	Mon,  1 Apr 2024 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988740;
	bh=YBrUas1maVJ0rtH7K5zii4TuPwC+Gx9h4EnNP1dHNBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY94Ahm2zjUojYVgpabpjqVvfq3nFpbRcwmZB0Ivi4jFUu5PXVpUZEA95cI7qFze0
	 lcZBO6qunKjF72daMDlr/DrqJIse1qsIZIEUqeGACsXYyKo9xtnfXm9F6RijQ0CsiO
	 rqP9ckzmjGWaxgN4jGrp0KzSAhPz98/iQkWZlFFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Benjamin LaHaise <ben@communityfibre.ca>,
	Eric Biggers <ebiggers@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Avi Kivity <avi@scylladb.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.7 275/432] fs/aio: Check IOCB_AIO_RW before the struct aio_kiocb conversion
Date: Mon,  1 Apr 2024 17:44:22 +0200
Message-ID: <20240401152601.376334277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 961ebd120565cb60cebe21cb634fbc456022db4a upstream.

The first kiocb_set_cancel_fn() argument may point at a struct kiocb
that is not embedded inside struct aio_kiocb. With the current code,
depending on the compiler, the req->ki_ctx read happens either before
the IOCB_AIO_RW test or after that test. Move the req->ki_ctx read such
that it is guaranteed that the IOCB_AIO_RW test happens first.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Cc: Benjamin LaHaise <ben@communityfibre.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org
Fixes: b820de741ae4 ("fs/aio: Restrict kiocb_set_cancel_fn() to I/O submitted via libaio")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240304235715.3790858-1-bvanassche@acm.org
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -590,8 +590,8 @@ static int aio_setup_ring(struct kioctx
 
 void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
 {
-	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, rw);
-	struct kioctx *ctx = req->ki_ctx;
+	struct aio_kiocb *req;
+	struct kioctx *ctx;
 	unsigned long flags;
 
 	/*
@@ -601,9 +601,13 @@ void kiocb_set_cancel_fn(struct kiocb *i
 	if (!(iocb->ki_flags & IOCB_AIO_RW))
 		return;
 
+	req = container_of(iocb, struct aio_kiocb, rw);
+
 	if (WARN_ON_ONCE(!list_empty(&req->ki_list)))
 		return;
 
+	ctx = req->ki_ctx;
+
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	list_add_tail(&req->ki_list, &ctx->active_reqs);
 	req->ki_cancel = cancel;


