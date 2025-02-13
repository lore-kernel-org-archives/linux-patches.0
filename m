Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3C14A605;
	Thu, 13 Feb 2025 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460839; cv=none; b=jBY04aFWoIjqIPtv1Rx6goGedFTCA47XERuh97ojZrsv6H5xnGrFhqjC/BcWj6fCi/S+sgIKru7AlTUfweB5UoS0RxUW6osxNdh616v2umjSD/7Knx14Pb0eo8NLfAhE9Tr6HXlM/ZObR+iw57inen52WkOFM0bnAchx1BeeyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460839; c=relaxed/simple;
	bh=48c8XAZlb8wntmlib++b9/qsp+R2SMW5yp5cESQgouo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CL9miC6mFKqcMOIjLiIorbnZKYy3vGtgSrCklwZ51Cet75mPG790ij9TERlEDkbwCL8SeYWmxP9rkwTyWHJafF4/0lAkTkPv8HWE+8bJYqr9qK8Csarm13ovDMi4GPMV3xgON8cp1V9vKrRtA5wcoFzEXmoL3uOayESCsoUqFZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQYnPOL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQYnPOL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48E3C4CED1;
	Thu, 13 Feb 2025 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460839;
	bh=48c8XAZlb8wntmlib++b9/qsp+R2SMW5yp5cESQgouo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQYnPOL9E+wnKca0moMNOYOm4c2I23de8CP3WUU2tFhb8pDuCLngg3YYEKQxrhODr
	 QGO9tUP5Pz6KDuj/jNreB2Yp57oBsZwvUc9rTR3PafwNvu1ifCGtpMvzJJKuqRkl7D
	 nLx0CroiS0mQ6DA8Vc2oIBSJKI+Sc10MBMm5zcn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Galas <ssgalas@cloud.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 227/273] io_uring/net: dont retry connect operation on EPOLLERR
Date: Thu, 13 Feb 2025 15:29:59 +0100
Message-ID: <20250213142416.283783356@linuxfoundation.org>
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
@@ -1533,6 +1533,11 @@ int io_connect(struct io_kiocb *req, uns
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
@@ -308,6 +308,8 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REISSUE;
 			}
 		}
+		if (unlikely(req->cqe.res & EPOLLERR))
+			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 


