Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E033CB2EA;
	Tue, 13 Oct 2026 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893694; cv=none; b=aG1g4u6EHazsGOg2neHxsyfbdKU6RZ2PJ99d3bDOzMn/Dh6JSXktyGZp2miVp4gREku5Iry4MCNVdNLkyGfTIZwZaEIaSs+ai6NWQyzeYOBHF7Pv5mRO68FjTQ94ZrC42Ko5fgrIWqtbenixMI/m9BRGTkAYUKnnidLAqe1AA0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893694; c=relaxed/simple;
	bh=1zHtmmYmsr5U1z7RRFIPz4Vb9mYPLEpIDYC8z4vUHig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGBvEHj1pL6WbJSMG7Hh0GQsiEiw1qOwHrOZQCvIaaHwjgVXYZQvC5ykanlnpToOJkXTnCivdtqFmNevsFWbGaGemDxZEq9CkawVWSYbplla7CmzhK+NFSr13FYSn+zFYwtpBdspos988WL47nMy4ia5WsGtpwLPTUClEBL7iGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Clg/sY3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Clg/sY3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62C1F000FF;
	Tue, 13 Oct 2026 12:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893693;
	bh=auvkuMMA9MrMWyG5Qsyrwfh67wz+ZqPvCoS2TRBXW4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Clg/sY3VyVEgOONzFmM79sacTa4FPCx3kbx3qUTEYYKtRkmQtekHAWoa3mXoBOLRJ
	 KIEzjrlAAtJERXLZCBjaCLRK7oFo3jDEV+ou7lZm0CuR1PlT7IkychADo95q1cVlj4
	 zbIgs7YJGOckRRnLgZzbwHRtLGqyIhGt+7yJWH4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/621] wifi: ath12k: fix memory leak in ath12k_wifi7_dp_rx_h_verify_tkip_mic()
Date: Tue, 13 Oct 2026 13:35:07 +0200
Message-ID: <20261013112928.258885629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 98d4f92ab6a1af2ea2ab590d7e2801b203110981 ]

In ath12k_wifi7_dp_rx_h_verify_tkip_mic(), the call to
ath12k_dp_rx_check_nwifi_hdr_len_valid() may return false when the
NWIFI header length is invalid, causing the function to abort early with
-EINVAL.

When this happens, the error propagates to
ath12k_wifi7_dp_rx_h_defrag(), which clears first_frag by setting it
to NULL. As a result, the corresponding MSDU is no longer referenced
by the defragmentation path and is never freed.

This leads to a memory leak for the affected MSDU on this error path.
Proper cleanup is required to ensure the MSDU is released when header
validation fails during TKIP MIC verification.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 9a0dddfb30f1 ("wifi: ath12k: Fix invalid data access in ath12k_dp_rx_h_undecap_nwifi")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260512021108.2031651-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 99d29eda26cf1..79ec83256e385 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -3238,8 +3238,10 @@ static int ath12k_dp_rx_h_verify_tkip_mic(struct ath12k *ar, struct ath12k_peer
 		    RX_FLAG_IV_STRIPPED | RX_FLAG_DECRYPTED;
 	skb_pull(msdu, hal_rx_desc_sz);
 
-	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu)))
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu))) {
+		dev_kfree_skb_any(msdu);
 		return -EINVAL;
+	}
 
 	ath12k_dp_rx_h_ppdu(ar, &rx_info);
 	ath12k_dp_rx_h_undecap(ar, msdu, rx_desc,
-- 
2.53.0



