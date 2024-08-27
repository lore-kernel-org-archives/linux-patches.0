Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944E51BC9FC;
	Tue, 27 Aug 2024 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771713; cv=none; b=tKXViIIBRnFycBhHaP89n3fVjTIT8gnanPlw8VrPZdjmZBD1MKoN4jq83RlJl93pSlZzjcW2MOxwfTIs+6Hp5zV/nQPTLsNOzKeKd+CI5COciN2FT3RX2Ac34zWey0wOA55VWlKhIO2a5Wen55uPOI+X0jwGslr+1P4qdU2tl+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771713; c=relaxed/simple;
	bh=idSxrWsTuxWwjl/ombsewL/ef7W7d/Wxpio1T13Hjco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDv5jihKHlaN4paGvOZAvS+B1lSNeV/cnzXAUl3Ft0XReqx1oyZGRwoKTprD/O+EgXlU/19aVYKEwOlCgpWZ0fMG5ieIqHmbuK9R6v0AjP8BU7j+Wxq4BQtFQClpMt9LRniImLwuiAwaA0r1YJxtvdnQfAKtH+ycr1ts17lFPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/3aELx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/3aELx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2F5C4AF50;
	Tue, 27 Aug 2024 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771713;
	bh=idSxrWsTuxWwjl/ombsewL/ef7W7d/Wxpio1T13Hjco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/3aELx0255L+/4FRh5z/iInc5Vn98OljSMGsoXCOKoD9r0Pm6IoXX/brgEb6kk2y
	 kUZBAKgJ10XF3buT3GzPsiP53xBjUbaDQCYKI46aseNxY3jq/a+5OnDoq0f6Ptd0uh
	 iyMTo6/8TKsxjBiRyja20+ib8IZK/uUDf8JO05rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kolbj=C3=B8rn=20Barmen?= <linux-ppc@kolla.no>,
	=?UTF-8?q?Jon=C3=A1=C5=A1=20Vidra?= <vidra@ufal.mff.cuni.cz>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.10 240/273] ata: pata_macio: Fix DMA table overflow
Date: Tue, 27 Aug 2024 16:39:24 +0200
Message-ID: <20240827143842.535423957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 822c8020aebcf5804a143b891e34f29873fee5e2 upstream.

Kolbjørn and Jonáš reported that their 32-bit PowerMacs were crashing
in pata-macio since commit 09fe2bfa6b83 ("ata: pata_macio: Fix
max_segment_size with PAGE_SIZE == 64K").

For example:

  kernel BUG at drivers/ata/pata_macio.c:544!
  Oops: Exception in kernel mode, sig: 5 [#1]
  BE PAGE_SIZE=4K MMU=Hash SMP NR_CPUS=2 DEBUG_PAGEALLOC PowerMac
  ...
  NIP pata_macio_qc_prep+0xf4/0x190
  LR  pata_macio_qc_prep+0xfc/0x190
  Call Trace:
    0xc1421660 (unreliable)
    ata_qc_issue+0x14c/0x2d4
    __ata_scsi_queuecmd+0x200/0x53c
    ata_scsi_queuecmd+0x50/0xe0
    scsi_queue_rq+0x788/0xb1c
    __blk_mq_issue_directly+0x58/0xf4
    blk_mq_plug_issue_direct+0x8c/0x1b4
    blk_mq_flush_plug_list.part.0+0x584/0x5e0
    __blk_flush_plug+0xf8/0x194
    __submit_bio+0x1b8/0x2e0
    submit_bio_noacct_nocheck+0x230/0x304
    btrfs_work_helper+0x200/0x338
    process_one_work+0x1a8/0x338
    worker_thread+0x364/0x4c0
    kthread+0x100/0x104
    start_kernel_thread+0x10/0x14

That commit increased max_segment_size to 64KB, with the justification
that the SCSI core was already using that size when PAGE_SIZE == 64KB,
and that there was existing logic to split over-sized requests.

However with a sufficiently large request, the splitting logic causes
each sg to be split into two commands in the DMA table, leading to
overflow of the DMA table, triggering the BUG_ON().

With default settings the bug doesn't trigger, because the request size
is limited by max_sectors_kb == 1280, however max_sectors_kb can be
increased, and apparently some distros do that by default using udev
rules.

Fix the bug for 4KB kernels by reverting to the old max_segment_size.

For 64KB kernels the sg_tablesize needs to be halved, to allow for the
possibility that each sg will be split into two.

Fixes: 09fe2bfa6b83 ("ata: pata_macio: Fix max_segment_size with PAGE_SIZE == 64K")
Cc: stable@vger.kernel.org # v6.10+
Reported-by: Kolbjørn Barmen <linux-ppc@kolla.no>
Closes: https://lore.kernel.org/all/62d248bb-e97a-25d2-bcf2-9160c518cae5@kolla.no/
Reported-by: Jonáš Vidra <vidra@ufal.mff.cuni.cz>
Closes: https://lore.kernel.org/all/3b6441b8-06e6-45da-9e55-f92f2c86933e@ufal.mff.cuni.cz/
Tested-by: Kolbjørn Barmen <linux-ppc@kolla.no>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_macio.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 1b85e8bf4ef9..1cb8d24b088f 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -208,6 +208,19 @@ static const char* macio_ata_names[] = {
 /* Don't let a DMA segment go all the way to 64K */
 #define MAX_DBDMA_SEG		0xff00
 
+#ifdef CONFIG_PAGE_SIZE_64KB
+/*
+ * The SCSI core requires the segment size to cover at least a page, so
+ * for 64K page size kernels it must be at least 64K. However the
+ * hardware can't handle 64K, so pata_macio_qc_prep() will split large
+ * requests. To handle the split requests the tablesize must be halved.
+ */
+#define PATA_MACIO_MAX_SEGMENT_SIZE	SZ_64K
+#define PATA_MACIO_SG_TABLESIZE		(MAX_DCMDS / 2)
+#else
+#define PATA_MACIO_MAX_SEGMENT_SIZE	MAX_DBDMA_SEG
+#define PATA_MACIO_SG_TABLESIZE		MAX_DCMDS
+#endif
 
 /*
  * Wait 1s for disk to answer on IDE bus after a hard reset
@@ -912,16 +925,10 @@ static int pata_macio_do_resume(struct pata_macio_priv *priv)
 
 static const struct scsi_host_template pata_macio_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
-	.sg_tablesize		= MAX_DCMDS,
+	.sg_tablesize		= PATA_MACIO_SG_TABLESIZE,
 	/* We may not need that strict one */
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	/*
-	 * The SCSI core requires the segment size to cover at least a page, so
-	 * for 64K page size kernels this must be at least 64K. However the
-	 * hardware can't handle 64K, so pata_macio_qc_prep() will split large
-	 * requests.
-	 */
-	.max_segment_size	= SZ_64K,
+	.max_segment_size	= PATA_MACIO_MAX_SEGMENT_SIZE,
 	.device_configure	= pata_macio_device_configure,
 	.sdev_groups		= ata_common_sdev_groups,
 	.can_queue		= ATA_DEF_QUEUE,
-- 
2.46.0



