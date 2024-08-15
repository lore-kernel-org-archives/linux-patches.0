Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99DC14AD0A;
	Thu, 15 Aug 2024 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732140; cv=none; b=FYkQq9X7ir9j227fyJliovnR3Vx+ikmrPnOQEfZw1/HgyUkKIMt+P3WHmiE/rGh/ec7IwCSa21Joy1U1cqCXHlvYXsWEleKz5xGuxAKu3xCp4LWCJkkUYPIcbYevT7Ntc8/sCgOy81tOPWD+QEGDyc3fN2BFIAttzCKc704aed4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732140; c=relaxed/simple;
	bh=VDeM/3nZedeqBlTvl+sVfgX58auJHkuHCMHyAt1I47k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKV1KGb7aeWuHVgRSZs2M1tCFAiGP4xl5D9Rwamv1uMW0Czgfi4mBjZJSJrYFkWZzQe5zFCqtP99djHDFQa+p4FjeH1k7AxqdNgvI/wdYGJG/maiuar0uD6VZVCsn+zGt2kzKaD8T4Kon93zpWj+eXTEjBnedKOihv7RhtLxXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3iOgAcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3iOgAcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E035EC32786;
	Thu, 15 Aug 2024 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732140;
	bh=VDeM/3nZedeqBlTvl+sVfgX58auJHkuHCMHyAt1I47k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3iOgAcPAyx1epogYcpUt6Cg62esGX30B7fTGTdacHm4tGC7keT9jJJh367ooLi4K
	 QqNxWCkqCvS+K1MFDetH02DWsImmrl4sRtXcnUxyRPxoeZxPY8/xfJXPsd85E+T0kN
	 M6R8Rz7NQMeSgSA+w+yLFI8FLEQe00aWwWflvSRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Huang <cjhuang@codeaurora.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/352] ath11k: dp: stop rx pktlog before suspend
Date: Thu, 15 Aug 2024 15:21:51 +0200
Message-ID: <20240815131920.977598694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 840c36fa727aea13a2401a5d1d33b722b79df5af ]

Stop dp rx pktlog when entering suspend and reap the mon_status buffer to keep
it empty. During resume restart the reap timer.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1607708150-21066-7-git-send-email-kvalo@codeaurora.org
Stable-dep-of: d2b0ca38d362 ("wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.h    |  1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c | 48 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/dp_rx.h |  3 ++
 drivers/net/wireless/ath/ath11k/mac.c   |  4 +++
 4 files changed, 56 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index c4972233149f4..89dc3ab2e2fb5 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -40,6 +40,7 @@ struct dp_rx_tid {
 
 #define DP_REO_DESC_FREE_THRESHOLD  64
 #define DP_REO_DESC_FREE_TIMEOUT_MS 1000
+#define DP_MON_PURGE_TIMEOUT_MS     100
 #define DP_MON_SERVICE_BUDGET       128
 
 struct dp_reo_cache_flush_elem {
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index a50325f4634ba..a83b5edea66b9 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -274,6 +274,28 @@ static void ath11k_dp_service_mon_ring(struct timer_list *t)
 		  msecs_to_jiffies(ATH11K_MON_TIMER_INTERVAL));
 }
 
+static int ath11k_dp_purge_mon_ring(struct ath11k_base *ab)
+{
+	int i, reaped = 0;
+	unsigned long timeout = jiffies + msecs_to_jiffies(DP_MON_PURGE_TIMEOUT_MS);
+
+	do {
+		for (i = 0; i < ab->hw_params.num_rxmda_per_pdev; i++)
+			reaped += ath11k_dp_rx_process_mon_rings(ab, i,
+								 NULL,
+								 DP_MON_SERVICE_BUDGET);
+
+		/* nothing more to reap */
+		if (reaped < DP_MON_SERVICE_BUDGET)
+			return 0;
+
+	} while (time_before(jiffies, timeout));
+
+	ath11k_warn(ab, "dp mon ring purge timeout");
+
+	return -ETIMEDOUT;
+}
+
 /* Returns number of Rx buffers replenished */
 int ath11k_dp_rxbufs_replenish(struct ath11k_base *ab, int mac_id,
 			       struct dp_rxdma_ring *rx_ring,
@@ -5065,3 +5087,29 @@ int ath11k_dp_rx_pdev_mon_detach(struct ath11k *ar)
 	ath11k_dp_mon_link_free(ar);
 	return 0;
 }
+
+int ath11k_dp_rx_pktlog_start(struct ath11k_base *ab)
+{
+	/* start reap timer */
+	mod_timer(&ab->mon_reap_timer,
+		  jiffies + msecs_to_jiffies(ATH11K_MON_TIMER_INTERVAL));
+
+	return 0;
+}
+
+int ath11k_dp_rx_pktlog_stop(struct ath11k_base *ab, bool stop_timer)
+{
+	int ret;
+
+	if (stop_timer)
+		del_timer_sync(&ab->mon_reap_timer);
+
+	/* reap all the monitor related rings */
+	ret = ath11k_dp_purge_mon_ring(ab);
+	if (ret) {
+		ath11k_warn(ab, "failed to purge dp mon ring: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.h b/drivers/net/wireless/ath/ath11k/dp_rx.h
index 6986752fc4b68..623da3bf9dc81 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.h
@@ -92,4 +92,7 @@ int ath11k_dp_rx_pdev_mon_detach(struct ath11k *ar);
 int ath11k_dp_rx_pdev_mon_attach(struct ath11k *ar);
 int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id);
 
+int ath11k_dp_rx_pktlog_start(struct ath11k_base *ab);
+int ath11k_dp_rx_pktlog_stop(struct ath11k_base *ab, bool stop_timer);
+
 #endif /* ATH11K_DP_RX_H */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3170c54c97b74..835e181d22cb7 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4149,6 +4149,10 @@ static int ath11k_mac_config_mon_status_default(struct ath11k *ar, bool enable)
 						       &tlv_filter);
 	}
 
+	if (enable && !ar->ab->hw_params.rxdma1_enable)
+		mod_timer(&ar->ab->mon_reap_timer, jiffies +
+			  msecs_to_jiffies(ATH11K_MON_TIMER_INTERVAL));
+
 	return ret;
 }
 
-- 
2.43.0



