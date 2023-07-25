Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBA14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6397C433C8;
	Tue, 25 Jul 2023 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282421;
	bh=ScanU+BhgmWJdTldgcCupwA3PbZWDh9RwbCKDblNdPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp7mL+5GTbAV1xVJ77YBW1bTYNk2f8FmSSl/OXeEgTgQzXEkh2K7abhE8em0zCn8y
	 wcR3PCWX5Lm5mYSY8ibexEl+3lyGquktXKMFcyo1hUSWsXdxJKJrgEAbwggoOFlV/B
	 NY+CR0uI7GObzHag73XIDE93D3G6IJza0hvutHIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 123/227] wifi: ath11k: fix memory leak in WMI firmware stats
Date: Tue, 25 Jul 2023 12:44:50 +0200
Message-ID: <20230725104519.912921428@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 6aafa1c2d3e3fea2ebe84c018003f2a91722e607 ]

Memory allocated for firmware pdev, vdev and beacon statistics
are not released during rmmod.

Fix it by calling ath11k_fw_stats_free() function before hardware
unregister.

While at it, avoid calling ath11k_fw_stats_free() while processing
the firmware stats received in the WMI event because the local list
is getting spliced and reinitialised and hence there are no elements
in the list after splicing.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230606091128.14202-1-quic_adisi@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 drivers/net/wireless/ath/ath11k/wmi.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 05920ad413c55..01ff197b017f7 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9468,6 +9468,7 @@ void ath11k_mac_destroy(struct ath11k_base *ab)
 		if (!ar)
 			continue;
 
+		ath11k_fw_stats_free(&ar->fw_stats);
 		ieee80211_free_hw(ar->hw);
 		pdev->ar = NULL;
 	}
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index d0b59bc2905a9..42d9b29623a47 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8103,6 +8103,11 @@ static void ath11k_update_stats_event(struct ath11k_base *ab, struct sk_buff *sk
 	rcu_read_unlock();
 	spin_unlock_bh(&ar->data_lock);
 
+	/* Since the stats's pdev, vdev and beacon list are spliced and reinitialised
+	 * at this point, no need to free the individual list.
+	 */
+	return;
+
 free:
 	ath11k_fw_stats_free(&stats);
 }
-- 
2.39.2



