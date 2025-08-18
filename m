Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F52B261B9B;
	Mon, 18 Aug 2025 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525560; cv=none; b=ZaFz037GOLvUHeMnnPqgopQBN0FmQ12O5+gx9b0FFO+EmkH4wK6o4RXV+EhX76YV0rj3KKpPuqX2tGzqj+QTua7lV0IpWUFvFcrZwm1/sIWrhO2w2oKosff1TmGmhetj8+rz/s34ZnhjqblQUdKut7XaoIfbBFhld19/oj81RLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525560; c=relaxed/simple;
	bh=3S7P2I2Y+g4rNUTCxeN+xRAy32x6tyCoupIdhwRNMR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCv/AbwrRh6m2pyqi8MTaOrmz4EfOUICH4+sL0xR7kazSL/D+50FnhvqZflFtoNheIviE4Umjg+Z2jBp0jy65EAdNgKqXRMBHM4wZ9P9c5Cr8rkjd8NDtDXFcR8el/CVQT0o8YWQdOszWdFk5PIYSfrtS4VfFTB4V7490ouaEV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJjWYyWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJjWYyWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBEEC4CEEB;
	Mon, 18 Aug 2025 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525559;
	bh=3S7P2I2Y+g4rNUTCxeN+xRAy32x6tyCoupIdhwRNMR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJjWYyWW9J3sScx+odYahCfRmrGRxVrDq1TUw6IhbiL2//uhDSjmE9NGR8c5dwO9B
	 yjJTzpl5fIFPLT4gZdwuTqi22Jgb6KlqDebYW/IqFQ7ur0FPqM0A/jdi45F7heJbCR
	 JhHjobiGznOWMcEna1y5xxK8xVDY97dUtR3PTUd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 299/570] wifi: ath12k: Fix station association with MBSSID Non-TX BSS
Date: Mon, 18 Aug 2025 14:44:46 +0200
Message-ID: <20250818124517.369228344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit 70eeacc1a92a444f4b5777ab19e1c378a5edc8dd ]

ath12k station is unable to associate with non-transmitting BSSes
in a Multiple BSS set because the user-space does not receive
information about the non-transmitting BSSes from mac80211's
scan results.

The ath12k driver does not advertise its MBSSID capability to mac80211,
resulting in wiphy->support_mbssid not being set. Consequently, the
information about non-transmitting BSS is not parsed from received
Beacon/Probe response frames and is therefore not included in the
scan results.

Fix this by advertising the MBSSID capability of ath12k driver to
mac80211.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250530035615.3178480-2-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 13f44239abde..a885dd168a37 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -12522,6 +12522,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	wiphy->mbssid_max_interfaces = mbssid_max_interfaces;
 	wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
+	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 
 	if (is_6ghz) {
 		wiphy_ext_feature_set(wiphy,
-- 
2.39.5



