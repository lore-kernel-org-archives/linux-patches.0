Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B843115ADB4;
	Mon, 23 Jun 2025 22:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717372; cv=none; b=r9T5pygzOfZT+e8BwuT9e1Ni2MEMVdDbz5Ks4WmYQKI93BNo1KJ1e63K3DWa5IN2KdUNsi9Pzamobmag1LGtgiNR2oPH5VDxZHfVaJntbca2WsbcfHLbLCpT6yKr9tDefPZvEPEzxiahAOgIRNVgKEG09vBgifxUTAk6MfgkfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717372; c=relaxed/simple;
	bh=9Uoz0Jt+5JcUMZjjnOgFSMlJvk+ON5wD5eNJWtZ21gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8jptqPsHUb6Sw9y2r2l3HeTZnUlMNutGBMS58rXgjbJ/WlDtJHQCXUmuN3uc5rIoqmSzPnHJIkFzYvTUovMeHUz9swrgPf7BlvvCJzmrm4BNoAyW/rde618zTWyUi2HR+awLLzDwFYWRD5XbpOgj270NJ0g0fzULg6LFDBhZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHpbxKaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHpbxKaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47264C4CEEA;
	Mon, 23 Jun 2025 22:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717372;
	bh=9Uoz0Jt+5JcUMZjjnOgFSMlJvk+ON5wD5eNJWtZ21gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHpbxKaFK1+6lwrYkmBkvSgq4b3gMjE3Ih3f23WzzoPx8z4CM3VznxDM5/U4Pw5AH
	 ipSHu2nxeOi+fjM8C+BvMrdr7c8nvceVrEUNjcERsZvCfRmQGcmACpbX34sVo9/QCu
	 4M/N5VLeqzG1GZD5Hx461Z+vfAvUx3ZGmA2DnjPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/414] bnxt_en: Add a helper function to configure MRU and RSS
Date: Mon, 23 Jun 2025 15:08:32 +0200
Message-ID: <20250623130651.329198688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit e11baaea94e2923739a98abeee85eb0667c04fd3 ]

Add a new helper function that will configure MRU and RSS table
of a VNIC. This will be useful when we configure both on a VNIC
when resetting an RX ring.  This function will be used again in
the next bug fix patch where we have to reconfigure VNICs for RSS
contexts.

Suggested-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250613231841.377988-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5dacc94c6fe6 ("bnxt_en: Update MRU and RSS table of RSS contexts on queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 37 ++++++++++++++++-------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d0a87424c74ed..e3dfce365ba40 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10390,6 +10390,26 @@ void bnxt_del_one_rss_ctx(struct bnxt *bp, struct bnxt_rss_ctx *rss_ctx,
 	bp->num_rss_ctx--;
 }
 
+static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
+				u16 mru)
+{
+	int rc;
+
+	if (mru) {
+		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
+		if (rc) {
+			netdev_err(bp->dev, "hwrm vnic %d set rss failure rc: %d\n",
+				   vnic->vnic_id, rc);
+			return rc;
+		}
+	}
+	vnic->mru = mru;
+	bnxt_hwrm_vnic_update(bp, vnic,
+			      VNIC_UPDATE_REQ_ENABLES_MRU_VALID);
+
+	return 0;
+}
+
 static void bnxt_hwrm_realloc_rss_ctx_vnic(struct bnxt *bp)
 {
 	bool set_tpa = !!(bp->flags & BNXT_FLAG_TPA);
@@ -15326,6 +15346,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_cp_ring_info *cpr;
 	struct bnxt_vnic_info *vnic;
 	int i, rc;
+	u16 mru;
 
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
@@ -15356,18 +15377,13 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	cpr = &rxr->bnapi->cp_ring;
 	cpr->sw_stats->rx.rx_resets++;
 
+	mru = bp->dev->mtu + ETH_HLEN + VLAN_HLEN;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
-		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
-		if (rc) {
-			netdev_err(bp->dev, "hwrm vnic %d set rss failure rc: %d\n",
-				   vnic->vnic_id, rc);
+		rc = bnxt_set_vnic_mru_p5(bp, vnic, mru);
+		if (rc)
 			return rc;
-		}
-		vnic->mru = bp->dev->mtu + ETH_HLEN + VLAN_HLEN;
-		bnxt_hwrm_vnic_update(bp, vnic,
-				      VNIC_UPDATE_REQ_ENABLES_MRU_VALID);
 	}
 
 	return 0;
@@ -15386,9 +15402,8 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 
 	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
-		vnic->mru = 0;
-		bnxt_hwrm_vnic_update(bp, vnic,
-				      VNIC_UPDATE_REQ_ENABLES_MRU_VALID);
+
+		bnxt_set_vnic_mru_p5(bp, vnic, 0);
 	}
 	/* Make sure NAPI sees that the VNIC is disabled */
 	synchronize_net();
-- 
2.39.5



