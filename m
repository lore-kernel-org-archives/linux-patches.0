Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444126B091;
	Thu, 13 Feb 2025 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459895; cv=none; b=SAyxpcplPz/fteP428yctSYdq7v5HfeD5u2sR0gVhuNzmEqKyJoc26mu8rfNDc/Whf8vWT9wweWw39HJ/euwpRLoxS+5ZuKUlWjvfL8EJYKYI0sPpaFdbn4FSmaAWIbEymTwQ98NNAcZj9rRdCuEZmsCTXqeuImgfzNdYW9ukUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459895; c=relaxed/simple;
	bh=iH1crWkGYjX9dxfS/sOn2Oxf03NAwD0S4cE6n7bAZ1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMMOJ2snGSntTD7C8k1HGsbRsaMKznC6kHZV/UlOKWmbBO3JV8w2XqTz0P9W90qIh3nRmiWClDiF/yWQt8Ttq8k2Pp3GoxJAMlXmyG5MdJ8GptgImxfZffSSNdGLqwnC/pkq/Iar6SnUCtwmYsQ1l6LIOteoK32xsYPJuNwhW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vStvZmYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vStvZmYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC97C4CEE4;
	Thu, 13 Feb 2025 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459895;
	bh=iH1crWkGYjX9dxfS/sOn2Oxf03NAwD0S4cE6n7bAZ1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vStvZmYYV0Crromrd3h7a2StkhUR+8d9EKkTGb/ZnWYl3E/1wWSFCpWnYajq6en15
	 Po6xdtnLzXXiCr8nbwFVv3/n33mO26+gQtRwpOItECLfwomCQSZIoxh6Mwtq1y5K2Y
	 R3Tua3QwEzu6lKyRetAlxqBLd9s09LrAMMBz+VQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Galas <ssgalas@cloud.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 395/443] io_uring/net: dont retry connect operation on EPOLLERR
Date: Thu, 13 Feb 2025 15:29:20 +0100
Message-ID: <20250213142455.850174893@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 8c8492ca64e79c6e0f433e8c9d2bcbd039ef83d0 upstream.

If a socket is shutdown before the connection completes, POLLERR is set
in the poll mask. However, connect ignores this as it doesn't know, and
attempts the connection again. This may lead to a bogus -ETIMEDOUT
result, where it should have noticed the POLLERR and just returned
-ECONNRESET instead.

Have the poll logic check for whether or not POLLERR is set in the mask,
and if so, mark the request as failed. Then connect can appropriately
fail the request rather than retry it.

Reported-by: Sergey Galas <ssgalas@cloud.ru>
Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/discussions/1335
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c  |    5 +++++
 io_uring/poll.c |    2 ++
 2 files changed, 7 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1709,6 +1709,11 @@ int io_connect(struct io_kiocb *req, uns
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		ret = -ECONNRESET;
+		goto out;
+	}
+
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
 	ret = __sys_connect_file(req->file, &io->addr, connect->addr_len,
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -273,6 +273,8 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
+		if (unlikely(req->cqe.res & EPOLLERR))
+			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 


