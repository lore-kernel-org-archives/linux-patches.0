Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5302CCC0;
	Tue, 27 May 2025 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365103; cv=none; b=i/Zcp/fLirTSfyZ+P9WqWAdjpGrgUc/FyRrySoqDWKwHO067lE4uOhtsQzZ3Iq4THTKd0xM2YpvmXcW841EFxH6rCgt1i8IZZnM6XgLmJnxtRopLR7vOb+ApGB4ImTcVCH5wnNvJzzOZwNdlrnnU6WCOdCQw3/sj521+46YIWfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365103; c=relaxed/simple;
	bh=uB04S/mnCeUHWd7kea8aP5vhxqxc9fWP7vChfUzaIO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4ZGA3JrJh7M6bhtdwMY0ssVEgL2RU+PRMa1bgAZ+fsVRdxXbJBSjqyAdQWovRZrPxGkbc2R/rj1Kr5KudDCutPOyozTY6vA/jRx2BxmfYJ1gJESuGGtaAdXz9vYN7Sqwy+7RI6yfFXVlAABv6DjJ9QGY27uIvmM2lAhfV9nqVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXTSGGlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXTSGGlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B655C4CEE9;
	Tue, 27 May 2025 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365102;
	bh=uB04S/mnCeUHWd7kea8aP5vhxqxc9fWP7vChfUzaIO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXTSGGlVOdhhKtm2nDPK4A/iK25YF9aO3Av04wmxJOEGcP/kBLMEa3YlGPl3baTEW
	 gsK1Cz49fZ9Yzuhs7HgKhNNiQnBTPfnJ5aeo/QYtclx8PeD2jTqKQ7UbpTAnf3NA1W
	 eX2V8TVmuNf8XC116bdADTeLncP8YeS5K5zQRg0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinith Kumar R <quic_vinithku@quicinc.com>,
	Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/626] wifi: ath12k: Report proper tx completion status to mac80211
Date: Tue, 27 May 2025 18:22:40 +0200
Message-ID: <20250527162455.865573261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Vinith Kumar R <quic_vinithku@quicinc.com>

[ Upstream commit d2d9c9b8de725e1006d3aa3d18678a732f5d3584 ]

Currently Tx completion for few exception packets are received from
firmware and the tx status updated to mac80211. The tx status values of
HAL_WBM_REL_HTT_TX_COMP_STATUS_DROP and HAL_WBM_REL_HTT_TX_COMP_STATUS_TTL
are considered as tx failure and reported as tx failure to mac80211.
But these failure status is due to internal firmware tx drop and these
packets were not tried to transmit in the air.
In case of mesh this invalid tx status report might trigger mpath broken
issue due to increase in mpath fail average.
So do not report these tx status as tx failure instead free the skb
by calling ieee80211_free_txskb(), and that will be accounted as dropped
frame.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Signed-off-by: Vinith Kumar R <quic_vinithku@quicinc.com>
Signed-off-by: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241122173432.2064858-1-quic_tamizhr@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 44406e0b4a342..ad21fbfbcbe22 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -557,13 +557,13 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_base *ab,
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
-	case HAL_WBM_REL_HTT_TX_COMP_STATUS_DROP:
-	case HAL_WBM_REL_HTT_TX_COMP_STATUS_TTL:
 		ts.acked = (wbm_status == HAL_WBM_REL_HTT_TX_COMP_STATUS_OK);
 		ts.ack_rssi = le32_get_bits(status_desc->info2,
 					    HTT_TX_WBM_COMP_INFO2_ACK_RSSI);
 		ath12k_dp_tx_htt_tx_complete_buf(ab, msdu, tx_ring, &ts);
 		break;
+	case HAL_WBM_REL_HTT_TX_COMP_STATUS_DROP:
+	case HAL_WBM_REL_HTT_TX_COMP_STATUS_TTL:
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_REINJ:
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_INSPECT:
 		ath12k_dp_tx_free_txbuf(ab, msdu, mac_id, tx_ring);
-- 
2.39.5



