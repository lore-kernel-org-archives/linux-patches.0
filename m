Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED49936A369;
	Wed, 20 May 2026 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294524; cv=none; b=p3ktD9r9TYPogA+Fr88TKZ36oVuIycHqCKs8r+HAA5eqZuqP0AOK7CAecwuX9j2Mfzay0L3APJrZV1OHPzw5laJX2Sm9gIX4DG74xdevuNV3lcs0FnUn5wwG6qbKmkbtqE1JHMTisO6TwVRPcDY802ELafR7S/xAVpnNGEwHmwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294524; c=relaxed/simple;
	bh=S/BlO+SfMobAgRwHjwXD16PJCoCZ/t/xzBpVfvc+G+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUKeI7eB/o2OyUjYW76I+aGvtFHYvj/GbcH6v4CDmMDDPtGaJcMOOnu6YGCy0eyhpg+jU5ARbFhAeDAnbdfkeCtUBmY/v8K9tTNq10Zkh6RUyPGZr8ekz7wjQCy0NxKN7H+cPTOoPk2CSh1OrTFVx8F8vajlTaQEWUfma3GhdUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXSmRNdV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXSmRNdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A5F1F000E9;
	Wed, 20 May 2026 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294521;
	bh=+GSAOFkwF+6hBrYl5QOYfLuzb2DcL3PDVPQL6QlQZLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXSmRNdV+nikd7SgC45+SEVXtP/sWQqhknyz+E65nqgu+t0AmBcx5widrUijVeEFI
	 qgfc/N1qUtxdqOnMBTExTcvdacxed572ZetLnfgLlryBqiAoAGllVQM1d3WzjykKT6
	 l8n3BkjxujdLbcJL7eH/GRCbfPLEADkBREu33wSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0070/1146] wifi: ath11k: fix memory leaks in beacon template setup
Date: Wed, 20 May 2026 18:05:20 +0200
Message-ID: <20260520162149.942568871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e4ee2ba1f669e..c06ee110a90f0 100644
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



