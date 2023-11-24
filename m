Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205F22F1D;
	Fri, 24 Nov 2023 18:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSvL2piy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C71C433C9;
	Fri, 24 Nov 2023 18:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851070;
	bh=6KHr9VOUGSmNqI/wTpMAo5XbIJbDJoLoskOEg0QVKfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSvL2piyjuTpWS3NZqa7JATpozxwQofqojvEgQ6DVorT2s2k5VVzXnB5MMfDaljGf
	 3Gvs+Dvm+nKBjcpvB33YgBIJvdrfWPEfrms4Km/rGTZ4GtBzs99i2u3LRvmtzTBrLH
	 Bw67IlQRcvVnWOTIJh/xDRaEzYEiaTAIt+EwJTGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.5 277/491] wifi: ath12k: fix htt mlo-offset event locking
Date: Fri, 24 Nov 2023 17:48:33 +0000
Message-ID: <20231124172032.897163560@linuxfoundation.org>
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


