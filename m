Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E843D5C06;
	Tue, 13 Oct 2026 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893691; cv=none; b=BlyRmz+St+QH7V+Yn5skBMtC2Cz+UKqknq9wranyY1Mdui2GqnBHc646e7rG3O1iPNVTvE+6Yn+3JpFQ/YAO46O3J8dvC4ZNlEiwjGi4EUBBeAgYgMA/m21iAmuhhKj8qZ+CVxC5GX1NWAg1mvILPxZhTQE62MjlQ1HDT8/046Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893691; c=relaxed/simple;
	bh=o2rJQ2qfQyzL9ObCA2YL4C6dV4liZdIzwLhgjkt58tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIr96qeMJVV+dRVp7MrwGMZUn9H12B56u+LJysZ4SU0t6xqmlCPKIxqPgpnOvwcrpjlnPW/QxN9aamaH8saTBYHsAcySAViJRPdLMK8mSs+cCU6jGHQXB37y/AlgPtO5pr9PGkFjCU5tgM3aiKQLIwouhngag5blyJKKOVDOiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCswiWns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCswiWns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876851F000FF;
	Tue, 13 Oct 2026 12:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893690;
	bh=0W2ntt8GdZVzJYjMcQtWc1oiaSbTWt96Q89Az01Fbek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCswiWnsYurDDqMNu/ZAJZjNfH3BDHraX5ODi5QBr2mC1yprljvuySwIN6osL/RLy
	 K8mNlUkSzIvNK2tpQkP4nC+OOIRjj1pmBFvGXTNfSCIKF/DRlOLQyojs2Fj5zGVdVl
	 /jPbDI5+rj94CfC+ser5kxqafQW1dT77vOZP7UZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/621] wifi: ath12k: fix inconsistent arvif state in vdev_create error paths
Date: Tue, 13 Oct 2026 13:35:06 +0200
Message-ID: <20261013112928.235000110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Zhang <wei.zhang@oss.qualcomm.com>

[ Upstream commit c972636efc63f0f43d725b59805dd1ae5bc4b31e ]

ath12k_mac_vdev_create() has three error path issues that leave arvif
in an inconsistent state:

1. When ath12k_wmi_vdev_create() fails, the function returns directly
   without clearing arvif->ar, which was already set before the WMI
   call. Subsequent code checking arvif->ar to determine vdev readiness
   will see a non-NULL value despite no vdev existing in firmware.

2. When ath12k_wmi_send_peer_delete_cmd() fails in err_peer_del, the
   code jumped to err: skipping the DP peer cleanup and vdev rollback,
   leaving num_created_vdevs, vdev maps and arvif list membership live.

3. When ath12k_wait_for_peer_delete_done() fails, the code jumped to
   err_vdev_del: skipping the DP peer cleanup.

Fix by changing the ath12k_wmi_vdev_create() failure to goto err instead
of returning directly, routing both err_peer_del failure paths through
err_dp_peer_del: for proper DP peer and vdev rollback, and consolidating
the arvif state cleanup at err:.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 477cabfdb776 ("wifi: ath12k: modify link arvif creation and removal for MLO")
Signed-off-by: Wei Zhang <wei.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260512044906.1735821-2-wei.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2f47054efa44e..7f7eddfa97719 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9745,7 +9745,7 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 	if (ret) {
 		ath12k_warn(ab, "failed to create WMI vdev %d: %d\n",
 			    arvif->vdev_id, ret);
-		return ret;
+		goto err;
 	}
 
 	ar->num_created_vdevs++;
@@ -9874,7 +9874,7 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
 				    arvif->vdev_id, arvif->bssid);
-			goto err;
+			goto err_vdev_del;
 		}
 
 		ret = ath12k_wait_for_peer_delete_done(ar, arvif->vdev_id,
@@ -9893,8 +9893,6 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 	ath12k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->num_created_vdevs--;
-	arvif->is_created = false;
-	arvif->ar = NULL;
 	ar->allocated_vdev_map &= ~(1LL << arvif->vdev_id);
 	ab->free_vdev_map |= 1LL << arvif->vdev_id;
 	ab->free_vdev_stats_id_map &= ~(1LL << arvif->vdev_stats_id);
@@ -9903,6 +9901,7 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 	spin_unlock_bh(&ar->data_lock);
 
 err:
+	arvif->is_created = false;
 	arvif->ar = NULL;
 	return ret;
 }
-- 
2.53.0



