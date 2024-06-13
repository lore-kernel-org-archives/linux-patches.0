Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF241428FC;
	Thu, 13 Jun 2024 11:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279437; cv=none; b=PfY4sb4aYcW6dHHju56XMQpqFkgpaUmOVe9faBZD4rB5fH65ekwDi22Se4OxtflaZ8yDg8qZ2HWS2PB/gLfcJ1p1Rc3IAbqXN0IF2qRZfj8n3X3YYgoY+G1sOKHAhhtbHeoHoZUzIyJIh/Y/lVIniu2/3jG/cnigep+QMgmBBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279437; c=relaxed/simple;
	bh=jCX8JybEakncLTZwx6K3TnihnasRCjCqxsb5SXrD994=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwfwhyP69mYbj5cB3eplqEMi4FAByNVnisSNSdUlB8uUHjqfkvAk5TR4GsmyxUbmzV4gLhoBYsJVisKqxREdLjZvu7hqX5k8lzt6/iGJr+2yjjN/4WIntFjkXARo0qhSDbfv7fTy52WDDH9sUiSWZ/PHjRg47gxVf3gSqbYa4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHVOj4Kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHVOj4Kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7821C2BBFC;
	Thu, 13 Jun 2024 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279437;
	bh=jCX8JybEakncLTZwx6K3TnihnasRCjCqxsb5SXrD994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHVOj4KtT7mT7i1VP+hO6PZFd6NWTnZrfH8L1Fa8MqkSE2hUSEulA5KDDRqHX9uVS
	 et+kjS3i2Na3W7wZhR73m/sqJ7vbf8FDaVl0HjdC1wjzyQBQDPzU7dg/S8+8tVQ9wT
	 8tthRgpn7HcXCUmFEX7QwBapLjux6ekJaJ6K5c5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 075/157] io_uring: check for non-NULL file pointer in io_file_can_poll()
Date: Thu, 13 Jun 2024 13:33:20 +0200
Message-ID: <20240613113230.323813041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 5fc16fa5f13b3c06fdb959ef262050bd810416a2 upstream.

In earlier kernels, it was possible to trigger a NULL pointer
dereference off the forced async preparation path, if no file had
been assigned. The trace leading to that looks as follows:

BUG: kernel NULL pointer dereference, address: 00000000000000b0
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 67 PID: 1633 Comm: buf-ring-invali Not tainted 6.8.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 2/2/2022
RIP: 0010:io_buffer_select+0xc3/0x210
Code: 00 00 48 39 d1 0f 82 ae 00 00 00 48 81 4b 48 00 00 01 00 48 89 73 70 0f b7 50 0c 66 89 53 42 85 ed 0f 85 d2 00 00 00 48 8b 13 <48> 8b 92 b0 00 00 00 48 83 7a 40 00 0f 84 21 01 00 00 4c 8b 20 5b
RSP: 0018:ffffb7bec38c7d88 EFLAGS: 00010246
RAX: ffff97af2be61000 RBX: ffff97af234f1700 RCX: 0000000000000040
RDX: 0000000000000000 RSI: ffff97aecfb04820 RDI: ffff97af234f1700
RBP: 0000000000000000 R08: 0000000000200030 R09: 0000000000000020
R10: ffffb7bec38c7dc8 R11: 000000000000c000 R12: ffffb7bec38c7db8
R13: ffff97aecfb05800 R14: ffff97aecfb05800 R15: ffff97af2be5e000
FS:  00007f852f74b740(0000) GS:ffff97b1eeec0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000b0 CR3: 000000016deab005 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 ? __die+0x1f/0x60
 ? page_fault_oops+0x14d/0x420
 ? do_user_addr_fault+0x61/0x6a0
 ? exc_page_fault+0x6c/0x150
 ? asm_exc_page_fault+0x22/0x30
 ? io_buffer_select+0xc3/0x210
 __io_import_iovec+0xb5/0x120
 io_readv_prep_async+0x36/0x70
 io_queue_sqe_fallback+0x20/0x260
 io_submit_sqes+0x314/0x630
 __do_sys_io_uring_enter+0x339/0xbc0
 ? __do_sys_io_uring_register+0x11b/0xc50
 ? vm_mmap_pgoff+0xce/0x160
 do_syscall_64+0x5f/0x180
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0x55e0a110a67e
Code: ba cc 00 00 00 45 31 c0 44 0f b6 92 d0 00 00 00 31 d2 41 b9 08 00 00 00 41 83 e2 01 41 c1 e2 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 90 89 30 eb a9 0f 1f 40 00 48 8b 42 20 8b 00 a8 06 75 af 85 f6

because the request is marked forced ASYNC and has a bad file fd, and
hence takes the forced async prep path.

Current kernels with the request async prep cleaned up can no longer hit
this issue, but for ease of backporting, let's add this safety check in
here too as it really doesn't hurt. For both cases, this will inevitably
end with a CQE posted with -EBADF.

Cc: stable@vger.kernel.org
Fixes: a76c0b31eef5 ("io_uring: commit non-pollable provided mapped buffers upfront")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -442,7 +442,7 @@ static inline bool io_file_can_poll(stru
 {
 	if (req->flags & REQ_F_CAN_POLL)
 		return true;
-	if (file_can_poll(req->file)) {
+	if (req->file && file_can_poll(req->file)) {
 		req->flags |= REQ_F_CAN_POLL;
 		return true;
 	}


