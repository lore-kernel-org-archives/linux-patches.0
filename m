Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EDA2EA16E;
	Tue, 17 Jun 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175499; cv=none; b=QSIGnkAARGBg3cRrZxuaaGoWfD0gRtCF9T7XhNetU2moNpzF6R3VBb/OkR4/7bjQdfWVFWjrMw3/YzRcQ/3umkc8A2jr9d1NKg9LWZOV9OpRMDrF2ndzDWO8qxv4RHW0IShjOP2i9tR2YOcKUEdKH2dggzH9MyN/cmgJD1AYGOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175499; c=relaxed/simple;
	bh=gkS/OXfC/P39HAbRRr8l7oCKNPCRY9Jucf377KlQbvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPlYxETTmusu3qbuzV60nF7b1grVBMAP+zj+BF93SM7ROgoE5auiFcGJskQAZCL+0k09oEUa9jfQ4g1O0iJG1bE8Jgbdt/mQ7LXotDxAxGBuMf1IuH6M9mHD+gbDNTTuztE5BPVTEORgfI1+x/4fbYZkQddZpLk7jGUGJa+XjgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yok1rmKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yok1rmKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1911C4CEE3;
	Tue, 17 Jun 2025 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175499;
	bh=gkS/OXfC/P39HAbRRr8l7oCKNPCRY9Jucf377KlQbvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yok1rmKqDjDWJJw2EWhCk8NXDntNBP+MvHCJzIHjBEfXX0rZzOzNbGkidOrxCX5Yg
	 QgxUZhAvShn4nz6dIud3Y1tN5hHOt5/cKgXO360fmGD7BH+TyQIbOfCi67gUwPDN5Z
	 hkuOk6QOTka7YP8yrsktOVIixP1vFDkelTx/9sb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/512] wifi: ath12k: Fix the QoS control field offset to build QoS header
Date: Tue, 17 Jun 2025 17:21:38 +0200
Message-ID: <20250617152424.943863912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index c2652bc8a02fd..1623298ba2c47 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2064,7 +2064,7 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 	struct ath12k_base *ab = ar->ab;
 	size_t hdr_len, crypto_len;
 	struct ieee80211_hdr hdr;
-	u16 qos_ctl;
+	__le16 qos_ctl;
 	u8 *crypto_hdr, mesh_ctrl;
 
 	ath12k_dp_rx_desc_get_dot11_hdr(ab, rx_desc, &hdr);
@@ -2085,13 +2085,13 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 
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



