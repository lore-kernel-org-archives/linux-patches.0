Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED961465A8;
	Tue, 25 Jun 2024 09:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308862; cv=none; b=A6YI0f53bgZqJt9lj0ySxOkyfQ6coQeuCia9TWw/XS0fkClOvTsYpmRjrcWIA5qHVk5DOhYfwavdxtgJviRohf7d/LLR1bN4AYMmhAl+DSRUqpZJGWhWyxvgyHvpIl0/Z+21RcRKnBxJ07sFAPxN+ErLnJ/RWAS8bFeyuJVj6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308862; c=relaxed/simple;
	bh=Kq1EBP7zADR3iig2oLyfzQLnrWu3Xa1na3h2amkauFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ8zeGlEQvwtfZf1/8dyRxeKW6kgcGQyhsu4cYzlYuSsgICG4J4x7yYhaKKBRZRI7UJdkabsS1anSJ6tFz9EAMBMql1XkPrDLCJC0iJ+f76BRDC/Ly6wy4l+bCBS+8TsWrjRG6x8dfvB1GeDfMDCUAwb/We7WvJSpYuDzSqRZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikWGV0he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikWGV0he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A9C32781;
	Tue, 25 Jun 2024 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308862;
	bh=Kq1EBP7zADR3iig2oLyfzQLnrWu3Xa1na3h2amkauFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikWGV0heWD/PVmXSDYVeONBbCkNe6LYAVcsJMxE6VcxgJTojxiUrn4zeN3MMMl9Z6
	 v5f6v5d2cmB4YHBsuxsszzNutWJXB6rhih9gN1Er14qROPgtunvvw6wnDiVI2lR/ja
	 Q6iEnLBTFExQlhGg+EEf5qTxwm289f2oNAvTtmvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/192] io_uring/sqpoll: work around a potential audit memory leak
Date: Tue, 25 Jun 2024 11:31:17 +0200
Message-ID: <20240625085537.361865732@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65b5dbe3c850e..350436e55aafe 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -240,6 +240,14 @@ static int io_sq_thread(void *data)
 		sqd->sq_cpu = raw_smp_processor_id();
 	}
 
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



