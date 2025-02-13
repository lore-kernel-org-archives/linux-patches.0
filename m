Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A27B1531DB;
	Thu, 13 Feb 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460846; cv=none; b=eYrCir8c4YBgfOXlYc0sZwTHfLksXpvT7qQ/GC9SQ3/lfE7SGZdZ/tRe0D0JW5Nzui+kWQhyQEDf3FfMb3zdjmFajKSmgVCyOtEylWb/DReCE+YGjPhj9frWeUD9NJ9c5mFkk/XDi16kDRnPWQw/Pj+Dgn5Mf2ZdJKHMu3y5GNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460846; c=relaxed/simple;
	bh=Rvqq9oAeqAyt92XTRh1r8gBxDPOmJaHCWkZmDKrcQwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayl6aMM0DgGK/hUxZoUFAi4AlP7iWkBYYHOOaXNrULEK9wS+EcODmcVHtHQvX66GwEflZRMzjZmmAzCRUtxuEqVUB1jq6aZ5gCzsXeNwnn1Z3vZin5+jmK/ftuzihvUsYcwYhG9/kWSS8SLKJf4if8gEg23pGL6YN+nIYIl0niI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUuG3FP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUuG3FP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B856C4CED1;
	Thu, 13 Feb 2025 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460846;
	bh=Rvqq9oAeqAyt92XTRh1r8gBxDPOmJaHCWkZmDKrcQwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUuG3FP49R+GjLqpe5lMypBt9zSc9Po5l7Xw1N5NwRCxG+9ilf1VlwGBRECSBuwpz
	 O7bfh68J9Hmh1alvTZ7CwIS8PW8bhJivkwR1DZrctWtAkdSV9miyN81yQMxhqpMrp0
	 PsnV2BpnXBhNUUmU2fpi9T/dMWeskeJBvaMfYPYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.6 229/273] io_uring/rw: commit provided buffer state on async
Date: Thu, 13 Feb 2025 15:30:01 +0100
Message-ID: <20250213142416.483635827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

When we get -EIOCBQUEUED, we need to ensure that the buffer is consumed
from the provided buffer ring, which can be done with io_kbuf_recycle()
+ REQ_F_PARTIAL_IO.

Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Fixes: c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -793,6 +793,8 @@ static int __io_read(struct io_kiocb *re
 			goto done;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
+		req->flags |= REQ_F_PARTIAL_IO;
+		io_kbuf_recycle(req, issue_flags);
 		if (iovec)
 			kfree(iovec);
 		return IOU_ISSUE_SKIP_COMPLETE;
@@ -816,6 +818,9 @@ static int __io_read(struct io_kiocb *re
 		goto done;
 	}
 
+	req->flags |= REQ_F_PARTIAL_IO;
+	io_kbuf_recycle(req, issue_flags);
+
 	io = req->async_data;
 	s = &io->s;
 	/*
@@ -956,6 +961,11 @@ int io_write(struct io_kiocb *req, unsig
 	else
 		ret2 = -EINVAL;
 
+	if (ret2 == -EIOCBQUEUED) {
+		req->flags |= REQ_F_PARTIAL_IO;
+		io_kbuf_recycle(req, issue_flags);
+	}
+
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		ret2 = -EAGAIN;


