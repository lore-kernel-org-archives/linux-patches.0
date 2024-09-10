Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EEC172BAE;
	Tue, 10 Sep 2024 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964167; cv=none; b=CEs358zICzgt8YKKcqMRVyLir0B9+lJS+a1lvbfLTbKiOJXnYWkG0MITf3Nwfdsq5ytAUacmKqWMpRv42MhU78r5uxX7GYy3kuWDjIWKyY+GxpY7/P+bJS/CtkjUUFUD9TWul/ti0rm64LOid4txoH8ms+9u1e8D2Lot84v0zV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964167; c=relaxed/simple;
	bh=fyQhrlXQJ6mbHN7s54IDOWt2TTXTdVlAZZYX9Vv6TUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc4fVAGCmGKrQNamF8k7KQ+DrHS3szyyD6qAmRYpt8g5kGCUVyTOGch7g9nzb0DI8oBF86B7zQRdwpYLBt5QqxZYaxOGg3j4VG5m/MqeQeDuAZxTE/4PPYhqI87pheVIqQyDWkg07b28NGs0I/I8C1bQHHOEjawPKMCbvA910C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nu62Gt55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nu62Gt55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D74C4CEC3;
	Tue, 10 Sep 2024 10:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964167;
	bh=fyQhrlXQJ6mbHN7s54IDOWt2TTXTdVlAZZYX9Vv6TUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu62Gt557FDwwq8X6qh3Uy9xWhS/eyrO5qFMAl+PJMvQcEoyHXDxbrRHagKRmFLYU
	 41Maq6VXOp6+ya7Sgn5UqYi+8JOLP7rDzX4khmnBR1O9kXZjE7+dRrYevUxix4gR5o
	 VyYlxCNhuSVQ9dvuKlo0MGK9LlKT8wsMLt8yshnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <quic_aarasahu@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/269] wifi: ath12k: fix uninitialize symbol error on ath12k_peer_assoc_h_he()
Date: Tue, 10 Sep 2024 11:30:50 +0200
Message-ID: <20240910092610.440527171@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Aaradhana Sahu <quic_aarasahu@quicinc.com>

[ Upstream commit 19b77e7c656a3e125319cc3ef347b397cf042bf6 ]

Smatch throws following errors

drivers/net/wireless/ath/ath12k/mac.c:1922 ath12k_peer_assoc_h_he() error: uninitialized symbol 'rx_mcs_80'.
drivers/net/wireless/ath/ath12k/mac.c:1922 ath12k_peer_assoc_h_he() error: uninitialized symbol 'rx_mcs_160'.
drivers/net/wireless/ath/ath12k/mac.c:1924 ath12k_peer_assoc_h_he() error: uninitialized symbol 'rx_mcs_80'.

In ath12k_peer_assoc_h_he() rx_mcs_80 and rx_mcs_160 variables
remain uninitialized in the following conditions:
1. Whenever the value of mcs_80 become equal to
   IEEE80211_HE_MCS_NOT_SUPPORTED then rx_mcs_80 remains uninitialized.
2. Whenever phy capability is not supported 160 channel width and
   value of mcs_160 become equal to IEEE80211_HE_MCS_NOT_SUPPORTED
   then rx_mcs_160 remains uninitialized.

Initialize these variables during declaration.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00188-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <quic_aarasahu@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240611031017.297927-3-quic_aarasahu@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index ba6fc27f4a1a..618eeaf6e331 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1614,7 +1614,9 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
 {
 	const struct ieee80211_sta_he_cap *he_cap = &sta->deflink.he_cap;
 	int i;
-	u8 ampdu_factor, rx_mcs_80, rx_mcs_160, max_nss;
+	u8 ampdu_factor, max_nss;
+	u8 rx_mcs_80 = IEEE80211_HE_MCS_NOT_SUPPORTED;
+	u8 rx_mcs_160 = IEEE80211_HE_MCS_NOT_SUPPORTED;
 	u16 mcs_160_map, mcs_80_map;
 	bool support_160;
 	u16 v;
-- 
2.43.0



