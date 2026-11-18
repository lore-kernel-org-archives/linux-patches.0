Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049530;
	b=5IFQ/Rt53Iv8/qwQ62NdZG4KIdgyG0NdZcyw52dfrzS5ynn8rha43Hh0P+htzMiKQsbg
	 xasKsQVwTb2ZCdAiSnR1nbO3vy+suw7uantTn6pNvxFAbscI54+ys89I39JhbqzxYBZtn
	 RHw7/K0DVVnpauXBIYsdb25Mf+3TFXK1RKc24dN5xneCgGWkFmaWy/h2a+6rQvxTQXYCI
	 ClB+KJkKJ0/kjbG2kSSz/MWtsFqEXBlgAziHAs23uSO11MBI65TywxRRgsBmTRxSnE+wD
	 /ayNLBaH4wrn829L4GVS/uUKb7ZykijdRRth5ZELcxOaZVyaAjPAD0mhbyldvuRaZJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0PvMyp+hurQtvivEQoUAMngeM+blthkzmGKYgzmwBg=;
	b=3jXCADHzF4afTkUUpLOGGRcGSoy03mXA2g9BxInj/oAISMTOo5ZEAIA9d3CezJQS6Ti5
	 k9A6NIZ0FgITvYTXh4dH5fzYUx6V9UcJpYY0efQGt4VFCXyagL43yRAfensPS265zz1Rh
	 947+cs3YN0FdkHgkBpa9EpVu5jpNOqaUJZY3KTbJLZwKHKADIGLAwIJmaU5UhH4GVqshs
	 wwIQY31JHY48mbXNrrbPnfpXn6rxYO3UDP+EWVlzBXeXSiYEdiBq9SorAACft/LKDk0ns
	 XERA1c8vKuavFe8OvC7LUxGEwTFvGhjEgFrXa5ENENumwqjEqPRCMl0FUaFAWm6hC6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJeHaOTV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB7B606A31C;
	Thu, 19 Nov 2026 00:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJeHaOTV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C6B1F000C4;
	Thu, 19 Nov 2026 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049530;
	bh=O0PvMyp+hurQtvivEQoUAMngeM+blthkzmGKYgzmwBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJeHaOTVB9vEXxCQE8NFWbHAmR66C2kiYMwE9G9368NFZSdZRcAd6FvHvzdGqSHqk
	 eg48l2yGJD5cNl8BmgUtTIn6+9vYwBa7Ffj9f+HmJ/N6QjT9ijEI/LQrzuk+ohjMLc
	 Uc+0Sz2JpZN5SE5Sk0is5FTdkLmREu6Vx7wQj/uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2384/2857] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150327.365332291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 3e7f5d362b2b3a21b3adb4b860aad14b69a896ad ]

The pending management TX cleanup walks txmgmt_idr with idr_for_each(),
and its callback removes the current entry. This can invalidate the
radix-tree iterator retained by idr_for_each().

Use idr_for_each_entry() so every iteration starts with a fresh lookup.
Continue to remove each entry under txmgmt_idr_lock before freeing its skb,
preventing concurrent TX completion from finding a stale skb pointer.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-3-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  3 +--
 drivers/net/wireless/ath/ath11k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath11k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index be7d0644a6e8f..5d7969643d7d6 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1794,8 +1794,7 @@ static void ath11k_core_pre_reconfigure_recovery(struct ath11k_base *ab)
 		complete(&ar->thermal.wmi_sync);
 
 		wake_up(&ar->dp.tx_empty_waitq);
-		idr_for_each(&ar->txmgmt_idr,
-			     ath11k_mac_tx_mgmt_pending_free, ar);
+		ath11k_mac_tx_mgmt_pending_free(ar);
 		idr_destroy(&ar->txmgmt_idr);
 		wake_up(&ar->txmgmt_empty_waitq);
 	}
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 8565a7031fae4..4f873ec4fcbed 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5515,13 +5515,13 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
 	ath11k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
 {
-	struct ath11k *ar = ctx;
-
-	ath11k_mac_tx_mgmt_free(ar, buf_id);
+	struct sk_buff *msdu;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, msdu, buf_id)
+		ath11k_mac_tx_mgmt_free(ar, buf_id);
 }
 
 static int ath11k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
@@ -8887,7 +8887,7 @@ static void __ath11k_mac_unregister(struct ath11k *ar)
 
 	ieee80211_unregister_hw(ar->hw);
 
-	idr_for_each(&ar->txmgmt_idr, ath11k_mac_tx_mgmt_pending_free, ar);
+	ath11k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 0231783ad754b..7c1f6a336aa2b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -161,7 +161,7 @@ struct ath11k *ath11k_mac_get_ar_by_pdev_id(struct ath11k_base *ab, u32 pdev_id)
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
 enum nl80211_he_gi ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
 enum nl80211_he_ru_alloc ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy);
-- 
2.53.0



