Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64984409;
	Mon, 23 Jun 2025 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714478; cv=none; b=ktl31Pl1c0+F9JCoBcn6NJwtA5QS5hqkHaxW9X/+ITY3KDpbJU01aRvF4JLOzFctpiLDcWsgbn22w8tHrkgx7cNn+vBv37o3SZGhtqyPqKSwb738wdHPX7u+tqUovRPtwDSCMpQlPFmWByE2+YFlXP+Arw9Ll6OPTnSzJOOaU04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714478; c=relaxed/simple;
	bh=U16fgCjlUpu3vMx16foi87guJlfLTXHdzNr+CMPjl3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB1hWfds1uln68yaJRMDi7QRFkzfH67ChHpkU7X/zhnT2vwWf0y2VFV8LNkbHVcL81tRxMjuit5nKSfXVDx6f2ErC388r5Dwn9TL+WTXPX/sH/nWve2YNjcKS/rcOU3lDgKjQv34iNJGaXhgr5vYCItIMB6Jak20iXp1bLCXme4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZogVC/C6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZogVC/C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAFEC4CEED;
	Mon, 23 Jun 2025 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714475;
	bh=U16fgCjlUpu3vMx16foi87guJlfLTXHdzNr+CMPjl3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZogVC/C6XFhxtJoUDgoFTN1hneIuupAUJq7YcLPJ9jltBqucbxow7Gy404c/fito0
	 jiL386ZJH6lj3xX5MC/tdpqZ5nqWmlY1aInOLKa+HKwUuhF1dZ0KTODppiQP0fakfg
	 42nkut+bA1z3Kgisr8kLa8NyfQdKNBBKJJ9kXlDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Roopni Devanathan <quic_rdevanat@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 417/592] wifi: ath12k: Fix incorrect rates sent to firmware
Date: Mon, 23 Jun 2025 15:06:15 +0200
Message-ID: <20250623130710.356354206@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>

[ Upstream commit cb1790249361ba9396b06b1af2500147e6e42e5e ]

Before firmware assert, if there is a station interface in the device
which is not associated with an AP, the basic rates are set to zero.
Following this, during firmware recovery, when basic rates are zero,
ath12k driver is sending invalid rate codes, which are negative values,
to firmware. This results in firmware assert.

Fix this by checking if rate codes are valid, before sending them
to the firmware.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Signed-off-by: Roopni Devanathan <quic_rdevanat@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250320112426.1956961-1-quic_rdevanat@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index eac4214c48c39..922901bab3e39 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3451,7 +3451,10 @@ static void ath12k_recalculate_mgmt_rate(struct ath12k *ar,
 	}
 
 	sband = hw->wiphy->bands[def->chan->band];
-	basic_rate_idx = ffs(bss_conf->basic_rates) - 1;
+	if (bss_conf->basic_rates)
+		basic_rate_idx = __ffs(bss_conf->basic_rates);
+	else
+		basic_rate_idx = 0;
 	bitrate = sband->bitrates[basic_rate_idx].bitrate;
 
 	hw_rate_code = ath12k_mac_get_rate_hw_value(bitrate);
@@ -4015,10 +4018,14 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 		band = def.chan->band;
 		mcast_rate = info->mcast_rate[band];
 
-		if (mcast_rate > 0)
+		if (mcast_rate > 0) {
 			rateidx = mcast_rate - 1;
-		else
-			rateidx = ffs(info->basic_rates) - 1;
+		} else {
+			if (info->basic_rates)
+				rateidx = __ffs(info->basic_rates);
+			else
+				rateidx = 0;
+		}
 
 		if (ar->pdev->cap.supported_bands & WMI_HOST_WLAN_5GHZ_CAP)
 			rateidx += ATH12K_MAC_FIRST_OFDM_RATE_IDX;
-- 
2.39.5



