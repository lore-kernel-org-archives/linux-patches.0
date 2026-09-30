Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714DE5383F2;
	Wed, 30 Sep 2026 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790044; cv=none; b=F+V1gYAYlPJw8z4xGYCphCJ4mIUqlFTuE/wFqOOnfU2RfO7yqS3obhEom8I+kwga9NtsIeBGqx+L718Pm3p6wbp3iccag3okuaUafv89WV1ANTFsK7oDieHeQN4Usnfg5jVNaej0RvA6zoOWDUDun8DD4a3ylNrAAfH8YXE7kNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790044; c=relaxed/simple;
	bh=q6clitCg08pgrR+LtqTjLlTy8aUQAswKMTAz27A18fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyA3zVSqzKQt56roxQ/+YGFXZJEI+sfHbIJiN1nmpqHJl9/D0ak74fFzqpXUU+tVNxeR66maDhoVBpmX5zPj7+FyVNRvy1WTxiYgq6rTPcdeBRfZt2NYritKmjH0AQVz002ci+IUEcl5WIPiTiSoDESDNgxxj9t1SRVJo90mCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMIxP2nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMIxP2nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D98E1F000FF;
	Wed, 30 Sep 2026 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790042;
	bh=vpJNPIU3X6Frv+jVaSxbFfdFoZR7yIScoK2g8ziW/zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMIxP2nlDn3s5j9P77/DYTdXRIFZPQ8pl/mmcusBYqIfzJ64uybn2w9jbtOsJwdgM
	 BCh1Tjlge5fvADPSlRavgvuQr7l8jjFYAESppmdaIdvJGy3JGaatuuqiXmLc0AOCrw
	 /aLfH1oUvRgwMPxzoi3kkrzsFIa0arNYfcgNXTWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weidong Zhu <weizhu@fiu.edu>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chao Shi <coshi036@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 645/877] nvme: skip the zoned limits update if the zone info query failed
Date: Wed, 30 Sep 2026 17:25:56 +0200
Message-ID: <20260930152428.577831771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit 3838e80fcfb32e62baffb63c6dc0a60153665a4d ]

nvme_query_zone_info() returns either a negative errno or a positive
NVMe status code, but nvme_update_ns_info_block() only tests for the
negative case:

	ret = nvme_query_zone_info(ns, lbaf, &zi);
	if (ret < 0)
		goto out;

If the device fails the Identify Namespace (I/O Command Set specific)
command, or the Identify Controller command issued by
nvme_set_max_append(), the positive status falls through and setup
continues with the zero-initialized zone info.  nvme_update_zone_info()
then marks the queue zoned with chunk_sectors and ns->head->zsze set to
zero.

blk_validate_zoned_limits() does not check chunk_sectors, so the limits
commit succeeds.  blk_revalidate_disk_zones() does reject the zero zone
size, but by then the limits are live and nothing rolls them back, so
I/O keeps being submitted to a zoned queue with a zero zone size and
disk_zone_no() shifts by ilog2(0):

  nvme0n1: Invalid non power of two zone size (0)
  UBSAN: shift-out-of-bounds in include/linux/blkdev.h:747:16
  shift exponent -1 is negative
   disk_zone_no include/linux/blkdev.h:747 [inline]
   bio_straddles_zones include/linux/blkdev.h:1058 [inline]
   blk_zone_wplug_handle_write block/blk-zoned.c:1423 [inline]
   blk_zone_plug_bio.cold+0x25/0x1c8 block/blk-zoned.c:1605
   blk_mq_submit_bio+0x18fb/0x2870 block/blk-mq.c:3196
   submit_bh_wbc+0x575/0x740 fs/buffer.c:2824
   __block_write_full_folio+0x728/0xdd0 fs/buffer.c:1933

Any device, firmware or NVMe-oF target that fails this one command
reaches this.

Skip the zoned limits update in that case, and log which of the two
things happened: during a revalidation the queue keeps the zone
geometry it was last validated with, and on a first scan the namespace
is registered without zoned limits, so that it is still available as a
handle for admin commands.  Neither of the paths in
nvme_query_zone_info() that return a positive status logs anything, so
the failure would otherwise be silent.

zi.zone_size is an exact indicator: every path that returns a positive
status returns before it is assigned, and after that the only failure
left is -ENODEV, which the caller already handles.

Found by FuzzNvme.
Fixes: c85c9ab926a5 ("nvme: split nvme_update_zone_info")
Cc: stable@vger.kernel.org
Cc: Weidong Zhu <weizhu@fiu.edu>
Suggested-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2206,9 +2206,26 @@ static int nvme_update_ns_info_block(str
 	if (!valid)
 		capacity = 0;
 
+	/*
+	 * A failed zone info query leaves zi zero-initialized, so skip the
+	 * zoned limits update instead of configuring the queue from it.
+	 * During a revalidation that keeps the zone geometry the queue was
+	 * last validated with; on a first scan the namespace is registered
+	 * without zoned limits, so that it is still available as a handle
+	 * for admin commands.
+	 */
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
-	    ns->head->ids.csi == NVME_CSI_ZNS)
-		nvme_update_zone_info(ns, &lim, &zi);
+	    ns->head->ids.csi == NVME_CSI_ZNS) {
+		if (zi.zone_size)
+			nvme_update_zone_info(ns, &lim, &zi);
+		else
+			dev_warn(ns->ctrl->device,
+				 "zone info query failed for nsid %u, %s\n",
+				 ns->head->ns_id,
+				 blk_queue_is_zoned(ns->disk->queue) ?
+				 "keeping the previous zone limits" :
+				 "not enabling zoned mode");
+	}
 
 	if (ns->ctrl->vwc & NVME_CTRL_VWC_PRESENT)
 		lim.features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;


