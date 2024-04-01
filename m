Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9981E525;
	Mon,  1 Apr 2024 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990064; cv=none; b=LLa5vNXsDgzyvl4e9tgx1Vz3IivulOzCdcLV//dIIfFcvSk80Au5Wmrn9+S+/R9kfoFcCQEeyb/sLs2IJd2wC5l63m0I3cNrUJ6/MCH6gxYNroiQ2oeJNHRl5Dxre/FHS9afTSnYdxSBvzsHZbHfo8gxhfhktyyCC+vDIiwueQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990064; c=relaxed/simple;
	bh=gG4VbV0RNoqg59wWzuMjoxB23gP4Txgx7GubNC1jn1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYxSleayc7f6E2x5ECbQgHzCxE4jkIOhoTtbZHZYUTXJsI8Ggk8KVoGS/JHeOwqhDBQbPI+yKiQISWAcdkuxGgiObpSzZelFMbwApaSsEoClKZzpUD+doAfoxkA9PKeYwbhslnbxhHNgpFAgVgto/NB8vHGcLzGMjcOFOWCE0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO2rJjWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO2rJjWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CF9C43390;
	Mon,  1 Apr 2024 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990064;
	bh=gG4VbV0RNoqg59wWzuMjoxB23gP4Txgx7GubNC1jn1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO2rJjWfUNMRfkHem3Vp2P5qnUPZ+/kQ5PGWH6P1DzEkNc1cupnVfR/X4Ax3cxXVT
	 wrkJ2pybVdYaanKUYEoGJRoNcyLLPvuLfSP0k/VTLVgFggZVhT3QnWbvzuZNOPRi+/
	 tuJxt9CurMqpmNDZlLb1pAZrzQqHUlKL24Ni87EM=
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
Subject: [PATCH 6.6 235/396] fs/aio: Check IOCB_AIO_RW before the struct aio_kiocb conversion
Date: Mon,  1 Apr 2024 17:44:44 +0200
Message-ID: <20240401152554.922020534@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


