Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC1E2AF00;
	Fri, 24 Nov 2023 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROxsgAea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF1EC433C7;
	Fri, 24 Nov 2023 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849718;
	bh=+C84UVG35b6qOt0nqrIm4evLPtlpKT7kaHZ8x/Haqv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROxsgAeaalBM/zdio54TqWM/BMm13NVbcwBNnC7Aqk4H2O7fgmLTbNXa6ICBt0tx/
	 HMrOlVu799tiYp9TOrf1EBwqhLV1M6Z2VvqLjs50ftKd3xML26ZkhgMjuEIYMJoi9v
	 0yy0pywXMktwyYN/pIellyJjIHJ8ktDfFsVFv+KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.6 292/530] wifi: ath11k: fix htt pktlog locking
Date: Fri, 24 Nov 2023 17:47:38 +0000
Message-ID: <20231124172036.924933929@linuxfoundation.org>
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


