Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF534165F;
	Fri, 21 Nov 2025 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733221; cv=none; b=hO0tUa/htxElKZWcLfHEJyqO2UIuZRKyNn6I41yNK1pTJzVrv2NQYTT7LB1kt3tyJCtnhHDMisV+Na0ptw1+HZdZgOPBIjofa3z7p+j3+JI985U97Ws7Ud3HRlE3JcYhp7605u761qfpH+JLBe8QRsxzYWLbn3PxnSL3COhcunw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733221; c=relaxed/simple;
	bh=IuboJO4YFa4cwbTDZGFkoOy/DJpIP/0XzuAxsGA06DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdINsj7nj92CmMSsADe818RMSAQGXPkLp2bAYummjCql4lCJd5ue6UK8w50jQj9qivdhUN6ea0+MWQwOE2gls18uHe2vhBUjSxZbTNmRKlVpUKAAJ7dEB3bJ9/YkBYUSbx3Y+/eBmHAOkZrymdLiWVbpyHBaosfkPIIMesVa2T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYptSoq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYptSoq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3362C4CEF1;
	Fri, 21 Nov 2025 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733221;
	bh=IuboJO4YFa4cwbTDZGFkoOy/DJpIP/0XzuAxsGA06DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYptSoq40XWJd8hVOW45g6Squ43XQkEToJuHcPF8sZ5ZoH7j9b5oa1da9J+XliyyW
	 BH34+claX0aL0yVNmTD/dkz6sIOwCsxustkOazmF3YCDEK9gSZZq+p1gaJT8KAg8YA
	 msXKPukB3LCQwc7WmDawv7CGVmOv1Ho25LSNe6R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 394/529] wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()
Date: Fri, 21 Nov 2025 14:11:33 +0100
Message-ID: <20251121130245.041673418@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 31dbabc9eaf33..16687223bdcba 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5841,6 +5841,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar,
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



