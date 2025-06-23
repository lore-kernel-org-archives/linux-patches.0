Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B32940B;
	Mon, 23 Jun 2025 22:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716574; cv=none; b=K3hgRtCxZ1gPiRZcd8OT/5YVK8C5ple8XAUO6MKtHnu8/B6mKpkzshQcmbl+dV2Sal9jz6t6ZU5z8XNGnQ52MoiIOzeGQnuzH9/SqnHz1lX61UP3c+nNM3bH4mukLN/Xqc8j91w7L5EMHFi0GXU+AORp1JtmFACe8g3ZJZdzdYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716574; c=relaxed/simple;
	bh=/wqEmBVExkOjIk8DAQTEFtP5WD2G6OFnWNv5OkQ8qFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaBfDeUccJYX8mi6H+wNCXEtrT9B1RYeiaSl7laQPPXx3ZwdiY1cELla80kh6bEsaSUB4+WSHW0dSd49k5PN7KXCyppRyEcMFxdOofrYZO3DCFguPAKDEts7hMLs9a/kNIpUf2AFkg6KDqKO74fZs7Rm0DGovJY6ncUJAGQcuQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiukiThM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiukiThM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C4BC4CEEA;
	Mon, 23 Jun 2025 22:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716573;
	bh=/wqEmBVExkOjIk8DAQTEFtP5WD2G6OFnWNv5OkQ8qFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiukiThM5Lu+MBGbrhQqpV3XSbNs+BN/fhIba4tH2MN7yD7wau0FcqdeF0RMwQKbZ
	 RQRA7FjQL5QcfMwMcwLgVA9S4YkoY/Qd4pbmQEZSogTKA5mPkTJAolayAWwugUFhFG
	 0qwwQxHT7xG4ZN3IWCU4uEVft/Dv19b/pE9XUSnA=
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
Subject: [PATCH 6.15 533/592] bnxt_en: Add a helper function to configure MRU and RSS
Date: Mon, 23 Jun 2025 15:08:11 +0200
Message-ID: <20250623130713.112075768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6afc2ab6fad22..3d975e50f9438 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10738,6 +10738,26 @@ void bnxt_del_one_rss_ctx(struct bnxt *bp, struct bnxt_rss_ctx *rss_ctx,
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
@@ -15884,6 +15904,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_vnic_info *vnic;
 	struct bnxt_napi *bnapi;
 	int i, rc;
+	u16 mru;
 
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
@@ -15933,18 +15954,13 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	napi_enable_locked(&bnapi->napi);
 	bnxt_db_nq_arm(bp, &cpr->cp_db, cpr->cp_raw_cons);
 
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
@@ -15969,9 +15985,8 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 
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



