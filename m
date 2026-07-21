Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12128305E3B;
	Tue, 21 Jul 2026 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671214; cv=none; b=n4Wslcp2NFxZlpNjzytpVyYwSZ6eiFRcHsIMLEa7Re599qjKPzUvGoKFfaXCWBlytLw5uVPrK4TWymhmPbC6h7drwRe+CBJvZIdmOVQ++5zr2a1LBFZ0VDy8JNFsP7dTtDbOUZhlrQSDXdnRMQTqYSSqQXanSbtCFEjkyMJXskE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671214; c=relaxed/simple;
	bh=PeIizlVPmd4OPfDd8D5XeIZBcePXCghJhTcxq57ur/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQsTtQbL1T+mkPDR/fZVKmOVR0wEE6ZvC/5fUKHwucoXgmjUmblnZ9sKWwIxT4N2Unh+lPJYm0l+7g64+501oxkgto2Iogu0AleWEjPP/R/hPf09BUACRJpuMVCO1RasU5qkOKnRKKBFJpWmMs0DMnrV8k7jvad5JuGt6C55huE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SadF2C40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SadF2C40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ED71F000E9;
	Tue, 21 Jul 2026 22:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671213;
	bh=Q6zOzf7b2a85EToFnO9Q2shpnMITzLmZYWI2UrwhHJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SadF2C40EoiT2UuN5aspa+YOGo4PcIQTJEW0jE4Pg4aR3JlUFoTiDSDF99PxVw2qC
	 piiXkOWqzp1QNfO1/4DIGN4m86SepMusNijZkAH2oaslTs+GQsdCZs4s7ZmLo7ioR0
	 uTdco1KBJBJ2Ms2xFbGLNgghZ01nydr92GEYnXb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Igor Achkinazi <igor.achkinazi@dell.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 160/843] nvme-multipath: set BIO_REMAPPED on bios remapped to per-path namespace disks
Date: Tue, 21 Jul 2026 17:16:35 +0200
Message-ID: <20260721152409.614861668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Achkinazi, Igor <Igor.Achkinazi@dell.com>

commit 88bac2c1a72b8f4f71e9845699aa872df04e5850 upstream.

When nvme_ns_head_submit_bio() remaps a bio from the multipath head to a
per-path namespace, bio_set_dev() clears BIO_REMAPPED.  The remapped bio
is then resubmitted through submit_bio_noacct() which calls
bio_check_eod() because BIO_REMAPPED is not set.

This races with nvme_ns_remove() which zeroes the per-path capacity
before synchronize_srcu():

  CPU 0 (IO submission)
  ---------------------
  srcu_read_lock()
  nvme_find_path() -> ns
    [NVME_NS_READY is set]

  CPU 1 (namespace removal)
  -------------------------
  clear_bit(NVME_NS_READY)
  set_capacity(ns->disk, 0)
  synchronize_srcu()  <- blocks

  CPU 0 (IO submission)
  ---------------------
  bio_set_dev(bio, ns->disk->part0)
    [clears BIO_REMAPPED]
  submit_bio_noacct(bio)
    -> bio_check_eod() sees capacity=0
    -> bio fails with IO error

The SRCU read lock prevents synchronize_srcu() from completing, but does
not prevent set_capacity(0) from executing.  The bio fails the EOD check
before it reaches the NVMe driver, so nvme_failover_req() never gets a
chance to redirect it to another path of multipath.  IO errors are
reported to the application despite another path being available.

On older kernels (before commit 0b64682e78f7 "block: skip unnecessary
checks for split bio"), the same race was also reachable through split
remainders resubmitted via submit_bio_noacct().

Fix this by setting BIO_REMAPPED after bio_set_dev() in
nvme_ns_head_submit_bio().  This skips bio_check_eod() on the per-path
device; the EOD check already passed on the multipath head.

NVMe per-path namespace devices are always whole disks (bd_partno=0), so
the blk_partition_remap() skip also gated by BIO_REMAPPED is a no-op.
The flag does not persist across failover and cannot go stale if the
namespace geometry changes between attempts: nvme_failover_req() calls
bio_set_dev() to redirect the bio back to the multipath head, which
clears BIO_REMAPPED.  When nvme_requeue_work() resubmits through
submit_bio_noacct(), bio_check_eod() runs normally against the current
capacity.

Same approach as commit 3a905c37c351 ("block: skip bio_check_eod for
partition-remapped bios").

Fixes: a7c7f7b2b641 ("nvme: use bio_set_dev to assign ->bi_bdev")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Igor Achkinazi <igor.achkinazi@dell.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -337,6 +337,12 @@ static blk_qc_t nvme_ns_head_submit_bio(
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
 		bio_set_dev(bio, ns->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
 		bio->bi_opf |= REQ_NVME_MPATH;
 		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);


