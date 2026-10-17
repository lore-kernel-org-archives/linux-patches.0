Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD182387373;
	Sat, 17 Oct 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258178; cv=none; b=PInURGpQ1awIqORkHc7F4tseXPiWoxlrvBdfsvKMioHA60g4QAfYZ09oIq3OW7VZIEDnpMY7IAA2MnBuJXOI1d3y/8uR7GEPCO286z2v8Yydk/B2TkFooWWq8bhSrn2n3kqmrXTrkIowG+X13YuXoI4caLJ5DwFQMMUUYaoOi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258178; c=relaxed/simple;
	bh=uyNylWrThbpSLq6R8ENSGgTuyal//uGpOZ1lH3nu3eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL1/n7Sa4uSezw1mtBHRAcdsoLCyOR9qyd1y6vD5hxMYW6JVDoIWlg7G4kPXbRQLShAGKX9jNxdkJl08VlnVEvl+KcbfTzjzX5SDzRXEC8m+m/DtDsBIfTTJJ2j7mZgsTzuo7/SdRsWsVpJcMLRXEDhKdgb8qfWkUEQqAKTXnmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuFIWaI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuFIWaI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2979C1F000C4;
	Sat, 17 Oct 2026 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258177;
	bh=FmHvvOPaD0ZeI1++mP/L+KQgH/Gwfh7rzvX674SijCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuFIWaI+/G+po+4tCDej4w5I9zL3qs8+pGSBX6+sBS/yu0YXMcyaGM86QWyHlAYxq
	 DUsvyjzWCeJR1M0Eh5btQiTiIPbdYJN+UhGkF0WOCC2545zN5cPRbC/rATjnf7/NPh
	 sgq65QvD+LzjQRFB7ou09YSOmmLX++APSDXLQXfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0755/1674] wifi: ath12k: fix invalid access to memory
Date: Sat, 17 Oct 2026 17:50:27 +0200
Message-ID: <20261017160450.481170542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit 9f17747fbda6fca934854463873c4abf8061491d ]

In ath12k_dp_rx_msdu_coalesce(), rxcb is fetched from skb and boolean
is_continuation is part of rxcb.
Currently, after freeing the skb, the rxcb->is_continuation accessed
again which is wrong since the memory is already freed.
This might lead use-after-free error.

Hence, fix by locally defining bool is_continuation from rxcb,
so that after freeing skb, is_continuation can be used.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250408045327.1632222-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 02e93f1627b95..a957b57eab1dc 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1765,6 +1765,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	struct hal_rx_desc *ldesc;
 	int space_extra, rem_len, buf_len;
 	u32 hal_rx_desc_sz = ar->ab->hw_params->hal_desc_sz;
+	bool is_continuation;
 
 	/* As the msdu is spread across multiple rx buffers,
 	 * find the offset to the start of msdu for computing
@@ -1813,7 +1814,8 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	rem_len = msdu_len - buf_first_len;
 	while ((skb = __skb_dequeue(msdu_list)) != NULL && rem_len > 0) {
 		rxcb = ATH12K_SKB_RXCB(skb);
-		if (rxcb->is_continuation)
+		is_continuation = rxcb->is_continuation;
+		if (is_continuation)
 			buf_len = DP_RX_BUFFER_SIZE - hal_rx_desc_sz;
 		else
 			buf_len = rem_len;
@@ -1831,7 +1833,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 		dev_kfree_skb_any(skb);
 
 		rem_len -= buf_len;
-		if (!rxcb->is_continuation)
+		if (!is_continuation)
 			break;
 	}
 
-- 
2.53.0



