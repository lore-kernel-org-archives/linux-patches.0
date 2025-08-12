Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94E305E08;
	Tue, 12 Aug 2025 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022289; cv=none; b=rr+rxwdRE+LPJTyM7gwVrKL9PPFp+nAYUwDWSWu6rbteUij+Fp1Ef0/hifrkcx/uEpd1zLSu6GpiI6CkrYVEV/rSgT1Ciyy5xx6rJo2swiaFRmYQpuK7tj6NuFBXSjmcufv1MmZd0HSjztrh8wNZqJz2IPhSnsZpLkAHOTJptC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022289; c=relaxed/simple;
	bh=etcrusL7VWTURRdyZzPPob+RzQzbr2M9gd7l4kNhf6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK5wUTLNIz+9wdB8nYUjINfFJXmPWffXq074hCxPVo3Bifnp6dM1v+4+jXkHFef20Xn7bnWbcMm1DmHAvdF1Z8V1JMgg+o73EV6waEsNnYa+x4uR1NpJqnqKiNXQShT3kIV7qFo2TScAjeMwU1qZ8lqv/IX9DMGqxp4nnk04XQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkVzgwh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkVzgwh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0385C4CEF0;
	Tue, 12 Aug 2025 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022289;
	bh=etcrusL7VWTURRdyZzPPob+RzQzbr2M9gd7l4kNhf6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkVzgwh5fFYMj1YV0Z14ljFo59Lsrb8qp2uCXaXZiEOyB1MYAzrvhGuzJg0WD8eSo
	 SBXfEGvIVnbWVb+D7UwG1ezSs+0iytyORzeDsVIVFMBrVZLquxls/TqArGaoyXgnDE
	 RJ7GFu4ZFPFyoP2Kj1BfgCBoU8nVqJ1dN+dpdeGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/369] wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()
Date: Tue, 12 Aug 2025 19:26:49 +0200
Message-ID: <20250812173018.986264334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 65c12b104cb942d588a1a093acc4537fb3d3b129 ]

ath11k_mac_disable_peer_fixed_rate() is passed as the iterator to
ieee80211_iterate_stations_atomic(). Note in this case the iterator is
required to be atomic, however ath11k_mac_disable_peer_fixed_rate() does
not follow it as it might sleep. Consequently below warning is seen:

BUG: sleeping function called from invalid context at wmi.c:304
Call Trace:
 <TASK>
 dump_stack_lvl
 __might_resched.cold
 ath11k_wmi_cmd_send
 ath11k_wmi_set_peer_param
 ath11k_mac_disable_peer_fixed_rate
 ieee80211_iterate_stations_atomic
 ath11k_mac_op_set_bitrate_mask.cold

Change to ieee80211_iterate_stations_mtx() to fix this issue.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250603-ath11k-use-non-atomic-iterator-v1-1-d75762068d56@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7ead581f5bfd..ddf4ec6b244b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8681,9 +8681,9 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 			return ret;
 		}
-		ieee80211_iterate_stations_atomic(ar->hw,
-						  ath11k_mac_disable_peer_fixed_rate,
-						  arvif);
+		ieee80211_iterate_stations_mtx(ar->hw,
+					       ath11k_mac_disable_peer_fixed_rate,
+					       arvif);
 	} else if (ath11k_mac_bitrate_mask_get_single_nss(ar, arvif, band, mask,
 							  &single_nss)) {
 		rate = WMI_FIXED_RATE_NONE;
@@ -8750,9 +8750,9 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		}
 
 		mutex_lock(&ar->conf_mutex);
-		ieee80211_iterate_stations_atomic(ar->hw,
-						  ath11k_mac_disable_peer_fixed_rate,
-						  arvif);
+		ieee80211_iterate_stations_mtx(ar->hw,
+					       ath11k_mac_disable_peer_fixed_rate,
+					       arvif);
 
 		arvif->bitrate_mask = *mask;
 		ieee80211_iterate_stations_atomic(ar->hw,
-- 
2.39.5



