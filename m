Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB62F18E025;
	Tue, 17 Jun 2025 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175509; cv=none; b=I6egA5tAqytprRQJnfFBP4PiQFMhZjLI6XuM1Q5Fc/9BtPmDvP17q+azxqAd8cpsbP3tdA/sgjkdhitC5kOSUgB7exONmzzzJVEYcAcL2OZkOEqcjAAep5esomCwWFiKFZZWivbLzTmw0GCUDPHZ8ePhykaS9S5ar2/Mqd3B+FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175509; c=relaxed/simple;
	bh=GzG7faJJyGYXkQcBSSqHEJMogeEq7KfDH2icuFxnk6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8eHKvDl2768I/2ZQCUo7CCZ4w0ePYKRR4/hBmLU7PC5LbikBQ5ESR9ac61WVMHllP3+5g061qNI6u+PB1QO2m5Knlap4X8llpOGMQ/wGBGPXOkl/NOs3B0/NJ0bUuLKfkZ5Ff4Hd1T3Er8SBVGr4hIB4hGpvprYAXgSO+OVSFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aus9i0tX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aus9i0tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C860C4CEE3;
	Tue, 17 Jun 2025 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175508;
	bh=GzG7faJJyGYXkQcBSSqHEJMogeEq7KfDH2icuFxnk6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aus9i0tXc39wh5N4qq2nLtQOWNF2/iilz3WvDx6dUyhoeT0S4QpN/w12Kasywher8
	 nv9U3tcjKNelpXtrLbEw0V4Sbs4FWoWv5qX3Zi/4xW6jKrfea3t3vE9pWibnT6ScJP
	 elEnLmFdat7T0ozFkDWb5UEJ13Fr1viToMCLG0Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/512] wifi: ath12k: fix node corruption in ar->arvifs list
Date: Tue, 17 Jun 2025 17:21:39 +0200
Message-ID: <20250617152424.984903055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>

[ Upstream commit 823435bd23108d6f8be89ea2d025c0e2e3769c51 ]

In current WLAN recovery code flow, ath12k_core_halt() only reinitializes
the "arvifs" list head. This will cause the list node immediately following
the list head to become an invalid list node. Because the prev of that node
still points to the list head "arvifs", but the next of the list head
"arvifs" no longer points to that list node.

When a WLAN recovery occurs during the execution of a vif removal, and it
happens before the spin_lock_bh(&ar->data_lock) in
ath12k_mac_vdev_delete(), list_del() will detect the previously mentioned
situation, thereby triggering a kernel panic.

The fix is to remove and reinitialize all vif list nodes from the list head
"arvifs" during WLAN halt. The reinitialization is to make the list nodes
valid, ensuring that the list_del() in ath12k_mac_vdev_delete() can execute
normally.

Call trace:
__list_del_entry_valid_or_report+0xd4/0x100 (P)
ath12k_mac_remove_link_interface.isra.0+0xf8/0x2e4 [ath12k]
ath12k_scan_vdev_clean_work+0x40/0x164 [ath12k]
cfg80211_wiphy_work+0xfc/0x100
process_one_work+0x164/0x2d0
worker_thread+0x254/0x380
kthread+0xfc/0x100
ret_from_fork+0x10/0x20

The change is mostly copied from the ath11k patch:
https://lore.kernel.org/all/20250320053145.3445187-1-quic_stonez@quicinc.com/

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250416021724.2162519-1-maharaja.kennadyrajan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 8bb8ee98188bf..c3c76e2680629 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1004,6 +1004,7 @@ static void ath12k_rfkill_work(struct work_struct *work)
 
 void ath12k_core_halt(struct ath12k *ar)
 {
+	struct list_head *pos, *n;
 	struct ath12k_base *ab = ar->ab;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -1019,7 +1020,12 @@ void ath12k_core_halt(struct ath12k *ar)
 
 	rcu_assign_pointer(ab->pdevs_active[ar->pdev_idx], NULL);
 	synchronize_rcu();
-	INIT_LIST_HEAD(&ar->arvifs);
+
+	spin_lock_bh(&ar->data_lock);
+	list_for_each_safe(pos, n, &ar->arvifs)
+		list_del_init(pos);
+	spin_unlock_bh(&ar->data_lock);
+
 	idr_init(&ar->txmgmt_idr);
 }
 
-- 
2.39.5



