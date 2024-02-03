Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6234101C2;
	Sat,  3 Feb 2024 04:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933544; cv=none; b=p0dbB1XH+9xpbKTjvRoYwpGV50lu/91in+Any+dSn4n2/Low4Lcw//9m8zkiDWBIes/S5wiRBEsxojsB3KCGW5DBxvGRtZcgJuigvNIt1NXnO5gqo4Saaix8uEhpPbTWkOIKK4xTb4ES2mxTbBFlt3rebhZk9GuTGH3NEWpmLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933544; c=relaxed/simple;
	bh=I+D+Ck+q3lVvR0ioCIKhPyIQ2NYLbZBgUs9hjzTJKFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi/AeVhrWwvoBB1ievnqEo7aGbC5y+29yDESAKcUrY2dSe45lTP17jTTjR6v4NqrNW6Mdusq6UQVFIeKq1YR7p1zpoVagdn/Sq1NWGYSz/KsK3XLfwhuNahUddVlGK/oAUtwSbQKE35g0GLtwFAOd2AFagW//0LaenNhx1CzxPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Smr9RzD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Smr9RzD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B85C43390;
	Sat,  3 Feb 2024 04:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933544;
	bh=I+D+Ck+q3lVvR0ioCIKhPyIQ2NYLbZBgUs9hjzTJKFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Smr9RzD+HWIOAXSjam0/U6kFryI1DNkhGPqQoJDYWRHJ34PdAuy5nRinMJp1ayxAX
	 +eV6iNBe7WBf+Xom0RZqguAizYp0WVC9uXc1QyYXpVDBene/h7TPgDweuC9KnO6f+F
	 Eu9HfzuUKPsxGyX5bIMQeJapbB0wlrEFXQXLWD9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <quic_kangyang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/322] wifi: ath12k: fix and enable AP mode for WCN7850
Date: Fri,  2 Feb 2024 20:03:08 -0800
Message-ID: <20240203035402.100130417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kang Yang <quic_kangyang@quicinc.com>

[ Upstream commit ed7e818a7b501012038d6bc6fedadaf7375a380a ]

For AP mode, the peer is created earlier in ath12k_mac_op_add_interface() but
ath12k_mac_op_assign_vif_chanctx() will try to create peer again.  Then an
error will return which makes AP mode startup fail.

Kernel log:

[ 5017.665006] ath12k_pci 0000:04:00.0: failed to create peer after vdev start delay: -22

wpa_supplicant log:

Failed to set beacon parameters
Interface initialization failed
wls1: interface state UNINITIALIZED->DISABLED
wls1: AP-DISABLED
wls1: Unable to setup interface.
Failed to initialize AP interface
wls1: interface state DISABLED->DISABLED
wls1: AP-DISABLED

So fix this check and enable AP mode for WCN7850, as now AP mode works normally.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231121022459.17209-1-quic_kangyang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hw.c  | 3 ++-
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.c b/drivers/net/wireless/ath/ath12k/hw.c
index 5991cc91cd00..c1dcdd849f9d 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -942,7 +942,8 @@ static const struct ath12k_hw_params ath12k_hw_params[] = {
 		.rx_mac_buf_ring = true,
 		.vdev_start_delay = true,
 
-		.interface_modes = BIT(NL80211_IFTYPE_STATION),
+		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				   BIT(NL80211_IFTYPE_AP),
 		.supports_monitor = false,
 
 		.idle_ps = true,
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 88346e66bb75..5434883eaf96 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -6196,8 +6196,8 @@ ath12k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	if (ab->hw_params->vdev_start_delay &&
-	    (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
-	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)) {
+	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		param.vdev_id = arvif->vdev_id;
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;
-- 
2.43.0



