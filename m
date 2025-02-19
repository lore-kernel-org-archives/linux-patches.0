Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268651D5175;
	Wed, 19 Feb 2025 09:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957230; cv=none; b=UPh8QOPunU+O9EThz0/RX19ShXNJN7RZCMV/PkxWF/QeIvQph89yZsyLfKcDP++gaAGR4GfRQolqkCwnD0ioW4/ueqxRxJoG3sLX6GDdKCGAbgaWeCNx9wSzJud+7rnBTS7EB3slNIk7fTqgJnw/MgvfwwCMcfmttmqgnhHDiKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957230; c=relaxed/simple;
	bh=guFFBN6DbYYXrM4QWf5pAlwkmfPt15JXYwXz4vNK/Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahfggLDhEb6zx7I1LAmkgAQqg+9sDI1Qv5OqR9Aj2QzdmyTVH/i1HbWl1LCbjbtZNjhiAWyTC+GLbDTQwqbqbjOExixwFCAVnFtELzp2l9l5dVhDNsZ0yv5EZl7iBaPjO/TmIOttkUWSPSGjJDlE2ez2ZEVvJkFaPBsQHK3LHcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF6J4tnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF6J4tnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B26C4CEEB;
	Wed, 19 Feb 2025 09:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957229;
	bh=guFFBN6DbYYXrM4QWf5pAlwkmfPt15JXYwXz4vNK/Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF6J4tnPY1e+bLjI73SNELI+Eh+7CG3dKxWQbC5fCvcgSeY1SB3AXdyAcLx6vM57z
	 yUHS/Z1QDrCxMJafOs2B+191+0JQIMVQvntMB9Cq64I2er56/nHsKi2hSTXVEeSDQ+
	 Im5S2sU22T8c/is3AreckecvEenrxBxtcIHwaj6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Galas <ssgalas@cloud.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 422/578] io_uring/net: dont retry connect operation on EPOLLERR
Date: Wed, 19 Feb 2025 09:27:06 +0100
Message-ID: <20250219082709.617465244@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
@@ -1486,6 +1486,11 @@ int io_connect(struct io_kiocb *req, uns
 		io = &__io;
 	}
 
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		ret = -ECONNRESET;
+		goto out;
+	}
+
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
 	ret = __sys_connect_file(req->file, &io->address,
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -288,6 +288,8 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
+		if (unlikely(req->cqe.res & EPOLLERR))
+			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 		if (io_is_uring_fops(req->file))


