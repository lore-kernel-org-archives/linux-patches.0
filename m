Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8B415F29;
	Fri,  4 Sep 2026 05:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501267; cv=none; b=jMHTVx/Y0eTb2qubucIzMfQpH7roc/yVUk/qZx/efXfmtxEQVIBLyL9XOkJGjHBtnI1XP8ePN1bRrqCVwqmVU7wHH1DMgS4O7u0WZBFKav3/Cs2XVVWNFaVAwRgdJkRKJcyaybDc47Fm2LidrBVJd/CUKK6nGozKchC1K/iJd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501267; c=relaxed/simple;
	bh=lbG9lSjvNTiGOxa2Ma2z7XHg0J8s/e0y85QeYUe9g7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMM1sAyiXc2IoV3an17HwkavOK6k0YSOGx+FtcAy2IOeq61vbosEoP4i4bDMRLuQbbUC2Swur5EkG5kYCRxjpmq2/KVYoBVfICOZ3CsBySKwfEv6+cN+/53arzrZj/eshqAfLzkpsQdpTkmYNlJef+KT66jiQmX319SOAVdKaMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zkk3DlLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zkk3DlLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2A1F00A3D;
	Fri,  4 Sep 2026 05:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501265;
	bh=fJEMlai+40A36/CRsuluj8RMU0DnViYS3e89XmOPdUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zkk3DlLr6Zf/cCeF9bYntaq0JjEI4l5Gc3f67DVxc5YVovs19fCMEmeoro4Nc+owJ
	 VFixoYXfEwYjK4SdghxLYLMBbXcZX/73Yykqvyu4ibc6R8qk+6mQkUEPCNxzRAiVui
	 AhsBQWFPqHwIBKiYw67XHCI3VateL7o5HrIKgfvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vaganov <p.vaganov@ideco.ru>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 306/552] scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()
Date: Fri,  4 Sep 2026 06:57:43 +0200
Message-ID: <20260904045757.210420212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Petr Vaganov <p.vaganov@ideco.ru>

commit 626147717bea776b61ed3631d2c26283760c4cc4 upstream.

During fuzz testing, the following issue was discovered:

BUG: KMSAN: uninit-value in __dma_map_sg_attrs+0x217/0x310
 __dma_map_sg_attrs+0x217/0x310
 dma_map_sg_attrs+0x4a/0x70
 ata_qc_issue+0x9f8/0x1420
 __ata_scsi_queuecmd+0x1657/0x1740
 ata_scsi_queuecmd+0x79a/0x920
 scsi_queue_rq+0x4472/0x4f40
 blk_mq_dispatch_rq_list+0x1cca/0x3ee0
 __blk_mq_sched_dispatch_requests+0x458/0x630
 blk_mq_sched_dispatch_requests+0x15b/0x340
 __blk_mq_run_hw_queue+0xe5/0x250
 __blk_mq_delay_run_hw_queue+0x138/0x780
 blk_mq_run_hw_queue+0x4bb/0x7e0
 blk_mq_sched_insert_request+0x2a7/0x4c0
 blk_execute_rq+0x497/0x8a0
 sg_io+0xbe0/0xe20
 scsi_ioctl+0x2b36/0x3c60
 sr_block_ioctl+0x319/0x440
 blkdev_ioctl+0x80f/0xd70
 __se_sys_ioctl+0x219/0x420
 __x64_sys_ioctl+0x93/0xe0
 x64_sys_call+0x1d6c/0x3ad0
 do_syscall_64+0x4c/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Uninit was created at:
 __alloc_pages+0x5c0/0xc80
 alloc_pages+0xe0e/0x1050
 blk_rq_map_user_iov+0x2b77/0x6100
 blk_rq_map_user_io+0x2fa/0x4d0
 sg_io+0xad6/0xe20
 scsi_ioctl+0x2b36/0x3c60
 sr_block_ioctl+0x319/0x440
 blkdev_ioctl+0x80f/0xd70
 __se_sys_ioctl+0x219/0x420
 __x64_sys_ioctl+0x93/0xe0
 x64_sys_call+0x1d6c/0x3ad0
 do_syscall_64+0x4c/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Bytes 14-15 of 16 are uninitialized
Memory access of size 16 starts at ffff88800cbdb000

When processing the last unaligned element of the scatterlist, it is
supplemented with missing bytes in the amount of pad_len.  These bytes
remain uninitialized, which leads to a problem.

Extend last_sg->length by pad_len first, then use sg_zero_buffer() to
zero those pad_len bytes.  sg_zero_buffer() uses sg_miter internally,
which correctly handles sg entries spanning multiple pages and padding
that crosses a page boundary.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 40b01b9bbdf5 ("block: update bio according to DMA alignment padding")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Vaganov <p.vaganov@ideco.ru>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260628185229.37957-1-p.vaganov@ideco.ru
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1184,8 +1184,10 @@ blk_status_t scsi_alloc_sgtables(struct
 	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
 			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+		unsigned int data_len = last_sg->length;
 
 		last_sg->length += pad_len;
+		sg_zero_buffer(last_sg, 1, pad_len, data_len);
 		cmd->extra_len += pad_len;
 	}
 


