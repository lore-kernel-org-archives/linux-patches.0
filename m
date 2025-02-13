Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12235221571;
	Thu, 13 Feb 2025 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458298; cv=none; b=UIn/3LQMfPU2a2A9ppFvXXa0A308EQ2wJZOP83gBQX1gNwOdOatHAZXzoc62OD8/v/1N00wS6hwTn7nf4SZmeil/hPHkxkJx6IHjSOq2e2PA0R8l8j/YhMmCi991hSeBzkEF4UcFD+HFAhS8rRx2qDT0JX+ekwxGP1jAyiJUsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458298; c=relaxed/simple;
	bh=iXfZMP6lGm0/UyplAG1gXS4eBjxKr4Bc8lTFVBMBCck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG0nJnt7JKPMYc9eoXsa62a2vOk25GF2kiIysyGcOVT460j3G2MnwxfqmZ2/nuEBRJcT8lXHHHXoh/cpnMFrVkcG5JKta+etgDaI8+SehKR9FpY+h377MQC+pmfYPBhltrYYXuh4Zj/HCozTOJMlFrQXI9Ty6r7luIFmL3SgL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6Uab19n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6Uab19n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9345EC4CED1;
	Thu, 13 Feb 2025 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458297;
	bh=iXfZMP6lGm0/UyplAG1gXS4eBjxKr4Bc8lTFVBMBCck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6Uab19n1v7AUvOCvKIzfBs7YgsOYqiyGM6etQsU+Rt/Dw/zzuYdVPM2mKHizUHGP
	 tBtMRfT2IcRo25/qUygvxlq9ONvSPvnFAMnDGyEFWOf62QtL6P0BGrwCgH8+9EskPL
	 tT+56lrqefxkXLgxvCOnsCGP2WJKFJMZHuzV7Unw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Galas <ssgalas@cloud.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 358/422] io_uring/net: dont retry connect operation on EPOLLERR
Date: Thu, 13 Feb 2025 15:28:27 +0100
Message-ID: <20250213142450.366295112@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1697,6 +1697,11 @@ int io_connect(struct io_kiocb *req, uns
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
@@ -315,6 +315,8 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
+		if (unlikely(req->cqe.res & EPOLLERR))
+			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 


