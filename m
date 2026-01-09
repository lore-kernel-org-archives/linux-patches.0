Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E342D31A7EA;
	Fri,  9 Jan 2026 11:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959528; cv=none; b=gNf3qH8/Hlh9Ce/+fr62YqBW2jby27YbFSrZwEtE/YIbY4dJgh93LpYy84A5VNRoU22OwsSdeNe749DcJzA9IQIPh5J6Klv4kr+vzbZrwlseYl6sV3KQf0AnC9PmFHanbLfXkzqJJu+j3W25teelrlnearjtj+HNuCGRlBvL95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959528; c=relaxed/simple;
	bh=k7fstFEvDgje3YHFSzT8HM7FFfQ9E64KbqyzO2MZwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsZAYr7SWmfVshtIPVnh4f8/p4YIaPya1WccKNDft2Lb7Taz+O2p4+5xeQ68DKPzJ2/ppWasqstKzKohgTC8PvfVpgXCVBvFfzCyM7YccjA9Ue6oGFAH2XLJazeRuZ+aaHtSUkJm7dmLLTfChFq5vRGTii+K5rdQE+vcFMZwVog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/ABKonQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/ABKonQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A2C4CEF1;
	Fri,  9 Jan 2026 11:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959527;
	bh=k7fstFEvDgje3YHFSzT8HM7FFfQ9E64KbqyzO2MZwjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/ABKonQ3Boj/TD38LBPOi/PAC3kVR6tHVzIqzSJ8Bst4fZxeLm/coXwWs5l7Pvl2
	 myZMDvZWbMV/I5ftRNwsRdfBaZSIJ9H+DMWGOqD7IF/n+K3SaNYdvAi1KmyCP6Ekto
	 7ZWRDnaS/c6cKBWV6gKeVwUqFpm8diLPLKIBvx+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/737] wifi: ath11k: fix peer HE MCS assignment
Date: Fri,  9 Jan 2026 12:33:43 +0100
Message-ID: <20260109112137.157716883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 2921be9bd530c..0937d725d4d0b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2424,10 +2424,10 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 			he_tx_mcs = v;
 		}
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_160);
+		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_160);
-		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		arg->peer_he_mcs_count++;
@@ -2437,10 +2437,10 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 
 	default:
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_80);
+		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_80);
-		v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		arg->peer_he_mcs_count++;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 16687223bdcba..f491aeb22a883 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2044,8 +2044,11 @@ int ath11k_wmi_send_peer_assoc_cmd(struct ath11k *ar,
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



