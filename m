Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4492590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5B5C433D2;
	Sun, 22 Jan 2023 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401153;
	bh=PdUoBRzklo3agrs2oOBjncZKyQKJk5C3zdryrEw3sHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cU7/1SNfcOsBXbGxAttqZPuweGAysQTTYijovSqSogYTv/VccvI7+ZQVK1xGMFPLS
	 xduP2bfDbWrvJN7nSj31wzm6jGP6M/y9zNvLeyCIxV969mlZXCkHZS2MuEsCWg+ivt
	 usrV05Y3o+0v9nHXSonpayrLdMB8MIsxDpSM2d80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH 6.1 100/193] io_uring/poll: dont reissue in case of poll race on multishot request
Date: Sun, 22 Jan 2023 16:03:49 +0100
Message-Id: <20230122150250.899030527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 8caa03f10bf92cb8657408a6ece6a8a73f96ce13 upstream.

A previous commit fixed a poll race that can occur, but it's only
applicable for multishot requests. For a multishot request, we can safely
ignore a spurious wakeup, as we never leave the waitqueue to begin with.

A blunt reissue of a multishot armed request can cause us to leak a
buffer, if they are ring provided. While this seems like a bug in itself,
it's not really defined behavior to reissue a multishot request directly.
It's less efficient to do so as well, and not required to rearm anything
like it is for singleshot poll requests.

Cc: stable@vger.kernel.org
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Reported-and-tested-by: Olivier Langlois <olivier@trillion01.com>
Link: https://github.com/axboe/liburing/issues/778
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -281,8 +281,12 @@ static int io_poll_check_events(struct i
 			 * to the waitqueue, so if we get nothing back, we
 			 * should be safe and attempt a reissue.
 			 */
-			if (unlikely(!req->cqe.res))
+			if (unlikely(!req->cqe.res)) {
+				/* Multishot armed need not reissue */
+				if (!(req->apoll_events & EPOLLONESHOT))
+					continue;
 				return IOU_POLL_REISSUE;
+			}
 		}
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;


