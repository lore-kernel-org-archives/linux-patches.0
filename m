Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB4439FD9;
	Fri, 24 Nov 2023 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KaUaD9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EEFC433C8;
	Fri, 24 Nov 2023 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849740;
	bh=czAu3I/GMmX+iAEf+pUbq0HRubM0vLrKG7m4cXsmogQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KaUaD9iYd8OzjjhjShE5y2RzojGhrhnXq6k7wgymLSfcumBymyxZnAAmo+ySa+fa
	 +Mf4saoRH/XTD2blyPrJqbHvHwPCe2w4ILDnYYI5W4DVOGHw8bnSrYsMuoa46jkf3W
	 TOFlmpjvgx6qjOwYPF2u7D7boRrtadi7VT2m33Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.6 294/530] wifi: ath12k: fix htt mlo-offset event locking
Date: Fri, 24 Nov 2023 17:47:40 +0000
Message-ID: <20231124172036.982296511@linuxfoundation.org>
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

commit 6afc57ea315e0f660b1f870a681737bb7b71faef upstream.

The ath12k active pdevs are protected by RCU but the htt mlo-offset
event handling code calling ath12k_mac_get_ar_by_pdev_id() was not
marked as a read-side critical section.

Mark the code in question as an RCU read-side critical section to avoid
any potential use-after-free issues.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org      # v6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231019113650.9060-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1658,11 +1658,12 @@ static void ath12k_htt_mlo_offset_event_
 	msg = (struct ath12k_htt_mlo_offset_msg *)skb->data;
 	pdev_id = u32_get_bits(__le32_to_cpu(msg->info),
 			       HTT_T2H_MLO_OFFSET_INFO_PDEV_ID);
-	ar = ath12k_mac_get_ar_by_pdev_id(ab, pdev_id);
 
+	rcu_read_lock();
+	ar = ath12k_mac_get_ar_by_pdev_id(ab, pdev_id);
 	if (!ar) {
 		ath12k_warn(ab, "invalid pdev id %d on htt mlo offset\n", pdev_id);
-		return;
+		goto exit;
 	}
 
 	spin_lock_bh(&ar->data_lock);
@@ -1678,6 +1679,8 @@ static void ath12k_htt_mlo_offset_event_
 	pdev->timestamp.mlo_comp_timer = __le32_to_cpu(msg->mlo_comp_timer);
 
 	spin_unlock_bh(&ar->data_lock);
+exit:
+	rcu_read_unlock();
 }
 
 void ath12k_dp_htt_htc_t2h_msg_handler(struct ath12k_base *ab,


