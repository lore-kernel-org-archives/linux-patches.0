Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083C436E484;
	Sat, 12 Sep 2026 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207614; cv=none; b=KynJEKQpl5mWXpwgp4PSods/XI7U+LBna9zLao8Iswb7a/Vge0qULrQh38hRafE3uJj2i/HtPdWCsNBv+6BDA3B6fzdMMteyJVIIgK8B74aNTX/K7fSsEnIfz0rFkvrq9ASyIDUFGyvc6ehKgF2oR5qe9DGmDtNbbUSiDG7r4Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207614; c=relaxed/simple;
	bh=0+6M5gRMFxCkx3xS5FIJCplWSbXPh2qd3OPX/AQMT7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjY8KoH0QIB2UNV5wQXnu3Ty6I5GezD8Ml/xFL+tP/0lJwgPOduUNjDxC6d5wHSLZiC1+z39bcPB41ohyCVymK13NTCYGQa2Jfafa+YqjFjZIeP3V+j9PCPw8W1tXcx9zscQPJ+kXiTV75Ct0RsIOX0tvvE7QystE9wXqbqMdho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ma6hd1sY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ma6hd1sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11AE1F000FF;
	Sat, 12 Sep 2026 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207612;
	bh=N7qd6lDtlvM6HJyINYJE4kqbWTdNRGebqEuAkMTYsps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ma6hd1sYmm2sV28EehZj+sFyoA7bkyUpXMZYVCiIqawQ1EoR4cjHYwjHNh6AIs9/E
	 4yi/0adLDjV8ZG8XidcAcJOMamD0HW1h229lzq4/H8AJkvwfnVIEgiSqX/gXDgMN67
	 X18JeeFaaJaWX8GtlP/aqA8BXK+3mDldbMgom/MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0447/1518] staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths
Date: Sat, 12 Sep 2026 08:43:36 +0200
Message-ID: <20260912065633.561614740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 41b8209376dffbd7b0b85c8bc4697d9166ac62ef ]

issue_beacon(), issue_probersp() and issue_asocrsp() obtain a management
xmit_frame together with its xmit_buf from the driver's fixed-size
management-TX pools via alloc_mgtxmitframe(). On the normal path the frame
is handed to dump_mgntframe(), which transfers ownership and eventually
returns both objects to their pools (the frame and, for beacons, the buf
in rtl8723bs_mgnt_xmit(); other bufs via the pending-xmitbuf/TX-completion
path).

Several error/edge paths return early after a successful
alloc_mgtxmitframe() but before dump_mgntframe(), so ownership is never
transferred and neither object is freed:

  - issue_beacon(): beacon larger than 512 bytes
  - issue_probersp(): cur_network->ie_length > MAX_IE_SZ
  - issue_probersp(): kzalloc() of the SSID scratch buffer fails
  - issue_asocrsp(): pkt_type is neither ASSOCRSP nor REASSOCRSP

Because alloc_mgtxmitframe() removes the frame and buf from their free
lists (list_del_init) without placing them on any pending list, an
orphaned pair is on no list and referenced by nobody, so it is only
reclaimed at driver teardown. Repeated hits progressively exhaust the
management-TX pools until alloc_mgtxmitframe() returns NULL and the
interface can no longer send beacons or probe/assoc responses.

Free the frame and buffer on these paths, matching the existing correct
error handling in issue_assocreq().

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260715111710.295052-1-congnt264@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index 8f7b5e2dce2f5..8d33631ab8f0f 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -2248,8 +2248,11 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 
 	spin_unlock_bh(&pmlmepriv->bcn_update_lock);
 
-	if ((pattrib->pktlen + TXDESC_SIZE) > 512)
+	if ((pattrib->pktlen + TXDESC_SIZE) > 512) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	pattrib->last_txcmdsz = pattrib->pktlen;
 
@@ -2311,8 +2314,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	pattrib->pktlen = pattrib->hdrlen;
 	pframe += pattrib->hdrlen;
 
-	if (cur_network->ie_length > MAX_IE_SZ)
+	if (cur_network->ie_length > MAX_IE_SZ) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 		pwps_ie = rtw_get_wps_ie(cur_network->ies+_FIXED_IE_LENGTH_, cur_network->ie_length-_FIXED_IE_LENGTH_, NULL, &wps_ielen);
@@ -2359,8 +2365,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 			u8 *ies = pmgntframe->buf_addr+TXDESC_OFFSET+sizeof(struct ieee80211_hdr_3addr);
 
 			buf = kzalloc(MAX_IE_SZ, GFP_ATOMIC);
-			if (!buf)
+			if (!buf) {
+				rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+				rtw_free_xmitframe(pxmitpriv, pmgntframe);
 				return;
+			}
 
 			ssid_ie = rtw_get_ie(ies+_FIXED_IE_LENGTH_, WLAN_EID_SSID, &ssid_ielen,
 				(pframe-ies)-_FIXED_IE_LENGTH_);
@@ -2744,10 +2753,13 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 
 	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
 	pmlmeext->mgnt_seq++;
-	if ((pkt_type == WIFI_ASSOCRSP) || (pkt_type == WIFI_REASSOCRSP))
+	if ((pkt_type == WIFI_ASSOCRSP) || (pkt_type == WIFI_REASSOCRSP)) {
 		SetFrameSubType(pwlanhdr, pkt_type);
-	else
+	} else {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	pattrib->hdrlen = sizeof(struct ieee80211_hdr_3addr);
 	pattrib->pktlen += pattrib->hdrlen;
-- 
2.53.0



