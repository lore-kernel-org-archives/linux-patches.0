Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F553803DC;
	Sat, 17 Oct 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258339; cv=none; b=AXAlK4Nd9gC1JcphNHGy+0TbZP2nVHACdJaR6+rbzV5kwlD4JRSrRI7CiT8BvhGvsWFx00XCj3zgEXC/QmdeEWyL1R5MPvvXQ9WYrGaFgvniT9Yq7vEgX2ZjmgN7kgj9X86uOWhSatlQrp9KBvgSt4pUMwWSs42q/TOoXQDMxQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258339; c=relaxed/simple;
	bh=tUOTnCPbWs+FVD+duUW5574WihJuJI1WiMNHYBz0ulA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fICbQWcRwldXekfw1CSsgN8U8yfII+XeYfkTYW/MhuqTDEk/T6q8Ei164UQixnBoKTWTE9d4HLMeMz3QG4tuuQoFCjLvlcEaqRjSza1TCKnFfcle480EhoLhcvlDR52IdDnLXKu035svhZEZr6fRvmt/6oCoQcH2KOBVGNh8shI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1S5xNsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1S5xNsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FFB1F000C4;
	Sat, 17 Oct 2026 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258338;
	bh=1hgtpazSVvPXX7gYBAfGtqVQWOoSP9FhtEiKlJDGCys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1S5xNsBLva9M87GzgydLxhKVm6v+zxr368Pr0+xUOOkh1fuyVtdWfb4uCCJ1U0ps
	 XCUNd11KGIWHDdMM9x4rg1MvrxTDrIYxXfg9oXfzI49ZmBcsfrUnOhWfLOHSKI1iSJ
	 63MCprQzwSs8XUKL9IISs165xth9QmNnVy+Kza5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0852/1674] staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths
Date: Sat, 17 Oct 2026 17:52:04 +0200
Message-ID: <20261017160452.993302209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 98b46182afd63..9125b6fed82bc 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -2259,8 +2259,11 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 
 	spin_unlock_bh(&pmlmepriv->bcn_update_lock);
 
-	if ((pattrib->pktlen + TXDESC_SIZE) > 512)
+	if ((pattrib->pktlen + TXDESC_SIZE) > 512) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	pattrib->last_txcmdsz = pattrib->pktlen;
 
@@ -2323,8 +2326,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	pframe += pattrib->hdrlen;
 
 
-	if (cur_network->ie_length > MAX_IE_SZ)
+	if (cur_network->ie_length > MAX_IE_SZ) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 		pwps_ie = rtw_get_wps_ie(cur_network->ies+_FIXED_IE_LENGTH_, cur_network->ie_length-_FIXED_IE_LENGTH_, NULL, &wps_ielen);
@@ -2371,8 +2377,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 			u8 *ies = pmgntframe->buf_addr+TXDESC_OFFSET+sizeof(struct ieee80211_hdr_3addr);
 
 			buf = rtw_zmalloc(MAX_IE_SZ);
-			if (!buf)
+			if (!buf) {
+				rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+				rtw_free_xmitframe(pxmitpriv, pmgntframe);
 				return;
+			}
 
 			ssid_ie = rtw_get_ie(ies+_FIXED_IE_LENGTH_, WLAN_EID_SSID, &ssid_ielen,
 				(pframe-ies)-_FIXED_IE_LENGTH_);
@@ -2765,10 +2774,13 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 
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



