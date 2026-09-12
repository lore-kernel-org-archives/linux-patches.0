Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D592E718B;
	Sat, 12 Sep 2026 07:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198476; cv=none; b=I4ea0YP9oMyal7YfmQYN5inrV8awVPTjsTNiwrTf2hTZYlGhnEiTDMLxrrulaDnEB6XPoY2tlzXWY7yLOXyL15vxi1AuCmFflQPfl8VX+qaqcGFzrrhU6hoGaQsJQfA2qOxxjMqj6UnFLtz2FWg9pU28VCPXyITbnz8Jdk/9rbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198476; c=relaxed/simple;
	bh=GAmu6CYApV3421OAmns/KLFoawUIn0h5fE8lSObmfMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7stYFf4v/u8OAZy0sY5ty1QUS4mtFopkv9ghYw8xFdgSbyM4LCiga7tK+XTNOURhWxLtRk3CFLm/cL3okm1qCh3UDUPfP+t706mE2u8obPdJgJFAe4uGtgraX/Exm8duelPNSfDv7RZ7VtAfBsIL9IQoCTLPhcOYfr1XY23Sas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sddyAuH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sddyAuH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6D61F000FF;
	Sat, 12 Sep 2026 07:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198474;
	bh=OPYxSMCJY2RV91B7HKTVnppMEBft9nqpTFdrOyKuLfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sddyAuH1+QMoYD5s0F0d56BcBKEH3M4lym/mHi5HvGFrz4wcdph6aDJm52b3xH40R
	 dudIevrFqoWvIctnsEP3Qle2mbcVXzVYl5rQBA+couxWuazPU12LwJi00qPrenETxo
	 bttO9otv3F7vSvP5NxAPJmf2T+qLkdq7rtRw5t24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0388/1815] wifi: ath12k: fix dp_link_peer dangling references on AP vdev rollback
Date: Sat, 12 Sep 2026 08:35:38 +0200
Message-ID: <20260912065658.000339956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit f066e1a93703c5be0fd905109d00587541711c97 ]

ath12k_mac_vdev_create() for an AP vdev creates the bss self-peer via
ath12k_peer_create(), which finishes by calling
ath12k_dp_link_peer_assign() to publish the dp_link_peer in the
dp_hw->dp_peers[peerid_index] RCU table, in the dp_peer's
link_peers[] array, and in the per-addr rhashtable.

If a step after ath12k_peer_create() fails the function jumps to
err_peer_del, which open-codes a WMI peer_delete and waits for the
unmap / delete_resp events. The wait_for_peer_delete_done() path
relies on ath12k_dp_link_peer_unmap_event() freeing the dp_link_peer
when the unmap arrives, but err_peer_del never calls
ath12k_dp_link_peer_unassign() first. The published references in
the dp_hw RCU table, dp_peer->link_peers[] and the rhashtable are
left pointing at the dp_link_peer that unmap_event then frees,
producing dangling pointers and use-after-free on subsequent
lookups.

Replace the open-coded sequence with a call to ath12k_peer_delete(),
which already does ath12k_dp_link_peer_unassign() before sending the
WMI command. This drops the published references before the
dp_link_peer is freed, in the same order as the normal teardown path
in ath12k_mac_remove_link_interface().

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 5525f12fa671 ("wifi: ath12k: Attach and detach ath12k_dp_link_peer to ath12k_dp_peer")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260629-ath12k-mlo-peer-delete-race-v2-1-362b25590d19@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index a0928890671ac..d024f768d7363 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -10616,22 +10616,8 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 err_peer_del:
 	if (ahvif->vdev_type == WMI_VDEV_TYPE_AP) {
-		reinit_completion(&ar->peer_delete_done);
-
-		ret = ath12k_wmi_send_peer_delete_cmd(ar, arvif->bssid,
-						      arvif->vdev_id);
-		if (ret) {
-			ath12k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
-				    arvif->vdev_id, arvif->bssid);
-			goto err_dp_peer_del;
-		}
-
-		ret = ath12k_wait_for_peer_delete_done(ar, arvif->vdev_id,
-						       arvif->bssid);
-		if (ret)
-			goto err_dp_peer_del;
-
-		ar->num_peers--;
+		/* ignore return value: propagate the original error */
+		ath12k_peer_delete(ar, arvif->vdev_id, arvif->bssid);
 	}
 
 err_dp_peer_del:
-- 
2.53.0



