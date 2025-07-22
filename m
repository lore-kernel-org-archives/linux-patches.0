Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9782433A8;
	Tue, 22 Jul 2025 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192107; cv=none; b=Zr+Hg/cK6XiOa0CYDlWJI5eB7PrfmV2WRtpXJbx5hOZfNikq312bwF9iajcfRPyaXQ8Q0ko5jcYeUkxJwwkbV8ON26Qu/PXHV+6zMKsyzhO0viglAo6FbRzig4+PZlF1/BfIBT4lmrH0nu/SQxOycg0FX3kD49KQRk8aCKfwGx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192107; c=relaxed/simple;
	bh=NKMonvoGv9LabQl1se0B0Tb8rwoYbcPqvU4LS4yr3zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnvmz2mO+DJ2LVflC1X7RsX+Xx5ltujF2J5GX42fXntP0CVnPdPYhzIHxkLxNbyCjlYGcPjvzBoXRoP8AbmOQxJ+UDtaG50ql9/vD/qvT7EeKMHs054JMVr18G4SIhd3LD/Onn6v/m9SxU6Fo6ShVbvCOxnqJW7ZcvUhD1KMykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBZCY/Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBZCY/Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6F6C4CEEB;
	Tue, 22 Jul 2025 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192107;
	bh=NKMonvoGv9LabQl1se0B0Tb8rwoYbcPqvU4LS4yr3zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBZCY/JrQAg7OmrRRLifKXA9d28m1uUX7ZZemax3aUHwJVR4hg+ULm4k4auDKBTsq
	 GUXhAqBeiO5BYWkUz+FMRQZWpfJNnqz8J9dM/fjZqWGe2UyBkJ0FdnCxafjuhVnzzR
	 0d7p01EmEZ/YCsN0qpztH8bGT+8WrVyFJQSvD9Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 14/79] io_uring/poll: fix POLLERR handling
Date: Tue, 22 Jul 2025 15:44:10 +0200
Message-ID: <20250722134328.909922637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1490,9 +1490,11 @@ int io_connect(struct io_kiocb *req, uns
 		io = &__io;
 	}
 
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
@@ -1524,8 +1526,10 @@ int io_connect(struct io_kiocb *req, uns
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
@@ -288,8 +288,6 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
-		if (unlikely(req->cqe.res & EPOLLERR))
-			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 		if (io_is_uring_fops(req->file))


