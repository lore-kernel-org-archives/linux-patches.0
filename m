Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F515E8B;
	Mon, 30 Dec 2024 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574205; cv=none; b=l97op5lY4+zj7UVW4kkK0QquNUtS+VFyKhxheplm6JtGqGlnd4L6MAWKsx2ihgGDT6m9muw9TKsL4EOwHl9FdW2hYsU4dWx+31tt5eWpuCiDzyjbfnx0RXk/Lq2TSyIGxm/PP1u8GM3Q/hCqHgwSu5Lnay0gpphVKIBhHZY5jd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574205; c=relaxed/simple;
	bh=k/zN2Q3ulw5zvaj9Jhycx6F562yQ5CEzypEcOMk13bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnYfpnrm2lTU2ViIZ+9SOYJgcBiigdjTGf1yD7YEnOfJQ9hyAgGUJ+a3igEoEvtTljDP5nxu56bw/csQtEii6JEa3ioFz+i08JHkNn8oC+ayh2ZW7n6G0FRoloDLPSrr3xg1sOeS2nRihJlfyInA8P/i0iEpRWbxq6iLzSEHLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2YEy3Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2YEy3Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB614C4CED0;
	Mon, 30 Dec 2024 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574205;
	bh=k/zN2Q3ulw5zvaj9Jhycx6F562yQ5CEzypEcOMk13bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2YEy3Fmd/v+maGVCVoLwC/EWpx17AdMRdaSJyCrlWkLGNOp5XGVPPO4I7bGRYR9X
	 X9rLw4xyHJ3Q/LYn0YlevTaZyCIoKAz9eX5uRyDqTDx2pz547lUluUNOpO/usO9ys+
	 gI/mN5OElcZKeoazcSj2UUqelH5U8DV7GEckXXg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prayas Patel <prayas.patel@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/114] scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs
Date: Mon, 30 Dec 2024 16:43:05 +0100
Message-ID: <20241230154220.717133638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81bb408ce56d..1e715fd65a7d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -134,8 +134,6 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
-#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
-
 #define MPI3MR_RESET_TOPOLOGY_SETTLE_TIME	10
 
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
@@ -1133,9 +1131,6 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
- * @cfg_page: Default memory for configuration pages
- * @cfg_page_dma: Configuration page DMA address
- * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
  * @transport_cmds: Command tracker for SAS transport commands
@@ -1332,10 +1327,6 @@ struct mpi3mr_ioc {
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
index f1ab76351bd8..2e6245bd4282 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4186,17 +4186,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_read_tsu_interval(mrioc);
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
 	dprint_init(mrioc, "allocating host diag buffers\n");
 	mpi3mr_alloc_diag_bufs(mrioc);
 
@@ -4768,11 +4757,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
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
@@ -5392,55 +5377,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
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
@@ -5596,8 +5532,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
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
@@ -5626,7 +5566,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
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
2.39.5



