Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93923372B4B;
	Fri,  4 Sep 2026 05:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500347; cv=none; b=VBeXBMeCuFA9vR+6NC8huRebYUPs5atiqIicsZjyoRa3YFEWdEjO6H+DxMemt3v/q0e3UaK+Fhz4aEpA0QCXncvzIpBjgWy1+XFxEewb35w5AvjS5zodkQ7vkOYQZCuO6RAqCFclg+hJt2Le+41BwgZG5x86Y6w+QFtMWSpyhoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500347; c=relaxed/simple;
	bh=J2+j9QQ3MKIU176/hKMOpU3PF9CacFFUJi4Q8/JQZVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lkh+f7LAIM7qxaMvHosznZSD0KfkbzRw7v2GnxLINxxdh1XzrprtyQKp1QMUBmsUq5QukjbeQuRhXOR5FoBJAP+mmUlzg3YkacvIoF/qsGFEFQHrsHOV+TUf3pTjVzjRVtbzC0rGZ9JbBnfrE9jaWqBwnKbhnBK/ValpnMgAFwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8TDwL2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8TDwL2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32921F00A3D;
	Fri,  4 Sep 2026 05:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500346;
	bh=hrg9K12shs6ExzCiSCQVzmtAqC0Vi+q/ArRab2WWbiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8TDwL2nhzwDDvm5z0osOz0aLTp3CqdBsyEZ05ooAre25kpPXo8Rx+UQSPvWR/DQn
	 9zjjAQST63JzwAqhSGdYajylNurjLQDkMqhJMN7fCXjKfltOqsdjuZojVgMFSRgK1c
	 nPXeOL5K4xVwAAWahXZ4oPBdfV/d9tETkj5eN1Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/552] wifi: ath11k: fix memory leaks in beacon template setup
Date: Fri,  4 Sep 2026 06:52:40 +0200
Message-ID: <20260904045747.900682782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 drivers/net/wireless/ath/ath11k/mac.c | 28 ++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f142c17aa9aa7..4794caa9f7eaa 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1557,12 +1557,15 @@ static int ath11k_mac_setup_bcn_tmpl_ema(struct ath11k_vif *arvif,
 	if (!beacons || !beacons->cnt) {
 		ath11k_warn(arvif->ar->ab,
 			    "failed to get ema beacon templates from mac80211\n");
-		return -EPERM;
+		ret = -EPERM;
+		goto free;
 	}
 
 	if (tx_arvif == arvif) {
-		if (ath11k_mac_set_vif_params(tx_arvif, beacons->bcn[0].skb))
-			return -EINVAL;
+		if (ath11k_mac_set_vif_params(tx_arvif, beacons->bcn[0].skb)) {
+			ret = -EINVAL;
+			goto free;
+		}
 	} else {
 		arvif->wpaie_present = tx_arvif->wpaie_present;
 	}
@@ -1589,11 +1592,11 @@ static int ath11k_mac_setup_bcn_tmpl_ema(struct ath11k_vif *arvif,
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
 
@@ -1622,19 +1625,22 @@ static int ath11k_mac_setup_bcn_tmpl_mbssid(struct ath11k_vif *arvif,
 	}
 
 	if (tx_arvif == arvif) {
-		if (ath11k_mac_set_vif_params(tx_arvif, bcn))
-			return -EINVAL;
+		if (ath11k_mac_set_vif_params(tx_arvif, bcn)) {
+			ret = -EINVAL;
+			goto free;
+		}
 	} else if (!ath11k_mac_set_nontx_vif_params(tx_arvif, arvif, bcn)) {
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free;
 	}
 
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



