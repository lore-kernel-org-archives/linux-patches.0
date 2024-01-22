Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72B4E1CC;
	Tue, 23 Jan 2024 01:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974732; cv=none; b=dnhY9EeWMr4Y0TOamewBM8bT+mBG0dA5osJOV78kTTT4qZSXRHvoAutC8Yyfu7f86Jbb0ggdX660e62uQzpB86Rk/qA4WjqpzGKMmqIdtfnkXH/I/pAEj9p4fHBFSEKjbXQteujd0adWpbE6UuN8nzk6VKG7NaMSEhoDUnWtbhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974732; c=relaxed/simple;
	bh=rnTn+UeUEAtCg/9XP9q6kz2FFxB0YMdbseDQczesIzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WshesY4bXzG7BFi8RTOl8RvXezAaE3fPDdCSYKVk4FkkjESaz05hI3Yo+QToexynCkPXTQ5q5CzWeoGTwSjDY1ko5axBVJYWRbn6yqSsz3ZhNCVPcSS8uX22GCbSnnQ6ivv+qWd+nK6WC3OdWBrAUoDHhc3Yucf6SmyW7VXx6xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSABynIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSABynIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E8AC43390;
	Tue, 23 Jan 2024 01:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974732;
	bh=rnTn+UeUEAtCg/9XP9q6kz2FFxB0YMdbseDQczesIzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSABynIwXNobkYPsXjGF1D0zwtdUlZatxZqWmkoyFgMRKd5YcQ24iZUCMJatWtMD0
	 873OR2We/as00hh2IfrIuMkbxIngGm0l7b7MF+zjQgMhEEg9BgR7oX/KPLPcbcJmya
	 HsljBfR7E0RUmZIuxyBx5idvW9aegmrvgq/5cY1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 272/374] io_uring/rw: ensure io->bytes_done is always initialized
Date: Mon, 22 Jan 2024 15:58:48 -0800
Message-ID: <20240122235754.230534310@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 0a535eddbe0dc1de4386046ab849f08aeb2f8faf upstream.

If IOSQE_ASYNC is set and we fail importing an iovec for a readv or
writev request, then we leave ->bytes_done uninitialized and hence the
eventual failure CQE posted can potentially have a random res value
rather than the expected -EINVAL.

Setup ->bytes_done before potentially failing, so we have a consistent
value if we fail the request early.

Cc: stable@vger.kernel.org
Reported-by: xingwei lee <xrivendell7@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3490,14 +3490,17 @@ static inline int io_rw_prep_async(struc
 	struct iovec *iov = iorw->fast_iov;
 	int ret;
 
+	iorw->bytes_done = 0;
+	iorw->free_iovec = NULL;
+
 	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
+	if (iov) {
+		iorw->free_iovec = iov;
 		req->flags |= REQ_F_NEED_CLEANUP;
+	}
 	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
 	return 0;
 }


