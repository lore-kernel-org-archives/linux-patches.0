Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E461514EE;
	Wed,  5 Feb 2025 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763945; cv=none; b=TVQoehCbRwjA22uoEL9uge4AudCE7Tl5Sfm2GEx+V/b2j1Ue7i5qV0tJoLfwqKLxtg0Yi+I7bEu8wm8hE7EcgdCVoSHQByGVI08Ur9wY9MrfRPTgK8BGg9xsJbY/D/hl8gf5H4HedXMEIC8WaEpLz9Cp/ABTD2+F5kW4nCq/QRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763945; c=relaxed/simple;
	bh=pnl2BotOIfYAkUQxG7pMHx3eAS3+iqs/ZUI37zTy8zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odRVHljfWYxot/MZe+6dVrnST0nATVADQcX0RGQ3JL2dSK5G6swGthyUQZ8mJxD8549Kxn5rFY1AHH4Q/J0NINAZUqSIi2mjbdtaWpQQ1EpTvN3YFPVsLBpNj3p8Qa5XkUeLWdI0Zr8lQxgXXAr1pRNT8B36rDtHzrA4SS6qS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7Sol9r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7Sol9r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F44EC4CED1;
	Wed,  5 Feb 2025 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763945;
	bh=pnl2BotOIfYAkUQxG7pMHx3eAS3+iqs/ZUI37zTy8zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7Sol9r1gF+Y1FSOqjzfKyPX2asSwu7KKFlqBzVU9yAHNhf9ZasTCUQA595PVXq4m
	 hUzISjUFBMFssHbVKKcU3EF6OSu8HXXSf40I8q3VkrchFr742Y8OCecq5chMdC/bam
	 saTkmA4i5CGmABy7JPFT6nyNgyF1bMw2Ga3AhGnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/590] wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/WCN6855
Date: Wed,  5 Feb 2025 14:37:10 +0100
Message-ID: <20250205134458.124573939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 40088e62572e1..40b52d12b4323 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3872,6 +3872,7 @@ int ath11k_dp_process_rx_err(struct ath11k_base *ab, struct napi_struct *napi,
 		ath11k_hal_rx_msdu_link_info_get(link_desc_va, &num_msdus, msdu_cookies,
 						 &rbm);
 		if (rbm != HAL_RX_BUF_RBM_WBM_IDLE_DESC_LIST &&
+		    rbm != HAL_RX_BUF_RBM_SW1_BM &&
 		    rbm != HAL_RX_BUF_RBM_SW3_BM) {
 			ab->soc_stats.invalid_rbm++;
 			ath11k_warn(ab, "invalid return buffer manager %d\n", rbm);
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 8f7dd43dc1bd8..753bd93f02123 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.c
@@ -372,7 +372,8 @@ int ath11k_hal_wbm_desc_parse_err(struct ath11k_base *ab, void *desc,
 
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



