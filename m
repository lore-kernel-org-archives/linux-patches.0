Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039451;
	b=qn9Qj1yIsSkk9bMdfK0S6xN2raR6Um1XR8UG/iH2EIoHM5wP7TNGDh7a6n81dXRe52wo
	 jQsMed67HtWzbwD48esp1Wj8xJKpQhmHAlE1qbz12zh6l3x10UCrSYQjbuaZELe7WHbFS
	 UkK75ViHWrZZJQS+JZ6DMKOUwwx7R7e8wRV3EiMJpf6ibbQSZzLaP62qih25ecDv5PNEC
	 pWAF7vOvMbZnpkgY4fbryrf8YrR4eEJEC1jq8JcFghLANJhhzM7OV6Iqmmso6c1IH0k6B
	 /8JNXSGguTX0ifK0kGVc8MyzjeK5XU1yiva0XTWp7JlkiEU2AhwdUGf2IZKtocTsWmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BzLZDPH7mJf1dLncaLOs1bNCFJYev0cUhVMK1/1tn0=;
	b=ZJFokaa5KEcOKo3WlNBEL30ICWpjSfWLtQN5232V2xllWMy9XF2ScVo3LG07Z+z2Mglr
	 bji+5EoLszn6Mm0arQNCbTHSmOM7lPPw9QG21kXFptZXhv1kjmdBSoHlMmhUIZHFIgB1I
	 MtfUyWexQE3WTEMeTwhcGx21yGMGg2Qi6SKlEbiS6LwnLYhUEVtak82VY9oTK/D98h5Nf
	 Z6PM7gNB2qvWA/ayLp7NKqt4FpF5czntGfQaqLcRYnSb8aPuVQwc0RGcYlYbRGPYw9GSZ
	 NrS+aw6D/836j7oLATnAg/AbmAgolr+fJzu/IUXsKuNds3iDRU4M1VrZsycxD5qO0Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqWGu333;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5F460A2602;
	Wed, 18 Nov 2026 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqWGu333
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A981F000C5;
	Wed, 18 Nov 2026 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039451;
	bh=0BzLZDPH7mJf1dLncaLOs1bNCFJYev0cUhVMK1/1tn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqWGu333oCRrg20b/AXCD1/qbpjNLTNHPjDOihGxnoJvssTdmA0YVg5Jsz68vT08m
	 grXQxceoygNehMh8WKIijNn6LkBIgsTXqMMmpT14wtirGEdzvQEx2tLUz+/sabM7zz
	 NkBjAR3fg+P40vsBWf2/u+riDoYSLcpyikBykNdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2106/3318] wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150425.259324174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit c7555d47b1d051e0406474349deccf74b491ae01 ]

In this function, we iterate over dp->reo_cmd_cache_flush_list using
list_for_each_entry_safe(), under dp->reo_cmd_lock for concurrent access,
and for each expired entries we :
  - drop the lock
  - call ath11k_dp_reo_cache_flush()
  - kfree() the entry
  - retake the lock to keep on iterating

list_for_each_entry_safe() protects us from deleting the entry during
iteration but doesn't protect for concurrent access. So another thread can
take the lock and modify the list in between and crash like below.

To fix the issue, move all entries that needs to be freed to a local list
while under the lock and then iterate over the list to free the entries
without holding the lock.

	BUG: Unable to handle kernel paging request at virtual address 00000010ddbeef8c
	Call trace:
	ath11k_dp_rx_tid_del_func+0x164/0x3c8
	ath11k_dp_process_reo_status+0x1d4/0x2fc
	ath11k_dp_service_srng+0x334/0x338
	ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
	__napi_poll+0x34/0x184
	napi_threaded_poll+0xb4/0x1d8
	kthread+0xdc/0xe0
	ret_from_fork+0x10/0x20

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index b3059e2084469..ce31830bac079 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -762,6 +762,9 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	struct ath11k_base *ab = dp->ab;
 	struct dp_rx_tid *rx_tid = ctx;
 	struct dp_reo_cache_flush_elem *elem, *tmp;
+	struct list_head flush_list;
+
+	INIT_LIST_HEAD(&flush_list);
 
 	if (status == HAL_REO_CMD_DRAIN) {
 		goto free_desc;
@@ -783,23 +786,25 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	list_add_tail(&elem->list, &dp->reo_cmd_cache_flush_list);
 	dp->reo_cmd_cache_flush_count++;
 
-	/* Flush and invalidate aged REO desc from HW cache */
+	/* identify aged REO desc that needs removal */
 	list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list,
 				 list) {
 		if (dp->reo_cmd_cache_flush_count > DP_REO_DESC_FREE_THRESHOLD ||
 		    time_after(jiffies, elem->ts +
 			       msecs_to_jiffies(DP_REO_DESC_FREE_TIMEOUT_MS))) {
-			list_del(&elem->list);
+			list_move_tail(&elem->list, &flush_list);
 			dp->reo_cmd_cache_flush_count--;
-			spin_unlock_bh(&dp->reo_cmd_lock);
-
-			ath11k_dp_reo_cache_flush(ab, &elem->data);
-			kfree(elem);
-			spin_lock_bh(&dp->reo_cmd_lock);
 		}
 	}
 	spin_unlock_bh(&dp->reo_cmd_lock);
 
+	/* remove aged REO desc from HW */
+	list_for_each_entry_safe(elem, tmp, &flush_list, list) {
+		ath11k_dp_reo_cache_flush(ab, &elem->data);
+		list_del(&elem->list);
+		kfree(elem);
+	}
+
 	return;
 free_desc:
 	dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,
-- 
2.53.0



