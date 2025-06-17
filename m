Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864962EE601;
	Tue, 17 Jun 2025 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176587; cv=none; b=QY0gYDYkXipsg4IycVvvhgUFkaPdfN7EhvSb96TUzEWMOI3Sw6C/DrJoe1jScjptkMEKXCoNF92QZW9ulXkIw24WVmMjiZ6omkC8V7SIorPfDS2/yWW3w14/2xoK/AcqTcsoZy1XSKnd5J9TjTIH7DDCFpUmQqfJV8ksGw6zZCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176587; c=relaxed/simple;
	bh=vzJIcV5DGquxpW9CEY4jEfSpbu3Fq+EIXmOtFg203Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoA1C+DdvUZYXz0i0dFf3gOJSYFK0jTYoadwaQts6aCRnkn402mbpuIbdNx/AIw6p0gW6WyLbNjtS2zk2+xTQDgEQYyQ1aZosYGQjRBkEYNtTO7+DRKPtQFZkF+xxxTlpUJF91KHYqmbnUr+aCRrS1OzNdJ/DXdfbDki+LmS+MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwaFxGgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwaFxGgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A1CC113CF;
	Tue, 17 Jun 2025 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176587;
	bh=vzJIcV5DGquxpW9CEY4jEfSpbu3Fq+EIXmOtFg203Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwaFxGgOqCMMvnxWB8s99KLL7MuqqXNwR4VTc2xk0S8be5PUD5dcAEOAdVAIT684r
	 R8BkpYN4+oZy0ytaboruUEB35cSxE+VhcX/Bq/MmQC03JHwia3+mWPB7d7D84S18nw
	 nVDHtqYwJXvA22TsZ0N/M2uKaCXCBgUFbDfC6ChE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 204/780] wifi: ath12k: Add MSDU length validation for TKIP MIC error
Date: Tue, 17 Jun 2025 17:18:32 +0200
Message-ID: <20250617152459.767715551@linuxfoundation.org>
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

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 763216fe6c5df95d122c71ef34c342427c987820 ]

In the WBM error path, while processing TKIP MIC errors, MSDU length
is fetched from the hal_rx_desc's msdu_end. This MSDU length is
directly passed to skb_put() without validation. In stress test
scenarios, the WBM error ring may receive invalid descriptors, which
could lead to an invalid MSDU length.

To fix this, add a check to drop the skb when the calculated MSDU
length is greater than the skb size.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250416021903.3178962-1-nithyanantham.paramasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 70afb3bd39202..317cc6e6e1f5b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -3824,6 +3824,15 @@ static bool ath12k_dp_rx_h_tkip_mic_err(struct ath12k *ar, struct sk_buff *msdu,
 
 	l3pad_bytes = ath12k_dp_rx_h_l3pad(ab, desc);
 	msdu_len = ath12k_dp_rx_h_msdu_len(ab, desc);
+
+	if ((hal_rx_desc_sz + l3pad_bytes + msdu_len) > DP_RX_BUFFER_SIZE) {
+		ath12k_dbg(ab, ATH12K_DBG_DATA,
+			   "invalid msdu len in tkip mic err %u\n", msdu_len);
+		ath12k_dbg_dump(ab, ATH12K_DBG_DATA, NULL, "", desc,
+				sizeof(*desc));
+		return true;
+	}
+
 	skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 	skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 
-- 
2.39.5



