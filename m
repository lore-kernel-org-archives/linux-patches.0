Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211B189901;
	Tue, 30 Jul 2024 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355689; cv=none; b=pQ6Aq8gWWRomivfVEFDzb9xmAhbgzTc+BD9SVgMlE5XPtMRv/eb+j0yBBsJj0ovGrQDJRBHOTDM1rnssaSxJN3RhjU8ALCJwS29x4fQ4xlIW1SjkXfuxjCwE3Oqj/HxVLMAcU6nw8Bi42WJLC/h+VUr7vrMUO05MEvwSqFuXjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355689; c=relaxed/simple;
	bh=KKL0gD/wanHUam2DLDjPclisdVvFlbWfPLAC6cT3awc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X166cGvxavpUd/pd37ejfTAnInpCa6R462rdNppLfQdpMoZOsKqZI1uYXqEi9R30p/D8aM3cMEZsvbbnJGh1Wd6nBRgAV5cHKazLPAb6UL1dkqnyE1kgsYDWZk9QxHWMIsI/ZcGrQyekDdnVNxMHlrkSg9TDKyaZzTQ1WuXq7S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eU5wVqmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eU5wVqmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CC9C32782;
	Tue, 30 Jul 2024 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355689;
	bh=KKL0gD/wanHUam2DLDjPclisdVvFlbWfPLAC6cT3awc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eU5wVqmB89XkVfpQf0Ul77MO8jmzbOdLvGgtOkKycxFBtm8F5nGSvO20Bk1L/NSGO
	 hErBlxNgxF5VAeHRjBo+1CMdpFHVetPUgrUA6vXUAJTcDOHIvvkYR/FdacHnLrVV/p
	 EVSRFspdT7zBprkh8bsfh4J1UADHdhpv7NRWgCoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6eb9cee2885ec06f5e3@syzkaller.appspotmail.com,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/440] wifi: virt_wifi: avoid reporting connection success with wrong SSID
Date: Tue, 30 Jul 2024 17:45:48 +0200
Message-ID: <20240730151620.384076039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: En-Wei Wu <en-wei.wu@canonical.com>

[ Upstream commit b5d14b0c6716fad7f0c94ac6e1d6f60a49f985c7 ]

When user issues a connection with a different SSID than the one
virt_wifi has advertised, the __cfg80211_connect_result() will
trigger the warning: WARN_ON(bss_not_found).

The issue is because the connection code in virt_wifi does not
check the SSID from user space (it only checks the BSSID), and
virt_wifi will call cfg80211_connect_result() with WLAN_STATUS_SUCCESS
even if the SSID is different from the one virt_wifi has advertised.
Eventually cfg80211 won't be able to find the cfg80211_bss and generate
the warning.

Fixed it by checking the SSID (from user space) in the connection code.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Reported-by: syzbot+d6eb9cee2885ec06f5e3@syzkaller.appspotmail.com
Signed-off-by: En-Wei Wu <en-wei.wu@canonical.com>
Link: https://patch.msgid.link/20240705023756.10954-1-en-wei.wu@canonical.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index ba14d83353a4b..cf1eb41e282a9 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -136,6 +136,8 @@ static struct ieee80211_supported_band band_5ghz = {
 /* Assigned at module init. Guaranteed locally-administered and unicast. */
 static u8 fake_router_bssid[ETH_ALEN] __ro_after_init = {};
 
+#define VIRT_WIFI_SSID "VirtWifi"
+
 static void virt_wifi_inform_bss(struct wiphy *wiphy)
 {
 	u64 tsf = div_u64(ktime_get_boottime_ns(), 1000);
@@ -146,8 +148,8 @@ static void virt_wifi_inform_bss(struct wiphy *wiphy)
 		u8 ssid[8];
 	} __packed ssid = {
 		.tag = WLAN_EID_SSID,
-		.len = 8,
-		.ssid = "VirtWifi",
+		.len = strlen(VIRT_WIFI_SSID),
+		.ssid = VIRT_WIFI_SSID,
 	};
 
 	informed_bss = cfg80211_inform_bss(wiphy, &channel_5ghz,
@@ -213,6 +215,8 @@ struct virt_wifi_netdev_priv {
 	struct net_device *upperdev;
 	u32 tx_packets;
 	u32 tx_failed;
+	u32 connect_requested_ssid_len;
+	u8 connect_requested_ssid[IEEE80211_MAX_SSID_LEN];
 	u8 connect_requested_bss[ETH_ALEN];
 	bool is_up;
 	bool is_connected;
@@ -229,6 +233,12 @@ static int virt_wifi_connect(struct wiphy *wiphy, struct net_device *netdev,
 	if (priv->being_deleted || !priv->is_up)
 		return -EBUSY;
 
+	if (!sme->ssid)
+		return -EINVAL;
+
+	priv->connect_requested_ssid_len = sme->ssid_len;
+	memcpy(priv->connect_requested_ssid, sme->ssid, sme->ssid_len);
+
 	could_schedule = schedule_delayed_work(&priv->connect, HZ * 2);
 	if (!could_schedule)
 		return -EBUSY;
@@ -252,12 +262,15 @@ static void virt_wifi_connect_complete(struct work_struct *work)
 		container_of(work, struct virt_wifi_netdev_priv, connect.work);
 	u8 *requested_bss = priv->connect_requested_bss;
 	bool right_addr = ether_addr_equal(requested_bss, fake_router_bssid);
+	bool right_ssid = priv->connect_requested_ssid_len == strlen(VIRT_WIFI_SSID) &&
+			  !memcmp(priv->connect_requested_ssid, VIRT_WIFI_SSID,
+				  priv->connect_requested_ssid_len);
 	u16 status = WLAN_STATUS_SUCCESS;
 
 	if (is_zero_ether_addr(requested_bss))
 		requested_bss = NULL;
 
-	if (!priv->is_up || (requested_bss && !right_addr))
+	if (!priv->is_up || (requested_bss && !right_addr) || !right_ssid)
 		status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 	else
 		priv->is_connected = true;
-- 
2.43.0



