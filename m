Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCDA381D6;
	Fri, 24 Nov 2023 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+9ma6YU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8BDC433CA;
	Fri, 24 Nov 2023 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849805;
	bh=LgKG+YRYMrXfL8SdVJvV4woMhvetdpeIEIDSRUFBP3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+9ma6YUjMDz6D6fu69Y6lTNIn28s9QXnchPHQXyLL8bkq7m9JnOCIXpAMnMnl7HB
	 Dw7u+11OB0t/LXKgNBOl2LixEgtTj9Ptnc4cyz0E8vPWJKAuke+yqLFWwUwCJz/qH5
	 c2M/qysc5QfbjOd++EWi2cn53KwwYIQu1CNPmxzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.6 293/530] wifi: ath11k: fix gtk offload status event locking
Date: Fri, 24 Nov 2023 17:47:39 +0000
Message-ID: <20231124172036.955135495@linuxfoundation.org>
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

commit 1dea3c0720a146bd7193969f2847ccfed5be2221 upstream.

The ath11k active pdevs are protected by RCU but the gtk offload status
event handling code calling ath11k_mac_get_arvif_by_vdev_id() was not
marked as a read-side critical section.

Mark the code in question as an RCU read-side critical section to avoid
any potential use-after-free issues.

Compile tested only.

Fixes: a16d9b50cfba ("ath11k: support GTK rekey offload")
Cc: stable@vger.kernel.org      # 5.18
Cc: Carl Huang <quic_cjhuang@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231019155342.31631-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8619,12 +8619,13 @@ static void ath11k_wmi_gtk_offload_statu
 		return;
 	}
 
+	rcu_read_lock();
+
 	arvif = ath11k_mac_get_arvif_by_vdev_id(ab, ev->vdev_id);
 	if (!arvif) {
 		ath11k_warn(ab, "failed to get arvif for vdev_id:%d\n",
 			    ev->vdev_id);
-		kfree(tb);
-		return;
+		goto exit;
 	}
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI, "event gtk offload refresh_cnt %d\n",
@@ -8641,6 +8642,8 @@ static void ath11k_wmi_gtk_offload_statu
 
 	ieee80211_gtk_rekey_notify(arvif->vif, arvif->bssid,
 				   (void *)&replay_ctr_be, GFP_ATOMIC);
+exit:
+	rcu_read_unlock();
 
 	kfree(tb);
 }


