Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054924;
	b=1F2X7rfwSgE2nMugJi3NkngzorVivRily4U5Riyv78pA36kRfL+m7bT+CN1G7ao1vFL+
	 OmwJzdWloyUB73nEoivbwQmXt/h5Jn4HWzEsmn7uv0T12V1f7nOYdlCrdG7K5xzGZIBEM
	 I1dWSNnJ+ZtzKCLP7siL9zDsJ25nsODqTPbjKRRfeGUwMxVAu0RdryrweEn5FaBB1j42R
	 2a7Aoir0Q7t2R9XRrupLaoVEOnSYyl3Y/fFFe2NYpkI6jOgK3q7l9YzlzethhIl+60qhR
	 a1qsxy2ZBTu/yn5I14MLKfRv3zZRTGL276AUtJhL51l3kjFKfDcsi+XPh8XjTkIycPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oolTqO3mg7pSp14u9YTKEf73Pnq9ajJQdpNsjMjN8/M=;
	b=CIkR0p5ye4wqW+aEDxZaxIx3IPvac/er8+rVI4Ro3Jo/O5YTHH6ujEYh9+BAVfhMaDKh
	 onbYBFSi95GadaG599/L6QlxGNlnW0KywVL9s2vZIy4l8uUUpdAMaVyp+nrP6bzPrdIqp
	 420ZIw2RyP6vh3U/lco5w8TPzgYuujhbOwYNDxpNComQpu4awWG0/qfeJAtIxbk/VrJ9c
	 alRegbbbo3aucwMOSOfXEUh67GDYFBS+yU/agj4VG1OuDs0hbhdsEhgiKNnmrHVOcycZ6
	 FOd+V3w2ouRzNm2QFKAknMim+XOWPXOA+kqzhsRobxOA1dXIpANaznXyKlsj0TNTH2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1jLchme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED3C606A32A;
	Thu, 19 Nov 2026 02:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1jLchme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851071F000C4;
	Thu, 19 Nov 2026 02:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054924;
	bh=oolTqO3mg7pSp14u9YTKEf73Pnq9ajJQdpNsjMjN8/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1jLchmeMhHAmMSuGpQ+E1nE/Sy2NdnlZBods9cs3M0DhGIh2yBCthRFUqS9GyLRZ
	 0vHAgmnDU4dakmyxapg120IaFE4CwWYN+k6SdobhmF6fQN4kbAW1ldqNiHuRGipLyx
	 tS4bWO1AcMPg71zohZYDGKXsLukff0j/Nqp8I+lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1421/2214] wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150108.058287111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 193d63559b057..b37144193b441 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -737,6 +737,9 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	struct ath11k_base *ab = dp->ab;
 	struct dp_rx_tid *rx_tid = ctx;
 	struct dp_reo_cache_flush_elem *elem, *tmp;
+	struct list_head flush_list;
+
+	INIT_LIST_HEAD(&flush_list);
 
 	if (status == HAL_REO_CMD_DRAIN) {
 		goto free_desc;
@@ -758,23 +761,25 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
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
 	dma_unmap_single(ab->dev, rx_tid->paddr, rx_tid->size,
-- 
2.53.0



