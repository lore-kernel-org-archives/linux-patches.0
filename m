Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390A357730;
	Wed,  3 Dec 2025 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779749; cv=none; b=c4fwv/m5rRrXqgTVFMTBxnvp1uS4fCOmMpENVZ23GNB1UlIrHCbkLyTsn5k6gTOGPkxD9VTyNX/Mp/Lx2eaR/XxHrBuCozeHnw+dVorTnz/a1jvyb3nnykesrhodEiyArvwzWNNWbThctwKGQXGET48yYnwAiZeiW7YXzF6c80c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779749; c=relaxed/simple;
	bh=nMf11DXLCtn2ReD4GXp09DNYcp2yCOPglVqKxGTv5GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXM7oc1lsrAMMMAXItAuS/QDTVRhpPEX7JHCsbkpbN46OmQSo+X/0pWyMpW+zm/JWNL8sSwbHZtjyC4GTBVF6OHIn5dpcHQagHZeXqzKscOqB4VLRnlwSD7WFFDj11xnv9Zy9WilrLf2KEdIPx/XrWiP4SdgIPGjaboAAPfYkLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieZm98+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieZm98+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BF9C4CEF5;
	Wed,  3 Dec 2025 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779749;
	bh=nMf11DXLCtn2ReD4GXp09DNYcp2yCOPglVqKxGTv5GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieZm98+QUm5zZld+HAZ/HYFnlLmoF1d1jgWwAk0yNh7AtJ81sSPZ7l7TSRD9n7swC
	 ineUlv9pKDkIxF08SKDrUP6x/mE8jHto+Hq5k+PM1v3c45UteCVKN5inYY0DqLzjNI
	 +eCdxgx3XIDShI/dp5S95DiulhLQornKuj0UJVaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/568] wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()
Date: Wed,  3 Dec 2025 16:25:50 +0100
Message-ID: <20251203152453.450467151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b58979bdfdc6..ed12bbb11fe89 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5246,6 +5246,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar,
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



