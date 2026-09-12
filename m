Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EB2332610;
	Sat, 12 Sep 2026 11:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212868; cv=none; b=H+3mr3X2roaCWWwVoRSCy0AOJ6+hY6DC6L4NFx9NfVwV9VFe4z0ktLVrD76hJRuiXv1NRGiJ5vwIurOZznZqSb9UPk6Wl/xc6NpnEqQewWmTjhH7B+8E4oEkPw8Nki0Z/MyNB6wC+/V9yYacKlf34fQp3LIeDtM4bhZlbduVZFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212868; c=relaxed/simple;
	bh=/YAdlZZTeEyGCeyC1MsXJTPG3I0R00kgASt94/0Pv6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUzXqqW9cKR1vTSIEg7vJceT7We1W3RwOFYxMGWOZ0MyZexbsMAJArtkmUcpR6/4SNVCdpAHt6WaC+EcODpbY2TuuenwT6utsWhpzSN5WsGfL9XLEgmmLCGvmqa7lTHLvftWm2JXP7Z6UcEnzQzSewXVgvbc9EV70SNbVq+bAx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm4hRxr0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm4hRxr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CF81F000FF;
	Sat, 12 Sep 2026 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212866;
	bh=MnnTD5CSCCaKQ+OUrAGaRGnTALg/yiJfvg/Y46LIDq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm4hRxr0OK7qdCU9nEQFmSnvLWW0Q6f9vl+H/REBNhYZ+7xbp2eldzHg4mMz+3vP6
	 jyhwx2m6DT2jKELjcUBPaKCe1gSk6lGQfJeQ1xCWyw+TeTZBAm3J9Y1a9jYbZf0Z56
	 IaFnTOoO6bJ90woTfCtJ+kpxXW5tqNfZvnOhVuZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Salman Alghamdi <me@cipherat.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 6.18 1517/1518] staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction
Date: Sat, 12 Sep 2026 09:01:26 +0200
Message-ID: <20260912065657.884302096@linuxfoundation.org>
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

From: Salman Alghamdi <me@cipherat.com>

commit 88e994c57a79f62d5338231d8d37ee8dd98baffe upstream.

Add guards to ensure ie_length is large enough before subtracting
fixed IE offsets to prevent unsigned integer underflow.

Fixes: 2038fe84b8bd ("staging: rtl8723bs: fix spacing around operators")
Fixes: d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
Closes: https://lore.kernel.org/linux-staging/DI2H39EAAFBZ.3KI5NWN02AQ2S@linux.dev/
Cc: stable <stable@kernel.org>
Signed-off-by: Salman Alghamdi <me@cipherat.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260513203455.31792-1-me@cipherat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -612,6 +612,8 @@ int rtw_is_desired_network(struct adapte
 	privacy = pnetwork->network.privacy;
 
 	if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS)) {
+		if (pnetwork->network.ie_length < _FIXED_IE_LENGTH_)
+			return false;
 		if (rtw_get_wps_ie(pnetwork->network.ies+_FIXED_IE_LENGTH_, pnetwork->network.ie_length-_FIXED_IE_LENGTH_, NULL, &wps_ielen))
 			return true;
 		else
@@ -625,11 +627,15 @@ int rtw_is_desired_network(struct adapte
 			bselected = false;
 
 		if (psecuritypriv->ndisauthtype == Ndis802_11AuthModeWPA2PSK) {
-			p = rtw_get_ie(pnetwork->network.ies + _BEACON_IE_OFFSET_, WLAN_EID_RSN, &ie_len, (pnetwork->network.ie_length - _BEACON_IE_OFFSET_));
-			if (p && ie_len > 0)
-				bselected = true;
-			else
+			if (pnetwork->network.ie_length < _BEACON_IE_OFFSET_) {
 				bselected = false;
+			} else {
+				p = rtw_get_ie(pnetwork->network.ies + _BEACON_IE_OFFSET_, WLAN_EID_RSN, &ie_len, (pnetwork->network.ie_length - _BEACON_IE_OFFSET_));
+				if (p && ie_len > 0)
+					bselected = true;
+				else
+					bselected = false;
+			}
 		}
 	}
 


