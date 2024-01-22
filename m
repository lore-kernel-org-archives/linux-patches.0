Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA5D12BF34;
	Tue, 23 Jan 2024 01:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971751; cv=none; b=CsGRXMYUv/WKH20jekGRolH0hst7wGBRHMni92IyAPBevuB6zwQp8cm5s/Y5T5t8kEgjBigvCu9lhOZQzY/KC7Wdp3KNjt5RTnYfH8yYIF71HZy5UqNnzivAN49P3qPwMDvTmlFRSkucIthaMuoLXB8mzY5ShT6YrL6zegE6NDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971751; c=relaxed/simple;
	bh=5++/wqWvnmzHKGNtTBNkQE8CHrrIZk7bGLBusokCTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aag0URR2fTvD+NZ4dfAIhYMU8Fi8zNrJZsx3Q+1KNQez3uRx+4/mZDv5Ylr14qk76+Ve53gqW06IAaX/jIaOuIE5av0XqlZPIdDeock9ItB6lUDe/uz6+SWlQxMt3wG/SvA1iV2kaiJjCMlc7dNlh7AfvJfZ7b6o1OBlw5CFTqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkwnDneV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkwnDneV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA77C43394;
	Tue, 23 Jan 2024 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971750;
	bh=5++/wqWvnmzHKGNtTBNkQE8CHrrIZk7bGLBusokCTHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkwnDneV+8USbgdt5Y2wYHf9lFXP0HB59szhFLJCEovS2Oqgk6OC8vwHOR53t6gXl
	 JHBdIpqUF3J7/Wci0AzyReDRXGUTsAgbW36hIN2kUtYBya2bxL/IjcLnKGAomIeqQy
	 GrJcrGwFuWfb+uTI0lT47aZN+tRpgpYMlgL3kQlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lin <yu-hao.lin@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Rafael Beims <rafael.beims@toradex.com>
Subject: [PATCH 6.1 310/417] wifi: mwifiex: configure BSSID consistently when starting AP
Date: Mon, 22 Jan 2024 15:57:58 -0800
Message-ID: <20240122235802.566754375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: David Lin <yu-hao.lin@nxp.com>

commit f0dd488e11e71ac095df7638d892209c629d9af2 upstream.

AP BSSID configuration is missing at AP start.  Without this fix, FW returns
STA interface MAC address after first init.  When hostapd restarts, it gets MAC
address from netdev before driver sets STA MAC to netdev again. Now MAC address
between hostapd and net interface are different causes STA cannot connect to
AP.  After that MAC address of uap0 mlan0 become the same. And issue disappears
after following hostapd restart (another issue is AP/STA MAC address become the
same).

This patch fixes the issue cleanly.

Signed-off-by: David Lin <yu-hao.lin@nxp.com>
Fixes: 12190c5d80bd ("mwifiex: add cfg80211 start_ap and stop_ap handlers")
Cc: stable@vger.kernel.org
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Tested-by: Rafael Beims <rafael.beims@toradex.com> # Verdin iMX8MP/SD8997 SD
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231215005118.17031-1-yu-hao.lin@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |    2 ++
 drivers/net/wireless/marvell/mwifiex/fw.h       |    1 +
 drivers/net/wireless/marvell/mwifiex/ioctl.h    |    1 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c  |    8 ++++++++
 4 files changed, 12 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2046,6 +2046,8 @@ static int mwifiex_cfg80211_start_ap(str
 
 	mwifiex_set_sys_config_invalid_data(bss_cfg);
 
+	memcpy(bss_cfg->mac_addr, priv->curr_addr, ETH_ALEN);
+
 	if (params->beacon_interval)
 		bss_cfg->beacon_period = params->beacon_interval;
 	if (params->dtim_period)
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -165,6 +165,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_STA_MAC_ADDR       (PROPRIETARY_TLV_BASE_ID + 32)
 #define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
+#define TLV_TYPE_UAP_MAC_ADDRESS    (PROPRIETARY_TLV_BASE_ID + 43)
 #define TLV_TYPE_UAP_BEACON_PERIOD  (PROPRIETARY_TLV_BASE_ID + 44)
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_BCAST_SSID     (PROPRIETARY_TLV_BASE_ID + 48)
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -107,6 +107,7 @@ struct mwifiex_uap_bss_param {
 	u8 qos_info;
 	u8 power_constraint;
 	struct mwifiex_types_wmm_info wmm_info;
+	u8 mac_addr[ETH_ALEN];
 };
 
 enum {
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -468,6 +468,7 @@ void mwifiex_config_uap_11d(struct mwifi
 static int
 mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 {
+	struct host_cmd_tlv_mac_addr *mac_tlv;
 	struct host_cmd_tlv_dtim_period *dtim_period;
 	struct host_cmd_tlv_beacon_period *beacon_period;
 	struct host_cmd_tlv_ssid *ssid;
@@ -487,6 +488,13 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, v
 	int i;
 	u16 cmd_size = *param_size;
 
+	mac_tlv = (struct host_cmd_tlv_mac_addr *)tlv;
+	mac_tlv->header.type = cpu_to_le16(TLV_TYPE_UAP_MAC_ADDRESS);
+	mac_tlv->header.len = cpu_to_le16(ETH_ALEN);
+	memcpy(mac_tlv->mac_addr, bss_cfg->mac_addr, ETH_ALEN);
+	cmd_size += sizeof(struct host_cmd_tlv_mac_addr);
+	tlv += sizeof(struct host_cmd_tlv_mac_addr);
+
 	if (bss_cfg->ssid.ssid_len) {
 		ssid = (struct host_cmd_tlv_ssid *)tlv;
 		ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);


