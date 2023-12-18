Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64011D13A;
	Mon, 18 Dec 2023 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXpg4oFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C457C433C9;
	Mon, 18 Dec 2023 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908223;
	bh=i0BxfCOp6SGJFRBkFEHn81FPZwtaB3LFnPJwyELgvI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXpg4oFJx9JSBTAAgjyaE5d7iOYveqKnyMSq00qmjCn+D5QFQD8UA8iKlrhQdskmx
	 eeihSdioFoY/wuRXcV3oAodQnkN8Y1wawMm7UxDeunfFl002d0DziZ0Dy+jPXaUeT/
	 X/OeFAYNdPlChKyKpvq8XoogFgrOXfcpL/SR5ZRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/166] nvme: catch errors from nvme_configure_metadata()
Date: Mon, 18 Dec 2023 14:51:05 +0100
Message-ID: <20231218135109.423422782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit cd9aed606088d36a7ffff3e808db4e76b1854285 ]

nvme_configure_metadata() is issuing I/O, so we might incur an I/O
error which will cause the connection to be reset.
But in that case any further probing will race with reset and
cause UAF errors.
So return a status from nvme_configure_metadata() and abort
probing if there was an I/O error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c09048984a277..d5c8b0a08d494 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1813,16 +1813,18 @@ static int nvme_init_ms(struct nvme_ns *ns, struct nvme_id_ns *id)
 	return ret;
 }
 
-static void nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
+static int nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
+	int ret;
 
-	if (nvme_init_ms(ns, id))
-		return;
+	ret = nvme_init_ms(ns, id);
+	if (ret)
+		return ret;
 
 	ns->features &= ~(NVME_NS_METADATA_SUPPORTED | NVME_NS_EXT_LBAS);
 	if (!ns->ms || !(ctrl->ops->flags & NVME_F_METADATA_SUPPORTED))
-		return;
+		return 0;
 
 	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		/*
@@ -1831,7 +1833,7 @@ static void nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
 		 * remap the separate metadata buffer from the block layer.
 		 */
 		if (WARN_ON_ONCE(!(id->flbas & NVME_NS_FLBAS_META_EXT)))
-			return;
+			return 0;
 
 		ns->features |= NVME_NS_EXT_LBAS;
 
@@ -1858,6 +1860,7 @@ static void nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
 		else
 			ns->features |= NVME_NS_METADATA_SUPPORTED;
 	}
+	return 0;
 }
 
 static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
@@ -2038,7 +2041,11 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 	ns->lba_shift = id->lbaf[lbaf].ds;
 	nvme_set_queue_limits(ns->ctrl, ns->queue);
 
-	nvme_configure_metadata(ns, id);
+	ret = nvme_configure_metadata(ns, id);
+	if (ret < 0) {
+		blk_mq_unfreeze_queue(ns->disk->queue);
+		goto out;
+	}
 	nvme_set_chunk_sectors(ns, id);
 	nvme_update_disk_info(ns->disk, ns, id);
 
-- 
2.43.0



