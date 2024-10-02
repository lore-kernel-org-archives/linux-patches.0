Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB451D2B0B;
	Wed,  2 Oct 2024 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879121; cv=none; b=Py4Ubiws6VCeKEcqY0GkEayiAdmLz3VGPwLunaQRJtAvzlxDGJCG1P1SlMjISLQ8iid4MySes/cfVAYF4c1KH4dJfaG5YeKIs8R7V8gF4YYaml8e3gcqGzE8mlQACQ4lSDVPt4hjLINI2/ar9s+oABOLwiTozCP+Jjpojo3C3jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879121; c=relaxed/simple;
	bh=gZSWprUfR2HbZ35q9e03ImoZ8YavhcFRNoAZp59uHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+FTI7kOAy21ZWiVxpY3EZZuznvvMhiR8jg0iOdM3MIUNmBRzg/aRYPWvwk9DM6GL+NfGMUYCUTyfff01SYI3qkpzkPyi/afrtNKwgG2C8mOvFYkLOKyqT3FV+dMy2IXK2mXd4Z07h2A5LrH3yOBms/Pwy9SpMgdbUkZALz840Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMwe8EMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMwe8EMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F3C4CEC2;
	Wed,  2 Oct 2024 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879121;
	bh=gZSWprUfR2HbZ35q9e03ImoZ8YavhcFRNoAZp59uHZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMwe8EMYt/87OyBj9gDLRhCrDE+7DVz5o+O/LyxooCPpPNBPfVRzuaeTCuZiXN4or
	 +KPh6QXZb/z/53HpXSFKyWYdSfpeb6HfApZlYo0NwD0YQYCU/mouKB8n7FeR4OlRnV
	 iwIrkhDVcdoI5KqudOgMb7qJ9Xslz7AvxNer5yO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/538] wifi: ath12k: fix invalid AMPDU factor calculation in ath12k_peer_assoc_h_he()
Date: Wed,  2 Oct 2024 14:54:10 +0200
Message-ID: <20241002125752.439977711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index dd2a7c95517be..4bb30e4037287 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1681,9 +1681,8 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
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



