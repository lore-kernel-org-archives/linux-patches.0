Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B749633CFD;
	Fri, 24 Nov 2023 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLNZfB/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447FCC433C8;
	Fri, 24 Nov 2023 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851063;
	bh=R6MMomudBxtbcy8Xp5umPO53kODY80Vg8RSHOCqK8s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLNZfB/7uEchJbWVnhdHKYkKgmZedrxU7B4X1t3Nf+yHwYnbTfEi2aOkXdXvKXWtM
	 b0+/asnBD/ZOqH2Db0uVYCdxPVRW/hy+T+EqzRiiuMZOFBpo9c9TwNgpRSiO2/6abG
	 lrZ5dqu5dQP6BEiJGWPGQknIc6DZy05Lqpd5Tz/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.5 274/491] wifi: ath11k: fix dfs radar event locking
Date: Fri, 24 Nov 2023 17:48:30 +0000
Message-ID: <20231124172032.811726593@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 3b6c14833165f689cc5928574ebafe52bbce5f1e upstream.

The ath11k active pdevs are protected by RCU but the DFS radar event
handling code calling ath11k_mac_get_ar_by_pdev_id() was not marked as a
read-side critical section.

Mark the code in question as an RCU read-side critical section to avoid
any potential use-after-free issues.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org      # 5.6
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231019153115.26401-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8337,6 +8337,8 @@ ath11k_wmi_pdev_dfs_radar_detected_event
 		   ev->detector_id, ev->segment_id, ev->timestamp, ev->is_chirp,
 		   ev->freq_offset, ev->sidx);
 
+	rcu_read_lock();
+
 	ar = ath11k_mac_get_ar_by_pdev_id(ab, ev->pdev_id);
 
 	if (!ar) {
@@ -8354,6 +8356,8 @@ ath11k_wmi_pdev_dfs_radar_detected_event
 		ieee80211_radar_detected(ar->hw);
 
 exit:
+	rcu_read_unlock();
+
 	kfree(tb);
 }
 


