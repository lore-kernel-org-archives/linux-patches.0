Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF97615FA91;
	Mon, 27 May 2024 19:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837838; cv=none; b=O7sTWCjBARwqNBl7QSa/iWzf6B9ugscFe7uMQXOYyGIFq4ojzrT/HCCju8UrMbgML03RwAsLm4WIzGGZLuvaJNQPUOaGqWzo13UrhHIa2lnaYVTpHRXRXwwLZXOfeoqZt8sRkKtfvoYaoaGNg/4XQMYBzVF+v++NRoBJo/BdNUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837838; c=relaxed/simple;
	bh=ykf1xUr0HmcZYMNNQY1KgYMzNqT5gnZu4RZXIyUp/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA3w0qjeDjzh6C7tZxk+M0hA2ckUZUS+R7prGkA1xP58MJ9I3SCshC/UxncIT/HIefwvGHMluWN60rBmUAba7rjHBd1Zxk/esp8+1GIN+daJ8/FG9I80fEywQVSAzb4wkLYTXThSlMfD0UBDJ1q49vaybjDK+YfuVLwqVtZoAuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VLZW1gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VLZW1gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743F5C32786;
	Mon, 27 May 2024 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837837;
	bh=ykf1xUr0HmcZYMNNQY1KgYMzNqT5gnZu4RZXIyUp/Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VLZW1gR1n6TYdbWJxUWYZRCT5Ao1RP6PYvek1RIz+cJ4K68kOBHLUrXQ1qvGGLja
	 nsOiDHuJCq7ofntaUpHfMrGEmGKpftdUIaBS7JQZ0GOV4+CxXa5IC42pJYvITJCEnJ
	 SqJ+OFLJgL0zbfb1DA6yVy4DP856i9/aqgkvtbL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 163/493] wifi: ath11k: dont force enable power save on non-running vdevs
Date: Mon, 27 May 2024 20:52:45 +0200
Message-ID: <20240527185635.711911595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index cc80310088ce1..a46b8e677cd1f 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1234,14 +1234,7 @@ static int ath11k_mac_vif_setup_ps(struct ath11k_vif *arvif)
 
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



