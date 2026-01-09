Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9755F1531E8;
	Fri,  9 Jan 2026 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961578; cv=none; b=izgWeB3QlvCtZPkfAUXdaqvi7GR7yTyUewDnYKr4H7Vp+/fNLtYkBP+TzQE3ctTu5/0apt8lWQSiJFR68YE9scj33p2KBHAbzgiYugeZ66UebeiwC60I3+nqlROG4x9c1AongmzXxwiGztIPjGbah51cJMvWqGunzkMY22y+WW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961578; c=relaxed/simple;
	bh=wdoEo/Uf3Pggpa60Aw6Xl90PjrWywS13XfhiW42cr3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PowmR5h/b5ecAz1SBqfKc8S4OUsAggMpsPAXUUNVT3BqYqbJ+qqz0p3Xsa9JCpilz01drxBkoiwSoF61B32IRoTkg8Da4LRtXT/amM9nT0i2HsjzMMfER2Gu7eGIJYRpv4bS7QzMgZLPnyRcGvLdRjWEGmMzoo8wEgJJFJept28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClnhfxvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClnhfxvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE087C4CEF1;
	Fri,  9 Jan 2026 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961578;
	bh=wdoEo/Uf3Pggpa60Aw6Xl90PjrWywS13XfhiW42cr3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClnhfxvUt6TIjzfBbjgKLCtiPd/0ARTRXFChzb5msUpj5clKwyVGEfHwelAIW4dlv
	 Y+exkru57XXkSrU8ERQWjEFmVZ6DAdmKSmYHX8r/5oDM/K8Z9p0SEHJjOKap5FsZD0
	 sJzLKgGDAa/S+EIyPVLhy6fTGgMQ9QXn4TKl9/50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/634] wifi: ath11k: fix peer HE MCS assignment
Date: Fri,  9 Jan 2026 12:35:40 +0100
Message-ID: <20260109112119.778971239@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 4a013ca2d490c73c40588d62712ffaa432046a04 ]

In ath11k_wmi_send_peer_assoc_cmd(), peer's transmit MCS is sent to
firmware as receive MCS while peer's receive MCS sent as transmit MCS,
which goes against firmwire's definition.

While connecting to a misbehaved AP that advertises 0xffff (meaning not
supported) for 160 MHz transmit MCS map, firmware crashes due to 0xffff
is assigned to he_mcs->rx_mcs_set field.

	Ext Tag: HE Capabilities
	    [...]
	    Supported HE-MCS and NSS Set
		[...]
	        Rx and Tx MCS Maps 160 MHz
		    [...]
	            Tx HE-MCS Map 160 MHz: 0xffff

Swap the assignment to fix this issue.

As the HE rate control mask is meant to limit our own transmit MCS, it
needs to go via he_mcs->rx_mcs_set field. With the aforementioned swapping
done, change is needed as well to apply it to the peer's receive MCS.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 61fe43e7216d ("ath11k: add support for setting fixed HE rate/gi/ltf")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251017-ath11k-mcs-assignment-v1-2-da40825c1783@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
 drivers/net/wireless/ath/ath11k/wmi.c | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4cab480f85a8d..6a244f110dca6 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2243,10 +2243,10 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 			he_tx_mcs = v;
 		}
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_160);
+		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_160);
-		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		arg->peer_he_mcs_count++;
@@ -2256,10 +2256,10 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 
 	default:
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_80);
+		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_80);
-		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		arg->peer_he_mcs_count++;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index ed12bbb11fe89..8b50dbc47300b 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2013,8 +2013,11 @@ int ath11k_wmi_send_peer_assoc_cmd(struct ath11k *ar,
 				     FIELD_PREP(WMI_TLV_LEN,
 						sizeof(*he_mcs) - TLV_HDR_SIZE);
 
-		he_mcs->rx_mcs_set = param->peer_he_tx_mcs_set[i];
-		he_mcs->tx_mcs_set = param->peer_he_rx_mcs_set[i];
+		/* firmware interprets mcs->rx_mcs_set field as peer's
+		 * RX capability
+		 */
+		he_mcs->rx_mcs_set = param->peer_he_rx_mcs_set[i];
+		he_mcs->tx_mcs_set = param->peer_he_tx_mcs_set[i];
 		ptr += sizeof(*he_mcs);
 	}
 
-- 
2.51.0



