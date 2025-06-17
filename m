Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FAA2ED15A;
	Tue, 17 Jun 2025 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176577; cv=none; b=r3oFnVWGDtRk8dEi3tEKcECplWPTjPRS8mofNHTdhAB/WHL9vJHg3PKRDcBvDuhV81Mk+WG8GsRAvYw+uwsQVH/gIT1afy7JGxPBDWsyNW9ZqBab3AFsLx+YVGI4Va7OJPQ6m5EgYCOcwQETbdFtsnhRu+5jAsLwwGVVZQeBkRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176577; c=relaxed/simple;
	bh=kVxOvYOt45vq0RxfUkvPwNpODc4RUZlO1uboalfgsyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX8+Uil7gZOmeKpTLqsUVtqgS4Ece+Ut0ysfiIRqoPpDx+FjlOwtTMJzFrMTs7F+6dvXJDWL7afcze99pNcGQ+BkfJatUWNKK/Kywvf3pZ41MgX0WjybMfAVaysqdgwm5aL4vV+QJ4CMMFh5Ioshbd8JDpB1LmaRm7vRMs3x4oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgqSOrsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgqSOrsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A429CC4CEE3;
	Tue, 17 Jun 2025 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176577;
	bh=kVxOvYOt45vq0RxfUkvPwNpODc4RUZlO1uboalfgsyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgqSOrsEIry7dVtTbkpUSuxgDy1OjtqYYMMEI4+LG7tlBSq9aGUe2OOYxL0pWXTjG
	 SZ1cIGtjnjbCF89knqSmd+aql5qXp8F+qEk0JwIOMnh5RZmedPgARNyfPfBlhpAj30
	 TsRhRqwaYbkHtgWxGlCf5p4ocwkfC/fuVNeiqxms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 203/780] wifi: ath12k: fix invalid access to memory
Date: Tue, 17 Jun 2025 17:18:31 +0200
Message-ID: <20250617152459.727468753@linuxfoundation.org>
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
index 21d240cc3aee4..70afb3bd39202 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1817,6 +1817,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	struct hal_rx_desc *ldesc;
 	int space_extra, rem_len, buf_len;
 	u32 hal_rx_desc_sz = ar->ab->hal.hal_desc_sz;
+	bool is_continuation;
 
 	/* As the msdu is spread across multiple rx buffers,
 	 * find the offset to the start of msdu for computing
@@ -1865,7 +1866,8 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	rem_len = msdu_len - buf_first_len;
 	while ((skb = __skb_dequeue(msdu_list)) != NULL && rem_len > 0) {
 		rxcb = ATH12K_SKB_RXCB(skb);
-		if (rxcb->is_continuation)
+		is_continuation = rxcb->is_continuation;
+		if (is_continuation)
 			buf_len = DP_RX_BUFFER_SIZE - hal_rx_desc_sz;
 		else
 			buf_len = rem_len;
@@ -1883,7 +1885,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 		dev_kfree_skb_any(skb);
 
 		rem_len -= buf_len;
-		if (!rxcb->is_continuation)
+		if (!is_continuation)
 			break;
 	}
 
-- 
2.39.5



