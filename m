Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FBB37E2F3;
	Sat, 12 Sep 2026 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241401; cv=none; b=i1crP8wM32zYhXRSqHrEhekpWKpobfvr7Ra3Pq3Tag9Ii39WWTMQ3DhzDUoXJtTShD2+9tGEVMCHGqMeT+z8VrYOrs288ZFvXr4BAeqq8qC9fovFwCjcZl5siK3Dy+gMFUaHSZuBFDZIYwjMq8G5ytPMIsr43LOykQzxAv6hOdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241401; c=relaxed/simple;
	bh=iTyVDrLfrav0FcfNWGSBZh0DLj99kePlN5SW7yeLHbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa1JIr96SYvS0KVn6qltnCAccUA72iHGVsvDoq6bsxrc6QQbpnii3hDirAcCrdWZfFU6d64LNPg3YOCBUE06yKywm8fjfEwvZoAG0gLpmoiyqLPfnP1UAOCaxjaCUJ25wQXZ7A7CtLb3ITu8OraDxmV4KhELZws3oJ5Qyo3qepY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCz0Dt1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCz0Dt1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015531F000FF;
	Sat, 12 Sep 2026 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241399;
	bh=87Pxd4na54H+T1+YhS5DbB9HwT+WyDcE2GJ6ae7+h3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCz0Dt1mplwRl9EK5r3G/1CRNzhXIBPrFKYlo9o/4HpNM5k9Aw0S024ixykY2mCeo
	 raaGwTnxYpET3/bEMkwpSqUI/4KXOIBdrYs4ckFrMUruwYPxFd3J2eMrIuGyQ44xdm
	 TjTXG7s2N3wSm/0OL1iL2FVNxAJ8mCfaiEwswrC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 128/798] nvme: zero the discard fallback page
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065519.910232228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit bededeaaeff404978a5a8e2a605a6c3017cddd3e upstream.

nvme_setup_discard() always maps sizeof(struct nvme_dsm_range) *
NVME_DSM_MAX_RANGES = 4096 bytes as the DSM payload however many ranges
the command declares, because some devices ignore the 'Number of Ranges'
field - the Fixes: commit records two that read past the declared ranges.
A single-range discard fills only the first 16 bytes.

Normally the buffer comes from kzalloc() and the other 4080 bytes are
zero.  When that allocation fails the code falls back to the
per-controller ctrl->discard_page, which nvme_init_ctrl() obtains with
alloc_page(GFP_KERNEL) and nothing ever zeroes, so those 4080 bytes are
whatever the page last held and are handed to the controller.  Reaching
it requires the kzalloc(GFP_ATOMIC | __GFP_NOWARN) to fail, that is
memory pressure; it is not remotely triggerable.  Failing the allocation
under KMSAN reproduces it, with the leaked tail full of vmemmap struct
page pointers.  The extent in the report is a partial transfer of the
payload, not the whole 4096 bytes; the 16-byte boundary in it is the one
declared range:

[   11.991601] BUG: KMSAN: uninit-value in dma_map_phys+0x14c8/0x1900
[   11.991969]  dma_map_phys+0x14c8/0x1900
[   11.992220]  dma_map_page_attrs+0xcf/0x130
[   11.992485]  e1000_xmit_frame+0x4099/0x6d10
[   11.992768]  dev_hard_start_xmit+0x22f/0xa80
[   11.993068]  sch_direct_xmit+0x35c/0xcb0
[   11.993315]  __dev_queue_xmit+0x1ee5/0x5eb0
[   11.993608]  ip_finish_output2+0x1903/0x1c30
[   11.993881]  ip_finish_output+0x288/0x870
[   11.994125]  ip_output+0x15e/0x400
[   11.994365]  __ip_queue_xmit+0x1e85/0x1fb0
[   11.994639]  ip_queue_xmit+0x60/0x80
[   11.994899]  __tcp_transmit_skb+0x4e71/0x5fa0
[   11.995210]  tcp_write_xmit+0x3a36/0x9160
[   11.995533]  __tcp_push_pending_frames+0xc5/0x3c0
[   11.995854]  tcp_push+0x7dc/0x840
[   11.996076]  tcp_sendmsg_locked+0x766c/0x8400
[   11.996371]  tcp_sendmsg+0x4b/0x90
[   11.996572]  inet_sendmsg+0x134/0x2a0
[   11.996823]  __sock_sendmsg+0x265/0x360
[   11.997076]  sock_sendmsg+0x100/0x1e0
[   11.997293]  nvme_tcp_try_send+0x196f/0x6370
[   11.997605]  nvme_tcp_queue_rq+0x1d54/0x20b0
[   11.997882]  blk_mq_dispatch_rq_list+0x5ee/0x2e50
[   11.998175]  __blk_mq_sched_dispatch_requests+0x16dc/0x24a0
[   11.998539]  blk_mq_sched_dispatch_requests+0x11b/0x2c0
[   11.998865]  blk_mq_run_work_fn+0x13b/0x280
[   11.999146]  process_scheduled_works+0x966/0x1ad0
[   11.999465]  worker_thread+0xe44/0x1480
[   11.999709]  kthread+0x53b/0x600
[   11.999927]  ret_from_fork+0x29f/0x7c0
[   12.000191]  ret_from_fork_asm+0x1a/0x30
[   12.000460]
[   12.000558] Uninit was created at:
[   12.000788]  __alloc_frozen_pages_noprof+0x8bf/0xd30
[   12.001096]  alloc_pages_mpol+0x1d0/0x5f0
[   12.001326]  alloc_pages_noprof+0x102/0x290
[   12.001627]  nvme_init_ctrl+0x5a3/0x9f0
[   12.001891]  nvme_tcp_create_ctrl+0xd75/0x19b0
[   12.002170]  nvmf_dev_write+0x4c68/0x4fd0
[   12.002426]  vfs_write+0x587/0x1a10
[   12.002636]  __x64_sys_write+0x207/0x4f0
[   12.002874]  x64_sys_call+0x2ff0/0x3ea0
[   12.003123]  do_syscall_64+0x147/0x3b0
[   12.003400]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   12.003680]
[   12.003777] Bytes 16-2843 of 2844 are uninitialized
[   12.004068] Memory access of size 2844 starts at ffff888109f82000
[   12.004412]
[   12.004530] CPU: 0 UID: 0 PID: 101 Comm: kworker/0:1H Not tainted 7.2.0-rc5-NVMECTL-gf5098b6bae76 #1 PREEMPT(lazy)
[   12.005127] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.005762] Workqueue: kblockd blk_mq_run_work_fn
[   12.006073] =====================================================

Allocate the page with __GFP_ZERO.  The single allocation site covers
every use of it: bytes no discard has written stay zero, and bytes one
did write hold that controller's own range list, which it has already
been sent.

Fixes: 530436c45ef2 ("nvme: Discard workaround for non-conformant devices")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4630,7 +4630,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctr
 
 	BUILD_BUG_ON(NVME_DSM_MAX_RANGES * sizeof(struct nvme_dsm_range) >
 			PAGE_SIZE);
-	ctrl->discard_page = alloc_page(GFP_KERNEL);
+	ctrl->discard_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!ctrl->discard_page) {
 		ret = -ENOMEM;
 		goto out;


