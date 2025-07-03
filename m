Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A52ED143;
	Thu,  3 Jul 2025 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555146; cv=none; b=PaFDpsWrue1r85XRhELoRVxCmFkq6IuP1Qcb7cFR0HuUHqxGqBgoqzmNzOTZfJHjZgj6SHRgOB5FUWYam/1X30Gocqv30WnxzAbwcWaScGBApJ/elNZ4fBHdlfjYe+6fTPz044ADuuqGg1I1XYsJpDjTimkgN56lYtfLwonvpHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555146; c=relaxed/simple;
	bh=kU1I7uJs761zqxDX2P+sXWh6j5XVB7EwSrsWHahGzt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzYVYpEkza7qOjirun41Bc/b80pTsCsJCqFECmBeHZaYqmcVvj3emxAWBPXRAuSEXryNFsgJeyMekXMoNGkxo6XnHNkXDJeDyy4g39mPXeOdHQQ4uXyK84kaXU8T4TewtPbPhd/pbIhuUyQUqalMFXqQsJTqtjovf2wvLsiiddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9jfOi/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9jfOi/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F07C4CEE3;
	Thu,  3 Jul 2025 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555146;
	bh=kU1I7uJs761zqxDX2P+sXWh6j5XVB7EwSrsWHahGzt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9jfOi/ZatOdL4qj15rBqHoDxm2HuMDBJ8qYqgyfexd/cNxbWx1gNZ5tVoZhNykLs
	 FMHycBD8rGgyHSUDjN75RiPbPLlG2VVCa19KMDobXHIkvZ+WzM+r79Mkiuv2BCiIwM
	 5NmLRp1uB2+ktjhfP6nT8hl3xrq3cHK48LTjZRRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 160/263] nvme: refactor the atomic write unit detection
Date: Thu,  3 Jul 2025 16:41:20 +0200
Message-ID: <20250703144010.777447980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b2e607fecac15e07f50269c080e2e71b5049dfa2 ]

Move all the code out of nvme_update_disk_info into the helper, and
rename the helper to have a somewhat less clumsy name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Stable-dep-of: f46d273449ba ("nvme: fix atomic write size validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 72 +++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 93a8119ad5ca6..1c853c5b8169b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1996,21 +1996,51 @@ static void nvme_configure_metadata(struct nvme_ctrl *ctrl,
 }
 
 
-static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
-			struct nvme_id_ns *id, struct queue_limits *lim,
-			u32 bs, u32 atomic_bs)
+static u32 nvme_configure_atomic_write(struct nvme_ns *ns,
+		struct nvme_id_ns *id, struct queue_limits *lim, u32 bs)
 {
-	unsigned int boundary = 0;
+	u32 atomic_bs, boundary = 0;
 
-	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
-		if (le16_to_cpu(id->nabspf))
+	/*
+	 * We do not support an offset for the atomic boundaries.
+	 */
+	if (id->nabo)
+		return bs;
+
+	if ((id->nsfeat & NVME_NS_FEAT_ATOMICS) && id->nawupf) {
+		/*
+		 * Use the per-namespace atomic write unit when available.
+		 */
+		atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
+		if (id->nabspf)
 			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+	} else {
+		/*
+		 * Use the controller wide atomic write unit.  This sucks
+		 * because the limit is defined in terms of logical blocks while
+		 * namespaces can have different formats, and because there is
+		 * no clear language in the specification prohibiting different
+		 * values for different controllers in the subsystem.
+		 */
+		atomic_bs = (1 + ns->ctrl->awupf) * bs;
+	}
+
+	if (!ns->ctrl->subsys->atomic_bs) {
+		ns->ctrl->subsys->atomic_bs = atomic_bs;
+	} else if (ns->ctrl->subsys->atomic_bs != atomic_bs) {
+		dev_err_ratelimited(ns->ctrl->device,
+			"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
+			ns->disk ? ns->disk->disk_name : "?",
+			ns->ctrl->subsys->atomic_bs,
+			atomic_bs);
 	}
+
 	lim->atomic_write_hw_max = atomic_bs;
 	lim->atomic_write_hw_boundary = boundary;
 	lim->atomic_write_hw_unit_min = bs;
 	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
 	lim->features |= BLK_FEAT_ATOMIC_WRITES;
+	return atomic_bs;
 }
 
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
@@ -2048,34 +2078,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 		valid = false;
 	}
 
-	atomic_bs = phys_bs = bs;
-	if (id->nabo == 0) {
-		/*
-		 * Bit 1 indicates whether NAWUPF is defined for this namespace
-		 * and whether it should be used instead of AWUPF. If NAWUPF ==
-		 * 0 then AWUPF must be used instead.
-		 */
-		if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf)
-			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
-		else
-			atomic_bs = (1 + ns->ctrl->awupf) * bs;
-
-		/*
-		 * Set subsystem atomic bs.
-		 */
-		if (ns->ctrl->subsys->atomic_bs) {
-			if (atomic_bs != ns->ctrl->subsys->atomic_bs) {
-				dev_err_ratelimited(ns->ctrl->device,
-					"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
-					ns->disk ? ns->disk->disk_name : "?",
-					ns->ctrl->subsys->atomic_bs,
-					atomic_bs);
-			}
-		} else
-			ns->ctrl->subsys->atomic_bs = atomic_bs;
-
-		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
-	}
+	phys_bs = bs;
+	atomic_bs = nvme_configure_atomic_write(ns, id, lim, bs);
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
 		/* NPWG = Namespace Preferred Write Granularity */
-- 
2.39.5



