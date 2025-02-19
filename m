Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608C81A315E;
	Wed, 19 Feb 2025 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956015; cv=none; b=Sj/FNEX6eSUCPIfniPQeblnd7yCvuNcP49iCqF3tm6tDI2MAzv/zv2dzXGGD6lKwi6G9ERjX264rwW1Sv7dydFLcWrx/iLlbTKk7YcBHu6saaSo2xWFmwBQoCkn+kEBcav7FGHwCQYO9e8ZiYP95woE5l1fwBRlfgw2U+Kj0A4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956015; c=relaxed/simple;
	bh=Og8i0ZhNERP98MRTI/bYIUqI1YCXzg4fS8QRgzMTdLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfeeXLpL7/JlVoQS5K1BY1GSk863mscsZVyTuD/f2NsklmA11nKjb5/zMzlIDcHjWsKQnzVuI/rQwyyGyrCVKUvghmibZ+W/MQ/Fdf8Vd/ip5+4H0HavMH/jDv9QhmYSArybEIBKdYyqhzvkYOFon7Ovn1Tq8MsDySsZjsbA1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKR+vQ2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKR+vQ2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3924C4CED1;
	Wed, 19 Feb 2025 09:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956015;
	bh=Og8i0ZhNERP98MRTI/bYIUqI1YCXzg4fS8QRgzMTdLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKR+vQ2Lyvo5AbehjMC39Xe4jN0Dzq4KjiOIMqNif5/PqpGNk/w+Alwl99s6rCobP
	 QgFDjvQc8u0U+bT3J+1MFLhJTlXEO+G2smWawMXhCTtFkt2BAJXD3uueQHxYLBF8pj
	 roF/LmUQKo2xS+xzM82h9fITr2s3MYW0WTkk2V3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/578] wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/WCN6855
Date: Wed, 19 Feb 2025 09:20:39 +0100
Message-ID: <20250219082654.277663639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balaji Pothunoori <quic_bpothuno@quicinc.com>

[ Upstream commit 78e154d42f2c72905fe66a400847e1b2b101b7b2 ]

The following error messages were encountered while parsing fragmented RX
packets for WCN6750/WCN6855:

ath11k 17a10040.wifi: invalid return buffer manager 4

This issue arose due to a hardcoded check for HAL_RX_BUF_RBM_SW3_BM
introduced in 'commit 71c748b5e01e ("ath11k: Fix unexpected return buffer
manager error for QCA6390")'

For WCN6750 and WCN6855, the return buffer manager ID should be
HAL_RX_BUF_RBM_SW1_BM. The incorrect conditional check caused fragmented
packets to be dropped, resulting in the above error log.

Fix this by adding a check for HAL_RX_BUF_RBM_SW1_BM.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00258-QCAMSLSWPL-1
Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-04479-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: 71c748b5e01e ("ath11k: Fix unexpected return buffer manager error for QCA6390")
Signed-off-by: Balaji Pothunoori <quic_bpothuno@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241030114625.2416942-1-quic_bpothuno@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c  | 1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index d01616d06a326..2f6b22708b53f 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3795,6 +3795,7 @@ int ath11k_dp_process_rx_err(struct ath11k_base *ab, struct napi_struct *napi,
 		ath11k_hal_rx_msdu_link_info_get(link_desc_va, &num_msdus, msdu_cookies,
 						 &rbm);
 		if (rbm != HAL_RX_BUF_RBM_WBM_IDLE_DESC_LIST &&
+		    rbm != HAL_RX_BUF_RBM_SW1_BM &&
 		    rbm != HAL_RX_BUF_RBM_SW3_BM) {
 			ab->soc_stats.invalid_rbm++;
 			ath11k_warn(ab, "invalid return buffer manager %d\n", rbm);
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 7f39c6fb7408c..d1785e71ffc98 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.c
@@ -371,7 +371,8 @@ int ath11k_hal_wbm_desc_parse_err(struct ath11k_base *ab, void *desc,
 
 	ret_buf_mgr = FIELD_GET(BUFFER_ADDR_INFO1_RET_BUF_MGR,
 				wbm_desc->buf_addr_info.info1);
-	if (ret_buf_mgr != HAL_RX_BUF_RBM_SW3_BM) {
+	if (ret_buf_mgr != HAL_RX_BUF_RBM_SW1_BM &&
+	    ret_buf_mgr != HAL_RX_BUF_RBM_SW3_BM) {
 		ab->soc_stats.invalid_rbm++;
 		return -EINVAL;
 	}
-- 
2.39.5



