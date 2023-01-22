Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A32590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F32C433EF;
	Sun, 22 Jan 2023 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400479;
	bh=N8UikIrmLV4NAq1qOTHsYsCi/692QTC3vJcLxeH6QVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gt5ElRhmDZ7zLyQ/3WWkRS9WNEORNHiEdDUc1/P//FyJ24BbL1Q52bHVYI6BQIxq
	 OmcWzKaqH8KBkVrU5TRGVxienUrv8Dsi+fU8jggpmwI1tELrQsAzlQPYvxArkK2XqU
	 x7/nqoSeeqAsuJ6TjnpZ4Dv12wwPH6nsz73jNUjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 91/98] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
Date: Sun, 22 Jan 2023 16:04:47 +0100
Message-Id: <20230122150233.265271095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

commit 3e4cb6ebbb2bad201c1186bc0b7e8cf41dd7f7e6 upstream.

I hit a very bad problem during my tests of SENDMSG_ZC.
BUG(); in first_iovec_segment() triggered very easily.
The problem was io_setup_async_msg() in the partial retry case,
which seems to happen more often with _ZC.

iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
being only relative to the first element.

Which means kmsg->msg.msg_iter.iov is no longer the
same as kmsg->fast_iov.

But this would rewind the copy to be the start of
async_msg->fast_iov, which means the internal
state of sync_msg->msg.msg_iter is inconsitent.

I tested with 5 vectors with length like this 4, 0, 64, 20, 8388608
and got a short writes with:
- ret=2675244 min_ret=8388692 => remaining 5713448 sr->done_io=2675244
- ret=-EAGAIN => io_uring_poll_arm
- ret=4911225 min_ret=5713448 => remaining 802223  sr->done_io=7586469
- ret=-EAGAIN => io_uring_poll_arm
- ret=802223  min_ret=802223  => res=8388692

While this was easily triggered with SENDMSG_ZC (queued for 6.1),
it was a potential problem starting with 7ba89d2af17aa879dda30f5d5d3f152e587fc551
in 5.18 for IORING_OP_RECVMSG.
And also with 4c3c09439c08b03d9503df0ca4c7619c5842892e in 5.19
for IORING_OP_SENDMSG.

However 257e84a5377fbbc336ff563833a8712619acce56 introduced the critical
code into io_setup_async_msg() in 5.11.

Fixes: 7ba89d2af17aa ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
Fixes: 257e84a5377fb ("io_uring: refactor sendmsg/recvmsg iov managing")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4681,8 +4681,10 @@ static int io_setup_async_msg(struct io_
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
-	if (!async_msg->free_iov)
-		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+	if (!kmsg->free_iov) {
+		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
+		async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
+	}
 
 	return -EAGAIN;
 }


