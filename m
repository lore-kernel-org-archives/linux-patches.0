Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808FD2EA172;
	Wed, 28 Jan 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615468; cv=none; b=gkG9osjtL0HaC1a7zaANHpDMOLfrP968MGOspc5iZ0cwQp+nkBbnWbnXB+um9ZNGtjn59SSTg//nMTqxWxBedKJ18DJG1BrmZnFfLO4vNmtEyCOtO8e7ryhdy+1ZqcX9UJ4EYXb4MA9KYo3LfSFn9jXzDA6CSoZSSOvw2xYfSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615468; c=relaxed/simple;
	bh=3OC3THbesKVUpQ7sug9N8aT/6V+T/w+9CE6NWsbLKR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp5i8mETr37+TbFJeYQOHhyfN6sbFFLWIvuoUL9fGq8XH6HsWIsJwDtzh9V+sQW1nb//YdvhBqvfPUNWRMyN7yFHw7apfhmtcLnCpZ6jtnmK79OdSZU4rGayyTVZ9yOVfcbUCoc4ZlknrxMFBaKfzeEvamC0UrilAqhFaeD/xjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELPf0fU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELPf0fU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABEFC4CEF1;
	Wed, 28 Jan 2026 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615468;
	bh=3OC3THbesKVUpQ7sug9N8aT/6V+T/w+9CE6NWsbLKR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELPf0fU5w2x7Ou/uypGV1V6JhHYYfuLdh7pVy3ZZCNKuW8gPMNgtCAGH88/ZyIwc6
	 6yESuXB5fTG/I8wbIwyghzsLf1zwyyPeI5gyk7peRoKkW8lpiOHu8QpMrqJZznLLlx
	 XLl89vI1UnwCXHywN8RXkB6NKGqq//15L1Zj1xWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/227] wifi: ath12k: fix dead lock while flushing management frames
Date: Wed, 28 Jan 2026 16:21:04 +0100
Message-ID: <20260128145345.034993666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit f88e9fc30a261d63946ddc6cc6a33405e6aa27c3 ]

Commit [1] converted the management transmission work item into a
wiphy work. Since a wiphy work can only run under wiphy lock
protection, a race condition happens in below scenario:

1. a management frame is queued for transmission.
2. ath12k_mac_op_flush() gets called to flush pending frames associated
   with the hardware (i.e, vif being NULL). Then in ath12k_mac_flush()
   the process waits for the transmission done.
3. Since wiphy lock has been taken by the flush process, the transmission
   work item has no chance to run, hence the dead lock.

>From user view, this dead lock results in below issue:

 wlp8s0: authenticate with xxxxxx (local address=xxxxxx)
 wlp8s0: send auth to xxxxxx (try 1/3)
 wlp8s0: authenticate with xxxxxx (local address=xxxxxx)
 wlp8s0: send auth to xxxxxx (try 1/3)
 wlp8s0: authenticated
 wlp8s0: associate with xxxxxx (try 1/3)
 wlp8s0: aborting association with xxxxxx by local choice (Reason: 3=DEAUTH_LEAVING)
 ath12k_pci 0000:08:00.0: failed to flush mgmt transmit queue, mgmt pkts pending 1

The dead lock can be avoided by invoking wiphy_work_flush() to proactively
run the queued work item. Note actually it is already present in
ath12k_mac_op_flush(), however it does not protect the case where vif
being NULL. Hence move it ahead to cover this case as well.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 56dcbf0b5207 ("wifi: ath12k: convert struct ath12k::wmi_mgmt_tx_work to struct wiphy_work") # [1]
Reported-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220959
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260113-ath12k-fix-dead-lock-while-flushing-v1-1-9713621f3a0f@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 00b3bf4d882a5..d6a44c19e2245 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11798,6 +11798,9 @@ static void ath12k_mac_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *v
 	if (drop)
 		return;
 
+	for_each_ar(ah, ar, i)
+		wiphy_work_flush(hw->wiphy, &ar->wmi_mgmt_tx_work);
+
 	/* vif can be NULL when flush() is considered for hw */
 	if (!vif) {
 		for_each_ar(ah, ar, i)
@@ -11805,9 +11808,6 @@ static void ath12k_mac_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *v
 		return;
 	}
 
-	for_each_ar(ah, ar, i)
-		wiphy_work_flush(hw->wiphy, &ar->wmi_mgmt_tx_work);
-
 	ahvif = ath12k_vif_to_ahvif(vif);
 	links = ahvif->links_map;
 	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
-- 
2.51.0



