Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469DC2E2F04;
	Tue, 15 Jul 2025 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587047; cv=none; b=GGjgoLJBX5hwHlI7TPOROttgC43vob+S94oTVJiAQ9hIWi4yg+p5pDLUnRGDCE/rjw1aYDqYuptHlmk6bBz76PKqeCeJrPdwF/xb0lMlEjJnjcgo3ysCj8v3Q90V2OqAKv3me4nnznUwMDA203kNmJR5S8n8yobaZXSwms71pMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587047; c=relaxed/simple;
	bh=Zw3KWAJQesZ2/C1EJGrdmMVtKkRmyvhVEjXLs7sauH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eystuq6x8/56mRfv3wdf5kbkjEhhkV4BICtZlRKrsWybXYUgGoxav9ru/eSrcLsEEB8xg3c2XGsT62brxNIGklLHP2dtV1O4b/4+YFtL2f+WpWVCU0lElTaVXRft5s7Egc/WEToo/+aiWv8X94ku2TiVtVLLYbrpIDtiytizxTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3nVNH+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3nVNH+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01A9C4CEE3;
	Tue, 15 Jul 2025 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587047;
	bh=Zw3KWAJQesZ2/C1EJGrdmMVtKkRmyvhVEjXLs7sauH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3nVNH+kEGJXkvmEzt8frl4ZubS4rNxP6A27ZiAzWmGX1mN+36P1lJI+YyTS3Umyn
	 9/gjbBvidj/wQcTPeV+UhZ7GxNrlky7eWxg3gzFLnuSP5s5E+vukPKQKgu6ZVshCUF
	 z2qt7OjQAhUm56hxvTZQwfIJl4mcyKrxa35TUXQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 146/192] block: reject bs > ps block devices when THP is disabled
Date: Tue, 15 Jul 2025 15:14:01 +0200
Message-ID: <20250715130820.770290496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Pankaj Raghav <p.raghav@samsung.com>

[ Upstream commit 4cdf1bdd45ac78a088773722f009883af30ad318 ]

If THP is disabled and when a block device with logical block size >
page size is present, the following null ptr deref panic happens during
boot:

[   [13.2 mK  AOSAN: null-ptr-deref in range [0x0000000000000000-0x0000000000K0 0 0[07]
[   13.017749] RIP: 0010:create_empty_buffers+0x3b/0x380
<snip>
[   13.025448] Call Trace:
[   13.025692]  <TASK>
[   13.025895]  block_read_full_folio+0x610/0x780
[   13.026379]  ? __pfx_blkdev_get_block+0x10/0x10
[   13.027008]  ? __folio_batch_add_and_move+0x1fa/0x2b0
[   13.027548]  ? __pfx_blkdev_read_folio+0x10/0x10
[   13.028080]  filemap_read_folio+0x9b/0x200
[   13.028526]  ? __pfx_filemap_read_folio+0x10/0x10
[   13.029030]  ? __filemap_get_folio+0x43/0x620
[   13.029497]  do_read_cache_folio+0x155/0x3b0
[   13.029962]  ? __pfx_blkdev_read_folio+0x10/0x10
[   13.030381]  read_part_sector+0xb7/0x2a0
[   13.030805]  read_lba+0x174/0x2c0
<snip>
[   13.045348]  nvme_scan_ns+0x684/0x850 [nvme_core]
[   13.045858]  ? __pfx_nvme_scan_ns+0x10/0x10 [nvme_core]
[   13.046414]  ? _raw_spin_unlock+0x15/0x40
[   13.046843]  ? __switch_to+0x523/0x10a0
[   13.047253]  ? kvm_clock_get_cycles+0x14/0x30
[   13.047742]  ? __pfx_nvme_scan_ns_async+0x10/0x10 [nvme_core]
[   13.048353]  async_run_entry_fn+0x96/0x4f0
[   13.048787]  process_one_work+0x667/0x10a0
[   13.049219]  worker_thread+0x63c/0xf60

As large folio support depends on THP, only allow bs > ps block devices
if THP is enabled.

Fixes: 47dd67532303 ("block/bdev: lift block size restrictions to 64k")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20250704092134.289491-1-p.raghav@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9a1f0ee40b566..7c2a66995518a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -268,11 +268,16 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
  * however we constrain this to what we can validate and test.
  */
 #define BLK_MAX_BLOCK_SIZE      SZ_64K
+#else
+#define BLK_MAX_BLOCK_SIZE      PAGE_SIZE
+#endif
+
 
 /* blk_validate_limits() validates bsize, so drivers don't usually need to */
 static inline int blk_validate_block_size(unsigned long bsize)
-- 
2.39.5



