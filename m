Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054876;
	b=ZTbDwvijtZLO7TATvtTXWSLQL9GPti6mYO50rPGZ1sevpUXx9MjohpBOuoFj7WcU95s0
	 xLCCUZ+KqBkTxLmGT5eJ/0GkDZPBv+E3ZS6Sho+R96hALsa4qdBK00Lmt1ORkHMTzq3is
	 rz3lfNzRH59a6X4HvZs44+ZmUZiuvVbYI/zAXPmiC54NmFYMH8zXalvnayk9FvIzLYWPl
	 9UM0votUDQW7Op+x3WTiG6bA57eaBEQAYKUPqczh99n/OPluMwpy3Dekoyl4TGijSf+RK
	 SlTeow+PNfnsYQahGT8jxCSQ5RkZeNW/74CU59xpJ4nciRF/TOsUqSRykJk+Jt5f4AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7NXvJgz/0289URxl1gShkZfIUPD3xOh3dCNASLdxyg=;
	b=siApCpU54BcYbk7Sg+5oDa3ReRbQLLK1ZxNBkZmf30fPOzidXI4n6iOVXFhoC1WlVwl+
	 eyjCXoDZVtbOz/1dqqvMLaYKIiNgwaXFRBHFppe9ojtopuXMi8aRFm/JIoC/o/d8BibVZ
	 7jJBEgidgi7PKVeIb9+658r9J23eskYHmQBBtB/RlE/nE8PAGpTnO1jVTi32EfIwYnlWD
	 tWwOdqvGGHOm1Ar3H0eOVTamjKn5waFigWsunTomlJUbEEr7zDX22VmH6ZgXFr3NfEgYc
	 Q24ZhOMVAYRhFYpVv6IwdP9nD3AuEYP9tah+91dABmx3q/PV7NCLjuWTIi47wJbkwlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zg5C41pl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE36606A320;
	Thu, 19 Nov 2026 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zg5C41pl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F3B1F000C4;
	Thu, 19 Nov 2026 02:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054876;
	bh=j7NXvJgz/0289URxl1gShkZfIUPD3xOh3dCNASLdxyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zg5C41plMysJr1zuPYKut75cz3/53PXCbE19nOt4a9yp6V8ghp0McZKotiHRCuCb1
	 GZhK8wPvgl6zt3N+Z1ovI67yzSsQXG6ZzwaSbtX84PWqstUWn74v2tgcJPMVBRaitE
	 jRywSu5CmClRYnEO238DUMcnRueSyNfpe/Q2qOoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1432/2214] scsi: mpi3mr: Code refactor of IOC init - part1
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150108.475029157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit e3605f65ef69f399aaade423f19f6db6eb3c11cb ]

Separate out reply and sense buffer allocation and initialization into two
routines and call only initialization routine while issuing the IOC Init
request message.

Also move out the event enable logic to a separate function.

Link: https://lore.kernel.org/r/20211220141159.16117-13-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 107 ++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0bb7cc727214b..d0d50566e1ee2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2546,10 +2546,9 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u32 sz, i;
-	dma_addr_t phy_addr;
 
 	if (mrioc->init_cmds.reply)
-		goto post_reply_sbuf;
+		return retval;
 
 	mrioc->init_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
 	if (!mrioc->init_cmds.reply)
@@ -2642,7 +2641,28 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->sense_buf_q)
 		goto out_failed;
 
-post_reply_sbuf:
+	return retval;
+
+out_failed:
+	retval = -1;
+	return retval;
+}
+
+/**
+ * mpimr_initialize_reply_sbuf_queues - initialize reply sense
+ * buffers
+ * @mrioc: Adapter instance reference
+ *
+ * Helper function to initialize reply and sense buffers along
+ * with some debug prints.
+ *
+ * Return:  None.
+ */
+static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
+{
+	u32 sz, i;
+	dma_addr_t phy_addr;
+
 	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
 	ioc_info(mrioc,
 	    "reply buf pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), reply_dma(0x%llx)\n",
@@ -2675,11 +2695,6 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	    i < mrioc->num_sense_bufs; i++, phy_addr += MPI3MR_SENSE_BUF_SZ)
 		mrioc->sense_buf_q[i] = cpu_to_le64(phy_addr);
 	mrioc->sense_buf_q[i] = cpu_to_le64(0);
-	return retval;
-
-out_failed:
-	retval = -1;
-	return retval;
 }
 
 /**
@@ -2706,6 +2721,8 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 		retval = -1;
 		goto out;
 	}
+	mpimr_initialize_reply_sbuf_queues(mrioc);
+
 	drv_info->information_length = cpu_to_le32(data_len);
 	strscpy(drv_info->driver_signature, "Broadcom", sizeof(drv_info->driver_signature));
 	strscpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
@@ -2778,6 +2795,13 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 		goto out_unlock;
 	}
 
+	mrioc->reply_free_queue_host_index = mrioc->num_reply_bufs;
+	writel(mrioc->reply_free_queue_host_index,
+	    &mrioc->sysif_regs->reply_free_host_index);
+
+	mrioc->sbq_host_index = mrioc->num_sense_bufs;
+	writel(mrioc->sbq_host_index,
+	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
@@ -3302,6 +3326,44 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_enable_events - Enable required events
+ * @mrioc: Adapter instance reference
+ *
+ * This routine unmasks the events required by the driver by
+ * sennding appropriate event mask bitmapt through an event
+ * notification request.
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
+static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
+{
+	int retval = 0;
+	u32  i;
+
+	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
+		mrioc->event_masks[i] = -1;
+
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_ADDED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
+
+	retval = mpi3mr_issue_event_notification(mrioc);
+	if (retval)
+		ioc_err(mrioc, "failed to issue event notification %d\n",
+		    retval);
+	return retval;
+}
+
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
@@ -3324,7 +3386,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
 	u32 timeout;
-	u32 ioc_status, ioc_config, i;
+	u32 ioc_status, ioc_config;
 	struct mpi3_ioc_facts_data facts_data;
 
 	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
@@ -3466,13 +3528,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		    retval);
 		goto out_failed;
 	}
-	mrioc->reply_free_queue_host_index = mrioc->num_reply_bufs;
-	writel(mrioc->reply_free_queue_host_index,
-	    &mrioc->sysif_regs->reply_free_host_index);
-
-	mrioc->sbq_host_index = mrioc->num_sense_bufs;
-	writel(mrioc->sbq_host_index,
-	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 
 	retval = mpi3mr_print_pkg_ver(mrioc);
 	if (retval) {
@@ -3505,25 +3560,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
-	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
-		mrioc->event_masks[i] = -1;
-
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_ADDED);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
-
-	retval = mpi3mr_issue_event_notification(mrioc);
+	retval = mpi3mr_enable_events(mrioc);
 	if (retval) {
-		ioc_err(mrioc, "Failed to issue event notification %d\n",
+		ioc_err(mrioc, "failed to enable events %d\n",
 		    retval);
 		goto out_failed;
 	}
-- 
2.53.0



