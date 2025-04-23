Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511511EFFB9;
	Wed, 23 Apr 2025 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420134; cv=none; b=TaDKlk3O3hi0kGA9fEHSWabxHIcRhWQLfc65i4ZjVWG4yGyDlFxMH1pw+cNeWJZvUQ77t+3HXa0W94Fl75LPx4Cpw7IsiiiS4U1u5gRDuxynp1NGp6fh3wx3KimPdiFqgUIDPMPfTIFC2TzpqmiXKBF+uHRTz1yxkqCRlYfSfGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420134; c=relaxed/simple;
	bh=cIkcF+ojwo4E26zzmlKasrbUXfAfvuMdMQ8vmFt1Fpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auewsykQ/WT7/qxKRInIs6MO2ndTFH6tFyZJuMuaUZLQ8YKIwSHD8+fSF/lMnZC4UiJJNpQGuYIpccTHKZ9vBM8FiA0vJU7kPwkE/ZeoEHf+F1kW0xUyvUby+Mhq6SdJ40e2tnc+4CMfHx3t7q2ZxsyiHU9VZI8tCMeHIAq5FKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7RFIEWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7RFIEWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0284C4CEE2;
	Wed, 23 Apr 2025 14:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420134;
	bh=cIkcF+ojwo4E26zzmlKasrbUXfAfvuMdMQ8vmFt1Fpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7RFIEWKK/lIj4k5Cp1t4s+uOdDtIl2WckgdrBz49lpvYyvOFtFH/9m8GPegOjjZV
	 rlUsJn3cV5oguw/SXqXRkdWnbMuv/Y3M+LRipiz+dMyayteP1hkqMR24V2HB0GJ6Rl
	 TrrmLq8s+PN45D1QMW5iMIw5D8gP0DVGXAre2mU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 062/241] nvmet: pci-epf: clear CC and CSTS when disabling the controller
Date: Wed, 23 Apr 2025 16:42:06 +0200
Message-ID: <20250423142623.135812274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit f8e01fa93f3e4fc255d240cfa0c045ce0b5c97ea ]

When a host shuts down the controller when shutting down but does so
without first disabling the controller, the enable bit remains set in
the controller configuration register. When the host restarts and
attempts to enable the controller again, the
nvmet_pci_epf_poll_cc_work() function is unable to detect the change
from 0 to 1 of the enable bit, and thus the controller is not enabled
again, which result in a device scan timeout on the host. This problem
also occurs if the host shuts down uncleanly or if the PCIe link goes
down: as the CC.EN value is not reset, the controller is not enabled
again when the host restarts.

Fix this by introducing the function nvmet_pci_epf_clear_ctrl_config()
to clear the CC and CSTS registers of the controller when the PCIe link
is lost (nvmet_pci_epf_stop_ctrl() function), or when starting the
controller fails (nvmet_pci_epf_enable_ctrl() fails). Also use this
function in nvmet_pci_epf_init_bar() to simplify the initialization of
the CC and CSTS registers.

Furthermore, modify the function nvmet_pci_epf_disable_ctrl() to clear
the CC.EN bit and write this updated value to the BAR register when the
controller is shutdown by the host, to ensure that upon restart, we can
detect the host setting CC.EN.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 49 +++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 70855bb9823af..5c4c4c1f535d4 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1825,6 +1825,21 @@ static void nvmet_pci_epf_cq_work(struct work_struct *work)
 				   NVMET_PCI_EPF_CQ_RETRY_INTERVAL);
 }
 
+static void nvmet_pci_epf_clear_ctrl_config(struct nvmet_pci_epf_ctrl *ctrl)
+{
+	struct nvmet_ctrl *tctrl = ctrl->tctrl;
+
+	/* Initialize controller status. */
+	tctrl->csts = 0;
+	ctrl->csts = 0;
+	nvmet_pci_epf_bar_write32(ctrl, NVME_REG_CSTS, ctrl->csts);
+
+	/* Initialize controller configuration and start polling. */
+	tctrl->cc = 0;
+	ctrl->cc = 0;
+	nvmet_pci_epf_bar_write32(ctrl, NVME_REG_CC, ctrl->cc);
+}
+
 static int nvmet_pci_epf_enable_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 {
 	u64 pci_addr, asq, acq;
@@ -1890,18 +1905,20 @@ static int nvmet_pci_epf_enable_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 	return 0;
 
 err:
-	ctrl->csts = 0;
+	nvmet_pci_epf_clear_ctrl_config(ctrl);
 	return -EINVAL;
 }
 
