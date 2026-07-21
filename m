Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7219D46DFE0;
	Tue, 21 Jul 2026 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658753; cv=none; b=KWJ2nEmF3Gja7pO1oCY48AfBrbR7Lp/85IZYrguU3rbg/1+sP8NtAh2BwWaoSPQPgk1JbitewDtZd20/BhJ/0uE5b19nxev4T5e+eBeJbnEyiBB+KYgqpJZdNRII7UakmhI0ZRR1KIfxgE5P+fHr/ti/x3/Sz65Jxes/Oil1Huw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658753; c=relaxed/simple;
	bh=ClUc532Ado/JYVaUnpOBgQGoMGwhPC2uQpjHB4poICw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igS9VubhMpXNAi5fwUTnpz4deIdJrSoAIxUw+LTRIb0Yl1bB2mSgNWW9AyPOdsexzthV7feYVjGKy0HkysuZpxeiG7dpnraBfoUK1yVj5GqNuP2UKBQ91MnBXJtpNMRonYi33tLHd4K5HquhrxA39EmwnFTPtsxiEaM/RCFFnog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNkAAqQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNkAAqQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93F21F000E9;
	Tue, 21 Jul 2026 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658752;
	bh=zqsqaADtSf7Ct2OTiuWxQO1bBL+95Rtj/WdzTB63fDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNkAAqQBE6cnQz+Av4DjhNwdeUR85JeuIuyuLZImbTrs1vXJXa/jR4KFhd+QYx89f
	 x4Jz7RLTjL59wyTxedaQB41lZ9veIM+0cNKFRO3vC4taSXM6lyGViVV1pb4g/DVn8B
	 T33T85OwY2BM3B9GG/ZEmQRz56XBErTMHhtS7i4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Ionut Nechita <ionut.nechita@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1263/1611] scsi: sas: Skip opt_sectors when DMA reports no real optimization hint
Date: Tue, 21 Jul 2026 17:22:59 +0200
Message-ID: <20260721152543.857702504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ionut Nechita <ionut.nechita@windriver.com>

commit be8fcd4a8217a916344c88a4b1b84f5736dda17e upstream.

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().

When the IOMMU is disabled or in passthrough mode and no DMA ops provide
an opt_mapping_size callback, dma_opt_mapping_size() returns
min(dma_max_mapping_size(), SIZE_MAX) which equals
dma_max_mapping_size() — a hard upper bound, not an optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) does not report an Optimal
Transfer Length in VPD page B0, so sdkp->opt_xfer_blocks remains 0.

sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) =
opt_sectors, propagating the bogus value into the block device's
optimal_io_size (visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_setup_opt_sectors() helper that sets
opt_sectors only when dma_opt_mapping_size() is strictly less than
dma_max_mapping_size(), indicating a genuine DMA optimization
constraint.

The helper computes min(opt_sectors, max_sectors) first, then rounds
down to a power of two so that filesystem geometry calculations always
produce clean results.

When the two DMA values are equal, no backend provided a real hint, so
opt_sectors stays at 0 ("no preference").

[mkp: implemented hch's suggestion]

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260519135238.373784-2-ionut.nechita@windriver.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_sas.c |   41 +++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
@@ -220,12 +221,45 @@ static int sas_bsg_initialize(struct Scs
  * SAS host attributes
  */
 
+/*
+ * Set shost->opt_sectors from the DMA optimal mapping size, but only
+ * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
+ * indicating a genuine optimization hint from an IOMMU or DMA backend.
+ * When the two are equal (e.g. IOMMU disabled / passthrough), no real
+ * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
+ * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
+ */
+static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
+{
+	struct device *dma_dev = shost->dma_dev;
+	size_t opt = dma_opt_mapping_size(dma_dev);
+	size_t max = dma_max_mapping_size(dma_dev);
+	unsigned int opt_sectors;
+
+	/* opt >= max means no real hint was provided by the DMA layer */
+	if (opt >= max)
+		return;
+
+	/* Clamp to max_sectors to avoid overflow in sector arithmetic */
+	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
+			    shost->max_sectors);
+
+	/* Guard against zero before rounddown_pow_of_two() */
+	if (!opt_sectors)
+		return;
+
+	/*
+	 * Round down to power-of-two so filesystem geometry calculations
+	 * (e.g. XFS stripe width/unit) always produce clean divisors.
+	 */
+	shost->opt_sectors = rounddown_pow_of_two(opt_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct device *dma_dev = shost->dma_dev;
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
@@ -237,10 +271,7 @@ static int sas_host_setup(struct transpo
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	sas_dma_setup_opt_sectors(shost);
 
 	return 0;
 }


