Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4DE153800;
	Tue,  3 Dec 2024 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240844; cv=none; b=Ei4FMFWxV21YEWrLwssdoThOgvIpTx/ANK9MxVSSFH318lEZUjm2IT0lWiRHw1INwpKE8H+cSvgM/s4ORnU4Gfxqp7HxaRMfJXoYhWPfbSUqanEz8Dnz8OCq2VC/+0Lo2yh2yDF+hq8XUxssiEp2yYFOoJumourc0bE5Kr8SKTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240844; c=relaxed/simple;
	bh=Auu7U2Fbhl0ATMPaJB6w9U83Z8WI3QsBeh8CmPgwn4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCqbxprx8+5CWXELnXdS9K4IxfwPTGuheAs2ewRadMLyMS9ahZZP4hncJspZ7HrueVJ2Utu/B0jJ2W5Fg7BauxzhNSJ4Xg1x8/WREt4Hiaen+IadiCyDT8kyHalGPREB+030gjqPC90RlFUejlwqZYualtaFIQAS2gc7NNzlFQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUZjwK3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUZjwK3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B473AC4CECF;
	Tue,  3 Dec 2024 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240844;
	bh=Auu7U2Fbhl0ATMPaJB6w9U83Z8WI3QsBeh8CmPgwn4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUZjwK3oE5SdaD6CBCF5igdsFTYGcBl7IxnWSfVrsMqm2l7lFlFc3ZBE/Y20TkUov
	 OeTfCF7cIfZhPNgYql1S2ozBf7XyS1Hsl97GcQwq80h6TvOZYOnvM8vkPL3cDyYaKf
	 QXojBZ9Mp0KVzAQNJp2yKVPgNQucyZ8g+mpaUwCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Marek Vasut <marex@denx.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/826] wifi: wilc1000: Set MAC after operation mode
Date: Tue,  3 Dec 2024 15:39:39 +0100
Message-ID: <20241203144753.598386388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 29dd3e48b9bd88bf65a1e760126fa18d1def7b30 ]

It seems it is necessary to set WILC MAC address after operation mode,
otherwise the MAC address of the WILC MAC is reset back to what is in
nvmem. This causes a failure to associate with AP after the WILC MAC
address was overridden by userspace.

Test case:
"
ap$ cat << EOF > hostap.conf
interface=wlan0
ssid=ssid
hw_mode=g
channel=6
wpa=2
wpa_passphrase=pass
wpa_key_mgmt=WPA-PSK
EOF
ap$ hostapd -d hostap.conf
ap$ ifconfig wlan0 10.0.0.1
"

"
sta$ ifconfig wlan0 hw ether 00:11:22:33:44:55
sta$ wpa_supplicant -i wlan0 -c <(wpa_passphrase ssid pass)
sta$ ifconfig wlan0 10.0.0.2
sta$ ping 10.0.0.1 # fails without this patch
"

AP still indicates SA with original MAC address from nvmem without this patch:
"
nl80211: RX frame da=ff:ff:ff:ff:ff:ff sa=60:01:23:45:67:89 bssid=ff:ff:ff:ff:ff:ff ...
                                          ^^^^^^^^^^^^^^^^^
"

Fixes: 83d9b54ee5d4 ("wifi: wilc1000: read MAC address from fuse at probe")
Tested-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241003132504.52233-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 9ecf3fb29b558..8bc127c5a538c 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -608,6 +608,9 @@ static int wilc_mac_open(struct net_device *ndev)
 		return ret;
 	}
 
+	wilc_set_operation_mode(vif, wilc_get_vif_idx(vif), vif->iftype,
+				vif->idx);
+
 	netdev_dbg(ndev, "Mac address: %pM\n", ndev->dev_addr);
 	ret = wilc_set_mac_address(vif, ndev->dev_addr);
 	if (ret) {
@@ -618,9 +621,6 @@ static int wilc_mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	wilc_set_operation_mode(vif, wilc_get_vif_idx(vif), vif->iftype,
-				vif->idx);
-
 	mgmt_regs.interface_stypes = vif->mgmt_reg_stypes;
 	/* so we detect a change */
 	vif->mgmt_reg_stypes = 0;
-- 
2.43.0



