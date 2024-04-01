Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C481DFF4;
	Mon,  1 Apr 2024 17:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991112; cv=none; b=TpyNwfPSkWyFbwuInt5sJLInV9Gg23JxM74fC1ue0eIklJ2Id32ofH3lN3NUysP+XTwhRwbC1ebqopLKyZIM5K4Waj4LBBprDR+YGRyV3kmg1lz8nMbXapNa65q7o3e8OpaPtpYx8l+djtmdIQ+/IV7zBLALmMeHNxDh3QEKadE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991112; c=relaxed/simple;
	bh=+NcE4/bcD3YuZsJ4GOexhfSP0OYEc5F2juJxTHFN37w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRqGQ3unEULpv2+IUPHwcEc/0QWu4MuwLHyW6K9nMvCBjJvyQBq9ADWnrkOvu7f1AU99y2y90kWReNHytnNLTIJh6/gAMFtXLur+/nEymrrolT9GDhuWiNnNPlWA6oTqtQ0cZ5t/WkDinJepzsVmwtH1UX++7cF5irkN4/GuKec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXl1A1nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXl1A1nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1613FC433C7;
	Mon,  1 Apr 2024 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991112;
	bh=+NcE4/bcD3YuZsJ4GOexhfSP0OYEc5F2juJxTHFN37w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXl1A1nbR+RQxckF4JHGQf3iApAglBIBm7xje71RbNbXLx+lXyPWnoxZIvZaHyEUr
	 fwm9THk+x9Dw8n+xFkyHFGMi+cMpY0dTldYN0mbcXTbXyLiiO4QTqVMt2ocoeglQPb
	 hu32mBDvOEsVzVaz4GyNwticQElX9Fw/vm8gqc8Y=
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
Subject: [PATCH 6.1 166/272] fs/aio: Check IOCB_AIO_RW before the struct aio_kiocb conversion
Date: Mon,  1 Apr 2024 17:45:56 +0200
Message-ID: <20240401152535.930316718@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -591,8 +591,8 @@ static int aio_setup_ring(struct kioctx
 
 void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
 {
-	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, rw);
-	struct kioctx *ctx = req->ki_ctx;
+	struct aio_kiocb *req;
+	struct kioctx *ctx;
 	unsigned long flags;
 
 	/*
@@ -602,9 +602,13 @@ void kiocb_set_cancel_fn(struct kiocb *i
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


