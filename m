Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5312DFF06;
	Tue, 17 Jun 2025 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176601; cv=none; b=Ffrm3pw/6yOWXvLwx019u3szWvBUl775N6ReisWzveDBv2UWXSH81eVvIXvJYJi4TPmNN5+9deSKDznBR9QttUONDW3TPzG3+v1ZMf4qKYrZLkhldQGhKCSYFstcrVWT0rpMjQ/XX9Q5tMJHmEWfYkuBQ2GeHC4evIpyH902UQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176601; c=relaxed/simple;
	bh=fmdQufRFvtMN43klt2q1kG2OE0sx+AQ2wEnHDfOcFSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr+tajN8/XoxNCCm/vXh37dvRI8obM+68dVfGU0YCLvtkKaKf+M1e5BTzpQo+BzPsK84ZzrIfWNz12n3yxwlEUWCzq8unNJNF8xXkFuZimVSP+ze7rkWaYAYCHtyV5SV76YU+cFo9t2rjlEdOXOL31t0xcQ3+2rprmsBPB45kI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdIVvRT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdIVvRT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F70AC4CEE3;
	Tue, 17 Jun 2025 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176600;
	bh=fmdQufRFvtMN43klt2q1kG2OE0sx+AQ2wEnHDfOcFSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdIVvRT1WnboAke9sVxou9rqK9ilh/LEOLVAR7nagLS2dQ2sN+kz0E4FeGO2Tv8xU
	 OanZPHyXWNqw40pHOp/rvVO4TkgTXoFVpiA/F0rHvaIA9p5PHMcWgWxJr/7KU+tAYx
	 9L4gDuubOGxfEyN+1y7Zqx1CqcdAuldnUFcd8Fag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 205/780] wifi: ath12k: Fix the QoS control field offset to build QoS header
Date: Tue, 17 Jun 2025 17:18:33 +0200
Message-ID: <20250617152459.809964156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>

[ Upstream commit 8599d4cc4191c8c1af34207a8b9414acca4afb59 ]

Currently, in the mac80211 layer, received EAPOL packets are dropped
when the HT control field is present in the QoS header. This issue
arises due to an incorrect QoS control field offset used to build
the QoS header in the MSDU data, leading to a corrupted header in the
mac80211 layer. This issue also applies to other frames that contain
the QoS control field, such as QoS data or Null frames. To resolve
this, use ieee80211_get_qos_ctl() to obtain the correct QoS control
offset from the MSDU data. Additionally, ensure the QoS control header
is copied in little-endian format within the MSDU data.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
Signed-off-by: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250415184102.2707300-1-nithyanantham.paramasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 317cc6e6e1f5b..125ccbd0532ce 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2119,7 +2119,7 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 	struct ath12k_base *ab = ar->ab;
 	size_t hdr_len, crypto_len;
 	struct ieee80211_hdr hdr;
-	u16 qos_ctl;
+	__le16 qos_ctl;
 	u8 *crypto_hdr, mesh_ctrl;
 
 	ath12k_dp_rx_desc_get_dot11_hdr(ab, rx_desc, &hdr);
@@ -2140,13 +2140,13 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 
 	/* Add QOS header */
 	if (ieee80211_is_data_qos(hdr.frame_control)) {
-		qos_ctl = rxcb->tid;
+		struct ieee80211_hdr *qos_ptr = (struct ieee80211_hdr *)msdu->data;
+
+		qos_ctl = cpu_to_le16(rxcb->tid & IEEE80211_QOS_CTL_TID_MASK);
 		if (mesh_ctrl)
-			qos_ctl |= IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT;
+			qos_ctl |= cpu_to_le16(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT);
 
-		/* TODO: Add other QoS ctl fields when required */
-		memcpy(msdu->data + (hdr_len - IEEE80211_QOS_CTL_LEN),
-		       &qos_ctl, IEEE80211_QOS_CTL_LEN);
+		memcpy(ieee80211_get_qos_ctl(qos_ptr), &qos_ctl, IEEE80211_QOS_CTL_LEN);
 	}
 }
 
-- 
2.39.5



