Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DBD11C8F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6685CC433D2;
	Mon,  8 May 2023 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544184;
	bh=KcdjGCERVhAYAgknl9UnSIXHyS5sM3UaahESDZw1D40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJtug9XZ+Ss5Yb8SMfCj5U3AwKTCzsAyHaztetTePyr65wlSJy9aodEoLj7vZF+Kc
	 P0mA5rNW93Y5cUXdRWaAwYsraw0OWolvA9FxqHTqUMQRVUzyS7Kq5h3avV5VmKBder
	 skRwrY5l0DkjlEWLNhERo0wwcOdTSQ7eDGwNs+r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 329/694] wifi: ath11k: fix SAC bug on peer addition with sta band migration
Date: Mon,  8 May 2023 11:42:44 +0200
Message-Id: <20230508094443.081806980@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 60b7d62ba8cdbd073997bff0f1cdae8d844002c0 ]

Fix sleep in atomic context warning detected by Smatch static checker
analyzer.

Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
always even if sta is not transitioning to another band.
This is peer_add function and a more secure locking should not cause
performance regression.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230209222622.1751-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/peer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index 1ae7af02c364e..1380811827a84 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -382,22 +382,23 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 		return -ENOBUFS;
 	}
 
+	mutex_lock(&ar->ab->tbl_mtx_lock);
 	spin_lock_bh(&ar->ab->base_lock);
 	peer = ath11k_peer_find_by_addr(ar->ab, param->peer_addr);
 	if (peer) {
 		if (peer->vdev_id == param->vdev_id) {
 			spin_unlock_bh(&ar->ab->base_lock);
+			mutex_unlock(&ar->ab->tbl_mtx_lock);
 			return -EINVAL;
 		}
 
 		/* Assume sta is transitioning to another band.
 		 * Remove here the peer from rhash.
 		 */
-		mutex_lock(&ar->ab->tbl_mtx_lock);
 		ath11k_peer_rhash_delete(ar->ab, peer);
-		mutex_unlock(&ar->ab->tbl_mtx_lock);
 	}
 	spin_unlock_bh(&ar->ab->base_lock);
+	mutex_unlock(&ar->ab->tbl_mtx_lock);
 
 	ret = ath11k_wmi_send_peer_create_cmd(ar, param);
 	if (ret) {
-- 
2.39.2



