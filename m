Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B17E65193;
	Tue, 23 Jan 2024 01:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971649; cv=none; b=uybC0bzsymC946ycIuH+E275fG2jyFwAmkPr83bHi9pO1pqwHA3/oB4bEM7mZhqjbSqHugQm0DpOKvM4qps7pDjhkz8+YfGHvFKy0cCFY/LP3VQn7lm4GBG2LgBufLrwrLF9bU6QYCryL3Y7XVAeyRb33FRM8yg+J6we54TCi9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971649; c=relaxed/simple;
	bh=2GSERM8zkjdJJEmW0GrdH6qd0hysEQNRzNpm9GCSKAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjiZXTdsjrGGz1hIDZdkkCnntwEzRBDwzCx92MsICmpGN2FamOh6gZK18IWgJQ4+SXOggbNVtp/JfWmWDgfE21LqckPkwQh2HdbrR4yTYVHFGnRppg6p1os3ik672nmrWa0kEVrAltd7rZ0mNMrtFRFv7VKDMMEA55Nf29bKnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTh9P7U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTh9P7U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD708C433F1;
	Tue, 23 Jan 2024 01:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971649;
	bh=2GSERM8zkjdJJEmW0GrdH6qd0hysEQNRzNpm9GCSKAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTh9P7U3Y1ycFnrEcerBsS1l50QpBjYtMBVc631cV0nYexecfJKUSwXyzFoSfSrV6
	 Giu7tv2APRwK8BdoZVpMZVfLZBByRYmBMH3Ug88Z2rfOehM5QaJFa86a/LiFsfE386
	 Eue/z5G2yg9SJqLjD8+eNLsWDwGm2TUDOd5WnJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 286/417] io_uring/rw: ensure io->bytes_done is always initialized
Date: Mon, 22 Jan 2024 15:57:34 -0800
Message-ID: <20240122235801.747394156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
 io_uring/rw.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -534,15 +534,19 @@ static inline int io_rw_prep_async(struc
 	struct iovec *iov;
 	int ret;
 
+	iorw->bytes_done = 0;
+	iorw->free_iovec = NULL;
+
 	/* submission path, ->uring_lock should already be taken */
 	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
+	if (iov) {
+		iorw->free_iovec = iov;
 		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
 	return 0;
 }
 


