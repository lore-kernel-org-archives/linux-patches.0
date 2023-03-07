Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBED2BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223D2C433EF;
	Tue,  7 Mar 2023 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216159;
	bh=/jxPuTv27P59KL+EwiDRvAYucwe2S6B/YHaq1iIUcQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t+AXgh7is9Cvr+tD8piGIcnQQDoE4opflAhV7F6PWE0/huu0RyXlp8XbGwupWLGW
	 kChQBChFnWwlyC51EGGQKiS3Gd1jdCKyTZU1E/+ztY/GEmkPA2v7W2YbfGbAfYC+u4
	 h/4GtuiPJPdWmzSSSOqIBd2viG+/lM2BzRWKtqQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lamparter <equinox@diac24.net>,
	Eric Dumazet <edumazet@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 494/567] io_uring: remove MSG_NOSIGNAL from recvmsg
Date: Tue,  7 Mar 2023 18:03:50 +0100
Message-Id: <20230307165927.363866446@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Lamparter <equinox@diac24.ne>

commit 7605c43d67face310b4b87dee1a28bc0c8cd8c0f upstream.

MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
generated when trying to write to a "broken pipe".  AF_PACKET's
packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
is set - making it unuseable in io_uring's recvmsg.

Remove MSG_NOSIGNAL from io_recvmsg_prep().

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230224150123.128346-1-equinox@diac24.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5141,7 +5141,7 @@ static int io_recvmsg_prep(struct io_kio
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 


