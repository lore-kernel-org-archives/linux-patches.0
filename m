Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2119CCEC;
	Tue, 22 Jul 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193269; cv=none; b=ojpLBYQBSU4VwHsSRP7oeU1V1JESYOz2wt4qRFozCofxY61HdnEOY0m8SMr/t8M7twx1De93z/6J4qjuKxY+MM+WtwkdVwyw0SgLy+6WC2OQGLE+UT0kTD8JalcExKpaOFhVxI8+5SO8O+hi1gEVeWwGb+CCj8Wj8yHEogTFJj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193269; c=relaxed/simple;
	bh=u89KTMaPtBxUA4EN+s1aSlkhs9MO/QlvRbVYbYFV8L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBc2Mfn4sW0MapFOvi8uDJO1sFW17AVeA9+heGyZKKX9vu3HkJdIBODJjENv6U1yKCpf1zGnR6xIIQR97ZRiUyBF0lmUBTN6vPtzlSRnCWKbQ8Et4gcgj4SdMQ7Hv8Sk8LoODnSoA5mkAob8v75QFl/LwhKVB8SJ2fkODFD5hco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnhOS1nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnhOS1nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A103C4CEEB;
	Tue, 22 Jul 2025 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193268;
	bh=u89KTMaPtBxUA4EN+s1aSlkhs9MO/QlvRbVYbYFV8L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnhOS1nmXeOQB4eHNRV1DBg5kTu4lvSKv35gVnBwPRhe7V6gq2MaP8tqF28CCyHvN
	 DPIrs0M+5AUROj8Hg7YOVmBBS1RZU0wi8b/7yw2Tl9s7hVXreF2twZRy9WvBNmJ0Fv
	 bnlcU8VdnP/131okHp/TtVoEjeCJayDR+fpU7NKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 042/187] io_uring/poll: fix POLLERR handling
Date: Tue, 22 Jul 2025 15:43:32 +0200
Message-ID: <20250722134347.324428021@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit c7cafd5b81cc07fb402e3068d134c21e60ea688c upstream.

8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
is a little dirty hack that
1) wrongfully assumes that POLLERR equals to a failed request, which
breaks all POLLERR users, e.g. all error queue recv interfaces.
2) deviates the connection request behaviour from connect(2), and
3) racy and solved at a wrong level.

Nothing can be done with 2) now, and 3) is beyond the scope of the
patch. At least solve 1) by moving the hack out of generic poll handling
into io_connect().

Cc: stable@vger.kernel.org
Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3dc89036388d602ebd84c28e5042e457bdfc952b.1752682444.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c  |   12 ++++++++----
 io_uring/poll.c |    2 --
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1749,9 +1749,11 @@ int io_connect(struct io_kiocb *req, uns
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (unlikely(req->flags & REQ_F_FAIL)) {
-		ret = -ECONNRESET;
-		goto out;
+	if (connect->in_progress) {
+		struct poll_table_struct pt = { ._key = EPOLLERR };
+
+		if (vfs_poll(req->file, &pt) & EPOLLERR)
+			goto get_sock_err;
 	}
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -1776,8 +1778,10 @@ int io_connect(struct io_kiocb *req, uns
 		 * which means the previous result is good. For both of these,
 		 * grab the sock_error() and use that for the completion.
 		 */
-		if (ret == -EBADFD || ret == -EISCONN)
+		if (ret == -EBADFD || ret == -EISCONN) {
+get_sock_err:
 			ret = sock_error(sock_from_file(req->file)->sk);
+		}
 	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -273,8 +273,6 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
-		if (unlikely(req->cqe.res & EPOLLERR))
-			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 


