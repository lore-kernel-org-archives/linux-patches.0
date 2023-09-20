Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67998465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4783EC433CB;
	Wed, 20 Sep 2023 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210692;
	bh=lC0320bE+MUSpYUq1M4XR00wOSdL0QPTABCw/MWwoNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8vPaivs7I5pVP9nZGEtgsStaRmkg/2jIIHMnLT2tujNvjfJt1LamLEasLGnWjAuk
	 pZ3D8JSKOPxQciBH+eRHb+7A97b7R+q9QrJ7DcY/MLgqZz44mDrc6sVD3OvOhgJ8pn
	 pLWa0ar9HJewlsnVkBy6x82/em2dYSGDQMWcLSs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 170/211] io_uring/net: fix iter retargeting for selected buf
Date: Wed, 20 Sep 2023 13:30:14 +0200
Message-ID: <20230920112851.160600434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f upstream.

When using selected buffer feature, io_uring delays data iter setup
until later. If io_setup_async_msg() is called before that it might see
not correctly setup iterator. Pre-init nr_segs and judge from its state
whether we repointing.

Cc: stable@vger.kernel.org
Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
Fixes: 0455d4ccec548 ("io_uring: add POLL_FIRST support for send/sendmsg and recv/recvmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0000000000002770be06053c7757@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -183,6 +183,10 @@ static int io_setup_async_msg(struct io_
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
+
+	if ((req->flags & REQ_F_BUFFER_SELECT) && !async_msg->msg.msg_iter.nr_segs)
+		return -EAGAIN;
+
 	/* if were using fast_iov, set it to the new one */
 	if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
 		size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
@@ -542,6 +546,7 @@ static int io_recvmsg_copy_hdr(struct io
 			       struct io_async_msghdr *iomsg)
 {
 	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)


