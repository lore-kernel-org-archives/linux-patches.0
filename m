Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B832821507C;
	Mon, 18 Aug 2025 13:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523799; cv=none; b=IcskhU7WMrCtL+1S4KxdIOieTWuow+4EP9/1A8OebDy/SBlNgzVmuCCKL9XSs9ucIDcdJBcMsh/PCuKZ2+VoTLDqCLlnImDcCoY6U7/Si4TRzLBoxnkfjJV5VfIu3lxFfOcc0znNPfPAS6+8UXqP06DigTKoz2+TSjI0STdL4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523799; c=relaxed/simple;
	bh=RuwrOT0s5W9S6yGWwzzZiw4ZGs5pSteB3H2jixirMGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUPjWOUcd6q/q2clMDPS9MJ/uT5oIitwsX7EorEKgogzMYX4Ik71pRDa4pqjyteHqVF1RWlZgwoUa8d6no1bnrPtsJi+EIslvAxGk0ACXlU2wZfsaS5w6OuiR6ctXgs5eDmMF5EEyJ7/4P7hAJNHJVy+oxG5IPuNY40xNX5+fso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ikf1wvCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ikf1wvCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FE6C4CEEB;
	Mon, 18 Aug 2025 13:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523799;
	bh=RuwrOT0s5W9S6yGWwzzZiw4ZGs5pSteB3H2jixirMGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ikf1wvCR7P8Y7WA0LYGbHncMxvY8CLjIuYUdaXlCYGo0TRX9+D4JHoO0Fsd4HKM++
	 X+e4AxuNKaI5nuckEvbsKKZxa9W7uo8dwA8QVPVxbqZqjHImYZam2uRQ8cDXr9sDeG
	 VQpp5ooP47Q/kD5SN8JfRW5Vh4Ud2E8unBqKUFtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 276/515] wifi: ath12k: Add memset and update default rate value in wmi tx completion
Date: Mon, 18 Aug 2025 14:44:22 +0200
Message-ID: <20250818124509.054815198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 9ebe4b573f7e..3a39a1be3f7c 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -5465,6 +5465,11 @@ static int wmi_process_mgmt_tx_comp(struct ath12k *ar, u32 desc_id,
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



