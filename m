Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B13A7AE6F;
	Mon,  4 Mar 2024 21:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587974; cv=none; b=NVjX3iGnTcwd9e9274TvC4s7Wz49nWyZD/jQ/OkssOEhCkF/ReqzLJ4bAmAzXHw5oY/OZMA0eNce9tXAaybthgZ9Dowi0kqAZ1EvD6k1SQtkJ8jgfc27ZPfRm02cBKthsdoCRsXF/0jl3FKMN7660SE9t0WVTtPn6YsVGA6sVJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587974; c=relaxed/simple;
	bh=jUlFXB6PuwTdauMsHqtb2m4B+q41vO6QVVbH3IH5s3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5E1WqwIKuMdLmxexB/mIXZulRlSsCkHzt6+21hl/CVIIS0iXJnBaFRslGC6NGNB6o7u4+70YtAgQNWrWiMFEtCxhzMfAkzgQU1t1gbep4rtIU2ESf857kbRqvW8DCdDf+iUw3K41lIXFvM+bbTsJLpMDXFrhORZOr2rVuhrNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsfWrDzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsfWrDzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEC3C433F1;
	Mon,  4 Mar 2024 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587974;
	bh=jUlFXB6PuwTdauMsHqtb2m4B+q41vO6QVVbH3IH5s3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsfWrDzraaKAdW25zHLp2AZOSntRnLK7MuYaFiZOW/IRx7KTm/RFDKO7oEn5s/vqX
	 h0Zg/1nSo1lbtNMssKKGCr5YlUY8GU8DrPC84A19IUb2p9z/vlFLNSCE4/wrqHFZmS
	 48rHZgTlIKk6uIvgqIUfMOvyRfZVU38B4jiIBmfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 144/162] dmaengine: idxd: Remove shadow Event Log head stored in idxd
Date: Mon,  4 Mar 2024 21:23:29 +0000
Message-ID: <20240304211556.313598431@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 0423655f5a880..3dd25a9a04f18 100644
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
index 1e89c80a07fc2..96062ae39f9a2 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -290,7 +290,6 @@ struct idxd_evl {
 	unsigned int log_size;
 	/* The number of entries in the event log. */
 	u16 size;
-	u16 head;
 	unsigned long *bmap;
 	bool batch_fail[IDXD_MAX_BATCH_IDENT];
 };
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 2183d7f9cdbdd..3bdfc1797f620 100644
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



