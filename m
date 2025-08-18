Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE2D3218B2;
	Mon, 18 Aug 2025 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523803; cv=none; b=hzhoZYifvQW7mOnfkv061x9TRZVdz+PwXKoBSkCpX7nq96SVCc76So7pjYPUe+s6v20fbGcZoDAV6jFrX/Q4SD7F4alHu5VMG9+Qv3ulC0g8vTE9C/wORVwtn7g55KSWattqStfXQ5yK+HEGFT3Lm5ubxqjbQt+17eSaajzSvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523803; c=relaxed/simple;
	bh=wBQ6ZqhRNFestYz7m0GIo6LJroZgr8fkbTvIsfuc69E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxUl6JkuDoeUMlPfodoD4PNm0MPmN54Kc+/ruwcVrwEUhl6LMCNZuIxrVZrvUboAzPeC1+dkYqFSQpS87Jx5qDV/GDxC41gvZ+xKYX41ndG7J41nSy3tIcPLDwRMyBZUcJib5wNyENdaCyGHZRZrSUFdtwXBiejIWDBu0zcBgC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzyaX3Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzyaX3Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FAFC4CEEB;
	Mon, 18 Aug 2025 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523803;
	bh=wBQ6ZqhRNFestYz7m0GIo6LJroZgr8fkbTvIsfuc69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzyaX3Nz7uvknq/fPmGrzmElK2hA9Bt+ktT9LGkSnVZUe3kNPdjx4wakqnhUCrlHl
	 bMww70vVLGbzuMuOZA5RsRiixBCIpeJ3Dajt85x/gp+Xa2762f6J2HHXi1YrSOU9Kc
	 jqWYTi5b4Bt0fXZ9A9WgHE9b29auQ1N8uy1RQlEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 277/515] wifi: ath12k: Fix station association with MBSSID Non-TX BSS
Date: Mon, 18 Aug 2025 14:44:23 +0200
Message-ID: <20250818124509.093215196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 029376c57496..cb0232113f5f 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11337,6 +11337,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	wiphy->mbssid_max_interfaces = mbssid_max_interfaces;
 	wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
+	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 
 	if (is_6ghz) {
 		wiphy_ext_feature_set(wiphy,
-- 
2.39.5



