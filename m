Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510F1F6691;
	Tue,  3 Dec 2024 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238442; cv=none; b=Yn8OIpF5YDAyhnBBfsjyDOQP95eiTAJpDiIHhRDKbFX/oCt1MgESL8vsK7LY5MmNo6spZk06IgZUDLiZQsaInhWZunMXrviXcOFA5P3YVCwACcRcvDFoblIw3zNYFnreNjGLN51fbKe6IaPDSTHRAiG1UNlBjWQUXvHxowW360o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238442; c=relaxed/simple;
	bh=FNxd6J1liP/EgOIXfpDvfYUNDCWE0mDjcWPMzsCujTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jq5u+CT9gMhxdSa88Q8pfkdb5LH+gDXna9NZO27cRmErm/S6MYsZ3Mxn19Ku7FnPhPPG+E7ZKwBVhiF59ZtvNsANaVYWlFHozUXpB+Ba33HP+JMfTVHF7G/cYJiYacNxI9Zuubt+NM4NkX2HBcBNhl38wrxjGpY0DZw3YHCTmeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKzmebcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKzmebcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86838C4CECF;
	Tue,  3 Dec 2024 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238441;
	bh=FNxd6J1liP/EgOIXfpDvfYUNDCWE0mDjcWPMzsCujTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKzmebcC+SV4iu+4ZgXIIXFpXX/HfuYHEAM0/Z3PJJQY4Oy+kUDBCliiB8d6NBru9
	 15+TvXkDF+ukmOzoOLnzzjNQ7+fOFq22YbgrkKpM17vGnBjt1r9Wxe+Kc/Au/PE72W
	 DGymgov21t4YZxtR9F91My4ffctBr2lia0f+m3OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Marek Vasut <marex@denx.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 279/817] wifi: wilc1000: Set MAC after operation mode
Date: Tue,  3 Dec 2024 15:37:31 +0100
Message-ID: <20241203144006.697127461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



