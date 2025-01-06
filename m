Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23AD1C5F11;
	Mon,  6 Jan 2025 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177813; cv=none; b=mKTOsWR2flRJgB/osKmG267ClYl85JwM3g77Ug2N+Dn3PaBdeNJc8RDBgHkUB0tc0F/Z53X2UWdOa+tv0jH0DTppg8bq0Ov6UMkc94ocjSqtAbpB2DKjldQRPLcmJl/mHLRkl8Rv6Nbyxmi6HXgYADsq2mxnhSboqozixBAYbas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177813; c=relaxed/simple;
	bh=9/YiY4bRoz0X5a2Pkyz9XnKCYxd9KP8tdWPRcwMFyK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoO75qY1na2DDBs6XHd+2l6UZzhp8u+XAtHEA7HtCiXyDskRCwV/LGcv0DsmdUZGlvPGC5YAPtHl2hjoF4wqiKO7v9H+LAYca/4Ky7WCQZ7jvqsrnkmSBgPeScZcrc0TS5wq6wuJI+P0UWchbi9+Jr5s1+wr611jdaI5xt+uYho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsVph+ZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsVph+ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F7EC4CED2;
	Mon,  6 Jan 2025 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177813;
	bh=9/YiY4bRoz0X5a2Pkyz9XnKCYxd9KP8tdWPRcwMFyK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsVph+ZZWRpD3p6MXMPs1Ds03kTJijwI2+6zZCU8t31/PdVl3zuYwkiWLgkGT9RFh
	 28KvmyjJdHxcPmYdMvszEbaKVmUpT1DNEtm66m+gMkmjJLprcEgEXohRze7Tfvsj9W
	 sVgSdqjXg1qftn4do35bsHIivA1MM/wZEP3dq/Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/156] io_uring/net: always initialize kmsg->msg.msg_inq upfront
Date: Mon,  6 Jan 2025 16:15:52 +0100
Message-ID: <20250106151144.221368004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c6e60a0a68b7e6b3c7e33863a16e8e88ba9eee6f ]

syzbot reports that ->msg_inq may get used uinitialized from the
following path:

BUG: KMSAN: uninit-value in io_recv_buf_select io_uring/net.c:1094 [inline]
BUG: KMSAN: uninit-value in io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_recv_buf_select io_uring/net.c:1094 [inline]
 io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_issue_sqe+0x420/0x2130 io_uring/io_uring.c:1740
 io_queue_sqe io_uring/io_uring.c:1950 [inline]
 io_req_task_submit+0xfa/0x1d0 io_uring/io_uring.c:1374
 io_handle_tw_list+0x55f/0x5c0 io_uring/io_uring.c:1057
 tctx_task_work_run+0x109/0x3e0 io_uring/io_uring.c:1121
 tctx_task_work+0x6d/0xc0 io_uring/io_uring.c:1139
 task_work_run+0x268/0x310 kernel/task_work.c:239
 io_run_task_work+0x43a/0x4a0 io_uring/io_uring.h:343
 io_cqring_wait io_uring/io_uring.c:2527 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3439 [inline]
 __se_sys_io_uring_enter+0x204f/0x4ce0 io_uring/io_uring.c:3330
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3330
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

and it is correct, as it's never initialized upfront. Hence the first
submission can end up using it uninitialized, if the recv wasn't
successful and the networking stack didn't honor ->msg_get_inq being set
and filling in the output value of ->msg_inq as requested.

Set it to 0 upfront when it's allocated, just to silence this KMSAN
warning. There's no side effect of using it uninitialized, it'll just
potentially cause the next receive to use a recv value hint that's not
accurate.

Fixes: c6f32c7d9e09 ("io_uring/net: get rid of ->prep_async() for receive side")
Reported-by: syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 18507658a921..7f549be9abd1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -748,6 +748,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 	if (req->opcode == IORING_OP_RECV) {
 		kmsg->msg.msg_name = NULL;
 		kmsg->msg.msg_namelen = 0;
+		kmsg->msg.msg_inq = 0;
 		kmsg->msg.msg_control = NULL;
 		kmsg->msg.msg_get_inq = 1;
 		kmsg->msg.msg_controllen = 0;
-- 
2.39.5