-static void nvmet_pci_epf_disable_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
+static void nvmet_pci_epf_disable_ctrl(struct nvmet_pci_epf_ctrl *ctrl,
+				       bool shutdown)
 {
 	int qid;
 
 	if (!ctrl->enabled)
 		return;
 
-	dev_info(ctrl->dev, "Disabling controller\n");
+	dev_info(ctrl->dev, "%s controller\n",
+		 shutdown ? "Shutting down" : "Disabling");
 
 	ctrl->enabled = false;
 	cancel_delayed_work_sync(&ctrl->poll_sqs);
@@ -1918,6 +1935,11 @@ static void nvmet_pci_epf_disable_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 	nvmet_pci_epf_delete_cq(ctrl->tctrl, 0);
 
 	ctrl->csts &= ~NVME_CSTS_RDY;
+	if (shutdown) {
+		ctrl->csts |= NVME_CSTS_SHST_CMPLT;
+		ctrl->cc &= ~NVME_CC_ENABLE;
+		nvmet_pci_epf_bar_write32(ctrl, NVME_REG_CC, ctrl->cc);
+	}
 }
 
 static void nvmet_pci_epf_poll_cc_work(struct work_struct *work)
@@ -1944,12 +1966,10 @@ static void nvmet_pci_epf_poll_cc_work(struct work_struct *work)
 	}
 
 	if (!nvmet_cc_en(new_cc) && nvmet_cc_en(old_cc))
-		nvmet_pci_epf_disable_ctrl(ctrl);
+		nvmet_pci_epf_disable_ctrl(ctrl, false);
 
-	if (nvmet_cc_shn(new_cc) && !nvmet_cc_shn(old_cc)) {
-		nvmet_pci_epf_disable_ctrl(ctrl);
-		ctrl->csts |= NVME_CSTS_SHST_CMPLT;
-	}
+	if (nvmet_cc_shn(new_cc) && !nvmet_cc_shn(old_cc))
+		nvmet_pci_epf_disable_ctrl(ctrl, true);
 
 	if (!nvmet_cc_shn(new_cc) && nvmet_cc_shn(old_cc))
 		ctrl->csts &= ~NVME_CSTS_SHST_CMPLT;
@@ -1988,16 +2008,10 @@ static void nvmet_pci_epf_init_bar(struct nvmet_pci_epf_ctrl *ctrl)
 	/* Clear Controller Memory Buffer Supported (CMBS). */
 	ctrl->cap &= ~(0x1ULL << 57);
 
-	/* Controller configuration. */
-	ctrl->cc = tctrl->cc & (~NVME_CC_ENABLE);
-
-	/* Controller status. */
-	ctrl->csts = ctrl->tctrl->csts;
-
 	nvmet_pci_epf_bar_write64(ctrl, NVME_REG_CAP, ctrl->cap);
 	nvmet_pci_epf_bar_write32(ctrl, NVME_REG_VS, tctrl->subsys->ver);
-	nvmet_pci_epf_bar_write32(ctrl, NVME_REG_CSTS, ctrl->csts);
-	nvmet_pci_epf_bar_write32(ctrl, NVME_REG_CC, ctrl->cc);
+
+	nvmet_pci_epf_clear_ctrl_config(ctrl);
 }
 
 static int nvmet_pci_epf_create_ctrl(struct nvmet_pci_epf *nvme_epf,
@@ -2102,7 +2116,8 @@ static void nvmet_pci_epf_stop_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 {
 	cancel_delayed_work_sync(&ctrl->poll_cc);
 
-	nvmet_pci_epf_disable_ctrl(ctrl);
+	nvmet_pci_epf_disable_ctrl(ctrl, false);
+	nvmet_pci_epf_clear_ctrl_config(ctrl);
 }
 
 static void nvmet_pci_epf_destroy_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
-- 
2.39.5



