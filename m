Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312B2F656A;
	Fri, 21 Nov 2025 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731639; cv=none; b=quRCFrFR9HWWs9I0bdWNmwqqbA1GrnwTT+lTV4oajw5Hu3K7CClGakiZ0FzQzoW+55yA8cW1lxbqoY/z9RMgYfiKYL8z0u0FXDh7T7HWL1Zi2w/9TxdCSoFxknn5frNGTUNk5CcyTjMYy/IhAa2Cab3L1kJMtdVNzUWgn3+CI2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731639; c=relaxed/simple;
	bh=xmdu9U8Vd+Xm4X1hdQ5/t8DeuHVVjLO6Ug67fWWu+hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYh03cby65zrcJdumoXQE1ppfc6Jltg6IPvY6AtrkxSQ+S/AXyr7/IxA0+je2gCBnV3hb/Xl6ZAFFPG0M93BnUwaw4atpb9mGXLvr72qsR53RL69IsuDy3tMOMaoVu/9vsg/3mdVXWH3lFLM+O0Y3/s0SmTJhDHbiHKnzjCMJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eJs6eoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eJs6eoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B07C4CEF1;
	Fri, 21 Nov 2025 13:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731638;
	bh=xmdu9U8Vd+Xm4X1hdQ5/t8DeuHVVjLO6Ug67fWWu+hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eJs6eoQM+scDaD/2iOwVFkN5BnjSK9z3MmEKEKVXK9wYhuQh2RrGIw6fijzw5E06
	 ZiZws5AC9KpEHo9gzjBkJNpz9mQCZcswEZf1liIeX85AMiTNopBDnAe3oivpb5laPv
	 W8B41WG9+Z5aZ0mKeapjkb/QeVTWUmYRXu1K17+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/185] wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()
Date: Fri, 21 Nov 2025 14:10:57 +0100
Message-ID: <20251121130144.962219516@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 9065b968752334f972e0d48e50c4463a172fc2a7 ]

When reporting tx completion using ieee80211_tx_status_xxx() family of
functions, the status part of the struct ieee80211_tx_info nested in the
skb is used to report things like transmit rates & retry count to mac80211

On the TX data path, this is correctly memset to 0 before calling
ieee80211_tx_status_ext(), but on the tx mgmt path this was not done.

This leads to mac80211 treating garbage values as valid transmit counters
(like tx retries for example) and accounting them as real statistics that
makes their way to userland via station dump.

The same issue was resolved in ath12k by commit 9903c0986f78 ("wifi:
ath12k: Add memset and update default rate value in wmi tx completion")

Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251104083957.717825-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 98811726d33bf..bfca9d3639810 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5961,6 +5961,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar,
 	dma_unmap_single(ar->ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	info = IEEE80211_SKB_CB(msdu);
+	memset(&info->status, 0, sizeof(info->status));
+	info->status.rates[0].idx = -1;
+
 	if ((!(info->flags & IEEE80211_TX_CTL_NO_ACK)) &&
 	    !tx_compl_param->status) {
 		info->flags |= IEEE80211_TX_STAT_ACK;
-- 
2.51.0



