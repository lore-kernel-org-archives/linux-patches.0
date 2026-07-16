Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19663FD96B;
	Thu, 16 Jul 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209437; cv=none; b=g0uXL/2rgxFyBBSgWWuU8U7AJ8r1VKXGLYZIPbey4b0oRGkfwKt9sK7X+QDLuEVd6p2UnQ9A2058Gh+F248Mi1ab9JSF/o+E1OGG3JZfM5eFVuyG9PebTLxdzHA5Gr9Df6vuGlaSEbQKNa4JL3Jm6ZJaHqXT4C6caDDZlT2kYIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209437; c=relaxed/simple;
	bh=Bbn09k3gatgDUipqwbu/y9VTXI3qw4DWBBfmlt5zPpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAdpXBizhT9PT6/aXo/2LLHAAVlmVvBhjc8eDuF08eX01tckpKc4qsorzYEzuCNLQwxULgmBjnCXCBR0khWL2CcCPJClmQzHv3bi1Q4Q10xX+K09a7uF0cld18b9J8HikWDSk/1UQmuhtQykns4cQbRAKhMZm1Buz43PKYuPzM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT0Dmh76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT0Dmh76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324F11F00A3F;
	Thu, 16 Jul 2026 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209434;
	bh=Bj5I9ob+/FXQ5shhL+BISyLyoBJDFdjekSb/40znZLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zT0Dmh76DQ/NOK80P9moG2XQS/WyJiR5gf8YY08Pmf9TGbuTo7CZPeh6yjeVirFoR
	 7w4ba5U++VetiSRgFBoSl0/xEZiiZ3aOK/nHoALLhXhYnQ5uWX+YikQg3Q9ibxfYsh
	 Is4xUb4FlZJfrbzrt0ZyjJU0nIAvl23xqPRidKqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2cd473471e77bda12b0e@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 184/518] io_uring/nop: fix file reference leak with IOSQE_FIXED_FILE
Date: Thu, 16 Jul 2026 15:27:32 +0200
Message-ID: <20260716133051.862752642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Almpanis <vasilisalmpanis@gmail.com>

commit 2564ca2e31bd8ee8348362941af2ee4671e487ca upstream.

NOP file-acquisition support choses between a fixed (registered) file and
a normal fget()'d file based on its own IORING_NOP_FIXED_FILE flag in
sqe->nop_flags. However, a request's REQ_F_FIXED_FILE is set
independently from the generic IOSQE_FIXED_FILE sqe flag during request
init, before the issue handler runs.

If a NOP is submitted with IOSQE_FIXED_FILE set (so REQ_F_FIXED_FILE is
set) but without IORING_NOP_FIXED_FILE, io_nop() takes the normal path
and grabs a real reference via io_file_get_normal(). On completion,
io_put_file() only drops the reference when REQ_F_FIXED_FILE is clear,
so the fget()'d file is never released and leaks:

  BUG: memory leak
  unreferenced object 0xffff88800f42c240 (size 176):
    kmem_cache_alloc_noprof+0x358/0x440
    alloc_empty_file+0x57/0x180
    path_openat+0x44/0x1e50
    do_file_open+0x121/0x200
    do_sys_openat2+0xa7/0x150
    __x64_sys_openat+0x82/0xf0

Decide between fixed and normal file acquisition from REQ_F_FIXED_FILE,
the same way io_assign_file() does for every other opcode, and fold
IORING_NOP_FIXED_FILE into REQ_F_FIXED_FILE at prep time.

Cc: stable@vger.kernel.org
Fixes: a85f31052bce ("io_uring/nop: add support for testing registered files and buffers")
Reported-by: syzbot+2cd473471e77bda12b0e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=879092631b98f73a28ea405adacfa5bb34a14a25
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Link: https://patch.msgid.link/20260615144619.482749-1-vasilisalmpanis@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/nop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -41,6 +41,8 @@ int io_nop_prep(struct io_kiocb *req, co
 		nop->fd = READ_ONCE(sqe->fd);
 	else
 		nop->fd = -1;
+	if (nop->flags & IORING_NOP_FIXED_FILE)
+		req->flags |= REQ_F_FIXED_FILE;
 	if (nop->flags & IORING_NOP_FIXED_BUFFER)
 		req->buf_index = READ_ONCE(sqe->buf_index);
 	if (nop->flags & IORING_NOP_CQE32) {
@@ -60,12 +62,10 @@ int io_nop(struct io_kiocb *req, unsigne
 	int ret = nop->result;
 
 	if (nop->flags & IORING_NOP_FILE) {
-		if (nop->flags & IORING_NOP_FIXED_FILE) {
+		if (req->flags & REQ_F_FIXED_FILE)
 			req->file = io_file_get_fixed(req, nop->fd, issue_flags);
-			req->flags |= REQ_F_FIXED_FILE;
-		} else {
+		else
 			req->file = io_file_get_normal(req, nop->fd);
-		}
 		if (!req->file) {
 			ret = -EBADF;
 			goto done;


