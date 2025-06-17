Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD682EA149;
	Tue, 17 Jun 2025 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175478; cv=none; b=Sv3/2QFebSZW9D7biLo+IgYRiB4VYJd2VXbbFMnf7DkilXNNQZMhO6MRdcP2MbLAcEjDQB378MqCVu/FltQ5cjfAXfmyEAh/XK7s9w1NUfw0XkKh80KUgtEl4Pk2KGVJiAoTaLqbHWkSLbbkzrqbRmt61SpCtj7Msz2DjGzmWOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175478; c=relaxed/simple;
	bh=tzXGHRuXcU57SNy2wcMV9dpfrA9GD5Q6aIPnKBippA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmNmXzSQysNbt7PlUKzPMZAAOy6KM/nhMEdC722XOhlpBnPZ278b5J9sGyEJg7sPD98qZmo9qYSmcKMjIyAyl12N8qmZtcCN6aYw7a+anOyTiXNO0B8ZTxW0HOcsztI2a4eYs+JDmlc9nVCn6h/62XoeI+/3hDsZbSjWPy2jf/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgOoRgSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgOoRgSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ABDC4CEE3;
	Tue, 17 Jun 2025 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175477;
	bh=tzXGHRuXcU57SNy2wcMV9dpfrA9GD5Q6aIPnKBippA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgOoRgSSRus1TqdW78T7SJzZspBc+SXowybuf+THvReAUiO+Y/dZ1bVtPxztVk+a2
	 oVjwyfzdM5mLF1f4XWs/SKpJe2Xm8dYVX9N2KOXH419o0RbJwxqZX2/TALkcuh7gL8
	 7+qtgtWKbxW+yeBcflD2wlIPwZ/nRztIa59KO90g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/512] wifi: ath12k: fix invalid access to memory
Date: Tue, 17 Jun 2025 17:21:36 +0200
Message-ID: <20250617152424.860876464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 5fcf3a465eda8..9c730b7009fe5 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1762,6 +1762,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	struct hal_rx_desc *ldesc;
 	int space_extra, rem_len, buf_len;
 	u32 hal_rx_desc_sz = ar->ab->hal.hal_desc_sz;
+	bool is_continuation;
 
 	/* As the msdu is spread across multiple rx buffers,
 	 * find the offset to the start of msdu for computing
@@ -1810,7 +1811,8 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 	rem_len = msdu_len - buf_first_len;
 	while ((skb = __skb_dequeue(msdu_list)) != NULL && rem_len > 0) {
 		rxcb = ATH12K_SKB_RXCB(skb);
-		if (rxcb->is_continuation)
+		is_continuation = rxcb->is_continuation;
+		if (is_continuation)
 			buf_len = DP_RX_BUFFER_SIZE - hal_rx_desc_sz;
 		else
 			buf_len = rem_len;
@@ -1828,7 +1830,7 @@ static int ath12k_dp_rx_msdu_coalesce(struct ath12k *ar,
 		dev_kfree_skb_any(skb);
 
 		rem_len -= buf_len;
-		if (!rxcb->is_continuation)
+		if (!is_continuation)
 			break;
 	}
 
-- 
2.39.5



