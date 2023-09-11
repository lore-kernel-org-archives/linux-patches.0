Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB31170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC9EC433C8;
	Mon, 11 Sep 2023 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440667;
	bh=Ia9n5HC5jxwgTRbW0C+1fpl5tYFoJmKpkWzvMJm20wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esnzm7rmCWqEmK8dqzzwtiDs4A2eJKQgVtKKMTuTIw/eVUQI3EO7Hp7ftfAmadR2P
	 1E3iHmEA3td5z5W6pOKaSW/Dn+5EVAqAsBllQoTMgM4fqE61/D4SIpe49zInC7n4fl
	 xyYlFUhLQvkM7CIfxO9lPqj/iFIHPzt1zWWl+ZJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 105/739] wifi: ath11k: fix band selection for ppdu received in channel 177 of 5 GHz
Date: Mon, 11 Sep 2023 15:38:24 +0200
Message-ID: <20230911134654.032019422@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 72c8caf904aed2caed5d6e75233294b6159ddb5d ]

5 GHz band channel 177 support was added with the commit e5e94d10c856 ("wifi:
ath11k: add channel 177 into 5 GHz channel list"). However, during processing
for the received ppdu in ath11k_dp_rx_h_ppdu(), channel number is checked only
till 173. This leads to driver code checking for channel and then fetching the
band from it which is extra effort since firmware has already given the channel
number in the metadata.

Fix this issue by checking the channel number till 177 since we support
it now.

Found via code review. Compile tested only.

Fixes: e5e94d10c856 ("wifi: ath11k: add channel 177 into 5 GHz channel list")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230726044624.20507-1-quic_adisi@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 5c76664ba0dd9..1e488eed282b5 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2408,7 +2408,7 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 		rx_status->freq = center_freq;
 	} else if (channel_num >= 1 && channel_num <= 14) {
 		rx_status->band = NL80211_BAND_2GHZ;
-	} else if (channel_num >= 36 && channel_num <= 173) {
+	} else if (channel_num >= 36 && channel_num <= 177) {
 		rx_status->band = NL80211_BAND_5GHZ;
 	} else {
 		spin_lock_bh(&ar->data_lock);
-- 
2.40.1



