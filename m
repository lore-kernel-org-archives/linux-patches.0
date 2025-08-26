Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FE5145B3E;
	Tue, 26 Aug 2025 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212993; cv=none; b=AGLgdYQjHZXI6YEBQcXmOWweGRj+DwuS9X7ikeLIAPGZH9VHk/OcL8U5bW4BbyhBsYeUvrUrhGKXX2huB2Jt1aOchs5tvFIY4k6E+VAwYxL72Nzk7cGcE5u5SVXbPz/nwjWSfNEATKCwMsgS1zJZj+FsLUx7aFuB8aKpbigHBjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212993; c=relaxed/simple;
	bh=Q924h72a7tr14zjBZVSwxpmtFfoPKtP2vheM2+hsWeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYO4CmrLVRl061B7jxPMLfIhkPpSX6p5ua2nombbc2o4AxmuYy9r72RsiEaWIe2YVDxlpO+1A+BadCz9kI8MjW8rTgwC586uYdqorkojSAop1WBm3CgsBzb2hr+9qDkW3lJioWS+KY1qk9U+aVe1YlCNw7Yx1oomf8dlrTb/pnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF7e8553; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF7e8553"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89AAC4CEF1;
	Tue, 26 Aug 2025 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212993;
	bh=Q924h72a7tr14zjBZVSwxpmtFfoPKtP2vheM2+hsWeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF7e8553VqrneB+lXMwFMb7C2YbKIg7x7tyTTQswNJwkJv/rUK7zwSmY6QQiUusN0
	 C29lfvgBnPBolaXQcBltMX8rcCdRP/GQnJdIipws19js6XTnE+qoRw6LVXHzGiabAo
	 XIubR2OaywuKe9kAmU+mHerILt8Xbf97Pkkz1DsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/587] wifi: ath12k: Add memset and update default rate value in wmi tx completion
Date: Tue, 26 Aug 2025 13:05:29 +0200
Message-ID: <20250826110957.520945626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit 9903c0986f782dfc511d7638b6f15fb6e8600cd3 ]

When both AP/STA and monitor interfaces are enabled, ieee80211_tx_status()
is invoked from two paths: the TX completion handler for data frames
and the WMI TX completion handler for management frames.
In the data path, the skb->cb is properly zeroed using memset, but in
the WMI path, this step is missing.

As a result, mac80211 encountered uninitialized (junk) values in
skb->cb when generating the radiotap header for monitor mode, leading
to invalid radiotap lengths.

Hence, explicitly zero the status field in the skb->cb using memset
in WMI TX completion path to ensure consistent and correct behavior
during WMI tx completion path.

Additionally, set info->status.rates[0].idx = -1 to indicate that
no valid rate information is available, avoiding misinterpretation of
garbage values.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250603063512.1887652-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index e918218ce2d6..7e400a0e0eb1 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4965,6 +4965,11 @@ static int wmi_process_mgmt_tx_comp(struct ath12k *ar, u32 desc_id,
 	dma_unmap_single(ar->ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	info = IEEE80211_SKB_CB(msdu);
+	memset(&info->status, 0, sizeof(info->status));
+
+	/* skip tx rate update from ieee80211_status*/
+	info->status.rates[0].idx = -1;
+
 	if ((!(info->flags & IEEE80211_TX_CTL_NO_ACK)) && !status)
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
-- 
2.39.5



