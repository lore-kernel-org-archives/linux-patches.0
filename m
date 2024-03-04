Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0211193;
	Mon,  4 Mar 2024 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588487; cv=none; b=Nv09fmpd6vvogRgAcumG1RATLk2kdSuUmIpgZjZ+6WtuXKhmEFkjvCmiSwaxAp2CLsfNFdPIbHPGRKTP7F9xeYqeZcg2Vs9iHzx6oje6tyEx7R4O8qZCvm9f/CYPUCZCjYez4N/QD1K/vCEbfUThviUSxo40J4nsT43i/qhD/dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588487; c=relaxed/simple;
	bh=wHnLe8Xq1+HwsGlh6Xiy7HC+1W9Li7qeK18Vgm7yIEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEMVdn3B+kk5jIZH8i5x4N4vJd/n+oBE42X/mf6NMVBeRdKXBZq7bWjM/hyd29Ltt6qDMlzK8hyAjwlFlsI4ShRdYIVgu8iAdEOQib/yvX47PVfXs/ImIcMsrr2zOAMDH/HhZEBHfNycgsUkAa7wUWY4hnEUlWnRW2o52304+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qammQ3BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qammQ3BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB1DC433F1;
	Mon,  4 Mar 2024 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588487;
	bh=wHnLe8Xq1+HwsGlh6Xiy7HC+1W9Li7qeK18Vgm7yIEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qammQ3BZ2t7VbzKZMHPiWC2+SwEEcbOdlFZ8VkugPlESRnCO/NkyfW+4FCsrvI20R
	 fXM1kZ8AHtOk+OkFCj61mdesS0QdAMLNzTXjlz+6O1mRdQHjOkxEpaUy/hge5pL6ZE
	 JD0sDa0ge3BpUAXUtThLH2GzMvkcnxRu99RdYbA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/143] dmaengine: idxd: Remove shadow Event Log head stored in idxd
Date: Mon,  4 Mar 2024 21:24:05 +0000
Message-ID: <20240304211553.893367946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit ecec7c9f29a7114a3e23a14020b1149ea7dffb4f ]

head is defined in idxd->evl as a shadow of head in the EVLSTATUS register.
There are two issues related to the shadow head:

1. Mismatch between the shadow head and the state of the EVLSTATUS
   register:
   If Event Log is supported, upon completion of the Enable Device command,
   the Event Log head in the variable idxd->evl->head should be cleared to
   match the state of the EVLSTATUS register. But the variable is not reset
   currently, leading mismatch between the variable and the register state.
   The mismatch causes incorrect processing of Event Log entries.

2. Unnecessary shadow head definition:
   The shadow head is unnecessary as head can be read directly from the
   EVLSTATUS register. Reading head from the register incurs no additional
   cost because event log head and tail are always read together and
   tail is already read directly from the register as required by hardware.

Remove the shadow Event Log head stored in idxd->evl to address the
mentioned issues.

Fixes: 244da66cda35 ("dmaengine: idxd: setup event log configuration")
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240215024931.1739621-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c    | 2 +-
 drivers/dma/idxd/debugfs.c | 2 +-
 drivers/dma/idxd/idxd.h    | 1 -
 drivers/dma/idxd/irq.c     | 3 +--
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index d32deb9b4e3de..4eeec95a66751 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -345,7 +345,7 @@ static void idxd_cdev_evl_drain_pasid(struct idxd_wq *wq, u32 pasid)
 	spin_lock(&evl->lock);
 	status.bits = ioread64(idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	t = status.tail;
-	h = evl->head;
+	h = status.head;
 	size = evl->size;
 
 	while (h != t) {
diff --git a/drivers/dma/idxd/debugfs.c b/drivers/dma/idxd/debugfs.c
index 9cfbd9b14c4c4..f3f25ee676f30 100644
--- a/drivers/dma/idxd/debugfs.c
+++ b/drivers/dma/idxd/debugfs.c
@@ -68,9 +68,9 @@ static int debugfs_evl_show(struct seq_file *s, void *d)
 
 	spin_lock(&evl->lock);
 
-	h = evl->head;
 	evl_status.bits = ioread64(idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	t = evl_status.tail;
+	h = evl_status.head;
 	evl_size = evl->size;
 
 	seq_printf(s, "Event Log head %u tail %u interrupt pending %u\n\n",
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index e269ca1f48625..6fc79deb99bfd 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -286,7 +286,6 @@ struct idxd_evl {
 	unsigned int log_size;
 	/* The number of entries in the event log. */
 	u16 size;
-	u16 head;
 	unsigned long *bmap;
 	bool batch_fail[IDXD_MAX_BATCH_IDENT];
 };
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index b501320a9c7ad..0bbc6bdc6145e 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -367,9 +367,9 @@ static void process_evl_entries(struct idxd_device *idxd)
 	/* Clear interrupt pending bit */
 	iowrite32(evl_status.bits_upper32,
 		  idxd->reg_base + IDXD_EVLSTATUS_OFFSET + sizeof(u32));
-	h = evl->head;
 	evl_status.bits = ioread64(idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	t = evl_status.tail;
+	h = evl_status.head;
 	size = idxd->evl->size;
 
 	while (h != t) {
@@ -378,7 +378,6 @@ static void process_evl_entries(struct idxd_device *idxd)
 		h = (h + 1) % size;
 	}
 
-	evl->head = h;
 	evl_status.head = h;
 	iowrite32(evl_status.bits_lower32, idxd->reg_base + IDXD_EVLSTATUS_OFFSET);
 	spin_unlock(&evl->lock);
-- 
2.43.0



