Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FD42F2346;
	Tue, 17 Jun 2025 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176344; cv=none; b=QL64i/zTFDlqpkelnRhIeRhePFBcVegcCRoUBaxYQMobZEj+wS+g5xlh/FSJxidK+6UYad9jWMpFKHbhBEv7iQzQJj8QLKpUhJwi77Gn8Cr4r7h37ZR2E7jlgxpHldoBIGjRlzgtl8A0LJOHcwqN2qBSxYvdo8n27yfyhJWI3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176344; c=relaxed/simple;
	bh=S1tHeLESWVTOzUU191tB8rNHssnUqVRsEwdy50ffVuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+PMgO7l8Kyc6EXknCdE9rg2wzW0PQAbtlVpAz94OeLRlmGNXKt9/HzlLc/HBs7s5c490YR/wlKqQlg0sRRUq7p2GNR+1/Fo2tFQ0Jy3pdw0TsU6xfA5vp1JUkBmZfaeF7PU1a25BI0xIAITn8tO0pzAOGcljvzIVsCxrpRgFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBWabVn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBWabVn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6434C4CEE3;
	Tue, 17 Jun 2025 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176344;
	bh=S1tHeLESWVTOzUU191tB8rNHssnUqVRsEwdy50ffVuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBWabVn+iHUFAvC0gub4eiAUlcCCC7m/UB/eRKczuyzRfxTPXq6IfqIlKpF9tzNc1
	 qgqz9CUcPZvx2XFQ0ptpmaBrSUQQpXOooPeQnxOqQCfqVsmoNUjFTvMdw1kfQncgAR
	 sqZD7vd6hc0ly6RvYL1SR71kuyGPaXUhVAFTu9Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 180/780] wifi: ath12k: fix SLUB BUG - Object already free in ath12k_reg_free()
Date: Tue, 17 Jun 2025 17:18:08 +0200
Message-ID: <20250617152458.802261156@linuxfoundation.org>
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

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 6d019abc402f58b25a7cab30b2d9af2f3173e4df ]

During rmmod of ath12k module with SLUB debug enabled, following print is
seen -

=============================================================================
BUG kmalloc-1k (Not tainted): Object already free
-----------------------------------------------------------------------------

Allocated in ath12k_reg_build_regd+0x94/0xa20 [ath12k] age=10470 cpu=0 pid=0
 __kmalloc_noprof+0xf4/0x368
 ath12k_reg_build_regd+0x94/0xa20 [ath12k]
 ath12k_wmi_op_rx+0x199c/0x2c14 [ath12k]
 ath12k_htc_rx_completion_handler+0x398/0x554 [ath12k]
 ath12k_ce_per_engine_service+0x248/0x368 [ath12k]
 ath12k_pci_ce_workqueue+0x28/0x50 [ath12k]
 process_one_work+0x14c/0x28c
 bh_worker+0x22c/0x27c
 workqueue_softirq_action+0x80/0x90
 tasklet_action+0x14/0x3c
 handle_softirqs+0x108/0x240
 __do_softirq+0x14/0x20
Freed in ath12k_reg_free+0x40/0x74 [ath12k] age=136 cpu=2 pid=166
 kfree+0x148/0x248
 ath12k_reg_free+0x40/0x74 [ath12k]
 ath12k_core_hw_group_destroy+0x68/0xac [ath12k]
 ath12k_core_deinit+0xd8/0x124 [ath12k]
 ath12k_pci_remove+0x6c/0x130 [ath12k]
 pci_device_remove+0x44/0xe8
 device_remove+0x4c/0x80
 device_release_driver_internal+0x1d0/0x22c
 driver_detach+0x50/0x98
 bus_remove_driver+0x70/0xf4
 driver_unregister+0x30/0x60
 pci_unregister_driver+0x24/0x9c
 ath12k_pci_exit+0x18/0x24 [ath12k]
 __arm64_sys_delete_module+0x1a0/0x2a8
 invoke_syscall+0x48/0x110
 el0_svc_common.constprop.0+0x40/0xe0
Slab 0xfffffdffc0033600 objects=10 used=6 fp=0xffff000000cdcc00 flags=0x3fffe0000000240(workingset|head|node=0|zone=0|lastcpupid=0x1ffff)
Object 0xffff000000cdcc00 @offset=19456 fp=0xffff000000cde400
[...]

This issue arises because in ath12k_core_hw_group_destroy(), each device
calls ath12k_core_soc_destroy() for itself and all its partners within the
same group. Since ath12k_core_hw_group_destroy() is invoked for each
device, this results in a double free condition, eventually causing the
SLUB bug.

To resolve this, set the freed pointers to NULL. And since there could be
a race condition to read these pointers, guard these with the available
mutex lock.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250408-fix_reboot_issues_with_hw_grouping-v4-1-95e7bf048595@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/reg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index 439d61f284d89..7fa7cd301b757 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -777,8 +777,12 @@ void ath12k_reg_free(struct ath12k_base *ab)
 {
 	int i;
 
+	mutex_lock(&ab->core_lock);
 	for (i = 0; i < ab->hw_params->max_radios; i++) {
 		kfree(ab->default_regd[i]);
 		kfree(ab->new_regd[i]);
+		ab->default_regd[i] = NULL;
+		ab->new_regd[i] = NULL;
 	}
+	mutex_unlock(&ab->core_lock);
 }
-- 
2.39.5



