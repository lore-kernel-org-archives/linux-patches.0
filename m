Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C51C2FC21;
	Fri, 24 Nov 2023 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+m2lxZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A609FC433C8;
	Fri, 24 Nov 2023 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851066;
	bh=JvONdaAAWFfnNG0tuAV+5J9+lq1xjd4C/2cHOKF5r/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+m2lxZCKabQjNrv7FsyVOCfI4eBJt8LSU4vfLUe4F4Om4nZYs60IUMW+4Ru6bCo1
	 8zytEc4ngClOrih4KwNIc6Kz+0fN3A+e+qWln9Hre7v0/Jp0HIxYp42PR03tKFlva+
	 n7OFpli7M1m3wPpZGW6SWvnu0jzQSMjGB6HE/6oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.5 275/491] wifi: ath11k: fix htt pktlog locking
Date: Fri, 24 Nov 2023 17:48:31 +0000
Message-ID: <20231124172032.838662171@linuxfoundation.org>
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

commit 3f77c7d605b29df277d77e9ee75d96e7ad145d2d upstream.

The ath11k active pdevs are protected by RCU but the htt pktlog handling
code calling ath11k_mac_get_ar_by_pdev_id() was not marked as a
read-side critical section.

Mark the code in question as an RCU read-side critical section to avoid
any potential use-after-free issues.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org      # 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231019112521.2071-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1621,14 +1621,20 @@ static void ath11k_htt_pktlog(struct ath
 	u8 pdev_id;
 
 	pdev_id = FIELD_GET(HTT_T2H_PPDU_STATS_INFO_PDEV_ID, data->hdr);
+
+	rcu_read_lock();
+
 	ar = ath11k_mac_get_ar_by_pdev_id(ab, pdev_id);
 	if (!ar) {
 		ath11k_warn(ab, "invalid pdev id %d on htt pktlog\n", pdev_id);
-		return;
+		goto out;
 	}
 
 	trace_ath11k_htt_pktlog(ar, data->payload, hdr->size,
 				ar->ab->pktlog_defs_checksum);
+
+out:
+	rcu_read_unlock();
 }
 
 static void ath11k_htt_backpressure_event_handler(struct ath11k_base *ab,


