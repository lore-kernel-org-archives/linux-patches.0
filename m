Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA275FBEF;
	Tue, 25 Jun 2024 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308168; cv=none; b=eYuYFRQBfCYNEKqjqK/yZn1y0GHtj9mTidk1maJCAp5g2Dc2VG7ae8KbpaJ3Rf7GB0ZsW5zAtM4M0tJyhSWzXzRDVfHNFP8qwd0cRm4Vd4ovPUveYaVahjrmD5kh5bgO0SHV5lfnsqtT4hJI2buSKs8VNkTZBzg+vZ0pmZ1TPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308168; c=relaxed/simple;
	bh=mtAzezlpLx7QbzpCq5L1j+hF65JQuG+GUp7VdwLr2Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIkmZOGJm4ULVYlNpeeDe5YfxD77Y/7Jmoxn0Gs616tuTUwHlz2CDNPimAoXquq3RbelLowvArL1HjksV/32jAWMFkwoh8cq/NuTE9a0P7wEXsGJDiuWRjTId9mDBn9Q2jdmJ/Ga19mWmCh+m0Oi/U8USNAsmIOMfY057Tf0jSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfjYOqmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfjYOqmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBAAC32781;
	Tue, 25 Jun 2024 09:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308167;
	bh=mtAzezlpLx7QbzpCq5L1j+hF65JQuG+GUp7VdwLr2Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfjYOqmuhPiKgri3gjNqvu7C9XqL5irHhScEPR7G1CyOMXFI5dYM/Rez/OcKqonyL
	 uSdaYRT3e90lg2KKcFUyljaEmoCya9QdsbQUr2mOkCYhMUyh3dJ1DXzx28Wm2GWsHn
	 WFV2Ja2PP6OMCB6aNgIqIHw4X5pJr3Ab0xj7W6aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/250] io_uring/sqpoll: work around a potential audit memory leak
Date: Tue, 25 Jun 2024 11:29:23 +0200
Message-ID: <20240625085548.247959646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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
index 158ab09c605ba..b3722e5275e77 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -293,6 +293,14 @@ static int io_sq_thread(void *data)
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



