Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031512;
	b=0ueANpyl/LKguRFqx/R9nK6ZTnTFOXt9PXkNL+sfw03rDasvxQoC5kBk3u+d0SeGEgYs
	 azNo1fMmwVzFN/wIJZEWTvhmiWJck7VjZshRuIVucE5F8lWtB1pBkeq5WIhBa/qyNmQiq
	 MqgK/g2KpIo/4Lua4ZkPt9TOJFgbsKjS7AP3F8lKXC7ke/uywVLaIqI17y7xVR+wtGnh3
	 1HSrn6f09yRIn5F+aiWre6jpvKZSJMbnUYHJgTTonOSDhv/IlN7L9VkFQY0sBMuuC8QND
	 y/ZdkkiP23Ajs3Rklx7SzIIoROz/+kFFP/5WL6UX9qX6E3TrZV3dYiJfeWM6JKtYAXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ng2+Z64usJrTNjQx4EYbqAqqx5LZ1nv5NSyZieQYono=;
	b=HjGtdLuj95sBTmUFSvrRTE7ajmyj6KDas/NcDYrW+MNefBdJEtoKeB6oSSdIA71ACqpz
	 tqsSGytygcU6qCZdJLZN39RDYc13hJ3S+l0H89ONE0u2vNsCa8AjCq+Q1gp8nFii1a064
	 6j9CX9+5OpJUf1MagXfYMAhSBWehPtoP4GC+D87VdM8yuJUe8joXfCb328g0X8C/f3hUh
	 uvD45LoETxOiWwfyxmm6ZFS4xptjlinrPSoR7wxA9sSqtwR7N6lAEE+lfqw9/hqZxNtn4
	 gxkK3RZMBZ8vrsPGojWBE5N/JTA25eFU4UTArswLlMUfX8VkYYDVmMGcBVeq6xTcehA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVykvKpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307E606A32A;
	Wed, 18 Nov 2026 19:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVykvKpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B95A1F000C4;
	Wed, 18 Nov 2026 19:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031512;
	bh=ng2+Z64usJrTNjQx4EYbqAqqx5LZ1nv5NSyZieQYono=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVykvKpM6x1sTiggcEtuLcCMI9Qwm34xqn51JffUXoEfupVaQdlsY/hyO7R864N0C
	 4HPazB1El5T7E2bmcrHo9iJ5sIB6H9LGtFLU683FrHP93hknKDoCrzVCt8EOLp1EZQ
	 5IIqpx4LG9tgi0xgfIdGxpj21cgBtUrC5zPgGPvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1085/1756] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Wed, 18 Nov 2026 15:53:32 +0100
Message-ID: <20261118150053.387195971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1c1a208e65a08191901cfded3bbccc4a54e4a75c ]

ath10k_htt_flush_tx_queue() walks pending_tx with idr_for_each().
Its callback calls ath10k_txrx_tx_unref(), which removes the current
entry from pending_tx through ath10k_htt_tx_free_msdu_id().

idr_for_each() keeps radix-tree iterator state across the callback.
Removing the current entry can therefore invalidate that state and
make the remaining walk unsafe.

Use idr_for_each_entry(), which starts a fresh lookup after each
callback.  The current entry can then be removed safely, while the
following idr_destroy() continues to release the IDR itself.

Fixes: 89d6d83565e9 ("ath10k: use idr api for msdu_ids")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-2-yaojiale02@163.com
[changed ath10k_htt_tx_clean_up_pending() signature]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c1ddd761af3e9..bbb27dae28a9d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -506,9 +506,8 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	return ret;
 }
 
-static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
+static void ath10k_htt_tx_clean_up_pending(int msdu_id, struct ath10k *ar)
 {
-	struct ath10k *ar = ctx;
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {0};
 
@@ -518,8 +517,6 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 
 	ath10k_txrx_tx_unref(htt, &tx_done);
-
-	return 0;
 }
 
 void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
@@ -536,8 +533,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
 static void ath10k_htt_flush_tx_queue(struct ath10k_htt *htt)
 {
+	struct sk_buff *msdu;
+	int msdu_id;
+
 	ath10k_htc_stop_hl(htt->ar);
-	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
+
+	idr_for_each_entry(&htt->pending_tx, msdu, msdu_id)
+		ath10k_htt_tx_clean_up_pending(msdu_id, htt->ar);
 }
 
 void ath10k_htt_tx_stop(struct ath10k_htt *htt)
-- 
2.53.0



