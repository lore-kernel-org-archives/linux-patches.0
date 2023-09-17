Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5B46FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5121EC433C8;
	Sun, 17 Sep 2023 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982861;
	bh=37syD00Hc/sdSgkw/XfRFiBm0gJYq78z4BtPnwWHqeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5G886JxxBcNPHgpXFArYk389sSnh8EQn+teUXCBuQuXOeKEdJUm/gGQe2uGdX3gu
	 eqBtAclZYMyr7lrm3XNaTyD278ppqGpzZxtfJroD4qnxUrwDrOLi5hq92f5U0I6mS1
	 LMKvyKr8JuZSXQYOiUULk2WvAAXkp0jPB56D9cVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 341/511] scsi: mpt3sas: Perform additional retries if doorbell read returns 0
Date: Sun, 17 Sep 2023 21:12:48 +0200
Message-ID: <20230917191122.046389166@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit 4ca10f3e31745d35249a727ecd108eb58f0a8c5e upstream.

The driver retries certain register reads 3 times if the returned value is
0. This was done because the controller could return 0 for certain
registers if other registers were being accessed concurrently by the BMC.

In certain systems with increased BMC interactions, the register values
returned can be 0 for longer than 3 retries. Change the retry count from 3
to 30 for the affected registers to prevent problems with out-of-band
management.

Fixes: b899202901a8 ("scsi: mpt3sas: Add separate function for aero doorbell reads")
Cc: stable@vger.kernel.org
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20230829090020.5417-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   46 +++++++++++++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_base.h |    1 
 2 files changed, 34 insertions(+), 13 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -139,6 +139,9 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPT
 static void
 _base_clear_outstanding_commands(struct MPT3SAS_ADAPTER *ioc);
 
+static u32
+_base_readl_ext_retry(const volatile void __iomem *addr);
+
 /**
  * mpt3sas_base_check_cmd_timeout - Function
  *		to check timeout and command termination due
@@ -214,6 +217,20 @@ _base_readl_aero(const volatile void __i
 	return ret_val;
 }
 
+static u32
+_base_readl_ext_retry(const volatile void __iomem *addr)
+{
+	u32 i, ret_val;
+
+	for (i = 0 ; i < 30 ; i++) {
+		ret_val = readl(addr);
+		if (ret_val == 0)
+			continue;
+	}
+
+	return ret_val;
+}
+
 static inline u32
 _base_readl(const volatile void __iomem *addr)
 {
@@ -941,7 +958,7 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADA
 
 	dump_stack();
 
-	doorbell = ioc->base_readl(&ioc->chip->Doorbell);
+	doorbell = ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		mpt3sas_print_fault_code(ioc, doorbell &
 		    MPI2_DOORBELL_DATA_MASK);
@@ -6537,7 +6554,7 @@ mpt3sas_base_get_iocstate(struct MPT3SAS
 {
 	u32 s, sc;
 
-	s = ioc->base_readl(&ioc->chip->Doorbell);
+	s = ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 	sc = s & MPI2_IOC_STATE_MASK;
 	return cooked ? sc : s;
 }
@@ -6682,7 +6699,7 @@ _base_wait_for_doorbell_ack(struct MPT3S
 					   __func__, count, timeout));
 			return 0;
 		} else if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
-			doorbell = ioc->base_readl(&ioc->chip->Doorbell);
+			doorbell = ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_FAULT) {
 				mpt3sas_print_fault_code(ioc, doorbell);
@@ -6722,7 +6739,7 @@ _base_wait_for_doorbell_not_used(struct
 	count = 0;
 	cntdn = 1000 * timeout;
 	do {
-		doorbell_reg = ioc->base_readl(&ioc->chip->Doorbell);
+		doorbell_reg = ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
 			dhsprintk(ioc,
 				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
@@ -6870,7 +6887,7 @@ _base_handshake_req_reply_wait(struct MP
 	__le32 *mfp;
 
 	/* make sure doorbell is not in use */
-	if ((ioc->base_readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
+	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
 		return -EFAULT;
 	}
@@ -6919,7 +6936,7 @@ _base_handshake_req_reply_wait(struct MP
 	}
 
 	/* read the first two 16-bits, it gives the total length of the reply */
-	reply[0] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	reply[0] = le16_to_cpu(ioc->base_readl_ext_retry(&ioc->chip->Doorbell)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
@@ -6927,7 +6944,7 @@ _base_handshake_req_reply_wait(struct MP
 			__LINE__);
 		return -EFAULT;
 	}
-	reply[1] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	reply[1] = le16_to_cpu(ioc->base_readl_ext_retry(&ioc->chip->Doorbell)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 
@@ -6938,10 +6955,10 @@ _base_handshake_req_reply_wait(struct MP
 			return -EFAULT;
 		}
 		if (i >=  reply_bytes/2) /* overflow case */
-			ioc->base_readl(&ioc->chip->Doorbell);
+			ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 		else
 			reply[i] = le16_to_cpu(
-			    ioc->base_readl(&ioc->chip->Doorbell)
+			    ioc->base_readl_ext_retry(&ioc->chip->Doorbell)
 			    & MPI2_DOORBELL_DATA_MASK);
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
@@ -7800,7 +7817,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER
 			goto out;
 		}
 
-		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+		host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
 		drsprintk(ioc,
 			  ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
 				   count, host_diagnostic));
@@ -7820,7 +7837,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER
 	for (count = 0; count < (300000000 /
 		MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
 
-		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+		host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
 
 		if (host_diagnostic == 0xFFFFFFFF) {
 			ioc_info(ioc,
@@ -8210,10 +8227,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
 	ioc->rdpq_array_enable_assigned = 0;
 	ioc->use_32bit_dma = false;
 	ioc->dma_mask = 64;
-	if (ioc->is_aero_ioc)
+	if (ioc->is_aero_ioc) {
 		ioc->base_readl = &_base_readl_aero;
-	else
+		ioc->base_readl_ext_retry = &_base_readl_ext_retry;
+	} else {
 		ioc->base_readl = &_base_readl;
+		ioc->base_readl_ext_retry = &_base_readl;
+	}
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
 		goto out_free_resources;
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1618,6 +1618,7 @@ struct MPT3SAS_ADAPTER {
 	u8		diag_trigger_active;
 	u8		atomic_desc_capable;
 	BASE_READ_REG	base_readl;
+	BASE_READ_REG	base_readl_ext_retry;
 	struct SL_WH_MASTER_TRIGGER_T diag_trigger_master;
 	struct SL_WH_EVENT_TRIGGERS_T diag_trigger_event;
 	struct SL_WH_SCSI_TRIGGERS_T diag_trigger_scsi;


