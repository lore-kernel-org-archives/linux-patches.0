Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D516416869;
	Fri,  4 Sep 2026 05:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499441; cv=none; b=k34WpOHPZJwZgOVzDkIQ/LS0az6JSOFt/ZWxrCJF6X/+EH2uCqGJf2mmKKtF7y2XHdrlNIuCLJfrldMTqfyo5BJjeUx759GGPV/39dufiLn4LGdB4KZZuuYYoJ+WM95e07PDZk5Tqlldmj9evyE+qPG5Bmc5emleBBr2YjHDMzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499441; c=relaxed/simple;
	bh=U9t2f5p0taTn12wJAqnL4nzSE02Yq25ro6wUclricG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESOp0CNSKLslUGdA8fNGM7vDreUHgmHUGX+le7Nn/nZ0D4OOsA56p08Khjh3Apu7wheb530fl0fOF3wRnnqn1xiDOy0ZEofhy0AV8ZalxXJbBi5Pz0zb6lvy9PyNo1IkfBRndSpW+bvCNIG3FX34PAG4Jlge4m0iqwoyqFGFRhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRZZmNV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRZZmNV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8695B1F00ACA;
	Fri,  4 Sep 2026 05:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499440;
	bh=VeQAiiz80ti/bZaecdl70c8Fca+guHltY98N92hPDIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRZZmNV3TLJBI0SLg+oF+CoyMFhLe7H1PgxCBCCHpkmpeh1pU/rlI4qcozKQRLsr0
	 EHv29KIgIJTLJuGZ+h0rin3CkTG/xOZGaQ9mg6E59pG0wq/m6RJedHEEQMzXPhFT0M
	 bSNwg6BB35+b/b1ROuOUd8tZHz0wt4XiQSGn2jh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vaganov <p.vaganov@ideco.ru>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 419/713] scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()
Date: Fri,  4 Sep 2026 06:56:27 +0200
Message-ID: <20260904045813.224004124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1187,8 +1187,10 @@ blk_status_t scsi_alloc_sgtables(struct
 	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
 			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+		unsigned int data_len = last_sg->length;
 
 		last_sg->length += pad_len;
+		sg_zero_buffer(last_sg, 1, pad_len, data_len);
 		cmd->extra_len += pad_len;
 	}
 


