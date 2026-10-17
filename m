Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5C3A1D01;
	Sat, 17 Oct 2026 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257903; cv=none; b=tiGFJiPNHOtyFf6ORKrBww4uUQUjo7RrzKLO8u3NrjmVZ9U7PMV9anqynFb3dvnrySQqde4USDWMhxlfQZb7gSfTi4YMUclEMlHfJmAwJObyFr3fsaxojFzDBQdg3H1UtuGvAtrXMrKVoukzdW0lYc8ESeciylLGCxjVzn9Vgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257903; c=relaxed/simple;
	bh=lp4j4qJYMVAMCpdC+rByf70lK3SWxJiX1QAWMC+nhGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0q7JmtF1HiV6Jgq8KQ0pVHhWa5NwmaV82bGkJ8CmXxD2lvTkgFsYV8/1MOS/KGKqqf4D2nO9p7z7NwZMty46HhG8dOHRNBcjxRjzMEwXl8Er49mu0M/MbmA6FIkYiP5RR0LC5EITnXiI+XayycaZqixNa99F8f0fgtjK9A23Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB93pH/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB93pH/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DAE1F000C4;
	Sat, 17 Oct 2026 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257901;
	bh=Jcdf1dB88DgHsvj9BSge4q0IGQmY2AhZ3Nj5nJXGlW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB93pH/zbnmwfBccpp23Cu0hIX1RxURjT5Ypsdo5JTUoBiTrgnjMHJA0WXhz7okIE
	 v3BJdPY6+v8w4LVaO9ZP0+5bspbPLM/1K0jq9Og506NVyinZZAje0VSSOKDwpdqRgP
	 83kdnIaCLhWVCnHRVGI+wvZh5W7LOyPu+sZmPoIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prayas Patel <prayas.patel@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0665/1674] scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs
Date: Sat, 17 Oct 2026 17:48:57 +0200
Message-ID: <20261017160448.178667838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 711201a8b8334a397440ac0b859df0054e174bc9 ]

The driver, through the SAS transport, exposes a sysfs interface to
enable/disable PHYs in a controller/expander setup.  When multiple PHYs
are disabled and enabled in rapid succession, the persistent and current
config pages related to SAS IO unit/SAS Expander pages could get
corrupted.

Use separate memory for each config request.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 81 ++++++---------------------------
 2 files changed, 13 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 90da783457fbf..5593d119d5dfa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -131,8 +131,6 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
-#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
-
 #define MPI3MR_RESET_TOPOLOGY_SETTLE_TIME	10
 
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
@@ -1033,9 +1031,6 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
- * @cfg_page: Default memory for configuration pages
- * @cfg_page_dma: Configuration page DMA address
- * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
  * @transport_cmds: Command tracker for SAS transport commands
@@ -1219,10 +1214,6 @@ struct mpi3mr_ioc {
 	u16 num_io_throttle_group;
 	struct mpi3mr_throttle_group_info *throttle_groups;
 
-	void *cfg_page;
-	dma_addr_t cfg_page_dma;
-	u16 cfg_page_sz;
-
 	u8 sas_transport_enabled;
 	u8 scsi_device_channel;
 	struct mpi3mr_drv_cmd transport_cmds;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b742ece3f0507..c29e23cce3742 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3880,17 +3880,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
 	mpi3mr_print_ioc_info(mrioc);
 
-	if (!mrioc->cfg_page) {
-		dprint_init(mrioc, "allocating config page buffers\n");
-		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
-		if (!mrioc->cfg_page) {
-			retval = -1;
-			goto out_failed_noretry;
-		}
-	}
-
 	if (!mrioc->init_cmds.reply) {
 		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 		if (retval) {
@@ -4434,11 +4423,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-	if (mrioc->cfg_page) {
-		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
-		    mrioc->cfg_page, mrioc->cfg_page_dma);
-		mrioc->cfg_page = NULL;
-	}
+
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
@@ -5023,55 +5008,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
-
-/**
- * mpi3mr_free_config_dma_memory - free memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: memory descriptor structure
- *
- * Check whether the size of the buffer specified by the memory
- * descriptor is greater than the default page size if so then
- * free the memory pointed by the descriptor.
- *
- * Return: Nothing.
- */
-static void mpi3mr_free_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if ((mem_desc->size > mrioc->cfg_page_sz) && mem_desc->addr) {
-		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
-		    mem_desc->addr, mem_desc->dma_addr);
-		mem_desc->addr = NULL;
-	}
-}
-
-/**
- * mpi3mr_alloc_config_dma_memory - Alloc memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: Memory descriptor to hold dma memory info
- *
- * This function allocates new dmaable memory or provides the
- * default config page dmaable memory based on the memory size
- * described by the descriptor.
- *
- * Return: 0 on success, non-zero on failure.
- */
-static int mpi3mr_alloc_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if (mem_desc->size > mrioc->cfg_page_sz) {
-		mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mem_desc->size, &mem_desc->dma_addr, GFP_KERNEL);
-		if (!mem_desc->addr)
-			return -ENOMEM;
-	} else {
-		mem_desc->addr = mrioc->cfg_page;
-		mem_desc->dma_addr = mrioc->cfg_page_dma;
-		memset(mem_desc->addr, 0, mrioc->cfg_page_sz);
-	}
-	return 0;
-}
-
 /**
  * mpi3mr_post_cfg_req - Issue config requests and wait
  * @mrioc: Adapter instance reference
@@ -5227,8 +5163,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 		cfg_req->page_length = cfg_hdr->page_length;
 		cfg_req->page_version = cfg_hdr->page_version;
 	}
-	if (mpi3mr_alloc_config_dma_memory(mrioc, &mem_desc))
-		goto out;
+
+	mem_desc.addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		mem_desc.size, &mem_desc.dma_addr, GFP_KERNEL);
+
+	if (!mem_desc.addr)
+		return retval;
 
 	mpi3mr_add_sg_single(&cfg_req->sgl, sgl_flags, mem_desc.size,
 	    mem_desc.dma_addr);
@@ -5257,7 +5197,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 	}
 
 out:
-	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
+	if (mem_desc.addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc.size,
+			mem_desc.addr, mem_desc.dma_addr);
+		mem_desc.addr = NULL;
+	}
+
 	return retval;
 }
 
-- 
2.53.0



