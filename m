Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3201839FE9;
	Fri, 24 Nov 2023 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7XC1yix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8AEC433C8;
	Fri, 24 Nov 2023 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849768;
	bh=zSrihRBN4/iEaZA8/BFoFbLTchCS9AgkEfwZlPQM0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7XC1yix/57gnYqotTYQD4Nsusk1eMXuKxhAvJq1A7B8LG3tO+upbcZvsRklEE1Kq
	 KirO2snXjkLWQcYhTypec3fJdGxwSau3ouzUlfr3O4xuA+U+6nO/iT8/CxcdHV7Eu0
	 HnTYSFToZt7ncF/5syDHtIWHdFhDVNh38qpy30EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.6 295/530] wifi: ath12k: fix dfs-radar and temperature event locking
Date: Fri, 24 Nov 2023 17:47:41 +0000
Message-ID: <20231124172037.016748701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 69bd216e049349886405b1c87a55dce3d35d1ba7 upstream.

The ath12k active pdevs are protected by RCU but the DFS-radar and
temperature event handling code calling ath12k_mac_get_ar_by_pdev_id()
was not marked as a read-side critical section.

Mark the code in question as RCU read-side critical sections to avoid
any potential use-after-free issues.

Note that the temperature event handler looks like a place holder
currently but would still trigger an RCU lockdep splat.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org	# v6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231019113650.9060-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6482,6 +6482,8 @@ ath12k_wmi_pdev_dfs_radar_detected_event
 		   ev->detector_id, ev->segment_id, ev->timestamp, ev->is_chirp,
 		   ev->freq_offset, ev->sidx);
 
+	rcu_read_lock();
+
 	ar = ath12k_mac_get_ar_by_pdev_id(ab, le32_to_cpu(ev->pdev_id));
 
 	if (!ar) {
@@ -6499,6 +6501,8 @@ ath12k_wmi_pdev_dfs_radar_detected_event
 		ieee80211_radar_detected(ar->hw);
 
 exit:
+	rcu_read_unlock();
+
 	kfree(tb);
 }
 
@@ -6517,11 +6521,16 @@ ath12k_wmi_pdev_temperature_event(struct
 	ath12k_dbg(ab, ATH12K_DBG_WMI,
 		   "pdev temperature ev temp %d pdev_id %d\n", ev.temp, ev.pdev_id);
 
+	rcu_read_lock();
+
 	ar = ath12k_mac_get_ar_by_pdev_id(ab, le32_to_cpu(ev.pdev_id));
 	if (!ar) {
 		ath12k_warn(ab, "invalid pdev id in pdev temperature ev %d", ev.pdev_id);
-		return;
+		goto exit;
 	}
+
+exit:
+	rcu_read_unlock();
 }
 
 static void ath12k_fils_discovery_event(struct ath12k_base *ab,


