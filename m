Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E3134389C;
	Sat, 12 Sep 2026 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198486; cv=none; b=fi/s+YuPMMabAT4vB18+WAXi1P8lwqtRWRExJiiBlR+b/N6zBREQEUCHowqv5ycRAFYjyC4TZEUhEuMDguf6TstBggCSKWTX3Y4f5f88JgvRwT+u6gm3uFxd5dVVAsnzsR9zoHxolLOwFW/ccYjZCxdJSl/7Cfi+UllHTpAOJQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198486; c=relaxed/simple;
	bh=VoKidhigC7J1iOBkm5n3ZUQfNyjT5tfI18G4FCJpBbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyJqV9GMr/w47Tys3jGYRxJemys+/PlTKarwTWE6lwfkAkcpxXC4Nm0f6XgTUdjndpgjnE7wgDZPuPRMpyivdz3sL2k6doYKyOll/W9jtJ8PKW/Oh38KybuUAwgbdjfIVfw7zVZzWxsBKH2AYfDJ100SMzDH3DhiCwmLdBEyUNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYgUKqOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYgUKqOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820851F000FF;
	Sat, 12 Sep 2026 07:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198484;
	bh=tz9qlJOjYSDWBKOa4ifkmTGSg7cDITfjskqR6FwnW0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYgUKqOm4m6fSscYGO3uKOY2yiEncRu70dhJd+oVNek8Ema5QN+mWYxk/dWlAkQH+
	 PisKfwbL61M69IdHPmfApJYnzaW9ykgjoNlzop6wdbSNPJaNAOMpKMsBUFaXjull6n
	 uYvfxgGbgcHoXbVk0HGd9b4oJRTq9TEAkWO99cK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0390/1815] wifi: ath12k: fix rx_mpdu_start layout for QCC2072
Date: Sat, 12 Sep 2026 08:35:40 +0200
Message-ID: <20260912065658.047420522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Zhang <wei.zhang@oss.qualcomm.com>

[ Upstream commit 9eb29fd47595e8128775f8ac57ca671238cb798a ]

QCC2072's rx_mpdu_start TLV has a different field layout from QCN9274.
Reusing struct rx_mpdu_start_qcn9274 in hal_rx_desc_qcc2072 causes the
RX datapath to read the wrong offsets for info2, info4, pn[] and
phy_ppdu_id, producing corrupted sequence number, PN, ppdu_id and
mpdu-info flags (encrypted, fragment, addr2/addr4 valid).

Add a dedicated struct rx_mpdu_start_qcc2072 that matches the actual
hardware descriptor layout, and use it in hal_rx_desc_qcc2072.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00188-QCACOLSWPL_V1_TO_SILICONZ-1

Fixes: 28badc78142e ("wifi: ath12k: add HAL descriptor and ops for QCC2072")
Signed-off-by: Wei Zhang <wei.zhang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260629061529.1993932-1-wei.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/ath/ath12k/wifi7/hal_rx_desc.h   | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx_desc.h b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx_desc.h
index 0d19a9cbb68ce..6d69851e529d8 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx_desc.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx_desc.h
@@ -140,6 +140,38 @@ struct rx_mpdu_start_qcn9274 {
 	__le32 res1;
 } __packed;
 
+struct rx_mpdu_start_qcc2072 {
+	__le32 info0;
+	__le32 info2;
+	__le32 reo_queue_desc_lo;
+	__le32 info1;
+	__le32 pn[4];
+	__le32 info4;
+	__le32 peer_meta_data;
+	__le16 ast_index;
+	__le16 sw_peer_id;
+	__le16 info3;
+	__le16 phy_ppdu_id;
+	__le32 info5;
+	__le32 info6;
+	__le16 frame_ctrl;
+	__le16 duration;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctrl;
+	u8 addr4[ETH_ALEN];
+	__le16 qos_ctrl;
+	__le32 ht_ctrl;
+	__le32 info7;
+	__le32 res0;
+	__le32 res1;
+	__le32 res2;
+	__le32 info8;
+	__le32 res3;
+	__le32 res4;
+} __packed;
+
 #define QCN9274_MPDU_START_SELECT_MPDU_START_TAG			BIT(0)
 #define QCN9274_MPDU_START_SELECT_INFO0_REO_QUEUE_DESC_LO		BIT(1)
 #define QCN9274_MPDU_START_SELECT_INFO1_PN_31_0				BIT(2)
@@ -1492,7 +1524,7 @@ struct hal_rx_desc_qcc2072 {
 	struct rx_msdu_end_qcn9274 msdu_end;
 	u8 rx_padding0[RX_BE_PADDING0_BYTES];
 	__le32 mpdu_start_tag;
-	struct rx_mpdu_start_qcn9274 mpdu_start;
+	struct rx_mpdu_start_qcc2072 mpdu_start;
 	struct rx_pkt_hdr_tlv_qcc2072 pkt_hdr_tlv;
 	u8 msdu_payload[];
 };
-- 
2.53.0



