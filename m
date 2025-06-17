Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D02DF3C9;
	Tue, 17 Jun 2025 15:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174618; cv=none; b=Lubz121Iv3E1OaQV2u80UZZHwP8grC73yn6uzLcRSMuIibkLxOQkkIsOhZW22t+vtVq67WbCLsFUWwe8hbUP5e9Pn1dV3EOMAnoAS6tc4Mrm+0Q5DkGgfNEmnMFrDB04cOwkLe7+q0q79u+xlyYF/a0KkFp80spRdoD9w/BzfzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174618; c=relaxed/simple;
	bh=Un+KMoQK8D/aIkzMlDQpRF0XDkWHfj5Y9T3dDXoLUnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMSss+rc3iU2bdb8vkC5z13Sg7ADfOTp7Tnri3e7bYhU7z/IAwVhwKjhCafp0dju/aPCBfq5E7Lv46QeN7do1Dw5gsHYqTLR7CRA3G8L1xjF3pFR+m/PntWvdbRA+JvraukXEzb9ulvZJuYgemdvor8DooZe79Yt8pXQMhceFz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgTCrinZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgTCrinZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3328C4CEE7;
	Tue, 17 Jun 2025 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174618;
	bh=Un+KMoQK8D/aIkzMlDQpRF0XDkWHfj5Y9T3dDXoLUnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgTCrinZZsiVjekOwwrvN+P4DTR4cXowhMmvpEVmjktezMGofR08iSlxLfKBodom/
	 8uayebWRhHhHpjU1Kvt+tyeoHPBgK/f377WEiVbS3L7MC1euGHrt2Ybeea1ZrManXn
	 SX61JjseLFltMNhQ5kwkkIsjCH0Zl/hzjhlIuTDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/356] wifi: ath12k: fix node corruption in ar->arvifs list
Date: Tue, 17 Jun 2025 17:23:30 +0200
Message-ID: <20250617152342.043627408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3df8059d55129..1b07a183aaedc 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -657,6 +657,7 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
 
 void ath12k_core_halt(struct ath12k *ar)
 {
+	struct list_head *pos, *n;
 	struct ath12k_base *ab = ar->ab;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -671,7 +672,12 @@ void ath12k_core_halt(struct ath12k *ar)
 
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



