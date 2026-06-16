Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7621A682B;
	Tue, 16 Jun 2026 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623969; cv=none; b=oNVZ+cJnww8ERT4VuFBoh9vot+vnQklMKwyrzW5NtBowZJjdgA6/x04lTM1RmDm7P6GIfZq522CWgcsZyLB0mJb61i+/klFDjZAVA59NrorWlb9nuf5H0YoQSsvnWZIzsRanmy31kB0nfvSIiGCsDIEFt7jXM1vkywno9+sZw4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623969; c=relaxed/simple;
	bh=lvsosTbp97r1j+CfVcKZM7t1o+q3yGEfDr7UlhQ0Py0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M69VXTIVqVURNoKGIE6ygawWE5B63BS1xRbGnwLspLkkvBMNX6vSSo0SQmL71GU9e3jg2qgKXdvK+06297Io7UAaXL8TYSvQ824dwzVGKUfVDfhH1my0pWV4ZUVnWmy6eg2ynfu08nPWbo/I34a2Z45cAigpZtuhiwvGe6vIMkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Crj/hR4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Crj/hR4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681631F00A3A;
	Tue, 16 Jun 2026 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623968;
	bh=PrpmMfZw4q0hjNEPAK7SQNoxDXzA6ZMPHrHqIMasvPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Crj/hR4Co+4D4zbWjmrapbzaFm6JAZipn7o2/vQ/InxggHd3TLoJtMFLnFQKymPY/
	 /cy13PTwLSJgjxTB2SKV1xeGY+BavZrqjqV4WLzLrnpn8rEsmOE3xoYSnHAIOD1Vsy
	 KuTlizXnSLJCwvTubB7pCO2QxNvKeETU6tDiR3YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Salman Alghamdi <me@cipherat.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 7.0 248/378] staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction
Date: Tue, 16 Jun 2026 20:27:59 +0530
Message-ID: <20260616145123.237310662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 		if (rtw_get_wps_ie(pnetwork->network.ies + _FIXED_IE_LENGTH_, pnetwork->network.ie_length - _FIXED_IE_LENGTH_, NULL, &wps_ielen))
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
 


