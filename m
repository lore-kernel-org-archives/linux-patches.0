Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105871552FD;
	Tue, 10 Sep 2024 10:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962508; cv=none; b=IWXq2/sgrKLd2ePBkZZhrslHzheOfTsInRj0eYdqIWdOj/rphOK4XWb/GFl+CBicVYQhADWdHAuNgDwHZcfpEHOb6KDmtEBz1H/IfXrdBxSoUN7uaFqEBzAzDKCk5sOcii0I2a6Cmo04RudsnHJOqJsuMMSYY/YC7H0Jbg4wvEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962508; c=relaxed/simple;
	bh=8lbI2b7Z96KE9gBvGctYLNAWWY8DVSkDaisWSDnkAjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mo9AXXQPoU/f1Oak2DQXnFeOzaImP+dJzUt/vIswgo7o1UayZB3zFVRzhP0CiiLK7S+XoVXYPCyDlHo/d46xfVJhfQwsa6VfWwCgu/RhZDrblYQRdOz55xx2E9y84HgalFnYDw3yKFTTrH7cwsFe+bAlwsQaRbpM2vjqX7dUZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJvsMXmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJvsMXmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894A0C4CED0;
	Tue, 10 Sep 2024 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962507;
	bh=8lbI2b7Z96KE9gBvGctYLNAWWY8DVSkDaisWSDnkAjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJvsMXmA2s6zt3ujZtygb8OwnMaNRAFolMgvnufDNnPBUG6hcPCqrlftPp67uqUtp
	 ZFq1w9q9DgZBiKYdo6uZI4/MkU/oq44QI7TKJTgVKQbCc89B3l+GooJNxfayxRuaIx
	 RRHEDQazsMe5kJyXkPNI2J8VlLa/Iuy/CUHKk4M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 031/121] mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K
Date: Tue, 10 Sep 2024 11:31:46 +0200
Message-ID: <20240910092547.211223679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Protsenko <semen.protsenko@linaro.org>

commit 8396c793ffdf28bb8aee7cfe0891080f8cab7890 upstream.

Commit 616f87661792 ("mmc: pass queue_limits to blk_mq_alloc_disk") [1]
revealed the long living issue in dw_mmc.c driver, existing since the
time when it was first introduced in commit f95f3850f7a9 ("mmc: dw_mmc:
Add Synopsys DesignWare mmc host driver."), also making kernel boot
broken on platforms using dw_mmc driver with 16K or 64K pages enabled,
with this message in dmesg:

    mmcblk: probe of mmc0:0001 failed with error -22

That's happening because mmc_blk_probe() fails when it calls
blk_validate_limits() consequently, which returns the error due to
failed max_segment_size check in this code:

    /*
     * The maximum segment size has an odd historic 64k default that
     * drivers probably should override.  Just like the I/O size we
     * require drivers to at least handle a full page per segment.
     */
    ...
    if (WARN_ON_ONCE(lim->max_segment_size < PAGE_SIZE))
        return -EINVAL;

In case when IDMAC (Internal DMA Controller) is used, dw_mmc.c always
sets .max_seg_size to 4 KiB:

    mmc->max_seg_size = 0x1000;

The comment in the code above explains why it's incorrect. Arnd
suggested setting .max_seg_size to .max_req_size to fix it, which is
also what some other drivers are doing:

   $ grep -rl 'max_seg_size.*=.*max_req_size' drivers/mmc/host/ | \
     wc -l
   18

This change is not only fixing the boot with 16K/64K pages, but also
leads to a better MMC performance. The linear write performance was
tested on E850-96 board (eMMC only), before commit [1] (where it's
possible to boot with 16K/64K pages without this fix, to be able to do
a comparison). It was tested with this command:

    # dd if=/dev/zero of=somefile bs=1M count=500 oflag=sync

Test results are as follows:

  - 4K pages,  .max_seg_size = 4 KiB:                   94.2 MB/s
  - 4K pages,  .max_seg_size = .max_req_size = 512 KiB: 96.9 MB/s
  - 16K pages, .max_seg_size = 4 KiB:                   126 MB/s
  - 16K pages, .max_seg_size = .max_req_size = 2 MiB:   128 MB/s
  - 64K pages, .max_seg_size = 4 KiB:                   138 MB/s
  - 64K pages, .max_seg_size = .max_req_size = 8 MiB:   138 MB/s

Unfortunately, SD card controller is not enabled in E850-96 yet, so it
wasn't possible for me to run the test on some cheap SD cards to check
this patch's impact on those. But it's possible that this change might
also reduce the writes count, thus improving SD/eMMC longevity.

All credit for the analysis and the suggested solution goes to Arnd.

[1] https://lore.kernel.org/all/20240215070300.2200308-18-hch@lst.de/

Fixes: f95f3850f7a9 ("mmc: dw_mmc: Add Synopsys DesignWare mmc host driver.")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYtddf2Fd3be+YShHP6CmSDNcn0ptW8qg+stUKW+Cn0rjQ@mail.gmail.com/
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240306232052.21317-1-semen.protsenko@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2831,8 +2831,8 @@ static int dw_mci_init_slot(struct dw_mc
 	if (host->use_dma == TRANS_MODE_IDMAC) {
 		mmc->max_segs = host->ring_size;
 		mmc->max_blk_size = 65535;
-		mmc->max_seg_size = 0x1000;
-		mmc->max_req_size = mmc->max_seg_size * host->ring_size;
+		mmc->max_req_size = DW_MCI_DESC_DATA_LENGTH * host->ring_size;
+		mmc->max_seg_size = mmc->max_req_size;
 		mmc->max_blk_count = mmc->max_req_size / 512;
 	} else if (host->use_dma == TRANS_MODE_EDMAC) {
 		mmc->max_segs = 64;


