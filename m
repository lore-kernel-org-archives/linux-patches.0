Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDEC1465A8;
	Tue, 25 Jun 2024 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309482; cv=none; b=iWNbFfb29a7brfmrjC9X/DxKmUdfBAaJI/4f0YVuf1buCuIBTl1cQP0DhuPhbIqUsXAIr270GDXVoB9GmRzccoaBkT7zYEp6lIhk/1eHAJ0uh/gfuAQmHgPrpa7p4joOW2w1k4yU2T0FppWJgWPHHaJT65dFVKLgpA5HxWLpaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309482; c=relaxed/simple;
	bh=KTttK6OmGZlmnM8oyIdLubgpw04RnoTmcdgXaflH0fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr5APlvsT1jE+65ofj8xdb96DDG9KhALrdiq80AMUNXU0g3tns/+uOBhSmzmh/8afvpFslORKLVBaz0IM+e+EivR/Ag1HUJS+pHd1z0H4JGRQa2fhdnabNtPUb4MSDt99J5EMkcRpLXhGbPmmnTI5GIX2tHUV48k/SZaP2r8czM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eILNQ2ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eILNQ2ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A9CC32781;
	Tue, 25 Jun 2024 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309482;
	bh=KTttK6OmGZlmnM8oyIdLubgpw04RnoTmcdgXaflH0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eILNQ2irOt1e15hhzeYoQS5bBD4oHV96rYGknsu+hV7GrpTEVyn/RaNJKMnth94uM
	 nucWXZoNOYRF7aEnqIPjWDe2WytmM1BoarDQjmY93ywI7QoxEd5wKJY2xP0svhBaOu
	 n6UBnR82GcdC10TvNsmTjoSNWOx0TNrI1Stf8+do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/131] io_uring/sqpoll: work around a potential audit memory leak
Date: Tue, 25 Jun 2024 11:32:38 +0200
Message-ID: <20240625085526.065319441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c4ce0ab27646f4206a9eb502d6fe45cb080e1cae ]

kmemleak complains that there's a memory leak related to connect
handling:

unreferenced object 0xffff0001093bdf00 (size 128):
comm "iou-sqp-455", pid 457, jiffies 4294894164
hex dump (first 32 bytes):
02 00 fa ea 7f 00 00 01 00 00 00 00 00 00 00 00  ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
backtrace (crc 2e481b1a):
[<00000000c0a26af4>] kmemleak_alloc+0x30/0x38
[<000000009c30bb45>] kmalloc_trace+0x228/0x358
[<000000009da9d39f>] __audit_sockaddr+0xd0/0x138
[<0000000089a93e34>] move_addr_to_kernel+0x1a0/0x1f8
[<000000000b4e80e6>] io_connect_prep+0x1ec/0x2d4
[<00000000abfbcd99>] io_submit_sqes+0x588/0x1e48
[<00000000e7c25e07>] io_sq_thread+0x8a4/0x10e4
[<00000000d999b491>] ret_from_fork+0x10/0x20

which can can happen if:

1) The command type does something on the prep side that triggers an
   audit call.
2) The thread hasn't done any operations before this that triggered
   an audit call inside ->issue(), where we have audit_uring_entry()
   and audit_uring_exit().

Work around this by issuing a blanket NOP operation before the SQPOLL
does anything.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 7b6facf529b8d..11610a70573ab 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -235,6 +235,14 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
+	/*
+	 * Force audit context to get setup, in case we do prep side async
+	 * operations that would trigger an audit call before any issue side
+	 * audit has been done.
+	 */
+	audit_uring_entry(IORING_OP_NOP);
+	audit_uring_exit(true, 0);
+
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
-- 
2.43.0



