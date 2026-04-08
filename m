Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6828C87C;
	Wed,  8 Apr 2026 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673207; cv=none; b=asNPn7knrs6WpxpHtgCQNEU4b432/JyXMv6xdzSl23NZFNVIQQz/3Q8eCjANnoNXmidloIacciA4x+vYcBZQcuyaXB/va/cKxa20cvN99wWnDLjulecIJo6F2K0380bnF0EcI9HdQJdKhBAfcJ74DLjHafJxNwsXKRPAMHWG1u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673207; c=relaxed/simple;
	bh=5ajefxLB1BaVwCM+Trv61gtoLq2/wtWmpJx+ixAjf0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL/PvWwy9yLM5uNPf7+lste/q0Db++qyXq1aoqG6YkmmiJTs8lphD+g7zIg7QdHO297n7DKps/bfj2uUCXHHCJ5GKz58tlbrXPKQgM418n+F7P1qFtorZreEvS3ZIJGnU0HF7OavmQiPxAEN4QxKlsp1ZBpDSwa3nkP0jx2I62Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+e9SZ+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+e9SZ+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3E1C19421;
	Wed,  8 Apr 2026 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673207;
	bh=5ajefxLB1BaVwCM+Trv61gtoLq2/wtWmpJx+ixAjf0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+e9SZ+nHlC8Is1H7PguiniIQhW8y1ADDwo8TXNfXXti4/6ND1DKswEDTRWjLS9KA
	 +4x7Hee+bNvia9rUqP6STCE5LoiWgc9Uhj+anxAXFHUCDSOdSOg8O2WDkCZWmhu1GZ
	 bPXTN6V59M79FnQ+zIFHuBbUMrM1aQkNQnfNbndQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 141/277] io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()
Date: Wed,  8 Apr 2026 20:02:06 +0200
Message-ID: <20260408175939.140914180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxi Qian <qjx1298677004@gmail.com>

commit b948f9d5d3057b01188e36664e7c7604d1c8ecb5 upstream.

sqe->len is __u32 but gets stored into sr->len which is int. When
userspace passes sqe->len values exceeding INT_MAX (e.g. 0xFFFFFFFF),
sr->len overflows to a negative value. This negative value propagates
through the bundle recv/send path:

  1. io_recv(): sel.val = sr->len (ssize_t gets -1)
  2. io_recv_buf_select(): arg.max_len = sel->val (size_t gets
     0xFFFFFFFFFFFFFFFF)
  3. io_ring_buffers_peek(): buf->len is not clamped because max_len
     is astronomically large
  4. iov[].iov_len = 0xFFFFFFFF flows into io_bundle_nbufs()
  5. io_bundle_nbufs(): min_t(int, 0xFFFFFFFF, ret) yields -1,
     causing ret to increase instead of decrease, creating an
     infinite loop that reads past the allocated iov[] array

This results in a slab-out-of-bounds read in io_bundle_nbufs() from
the kmalloc-64 slab, as nbufs increments past the allocated iovec
entries.

  BUG: KASAN: slab-out-of-bounds in io_bundle_nbufs+0x128/0x160
  Read of size 8 at addr ffff888100ae05c8 by task exp/145
  Call Trace:
   io_bundle_nbufs+0x128/0x160
   io_recv_finish+0x117/0xe20
   io_recv+0x2db/0x1160

Fix this by rejecting negative sr->len values early in both
io_sendmsg_prep() and io_recvmsg_prep(). Since sqe->len is __u32,
any value > INT_MAX indicates overflow and is not a valid length.

Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Cc: stable@vger.kernel.org
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Link: https://patch.msgid.link/20260329153909.279046-1-qjx1298677004@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -422,6 +422,8 @@ int io_sendmsg_prep(struct io_kiocb *req
 
 	sr->done_io = 0;
 	sr->len = READ_ONCE(sqe->len);
+	if (unlikely(sr->len < 0))
+		return -EINVAL;
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
@@ -792,6 +794,8 @@ int io_recvmsg_prep(struct io_kiocb *req
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	if (unlikely(sr->len < 0))
+		return -EINVAL;
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~RECVMSG_FLAGS)
 		return -EINVAL;


