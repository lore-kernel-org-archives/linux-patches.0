Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A8D13AD22;
	Wed,  5 Feb 2025 13:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763351; cv=none; b=JOe9kPbOdT1Q9mwaLOZhO/inMMvvBH4i1HIdacVL1qUoGTzpKZNlEEoQk5RL3cCmhvojltDiYocZ94wC/GhA793aAGiSmelUC2GCPnw+BlXGfObwfntPHEr2ztsVjTjtUKC9E69plDuVGBGJQ/CnAz8ReDWQhWulKg6nk34shLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763351; c=relaxed/simple;
	bh=tolORI/kbCuDMsJ3WvQ7q9Pk4mBy7t5Z1wgqR14uGWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFJqzSyuk3oxtGi/NTVrYhMhdB25Gm2XKo53YdDCM+j+Pkc+VUhkcXJc6GlbY9B81Gu4hgirkDsWYijastJ7Sg/0Sou/GfJF9RGXNkTjhAHgc4DNlNOWhh65ZdEMtckJ0WNnE+Kgc+oWyu/rMKZUf/3bTtXbUxhHdFaI2qswaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9Nxbd3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9Nxbd3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FF6C4CED1;
	Wed,  5 Feb 2025 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763351;
	bh=tolORI/kbCuDMsJ3WvQ7q9Pk4mBy7t5Z1wgqR14uGWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9Nxbd3upailkWXTDuDjN0HcdUQEcY2EG2D2saQL7Azyz9ZhEFF0LVrP7wdGkT2OL
	 7hxhsWbgT6jFHHPDjx4OICkJY1g7wMKf0HONDnM8uSdm0RPfO0W08UDF6oO+AVh9MM
	 XCD0Os1CzMg+aNh9f6tQTTlvdAKuKfZxr2MNyO14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balaji Pothunoori <quic_bpothuno@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/393] wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/WCN6855
Date: Wed,  5 Feb 2025 14:39:27 +0100
Message-ID: <20250205134422.139918408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index fb426195a3f01..4c70366ac56eb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3811,6 +3811,7 @@ int ath11k_dp_process_rx_err(struct ath11k_base *ab, struct napi_struct *napi,
 		ath11k_hal_rx_msdu_link_info_get(link_desc_va, &num_msdus, msdu_cookies,
 						 &rbm);
 		if (rbm != HAL_RX_BUF_RBM_WBM_IDLE_DESC_LIST &&
+		    rbm != HAL_RX_BUF_RBM_SW1_BM &&
 		    rbm != HAL_RX_BUF_RBM_SW3_BM) {
 			ab->soc_stats.invalid_rbm++;
 			ath11k_warn(ab, "invalid return buffer manager %d\n", rbm);
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 363adac84a870..2bc95026335e3 100644
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



