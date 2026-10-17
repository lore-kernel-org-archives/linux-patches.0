Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58599460;
	Sat, 17 Oct 2026 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258778; cv=none; b=ImfxnrHmbkQWlxLpbITi3UZKvWmwKKSZgjPST/JtwTzcZj42Vh35tZ2kWfuGo+BS1GZthpSxJID5NgJ8Fe9VPzAnrK3cqPtnIW3yTP9RUGsQ1aWKgjdkaCbHXpduuWaCp/ar0ujHOcEnNwHKRgvxpL9BnztYriAw7a2ibRqObyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258778; c=relaxed/simple;
	bh=GWe73x5+ZXEm0TRn0sp8tt3tFdlQZuOryPXb6gZnIqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMyV3G1DNHgnJG/ghw7rcCnVFJPFAWssiS00+oQxaKShJd3//fKXr8mOjVJEbio/M1MAtB0wL2Mrjqs/14bxKGCOV6brxAiBnh7JRPg7txa8wzMwN+TxXTiqwaWSSIgQehF9ouAly/rxsvO1djj6dZVc84iPY4vorasWBJI0Nq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3OHYg/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3OHYg/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AE81F000C4;
	Sat, 17 Oct 2026 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258777;
	bh=iMNM4JgycjsluINgswXBVKeqMHNrppmkyV9B090eLz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3OHYg/D0M2tOzGt9Nwhl4iC1K2sOQebFGd6OGKusEOcqeni1yAjyCX7abjNEJdo1
	 ILFdew34KgtHQaTCS3IAP6W6SFyurVcu5sSeeB0TRPhnZKxKAJv0LuWodybs1GUW/D
	 GodIKcjhVrvnlgbkJwI3ZMRFqKbdl31ZF87HiV6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0996/1674] wifi: ath11k: fix memory leaks in beacon template setup
Date: Sat, 17 Oct 2026 17:54:28 +0200
Message-ID: <20261017160456.683000870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit ff49eba595df500e4ddccc593088c8a4ab5f2c27 ]

The functions ath11k_mac_setup_bcn_tmpl_ema() and
ath11k_mac_setup_bcn_tmpl_mbssid() allocate memory for beacon templates
but fail to free it when parameter setup returns an error.

Since beacon templates must be released during normal execution, they
must also be released in the error handling paths to prevent memory
leaks.

Fix this by using unified exit paths with proper cleanup in the respective
error paths.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 3a415daa3e8b ("wifi: ath11k: add P2P IE in beacon template")
Fixes: 335a92765d30 ("wifi: ath11k: MBSSID beacon support")
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260130084451.110768-1-zilin@seu.edu.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 83936ccfb506c..fade0b8d87782 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1461,7 +1461,8 @@ static int ath11k_mac_setup_bcn_tmpl_ema(struct ath11k_vif *arvif)
 	if (!beacons || !beacons->cnt) {
 		ath11k_warn(arvif->ar->ab,
 			    "failed to get ema beacon templates from mac80211\n");
-		return -EPERM;
+		ret = -EPERM;
+		goto free;
 	}
 
 	if (tx_arvif == arvif)
@@ -1491,11 +1492,11 @@ static int ath11k_mac_setup_bcn_tmpl_ema(struct ath11k_vif *arvif)
 		}
 	}
 
-	ieee80211_beacon_free_ema_list(beacons);
-
 	if (tx_arvif != arvif && !nontx_vif_params_set)
-		return -EINVAL; /* Profile not found in the beacons */
+		ret = -EINVAL; /* Profile not found in the beacons */
 
+free:
+	ieee80211_beacon_free_ema_list(beacons);
 	return ret;
 }
 
@@ -1528,16 +1529,18 @@ static int ath11k_mac_setup_bcn_tmpl_mbssid(struct ath11k_vif *arvif)
 
 	if (tx_arvif == arvif)
 		ath11k_mac_set_vif_params(tx_arvif, bcn);
-	else if (!ath11k_mac_set_nontx_vif_params(tx_arvif, arvif, bcn))
-		return -EINVAL;
+	else if (!ath11k_mac_set_nontx_vif_params(tx_arvif, arvif, bcn)) {
+		ret = -EINVAL;
+		goto free;
+	}
 
 	ret = ath11k_wmi_bcn_tmpl(ar, arvif->vdev_id, &offs, bcn, 0);
-	kfree_skb(bcn);
-
 	if (ret)
 		ath11k_warn(ab, "failed to submit beacon template command: %d\n",
 			    ret);
 
+free:
+	kfree_skb(bcn);
 	return ret;
 }
 
-- 
2.53.0



