Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5B19938D;
	Thu,  6 Jun 2024 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683215; cv=none; b=ASMi1MXRbyyfV0Ps656cup9NgU4ZnXLushteP681kQizcF+PbobZvSVgbNoSpxhsn86PDUapxh3GOmKjY5f0rf3T0QzF8attxpF6Y5gPny3piEGH4CfN2/F/L9czlEExR/sG9ES1VVEeosXjOo53Znl3Z33E/NI0b9MtRfAwpZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683215; c=relaxed/simple;
	bh=o04hx/NAmh0Y+qRgTne+wex8yd+K49QB3scqVtQWeRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKT3xxoevkUhuZVBdx+URwr0++2A9vNivTPnSr04eED52VZPZFzWK0yWCC7EpAX+GWgjz19+Qj97bH8Tu746nPBxRs3jv7TumqapWZZG3CcrFx83SHFillFF6GQJa/C+v/T5N/PQEpxXMUFBTeWA/KHeNij1h3CbDPJveYECngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxCwoX/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxCwoX/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E22C2BD10;
	Thu,  6 Jun 2024 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683214;
	bh=o04hx/NAmh0Y+qRgTne+wex8yd+K49QB3scqVtQWeRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxCwoX/ECkyRnixpAOLN4jW+JW0CIV3D/DInJC80aMYvLG8nRVzL+5wuQz7LcU+BT
	 nTcljKLtxuv2cTzTahxPFy5D4/kt54O5Zl3jvy7E6zGtgV+A8wEZrl4zUwlGMPuKRm
	 9jKjOWyrwnAsbZeEHUPv4vdGfekzBBx12LFki9XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/473] wifi: ath11k: dont force enable power save on non-running vdevs
Date: Thu,  6 Jun 2024 16:00:21 +0200
Message-ID: <20240606131702.953612376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 01296b39d3515f20a1db64d3c421c592b1e264a0 ]

Currently we force enable power save on non-running vdevs, this results
in unexpected ping latency in below scenarios:
	1. disable power save from userspace.
	2. trigger suspend/resume.

With step 1 power save is disabled successfully and we get a good latency:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=5.13 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=5.45 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=5.99 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=6.34 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=4.47 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=6.45 ms

While after step 2, the latency becomes much larger:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=17.7 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=15.0 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=14.3 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=16.5 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=20.1 ms

The reason is, with step 2, power save is force enabled due to vdev not
running, although mac80211 was trying to disable it to honor userspace
configuration:

ath11k_pci 0000:03:00.0: wmi cmd sta powersave mode psmode 1 vdev id 0
Call Trace:
 ath11k_wmi_pdev_set_ps_mode
 ath11k_mac_op_bss_info_changed
 ieee80211_bss_info_change_notify
 ieee80211_reconfig
 ieee80211_resume
 wiphy_resume

This logic is taken from ath10k where it was added due to below comment:

	Firmware doesn't behave nicely and consumes more power than
	necessary if PS is disabled on a non-started vdev.

However we don't know whether such an issue also occurs to ath11k firmware
or not. But even if it does, it's not appropriate because it goes against
userspace, even cfg/mac80211 don't know we have enabled it in fact.

Remove it to fix this issue. In this way we not only get a better latency,
but also, and the most important, keeps the consistency between userspace
and kernel/driver. The biggest price for that would be the power consumption,
which is not that important, compared with the consistency.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: b2beffa7d9a6 ("ath11k: enable 802.11 power save mode in station mode")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240309113115.11498-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 51fc77e93de5c..b863ead198bda 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1226,14 +1226,7 @@ static int ath11k_mac_vif_setup_ps(struct ath11k_vif *arvif)
 
 	enable_ps = arvif->ps;
 
-	if (!arvif->is_started) {
-		/* mac80211 can update vif powersave state while disconnected.
-		 * Firmware doesn't behave nicely and consumes more power than
-		 * necessary if PS is disabled on a non-started vdev. Hence
-		 * force-enable PS for non-running vdevs.
-		 */
-		psmode = WMI_STA_PS_MODE_ENABLED;
-	} else if (enable_ps) {
+	if (enable_ps) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
-- 
2.43.0



