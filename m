Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C65F2ED854;
	Tue, 17 Jun 2025 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177218; cv=none; b=SSniy+CGjfc9qrpLEv5HqnARnoN/oR5cGSTa5vHoygw3vGCRV0vuC6yUWs2qYP6cljLiOqmmImyj3IRV5vriEWX9poTOEyhjQePyEunIK1XGERDO92t6Sm60EA/LF6zgN8jNAM0zG9J+tG5GESnoTC62bukpST9I34ipn7ZHI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177218; c=relaxed/simple;
	bh=yrcn9IxFr2O2pfhF90QtuXjqg6SiqcdrWEZ1HYDV07s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZti2VSn7ryljaCcj7TK6Jym3yeiiOEZ/UGuATjh+4cVQPFu5JxDgW3dTyD0DJtVXOOOkoqhEH6R3MAQkE8KdhwKchfv8ne13DC7sJ3OxuUjr/+Ws36jWkfCr3uMYmknwiF8x4n3c67sWl/PwiBBdqiqg2hnVkA0MK+IKIAjfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbgNdZ2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbgNdZ2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE276C4CEE3;
	Tue, 17 Jun 2025 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177218;
	bh=yrcn9IxFr2O2pfhF90QtuXjqg6SiqcdrWEZ1HYDV07s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbgNdZ2Oc4LD9euoJzpBNI7jgLUSSdgT2XyWvMsrzs2Ewmfa6wg5AZMaQyQdgusAp
	 e8rMBSIGOuI0WL2yZ7vPd7l6CK8cCshpjdDxLOmN9xv4MXyxLQCHO3b1I37bKySKTc
	 bUSjf6HQQEiUtwFCEF+Ug+BKpUFJ+uaV6RvfjPzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingying Tang <quic_yintang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 273/780] wifi: ath12k: Reorder and relocate the release of resources in ath12k_core_deinit()
Date: Tue, 17 Jun 2025 17:19:41 +0200
Message-ID: <20250617152502.587221545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Yingying Tang <quic_yintang@quicinc.com>

[ Upstream commit aabd3be90579ed088aa34f0584ab6836c735c76f ]

Ath12k panic notifier is registered in driver loading process. But it is not
unregistered if ATH12K_FLAG_QMI_FAIL is set(e.g. load BDF failed) and unload
driver. It causes a dirty node in panic notifier list since ath12k panic
notifier is not unregistered from list but the buffer of this node is freed
in driver unloading process. If load driver again there will be a page fault
error due to this dirty node in panic notifier list.

This issue is caused by asymmetry between ath12k_core_init() and
ath12k_core_deinit(). Reorder and relocate the release of resources in
ath12k_core_deinit() to avoid this asymmetry issue.

Call Trace:
<TASK>
? show_regs+0x67/0x70
? __die_body+0x20/0x70
? __die+0x2b/0x40
? page_fault_oops+0x15d/0x500
? search_bpf_extables+0x63/0x90
? notifier_chain_register+0x21/0xe0
? search_exception_tables+0x5f/0x70
? kernelmode_fixup_or_oops.isra.0+0x61/0x80
? __bad_area_nosemaphore+0x179/0x240
? bad_area_nosemaphore+0x16/0x20
? do_user_addr_fault+0x312/0x7f0
? prb_read_valid+0x1c/0x30
? exc_page_fault+0x78/0x180
? asm_exc_page_fault+0x27/0x30
? notifier_chain_register+0x21/0xe0
? notifier_chain_register+0x55/0xe0
atomic_notifier_chain_register+0x2c/0x50
ath12k_core_init+0x7e/0x110 [ath12k]
ath12k_pci_probe+0xaba/0xba0 [ath12k]

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0-02903-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 809055628bce8 ("wifi: ath12k: add panic handler")
Signed-off-by: Yingying Tang <quic_yintang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250423055650.16230-2-quic_yintang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 5 ++---
 drivers/net/wireless/ath/ath12k/core.h | 1 +
 drivers/net/wireless/ath/ath12k/pci.c  | 5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 6b0c719be5434..770156347ffad 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1785,7 +1785,7 @@ static void ath12k_core_hw_group_destroy(struct ath12k_hw_group *ag)
 	}
 }
 
-static void ath12k_core_hw_group_cleanup(struct ath12k_hw_group *ag)
+void ath12k_core_hw_group_cleanup(struct ath12k_hw_group *ag)
 {
 	struct ath12k_base *ab;
 	int i;
@@ -1933,10 +1933,9 @@ int ath12k_core_init(struct ath12k_base *ab)
 
 void ath12k_core_deinit(struct ath12k_base *ab)
 {
-	ath12k_core_panic_notifier_unregister(ab);
-	ath12k_core_hw_group_cleanup(ab->ag);
 	ath12k_core_hw_group_destroy(ab->ag);
 	ath12k_core_hw_group_unassign(ab);
+	ath12k_core_panic_notifier_unregister(ab);
 }
 
 void ath12k_core_free(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 2ee83517eadc7..f5f1ec796f7c5 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -1195,6 +1195,7 @@ struct ath12k_fw_stats_pdev {
 };
 
 int ath12k_core_qmi_firmware_ready(struct ath12k_base *ab);
+void ath12k_core_hw_group_cleanup(struct ath12k_hw_group *ag);
 int ath12k_core_pre_init(struct ath12k_base *ab);
 int ath12k_core_init(struct ath12k_base *ath12k);
 void ath12k_core_deinit(struct ath12k_base *ath12k);
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 99b2c7927ec81..273f4bc260bfe 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1734,8 +1734,6 @@ static void ath12k_pci_remove(struct pci_dev *pdev)
 
 	if (test_bit(ATH12K_FLAG_QMI_FAIL, &ab->dev_flags)) {
 		ath12k_pci_power_down(ab, false);
-		ath12k_qmi_deinit_service(ab);
-		ath12k_core_hw_group_unassign(ab);
 		goto qmi_fail;
 	}
 
@@ -1743,9 +1741,10 @@ static void ath12k_pci_remove(struct pci_dev *pdev)
 
 	cancel_work_sync(&ab->reset_work);
 	cancel_work_sync(&ab->dump_work);
-	ath12k_core_deinit(ab);
+	ath12k_core_hw_group_cleanup(ab->ag);
 
 qmi_fail:
+	ath12k_core_deinit(ab);
 	ath12k_fw_unmap(ab);
 	ath12k_mhi_unregister(ab_pci);
 
-- 
2.39.5



