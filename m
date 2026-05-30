Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9180030E853;
	Sat, 30 May 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162514; cv=none; b=s+GX5FcRbHVsU1UARO47VEBOW8Y9oEIIxGlVZXeFUUsO4RDAS5vcuiRAweHhhXKxu/S6hp7/bsx/ABevIzgMqBeh171XLfn4HEVgvzN+C2eh6GUURC1rV3dqiW34mhe0o7SDFVnEOwFpC8qFNPrAiRRWkNYB4hV4Rh/DTNO64Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162514; c=relaxed/simple;
	bh=BWko8nPqR8zLVm9uejGEVbkrBBkIbJZ043196Dx9MWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epsHyXfxL4mprev03Oe+rUBJ8EGegtfTl4TbTYIjWjQ6SY8IJzjaMRI9pSwQMS/1qVM3Vp1jgo2e0u/4WGChnPMewHvstyY/00mxVuxWADPiRDm3bILggbNthyXlBpXTLJcGgfMm6X+dwLQ4dypRUcrI10jAlj8rztcrZpwTQFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHd/3VPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHd/3VPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62EE1F00893;
	Sat, 30 May 2026 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162513;
	bh=jEgsjCbceHXhUOoc8/CDjS3Fb6Udmu4fSqSB82goWFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHd/3VPIyq1BQYB4Y8dAkghM6nl3ooag+CU6br5SMNBNPvDXXRBuz3jPVRmuxf8EP
	 fV+7y9AWwEettWIm9YfauSmWEYh0X+AOjzBamUnf/DAu64uWAaSXl97hG6hcpyKSsi
	 qwAzmCjBfOpTH82fypO1O/M18MZWFtghckV5g0oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Youghandhar Chintala <quic_youghand@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 942/969] wifi: ath11k: Trigger sta disconnect on hardware restart
Date: Sat, 30 May 2026 18:07:46 +0200
Message-ID: <20260530160326.769572401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youghandhar Chintala <quic_youghand@quicinc.com>

[ Upstream commit a018750a2cceaf4427c4ee3d9ce3e83a171d5bd6 ]

Currently after the hardware restart triggered from the driver, the
station interface connection remains intact, since a disconnect trigger
is not sent to userspace. This can lead to a problem in targets where
the wifi mac sequence is added by the firmware.

After the target restart, its wifi mac sequence number gets reset to
zero. Hence AP to which our device is connected will receive frames with
a  wifi mac sequence number jump to the past, thereby resulting in the
AP dropping all these frames, until the frame arrives with a wifi mac
sequence number which AP was expecting.

To avoid such frame drops, its better to trigger a station disconnect
upon target hardware restart which can be done with API
ieee80211_reconfig_disconnect exposed to mac80211.

The other targets are not affected by this change, since the hardware
params flag is not set.

Reported-by: kernel test robot <lkp@intel.com>

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221104085403.11025-1-quic_youghand@quicinc.com
Stable-dep-of: 2a2451a34afd ("wifi: ath11k: fix peer resolution on rx path when peer_id=0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 6 ++++++
 drivers/net/wireless/ath/ath11k/hw.h   | 1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 9b5349230ad34..7a61c84939cb3 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -195,6 +195,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = true,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
 		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = false,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -277,6 +278,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = true,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
 		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = true,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -356,6 +358,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = true,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
 		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = false,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -438,6 +441,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = true,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
 		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = true,
 	},
 	{
 		.name = "wcn6855 hw2.1",
@@ -519,6 +523,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = true,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE,
 		.smp2p_wow_exit = false,
+		.support_fw_mac_sequence = true,
 	},
 	{
 		.name = "wcn6750 hw1.0",
@@ -597,6 +602,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.tcl_ring_retry = false,
 		.tx_ring_size = DP_TCL_DATA_RING_SIZE_WCN6750,
 		.smp2p_wow_exit = true,
+		.support_fw_mac_sequence = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 8a3f24862edc4..0c5ef8a526d85 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -219,6 +219,7 @@ struct ath11k_hw_params {
 	bool tcl_ring_retry;
 	u32 tx_ring_size;
 	bool smp2p_wow_exit;
+	bool support_fw_mac_sequence;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 6a244f110dca6..2ef03ad1c9051 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7981,6 +7981,7 @@ ath11k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 	struct ath11k *ar = hw->priv;
 	struct ath11k_base *ab = ar->ab;
 	int recovery_count;
+	struct ath11k_vif *arvif;
 
 	if (reconfig_type != IEEE80211_RECONFIG_TYPE_RESTART)
 		return;
@@ -8016,6 +8017,12 @@ ath11k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 				ath11k_dbg(ab, ATH11K_DBG_BOOT, "reset success\n");
 			}
 		}
+		if (ar->ab->hw_params.support_fw_mac_sequence) {
+			list_for_each_entry(arvif, &ar->arvifs, list) {
+				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
+					ieee80211_hw_restart_disconnect(arvif->vif);
+			}
+		}
 	}
 
 	mutex_unlock(&ar->conf_mutex);
-- 
2.53.0



