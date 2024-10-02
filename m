Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3EC1CFEDA;
	Wed,  2 Oct 2024 13:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875194; cv=none; b=HShn+PyiWVNOUYNB/8mGtNlmYDTGMXM0Yjf1WKvTL3bOsjjNX2XH885D3S/aHOZH3BWTl+63L/qZ1x6ImEKxRcy87/Ood6661DubB8cAckTS0YZ9p48X2mCVUpn95fEE5QaWu+RkND/Ci/sKoABWy+3V+hDS3odqKd0NuS/yTcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875194; c=relaxed/simple;
	bh=/RsZufGKoepoaheSv8E5lvetTGKD1gDj1V9EkxFJs7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g052yl8d9KzYcQLed9FVivrbmZJnQE2FSey/zPvtzad8KFZ7Nrx3IiJnSxwpdPTk7i5BXa/cxowBhVUv/g7zkiJC4qEBcjQ3YHKfr44sXScA8pjFxtX1x8zBDikZNEfqaIt0iRx0FQmZoJtVdNYG1LBwR13fTCn+T4Bb/avO2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBJK4D8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBJK4D8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8783CC4CEC5;
	Wed,  2 Oct 2024 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875193;
	bh=/RsZufGKoepoaheSv8E5lvetTGKD1gDj1V9EkxFJs7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBJK4D8T48klyQjeud5AFiHRq3JCQKaQ80YjnWpBsAUilLhkNz6KMJFrzbbCQYeFl
	 DfUVAgsmdF3s6Q0Nr0NbRknN7dj7vwjKCJeNWu4Yr8SX5f0q/RHD6FYoZmbNfNbVIA
	 SfwQRjrIzSh2x0DHqiL0wI3adwmYhBkpovPxnbJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/695] wifi: ath12k: fix invalid AMPDU factor calculation in ath12k_peer_assoc_h_he()
Date: Wed,  2 Oct 2024 14:50:13 +0200
Message-ID: <20241002125823.099716029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit a66de2d0f22b1740f3f9777776ad98c4bee62dff ]

Currently ampdu_factor is wrongly calculated in ath12k_peer_assoc_h_he(), fix it.

This is found during code review.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240710021819.87216-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index ce41c8153080c..a3248d9775329 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -2196,9 +2196,8 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
 	 * request, then use MAX_AMPDU_LEN_FACTOR as 16 to calculate max_ampdu
 	 * length.
 	 */
-	ampdu_factor = (he_cap->he_cap_elem.mac_cap_info[3] &
-			IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK) >>
-			IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK;
+	ampdu_factor = u8_get_bits(he_cap->he_cap_elem.mac_cap_info[3],
+				   IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK);
 
 	if (ampdu_factor) {
 		if (sta->deflink.vht_cap.vht_supported)
-- 
2.43.0



