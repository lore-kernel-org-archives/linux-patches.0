Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4905624CEEA;
	Sat, 12 Sep 2026 09:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205493; cv=none; b=aLsDkD/yvIteQxWbj1C2PBDz5n4SrwZFm2Rz2ie8OS20Ykvp1RN1Pip1F8lUizOGHCazjTr0qUYAXA13LNDoi8YjqIGWCvHr2OAf7Levuuh16vCyQLkL5x+NJGtYAX+zCy5fAT6DBEKNc+OjDCS9V8Q2/nCJg61JUnuDYha+v54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205493; c=relaxed/simple;
	bh=XDg7l0ExrJrSh/90+Pm53h9rGDu46McW/GozsV+4xVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyozxaIap/bIUEVSYjfWpVwUQys6AOLEgbd9yU0oQI/L07Y7FA3nLvMEbN6So2BnPNT9f30PkOdsnnIJ4crVay8eViYjEcwKXtsqHqQLoZ9dRNuxV5Qoesiu01Iul1/YapI/U27FEL9aDvV9u/gMFtsOInVls6xoeXgMsGMcTh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sOF26fS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sOF26fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671721F000FF;
	Sat, 12 Sep 2026 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205492;
	bh=jVIVqdQQb8uBz3kAingvOwfxx3+wEociDnuI+fK26M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sOF26fSuRuhZv0gk3uZuG6MnwhsQEjFiElAuSKDYHRjLDyZVSeQdsNt4fi1PsT4s
	 iL+ArTMUKv59QlgMXCz42SurwyyICp5mhDLL0A1ln8pphDiBkXFlT82/TV8sPBpAGw
	 SseCHUjnmf//wU87aeOgzTtH0Jtw9tpIaTIrjK4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0014/1518] nvme: fold nvme_config_discard() into nvme_update_disk_info()
Date: Sat, 12 Sep 2026 08:36:23 +0200
Message-ID: <20260912065623.739704952@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 9110b85244f142ca4bcaea27be408c778d3c48d0 ]

The choice of what queue limits are set in nvme_update_disk_info() vs.
nvme_config_discard() seems a bit arbitrary. A subsequent commit will
compute the discard_granularity limit using struct nvme_id_ns, which is
only passed to nvme_update_disk_info() currently. So move the logic in
nvme_config_discard() to nvme_update_disk_info(). Replace several
instances of ns->ctrl in nvme_update_disk_info() with the ctrl variable
brought from nvme_config_discard().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1882,26 +1882,6 @@ static bool nvme_init_integrity(struct n
 	return true;
 }
 
-static void nvme_config_discard(struct nvme_ns *ns, struct queue_limits *lim)
-{
-	struct nvme_ctrl *ctrl = ns->ctrl;
-
-	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns->head, UINT_MAX))
-		lim->max_hw_discard_sectors =
-			nvme_lba_to_sect(ns->head, ctrl->dmrsl);
-	else if (ctrl->oncs & NVME_CTRL_ONCS_DSM)
-		lim->max_hw_discard_sectors = UINT_MAX;
-	else
-		lim->max_hw_discard_sectors = 0;
-
-	lim->discard_granularity = lim->logical_block_size;
-
-	if (ctrl->dmrl)
-		lim->max_discard_segments = ctrl->dmrl;
-	else
-		lim->max_discard_segments = NVME_DSM_MAX_RANGES;
-}
-
 static bool nvme_ns_ids_equal(struct nvme_ns_ids *a, struct nvme_ns_ids *b)
 {
 	return uuid_equal(&a->uuid, &b->uuid) &&
@@ -2084,6 +2064,7 @@ static bool nvme_update_disk_info(struct
 		struct queue_limits *lim)
 {
 	struct nvme_ns_head *head = ns->head;
+	struct nvme_ctrl *ctrl = ns->ctrl;
 	u32 bs = 1U << head->lba_shift;
 	u32 atomic_bs, phys_bs, io_opt = 0;
 	bool valid = true;
@@ -2118,11 +2099,26 @@ static bool nvme_update_disk_info(struct
 	lim->physical_block_size = min(phys_bs, atomic_bs);
 	lim->io_min = phys_bs;
 	lim->io_opt = io_opt;
-	if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
-	    (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
+	if ((ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
+	    (ctrl->oncs & NVME_CTRL_ONCS_DSM))
 		lim->max_write_zeroes_sectors = UINT_MAX;
 	else
-		lim->max_write_zeroes_sectors = ns->ctrl->max_zeroes_sectors;
+		lim->max_write_zeroes_sectors = ctrl->max_zeroes_sectors;
+
+	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns->head, UINT_MAX))
+		lim->max_hw_discard_sectors =
+			nvme_lba_to_sect(ns->head, ctrl->dmrsl);
+	else if (ctrl->oncs & NVME_CTRL_ONCS_DSM)
+		lim->max_hw_discard_sectors = UINT_MAX;
+	else
+		lim->max_hw_discard_sectors = 0;
+
+	lim->discard_granularity = lim->logical_block_size;
+
+	if (ctrl->dmrl)
+		lim->max_discard_segments = ctrl->dmrl;
+	else
+		lim->max_discard_segments = NVME_DSM_MAX_RANGES;
 	return valid;
 }
 
@@ -2387,7 +2383,6 @@ static int nvme_update_ns_info_block(str
 	if (!nvme_update_disk_info(ns, id, &lim))
 		capacity = 0;
 
-	nvme_config_discard(ns, &lim);
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    ns->head->ids.csi == NVME_CSI_ZNS)
 		nvme_update_zone_info(ns, &lim, &zi);


