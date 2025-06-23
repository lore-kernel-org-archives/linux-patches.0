Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627DD1AD3FA;
	Mon, 23 Jun 2025 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715208; cv=none; b=VpTzyMB/9CZLrKtP3YX2TGFr8d7axXBV5vECr8lIHvOcYfvMp3HPrLeGnZ0Pp062ebg4yKmpK/2/S10OpF0/5lzkAXtuVAcAFEAEPsLUFYSoAkl9azj2S7ylsWw91LcdK5P3lAzkLgvWFL/hTQpT2PEOY81ACWBJXGwtQOwKhEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715208; c=relaxed/simple;
	bh=KAQCDUk2ojznMxb6q0Fq95XW8JWB8VNdWmsfaRGrSAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9ARGCvnqGJoRvF5Pa3sZj7lMKLJktYCYhQYbpM8Ky3ZxnuXdMnbGaR+BJnOZNT1BwmWcyGpJg5LGQDYX+aAe6dGQTAyJB5a7JGVSPJtQ5Weaxel68GTkgsjq5+kA1pCrD+9Gbe1I7+NZ51DHX1/AtqpBfW6+zIz8OMOnUVvktc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMkRBlaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMkRBlaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFCC4CEEA;
	Mon, 23 Jun 2025 21:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715208;
	bh=KAQCDUk2ojznMxb6q0Fq95XW8JWB8VNdWmsfaRGrSAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMkRBlawo6WtQPZfuEaX8q3k0jGt/VZBw9pnY4Ph2SeTCcX8UJZS07ul1wXo/oxyD
	 M7IKumYOkYfV8b8yngMmNy9tPjl1mgPpkArx9Ntxuo6tUwVl9/nW719CSXWXs/c3jg
	 +kZPDJbS+tN4ujQ+fC3Zk3n2fuZtnqM6CSrrG8ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 445/592] io_uring/rsrc: validate buffer count with offset for cloning
Date: Mon, 23 Jun 2025 15:06:43 +0200
Message-ID: <20250623130711.016665472@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 1d27f11bf02b38c431e49a17dee5c10a2b4c2e28 upstream.

syzbot reports that it can trigger a WARN_ON() for kmalloc() attempt
that's too big:

WARNING: CPU: 0 PID: 6488 at mm/slub.c:5024 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
Modules linked in:
CPU: 0 UID: 0 PID: 6488 Comm: syz-executor312 Not tainted 6.15.0-rc7-syzkaller-gd7fa1af5b33e #0 PREEMPT
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
lr : __do_kmalloc_node mm/slub.c:-1 [inline]
lr : __kvmalloc_node_noprof+0x3b4/0x640 mm/slub.c:5012
sp : ffff80009cfd7a90
x29: ffff80009cfd7ac0 x28: ffff0000dd52a120 x27: 0000000000412dc0
x26: 0000000000000178 x25: ffff7000139faf70 x24: 0000000000000000
x23: ffff800082f4cea8 x22: 00000000ffffffff x21: 000000010cd004a8
x20: ffff0000d75816c0 x19: ffff0000dd52a000 x18: 00000000ffffffff
x17: ffff800092f39000 x16: ffff80008adbe9e4 x15: 0000000000000005
x14: 1ffff000139faf1c x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000139faf21 x10: 0000000000000003 x9 : ffff80008f27b938
x8 : 0000000000000002 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 00000000ffffffff x4 : 0000000000400dc0 x3 : 0000000200000000
x2 : 000000010cd004a8 x1 : ffff80008b3ebc40 x0 : 0000000000000001
Call trace:
 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024 (P)
 kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
 io_rsrc_data_alloc io_uring/rsrc.c:206 [inline]
 io_clone_buffers io_uring/rsrc.c:1178 [inline]
 io_register_clone_buffers+0x484/0xa14 io_uring/rsrc.c:1287
 __io_uring_register io_uring/register.c:815 [inline]
 __do_sys_io_uring_register io_uring/register.c:926 [inline]
 __se_sys_io_uring_register io_uring/register.c:903 [inline]
 __arm64_sys_io_uring_register+0x42c/0xea8 io_uring/register.c:903
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

which is due to offset + buffer_count being too large. The registration
code checks only the total count of buffers, but given that the indexing
is an array, it should also check offset + count. That can't exceed
IORING_MAX_REG_BUFFERS either, as there's no way to reach buffers beyond
that limit.

There's no issue with registrering a table this large, outside of the
fact that it's pointless to register buffers that cannot be reached, and
that it can trigger this kmalloc() warning for attempting an allocation
that is too large.

Cc: stable@vger.kernel.org
Fixes: b16e920a1909 ("io_uring/rsrc: allow cloning at an offset")
Reported-by: syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/684e77bd.a00a0220.279073.0029.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1174,6 +1174,8 @@ static int io_clone_buffers(struct io_ri
 		return -EINVAL;
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
+	if (nbufs > IORING_MAX_REG_BUFFERS)
+		return -EINVAL;
 
 	ret = io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.nr));
 	if (ret)


