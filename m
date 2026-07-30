Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2083947A4;
	Thu, 30 Jul 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427617; cv=none; b=uGyYMAJMu15699xeIiJW62fvzFPsl6meRVJHWZFdq0pgU2vKufGgOsSQi0cMdAGwV91Y/Mpjm3/phVRG2g0qY3Wlpxj9i1BpMI2CkIDoHuer56ZjgYeWiL2W4nXpc9tl58Fov4Sl51MsTqkHE7n+mgsSfIjePD9tGdGb4DRrGeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427617; c=relaxed/simple;
	bh=FStqTiecah2+nL1B0Mi2g4WveeinwWWBELzqlmKdqvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ed48DNwscyUiLn4qhsJlbWX3CWE7La9OpHnb6yQILLmtG0Uf1Pg3QxH5Q5halhz8jcohdvhAAUidIU6K+K8fuW/eshwzLQ2BkDk5h3rdXbiCpxBz++U1siOoChUqlQmRNTUEplAmCOBWnXQvkE3uOuNPzoSYEeXs8ZZdIcoj4nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPmJ+lIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPmJ+lIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553711F000E9;
	Thu, 30 Jul 2026 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427615;
	bh=g+s6biZBYXxrRD/KjMk0CTYdeMte2Z8K5upKaBSiLwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPmJ+lIXcYvb7cpg4JoY7fR2CZdrjdsaLmky5gv+IWUHkTkLweNpmR+VpNENHBKGL
	 IBOukpfXhmeGxsCb+yxtCrU7xgZWc11yJc+yffO0NkhNoZEg1zeQrkvA4vYeDt5FBY
	 xYQyN6fWoG0zb5mXb05YeoAR90ZVSu1Tq7kLaVJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shelley Yang <shelley.yang@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/484] wifi: brcmfmac: fix 802.1X-SHA256 call trace warning
Date: Thu, 30 Jul 2026 16:11:15 +0200
Message-ID: <20260730141427.335632299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shelley Yang <shelley.yang@infineon.com>

[ Upstream commit 7cb34f6c4fe8a68af621d870abe63bfca2275dd6 ]

Based on wpa_auth as 1x_256 mode, need to set up
"use_fwsup" with BRCMF_PROFILE_FWSUP_1X.
Or it will happen trace warning when call brcmf_cfg80211_set_pmk().

[ 4481.831101] ------------[ cut here ]------------
[ 4481.831102] WARNING: CPU: 1 PID: 2997 at
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:7242 brcmf_cfg80211_set_pmk+0x77/0xd0 [brcmfmac]
[...]
[ 4481.831202] Call Trace:
[ 4481.831204]  <TASK>
[ 4481.831205]  nl80211_set_pmk+0x183/0x250 [cfg80211]
[ 4481.831233]  genl_family_rcv_msg_doit+0xea/0x150
[ 4481.831237]  genl_rcv_msg+0x104/0x240
[ 4481.831239]  ? cfg80211_probe_status+0x2c0/0x2c0 [cfg80211]
[ 4481.831257]  ? genl_family_rcv_msg_doit+0x150/0x150
[ 4481.831259]  netlink_rcv_skb+0x4e/0x100
[ 4481.831261]  genl_rcv+0x24/0x40
[ 4481.831262]  netlink_unicast+0x236/0x380
[ 4481.831264]  netlink_sendmsg+0x250/0x4b0
[ 4481.831266]  sock_sendmsg+0x5c/0x70
[ 4481.831269]  ____sys_sendmsg+0x236/0x2b0
[ 4481.831271]  ? copy_msghdr_from_user+0x6d/0xa0
[ 4481.831272]  ___sys_sendmsg+0x86/0xd0
[ 4481.831274]  ? avc_has_perm+0x8c/0x1a0
[ 4481.831276]  ? preempt_count_add+0x6a/0xa0
[ 4481.831279]  ? sock_has_perm+0x82/0xa0
[ 4481.831280]  __sys_sendmsg+0x57/0xa0
[ 4481.831282]  do_syscall_64+0x38/0x90
[ 4481.831284]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 4481.831286] RIP: 0033:0x7fd270d369b4

Fixes: 2526ff21aa77 ("brcmfmac: support 4-way handshake offloading for 802.1X")
Signed-off-by: Shelley Yang <shelley.yang@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260525083859.581246-1-shelley.yang@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c7f62226ebbcc5..7146e32717cfcf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2122,7 +2122,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 				 sme->crypto.akm_suites[0]);
 			return -EINVAL;
 		}
-	} else if (val & (WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED)) {
+	} else if (val & (WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED | WPA2_AUTH_1X_SHA256)) {
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_8021X:
 			val = WPA2_AUTH_UNSPECIFIED;
-- 
2.53.0



