Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43EC128;
	Tue, 13 Feb 2024 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845967; cv=none; b=KaY5yxHhRr3K0JZ4OwV6ZwXRZYreVDRaGlgpnvkpnC2txhwQ7xOPt/RwuolYOMzmWCT1HRkd1g5vHYAwgVigMto8bhNra4PfY7RPZ1kyK4eefXBdO6TrEbaOFmUv92THNvNghHRClkM5EpkiyeQ9+0lfAKXCb8VGckreQeCkR5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845967; c=relaxed/simple;
	bh=Ybhle1cNXZQtJZSsOY26I8qxJVlxMuc2mYo8h5sEkO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7CeRnx6962Yz7HfrdPF5ADCtRHwlM3nKawxXgol9ZWSmx/yGpnqQmu4/ADAu/95rpD8Gb70Z1B0omCWqhSOUd5z1EaYBJKUpFPco3ddQMZnn8u0yP5aRR0jirHTMc0IzrAggSaRC3Kdu4zpel2ltPDjODItKgtzwQyrxzn87j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLj/J0Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLj/J0Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31119C433C7;
	Tue, 13 Feb 2024 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845967;
	bh=Ybhle1cNXZQtJZSsOY26I8qxJVlxMuc2mYo8h5sEkO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLj/J0Zw1JUuQXfDU6V9TMhi1tYZtHWhYUg5KzNWRzeO9jYAnmduJT01gOlMFxHvK
	 8Ws+rlHebA99bRXz0r99lFyyhH0na2rJ+Fzj75Is1JjFvGXiicKHySaqAtI13BMy4j
	 5w7h2Hwdv7vdQJzc4o1Xzm2E1TlE4ORPr9Jjx5MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 107/124] io_uring/net: un-indent mshot retry path in io_recv_finish()
Date: Tue, 13 Feb 2024 18:22:09 +0100
Message-ID: <20240213171856.853625726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 91e5d765a82fb2c9d0b7ad930d8953208081ddf1 upstream.

In preparation for putting some retry logic in there, have the done
path just skip straight to the end rather than have too much nesting
in here.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -645,23 +645,27 @@ static inline bool io_recv_finish(struct
 		return true;
 	}
 
-	if (!mshot_finished) {
-		if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-					*ret, cflags | IORING_CQE_F_MORE)) {
-			io_recv_prep_retry(req);
-			/* Known not-empty or unknown state, retry */
-			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1)
-				return false;
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				*ret = IOU_ISSUE_SKIP_COMPLETE;
-			else
-				*ret = -EAGAIN;
-			return true;
-		}
-		/* Otherwise stop multishot but use the current result. */
-	}
+	if (mshot_finished)
+		goto finish;
 
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_recv_prep_retry(req);
+		/* Known not-empty or unknown state, retry */
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1)
+			return false;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			*ret = IOU_ISSUE_SKIP_COMPLETE;
+		else
+			*ret = -EAGAIN;
+		return true;
+	}
+	/* Otherwise stop multishot but use the current result. */
+finish:
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)


