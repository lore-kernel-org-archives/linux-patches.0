Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BECF471418;
	Tue, 21 Jul 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656542; cv=none; b=SsRAC5vnyE+NXdmt2qZv8VkYhJs2Vy0siA5M9qjNu6iANzq0V9F0ZOiFahz6DKN6+KTAcFEgFQQ1SEzKGUX5mogypQVlWmiJEK1NOwHYbVwQzt8BvQcVhUBLhPkEOkDiihhgojYRcHn4JBf7N3QBxXFEMts6PBPaH5UauWTYP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656542; c=relaxed/simple;
	bh=hPqvCibQUyM42i2VI80vPLLujMQSTtVfddzbplMUCNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5DsVlYo2vmOmpGZQQYKKOqX2BnWjW4mPq8XaJ3L+Z7cFAATco18RiwXpX2uVxGQU33IUjLyh5X0l+QxJGA5TOnQsiCH/f4WiNh/YMPK7DdQe3GW5FJ+eTj68Wjuyo6YVEpGHYaNcVaJ0V22KfIpUSPmM8q4Cx0+WNBmh64c/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jimfpSau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jimfpSau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980571F00A3D;
	Tue, 21 Jul 2026 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656540;
	bh=2lk5SkjDmt4ZnRGHPzNiMfuq0r8AccSmVVNp9mQ0ERA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jimfpSauEk6No/oyqgAxTzOq3cmJEfagtKxuP8+utZ9uhZJwZQMiR4Bz7ZzrUM8hX
	 7J7ibqr/Mt0kQnof1f7F0eXkTfnfPJpsGM9hzPKpWhEcBydBtjLhpbLZY9pRIxuCFg
	 bTn2avTCoDbikM8AhM4+IRuFHduwfGpCKQrMLCS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <quic_wgong@quicinc.com>,
	Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0419/1611] wifi: ath12k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE when NSS ratio is reported
Date: Tue, 21 Jul 2026 17:08:55 +0200
Message-ID: <20260721152524.688676094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 63abe299b12b317dfee5bcd09037da4668a4431a ]

When firmware reports NSS ratio support, SUPPORTS_VHT_EXT_NSS_BW is enabled in
ath12k. However, IEEE80211_VHT_EXT_NSS_BW_CAPABLE must also be set to make the
advertisement valid.

According to IEEE Std 802.11-2024, Subclause 9.4.2.156.3 (Supported VHT-MCS and
NSS Set subfields), the VHT Extended NSS BW Capable bit indicates whether a STA
is capable of interpreting the Extended NSS BW Support subfield of the VHT
capabilities information field. Advertising extended NSS BW support without
setting this capability bit is therefore invalid.

Without this change, mac80211 detects the inconsistency and logs:

  ieee80211 phy0: copying sband (band 1) due to VHT EXT NSS BW flag

This indicates that mac80211 implicitly aligns IEEE80211_VHT_EXT_NSS_BW_CAPABLE
during ieee80211_register_hw(). Explicitly setting the bit in ath12k avoids this
fixup and ensures capabilities are advertised correctly by the driver.

This change follows the same approach as the existing ath11k fix.
https://lore.kernel.org/all/20211013073704.15888-1-wgong@codeaurora.org/

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1

Fixes: 18ab9d038fad ("wifi: ath12k: add support for 160 MHz bandwidth")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260604095831.2674298-1-maharaja.kennadyrajan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 368c377ab9b55d..4bb4482e27343b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7672,6 +7672,10 @@ ath12k_create_vht_cap(struct ath12k *ar, u32 rate_cap_tx_chainmask,
 	vht_cap.vht_supported = 1;
 	vht_cap.cap = ar->pdev->cap.vht_cap;
 
+	if (ar->pdev->cap.nss_ratio_enabled)
+		vht_cap.vht_mcs.tx_highest |=
+			cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
 	ath12k_set_vht_txbf_cap(ar, &vht_cap.cap);
 
 	/* 80P80 is not supported */
-- 
2.53.0



