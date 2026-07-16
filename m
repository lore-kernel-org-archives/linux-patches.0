Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0F1313E30;
	Thu, 16 Jul 2026 14:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210935; cv=none; b=ngfRdGUdOHpkX4P8LUTCRblwciFCnhL63xveKU2Qq5EEywcGDGmIRCSdzlYQqeRj/GOMN+03DNESrpVWa+TvfQ/bmm2mfNVFi6ZOsmpCYA2kXhCRc11kmCsHxT7oKyenfrXXpZhbLQJhI5Iiv7xvvDkEJTSvXdQlvmkAXeCtDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210935; c=relaxed/simple;
	bh=Mto55vdJ3SOjE2VEfqsPTbvWWtVnakw4ov+alywScp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLR3XjTZ5kXcL8kMXVXLx2WtHjIFJgkcJiH/YL5Hlnh+mREGMblFaK4r5uP/KlE01Izva0DBHJN4IB1TRlqnCUf3sf7DrfdjOoFfx2q5pMgPmF6MQAy/kUlmpmSrmrALARJiMFHOnTbotFT8hw6ctvfrbpSp1B23C0H0FvrN1EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ve1O2jdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ve1O2jdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087941F000E9;
	Thu, 16 Jul 2026 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210933;
	bh=U2KxE5WBuF5s0dGHfrXNFyyyFw9fE9jwjgPwwWUFUFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ve1O2jdU7qCId0r0BSp/5dMIfle0e396fUj1nh99fJjnCZeCbPSuyJLUp8FlwwG7X
	 R1eVNpaOajk4TQLhoqcKpvduGSBby8geNUxDJeZPnO1/xinOLTfIQgyF4x5hLTiKEb
	 f3fIuV914gSsH0A3mK+rvKH7FjGyCNiMLy5kQsdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2cd473471e77bda12b0e@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 182/480] io_uring/nop: fix file reference leak with IOSQE_FIXED_FILE
Date: Thu, 16 Jul 2026 15:28:49 +0200
Message-ID: <20260716133048.659981277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


