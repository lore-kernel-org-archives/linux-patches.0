Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3763164B7;
	Thu, 28 May 2026 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998985; cv=none; b=oS80ImV/Utd0twvxZsZ0HqA0whyB2GGxRZKP/ZzLXFDjNT5BONPfcq42Ft0nHYF5El8Il5E5LsEVn8t1LGhkEj2P0HwybuiQeIGEGvHIraCCVmh4boDkYKHUZDd9RLxkX9dR3usMsavL0zFzRDEkWZf4wLiHN3lvebJaya5ouFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998985; c=relaxed/simple;
	bh=lRDpVkZNg9eht2mUFYwv+v+MpDLyEuoU6mdtA5E0irY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDKQv8cw9rlen/P4HYMLLbDjOsbAYk97J1IWTmSQzuuqpjxKMhX7xXhm1oedPCjocCLc/AT7Nlrz0EL9C13fVZ56UoUe/YpgQu9ttrXl1Z4aGb+RucbCVlG36O3sNKeQ05l1Ni29dY70hesXQ3rvK7OJmYghvYbiibWSoj0hjWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBQnfM35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBQnfM35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E521F000E9;
	Thu, 28 May 2026 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998984;
	bh=w/Om4kgkP1S6W/3Wu5w0OkPHuVaXjS1PDwCj3x5MLWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBQnfM35cKyVI8LLBTSwh7t3RZGpSUGuVi5lzIB5Sr4e/FMF2PQ25PHu/VsV918sQ
	 HLi016JdGBlMSlglk8upkz6Q/UOCGn6ApUypAwIss+zAiqjBnIRxmI2obIAAsvSm1/
	 bVdNNwtIdb9z+u44Jcr97kq4llupHGM7hgG0CI6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 368/461] wifi: ath12k: fix EHT TX MCS limitation due to wrong 20 MHz-only parsing
Date: Thu, 28 May 2026 21:48:17 +0200
Message-ID: <20260528194658.094620592@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 60fb2cf51e77bb1c0261160b4be44209d68956b1 ]

When connecting to an AP configured for EHT 20 MHz with a full EHT
MCS/NSS map (supporting MCS 0-13)

Supported EHT-MCS and NSS Set
    EHT-MCS Map (BW <= 80MHz): 0x444444
        .... .... .... .... .... 0100 = Rx Max Nss That Supports EHT-MCS 0-9: 4
        .... .... .... .... 0100 .... = Tx Max Nss That Supports EHT-MCS 0-9: 4
        .... .... .... 0100 .... .... = Rx Max Nss That Supports EHT-MCS 10-11: 4
        .... .... 0100 .... .... .... = Tx Max Nss That Supports EHT-MCS 10-11: 4
        .... 0100 .... .... .... .... = Rx Max Nss That Supports EHT-MCS 12-13: 4
        0100 .... .... .... .... .... = Tx Max Nss That Supports EHT-MCS 12-13: 4

TX throughput is observed to be significantly lower than expected.
Investigation shows that TX rates are limited to EHT MCS 11, even though
the AP advertises support for EHT MCS 12/13.

The root cause is an incorrect parsing of the Supported EHT-MCS and NSS
Set element in ath12k_peer_assoc_h_eht().

IEEE Std 802.11be-2024 Figure 9-1074as describes the format for 20
MHz-Only Non-AP STAs.

IEEE Std 802.11be-2024 Figure 9-1074at describes the format for all
other AP and non-AP STAs.

Currently the first format is parsed when the peer advertises no wider
HE channel width support, without considering whether it is an AP or a
non-AP STA. This is incorrect: the peer AP's capabilities must be parsed
using Figure 9-1074at even when it operates on 20 MHz only. Parsing it
as Figure 9-1074as causes rx_tx_mcs13_max_nss to be interpreted as zero,
which is then passed to firmware, leading firmware to assume the peer
does not support MCS 13 and to limit TX rates at MCS 11.

Fix this by parsing the Figure 9-1074as format only when the peer is a
20 MHz-Only non-AP STA, i.e. when the local interface operates as AP or
mesh point.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 6c95151e2e77 ("wifi: ath12k: Add EHT MCS/NSS rates to Peer Assoc")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260514-ath12k-fix-20mhz-only-mcs-map-v1-1-a38d4a9b21a2@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index fa36e984c74b2..6869e9860776d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3446,7 +3446,9 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 		arg->peer_eht_mcs_count++;
 		fallthrough;
 	default:
-		if (!(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
+		if ((vif->type == NL80211_IFTYPE_AP ||
+		     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+		    !(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
 		      IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
 			bw_20 = &eht_cap->eht_mcs_nss_supp.only_20mhz;
 
@@ -3475,7 +3477,9 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	arg->punct_bitmap = ~arvif->punct_bitmap;
 	arg->eht_disable_mcs15 = link_conf->eht_disable_mcs15;
 
-	if (!(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
+	if ((vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    !(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
 	      IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
 		if (bw_20->rx_tx_mcs13_max_nss)
 			max_nss = max(max_nss, u8_get_bits(bw_20->rx_tx_mcs13_max_nss,
-- 
2.53.0



