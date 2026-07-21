Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30416434E2C;
	Tue, 21 Jul 2026 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649019; cv=none; b=mk8TaES2VEPZ9xG14/va7u8YmlUllyud+iczu3pGzCX7FDb5R4MHDUi7c1VziQUrrzq7c++Sjmla1Hs2vV1GmTINQgDuxPta9gkOfQ0U4FvuL+NKZsg+cdWhzeeDjPCrx3Flbf1TO/eISjTbunYyxLfMFipUV/IHpdLJzbDOX0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649019; c=relaxed/simple;
	bh=xU9loWvDQ+isiDXwfjQC6igOoJNa2gkDB7WPOX45oLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK+2ysg6URl+T4j2DfWD/NPKDJXP5RDbd78LB40GCZbizFxLM/xS+8nne+PGN6Ln45z7kFAZd9vTwSZ2DDeUT6GpBOLW4aROMknNSgvy8ytmVXFU7YUEG9nlrejanlzhAaDMtPtYPiDLHiShmKRwpQQIc1dQcURnj6X9t/k80LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tb4lYIjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tb4lYIjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D01F000E9;
	Tue, 21 Jul 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649018;
	bh=/jecjbFjJqzuReyOl83+sfkCUfvXByS5MzCJaRdW9xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tb4lYIjMh8cNZh/98D+NcnCWk+RQYlgcOD5PPIkN2+Nx/0PeuBPRO6PnspfNDvM55
	 eXdS4M1s9+xvTOAPsHF9A7OxupGBZnBR8ha6sBtSBx2m52pKAZWrffLt/pYjDUu2lb
	 +wE5AFBKFSF8PfikizBtLlqyWBwtawkrHzgffOxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0420/2077] wifi: ath12k: fix inconsistent arvif state in vdev_create error paths
Date: Tue, 21 Jul 2026 17:01:33 +0200
Message-ID: <20260721152602.644058308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/ath/ath12k/mac.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2cff9485c95afb..6a3aaa1ba47acf 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -10293,7 +10293,7 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 	if (ret) {
 		ath12k_warn(ab, "failed to create WMI vdev %d: %d\n",
 			    arvif->vdev_id, ret);
-		return ret;
+		goto err;
 	}
 
 	ar->num_created_vdevs++;
@@ -10440,13 +10440,13 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
 				    arvif->vdev_id, arvif->bssid);
-			goto err;
+			goto err_dp_peer_del;
 		}
 
 		ret = ath12k_wait_for_peer_delete_done(ar, arvif->vdev_id,
 						       arvif->bssid);
 		if (ret)
-			goto err_vdev_del;
+			goto err_dp_peer_del;
 
 		ar->num_peers--;
 	}
@@ -10463,8 +10463,6 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 	ath12k_wmi_vdev_delete(ar, arvif->vdev_id);
 	ar->num_created_vdevs--;
-	arvif->is_created = false;
-	arvif->ar = NULL;
 	ar->allocated_vdev_map &= ~(1LL << arvif->vdev_id);
 	ab->free_vdev_map |= 1LL << arvif->vdev_id;
 	ab->free_vdev_stats_id_map &= ~(1LL << arvif->vdev_stats_id);
@@ -10473,6 +10471,7 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 	spin_unlock_bh(&ar->data_lock);
 
 err:
+	arvif->is_created = false;
 	arvif->ar = NULL;
 	return ret;
 }
-- 
2.53.0



