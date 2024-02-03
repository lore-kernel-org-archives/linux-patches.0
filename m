Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E41756F;
	Sat,  3 Feb 2024 04:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933557; cv=none; b=HQN+CaOWo2RZFPeYAR6TaIweRc8FYmrAnkRMSZzsTtv9aXSKgVwmlnhEaMwtEgelTNsU+2pN1akfLjMgSzD5ZJnyMkxkmi/VlwDNemUjD8JuD5GtHkapAClRFyAht86l5wZPMffDtQeJhIIaR57XNaZvrik/I5INue+CGTdrLSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933557; c=relaxed/simple;
	bh=zUzQ4Ihf6h/LxZbGKe+vnf3a3RDaalxVnpghbrc/OFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nswcIHFA3HenIhaAPZ7NG78Ngm+TsHyxhSLTowvzH89/aP6GTegIO+ieZb+HtxNch8avblKu31oZnpRE3Q+IPM+Cq6ZEYCLgRCzGIieL5QhKpOwlX+8V8wV7Tqd4pkcFIvwgeiEEBLvXgDqfN9oG/aTvTcklulNV22lQifrifUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtgvQYu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtgvQYu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F19C43390;
	Sat,  3 Feb 2024 04:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933556;
	bh=zUzQ4Ihf6h/LxZbGKe+vnf3a3RDaalxVnpghbrc/OFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtgvQYu3INQ+FqZfvKA8WS+eDJYSBKySjhx981tTtZ5M2J5D4fXE7sLIlKXDLPnRe
	 AL/vYaoWVZNLeK/MN1kX0mQz4cUpOfLvnx8fDRw9qMviVSeIpuMHsWYef2JLMLgmHe
	 jKdMeg341T7WPKzm/Gc+cggEWKAblahuAyY5a6co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/322] wifi: ath12k: fix the issue that the multicast/broadcast indicator is not read correctly for WCN7850
Date: Fri,  2 Feb 2024 20:03:26 -0800
Message-ID: <20240203035402.673888750@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lingbo Kong <quic_lingbok@quicinc.com>

[ Upstream commit 7133b072dfbfac8763ffb017642c9c894894c50d ]

We observe some packets are discarded in ieee80211_rx_handlers_result
function for WCN7850. This is because the way to get multicast/broadcast
indicator with RX_MSDU_END_INFO5_DA_IS_MCBC & info5 is incorrect. It should
use RX_MSDU_END_INFO13_MCAST_BCAST & info13 to get multicast/broadcast
indicator.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Signed-off-by: Lingbo Kong <quic_lingbok@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231206141759.5430-1-quic_lingbok@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index e7a150e7158e..b49a4add8828 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -889,8 +889,8 @@ static u8 *ath12k_hw_wcn7850_rx_desc_mpdu_start_addr2(struct hal_rx_desc *desc)
 
 static bool ath12k_hw_wcn7850_rx_desc_is_da_mcbc(struct hal_rx_desc *desc)
 {
-	return __le16_to_cpu(desc->u.wcn7850.msdu_end.info5) &
-	       RX_MSDU_END_INFO5_DA_IS_MCBC;
+	return __le32_to_cpu(desc->u.wcn7850.msdu_end.info13) &
+	       RX_MSDU_END_INFO13_MCAST_BCAST;
 }
 
 static void ath12k_hw_wcn7850_rx_desc_get_dot11_hdr(struct hal_rx_desc *desc,
-- 
2.43.0



