Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5A23A9BE;
	Mon, 23 Jun 2025 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684960; cv=none; b=cvjYHeuWtvv8W+zfJ3eAUy/5QSVl3o16O/Ap9G59Z5kV60cSYq/d3VoEjttAPN/deKxCODMmsI5o/Fcoa3ZsoOZwFKBk9GSs0g+XgylHpfXhVBcIt5xVRa+UJHIkfc9tRUX8lLLEBNJioQTAwwnROVAjZI/JvfUW3qrrJwBZgpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684960; c=relaxed/simple;
	bh=BwwFDHWdEaPN+CuFuKA4Z6GdLx+lrbltHzQ9iH3Yk34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfUdeHiuffj2rU1fwZ28FAfvvyeyqQxyGgc/3ZgSPfpzAdtw0GeywNPg13NZvnAdIKcIPcg+fQ759+1eCjA3RLf+gJgz6kmN5Y/254s+OC2sAcoCNOqT+UbIhoptfP7tWjv7vw4cjvQGSnTwt0meVVDKKRdt6ZKnHQKj7fnznHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULhsGxjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULhsGxjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB7EC4CEEA;
	Mon, 23 Jun 2025 13:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684960;
	bh=BwwFDHWdEaPN+CuFuKA4Z6GdLx+lrbltHzQ9iH3Yk34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULhsGxjjD70J1yYmBbCHj/g+NiFtnvoKd9WQWLK3Yzko67sa7wYbxrS4sOqejok95
	 PCK8yikh6nK/b/RIrLx2s/CZqlpLjt1ea126VXsczU1UYNT+28YKr9oOPqtiRDv9S3
	 ZMhMoHhTWln2uxTEHn+ggU/x6stchGd5BfklQ4ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 195/592] io_uring/net: only consider msg_inq if larger than 1
Date: Mon, 23 Jun 2025 15:02:33 +0200
Message-ID: <20250623130704.928707695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 2c7f023219966777be0687e15b57689894304cd3 upstream.

Currently retry and general validity of msg_inq is gated on it being
larger than zero, but it's entirely possible for this to be slightly
inaccurate. In particular, if FIN is received, it'll return 1.

Just use larger than 1 as the check. This covers both the FIN case, and
at the same time, it doesn't make much sense to retry a recv immediately
if there's even just a single 1 byte of valid data in the socket.

Leave the SOCK_NONEMPTY flagging when larger than 0 still, as an app may
use that for the final receive.

Cc: stable@vger.kernel.org
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Fixes: 7c71a0af81ba ("io_uring/net: improve recv bundles")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -840,7 +840,7 @@ static inline bool io_recv_finish(struct
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry && kmsg->msg.msg_inq > 0 && this_ret > 0 &&
+		if (!sr->retry && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
@@ -1077,7 +1077,7 @@ static int io_recv_buf_select(struct io_
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 0)
+		if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);


