Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3EB415B7B;
	Sat, 12 Sep 2026 09:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205619; cv=none; b=lBvHtfn9Hwf2nVes4JU7I8ZyatHQstI3RgXbXkNwZxfq82QceUUyEyMHi0uIz9COiM6HHgwKlA9SiM0wYpbadX704Kh99Czkf7M7NxiFh6hB1EkH6z2qeq3CzhXnHSpwiwZhnkxT+i9DD4EQU9NiGYlgWzpz/0IteDxML9BuHIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205619; c=relaxed/simple;
	bh=K84HUdGS667OfsJ0tFiWP3QadZNOUuCpN0vPl9yF/ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euVHjkOFAELzK0lTdPLJ2L5Kq/LbacisqrOwyPAGyhi8Bc2BqsjSSTWGAj5+IIJjxcYwcSPYmNcTitZoE0lHNgs7Yhi4u4hboi3mkS5gUlRecLISbiEga9qNyhwRBTtdLCCaPYe1hdo0t8LJ/LPxDX9xTibyXCqUXPblKgkRM0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRpNCaJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRpNCaJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F461F000FF;
	Sat, 12 Sep 2026 09:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205614;
	bh=x8A7quyyzuDd7eSvGdh74u7xyqihzwObphjbcGIrb+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRpNCaJn+STSQKkeF1y4CG9x8nfl0JUA585a73pkSekzecF//DGNsJpGVQ9pZqAAp
	 lf67lDYRKNjQLX+fr3O3eQEo1aFvNeDQIRFeh2TadWei4Cieugu07CeZeGqQdBRnYO
	 TzodfC8uJ7U4J40uW607qHYG+i35EvCyPssJTugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weidong Zhu <weizhu@fiu.edu>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chao Shi <coshi036@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0037/1518] nvme: skip the zoned limits update if the zone info query failed
Date: Sat, 12 Sep 2026 08:36:46 +0200
Message-ID: <20260912065624.270358642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
@@ -2383,9 +2383,26 @@ static int nvme_update_ns_info_block(str
 	if (!nvme_update_disk_info(ns, id, &lim))
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
 
 	if ((ns->ctrl->vwc & NVME_CTRL_VWC_PRESENT) && !info->no_vwc)
 		lim.features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;


