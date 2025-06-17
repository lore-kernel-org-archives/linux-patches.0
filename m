Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543EA22FF2B;
	Tue, 17 Jun 2025 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177208; cv=none; b=cyT4pCPLaCDbEGOFFj1f620VrPiunV5fpygt0TG6ke/i4pV7Vgo8bv6++2YMkgQylwNwE4G4jaHxzytYeJLsc35hzgsL/I4t/nWpLSqOJm4Bpr9lbkwHBFPa23eWnDunSypsV17MeTVm7MogYzkpJk+owOGBaF2V8Y/DPKxG/qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177208; c=relaxed/simple;
	bh=tRNeG6bp9STMj5uC7Cy2bhGZ3Oi0w1vifZRNXGVX2SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA1iuLQxTYM1tu4jvDhUfNcMeuHWTRt0Os93BmAqh7rUDLoQnasxKhdyvPAJwUTHbQiY8gd30TifLiEko7EfH1gfh8akGsCKAgPt+yiLQxPYECinLEoFKf3nf8oLlGTvQkQO5ngP/uN8VMJIqtpQyTGuE6CYJAKLgVKVUX32vSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBbzvTIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBbzvTIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC8CC4CEE3;
	Tue, 17 Jun 2025 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177208;
	bh=tRNeG6bp9STMj5uC7Cy2bhGZ3Oi0w1vifZRNXGVX2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBbzvTIMvAhzdYgnyVzsxTMAFG/VTf/btRDSWP7lg+5pzvbOKmHuZpmo/TIaIgkLl
	 DlQ8sR9CEFlR+hdngQdrbVungRbaqwF7vf1/hYwKqoxU+FgY2w9mupuqjRvcAxwK+8
	 SBk3giU9lcPSdk28yR28kxITyxQ2qvSmFh8FHCkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Sowjanya vardhineni <quic_svardhin@quicinc.com>,
	Mahendran P <quic_mahep@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 272/780] wifi: ath12k: Fix invalid RSSI values in station dump
Date: Tue, 17 Jun 2025 17:19:40 +0200
Message-ID: <20250617152502.541052437@linuxfoundation.org>
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

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 3126f1c52af5bc8d40d2c984907daeb501f6b739 ]

When processing a "station dump" command, the driver retrieves RSSI
values from the HAL_PHYRX_RSSI_LEGACY TLV received from the monitor
destination ring, and reports them to userspace. Currently, the RSSI
values reported are improper because the hardware has not been
configured to update them properly.

To fix this, enable the HTT_RX_FILTER_TLV_FLAGS_PPDU_START_USER_INFO in
the filter setup to ensure the correct RSSI values are returned in the
HAL_PHYRX_RSSI_LEGACY TLV, resulting in correct RSSI values being
reported to userspace.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00218-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Signed-off-by: Sowjanya vardhineni <quic_svardhin@quicinc.com>
Reviewed-by: Mahendran P <quic_mahep@quicinc.com>
Link: https://patch.msgid.link/20250424055104.2503723-1-quic_svardhin@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 65eb50bf03b24..331bcf5e6c4cc 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -229,7 +229,8 @@ ath12k_phymodes[NUM_NL80211_BANDS][ATH12K_CHAN_WIDTH_NUM] = {
 const struct htt_rx_ring_tlv_filter ath12k_mac_mon_status_filter_default = {
 	.rx_filter = HTT_RX_FILTER_TLV_FLAGS_MPDU_START |
 		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END |
-		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END_STATUS_DONE,
+		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END_STATUS_DONE |
+		     HTT_RX_FILTER_TLV_FLAGS_PPDU_START_USER_INFO,
 	.pkt_filter_flags0 = HTT_RX_FP_MGMT_FILTER_FLAGS0,
 	.pkt_filter_flags1 = HTT_RX_FP_MGMT_FILTER_FLAGS1,
 	.pkt_filter_flags2 = HTT_RX_FP_CTRL_FILTER_FLASG2,
-- 
2.39.5



