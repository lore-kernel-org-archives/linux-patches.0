Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5C644BCB8;
	Tue, 16 Jun 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626026; cv=none; b=Dkgcr19P2R7eTD5v3WAmpa0es0Xf/EOlH8mNSEhho5iswmC49yU73RS3nWt9AgFpTDt4YEvaRd7/gSjZVEmQgg8b7bxVOU3NzX1NbwIoC139FbHo3MWiU1tBZJ8Axi/OrwxiOm6sPqJZfnM5z3c3eFcohAWERtOPp/yRwV7IAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626026; c=relaxed/simple;
	bh=0P6Snh6Z0AqVewSpL8TlFyxutH8w52oMCmQcx0jq94U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaIOhZEC/tM7bwNbJ+7lM/Olv1Im4CKUSsdsgrbG4hqNHWd9v5pxcYPDUr5l6f/yFEdouQ9dzWs2tYBX68vkp8i+mIoOC8UG+qD/pF2dbKE3Nq86NcPd1g7fptpAy7FNRt1TZ1xN9UMLkXMkvoYTIsPtPVsuqCQWK4n1gw+ymXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln+h6tM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln+h6tM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A0D1F000E9;
	Tue, 16 Jun 2026 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626025;
	bh=jKNGkKoXl0Od7PbZfR6M8FMSrCYhgzyELCjUcsPBJjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln+h6tM4LBuzYTuFHaljTGCc3/RepIaBayFw+nTK51wXKdPlDCrei3UWKNRRXT4Rh
	 XqcPmouK76hz5DUB+hK8/SFGPnP6vcMA/5HpMiIBnWGBgByCDeMQl34IGHuc11W9z3
	 1VATEfoLAzhMKpp+2oLshCkx9LN7zzXkCJO3awsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Salman Alghamdi <me@cipherat.com>
Subject: [PATCH 6.18 209/325] staging: rtl8723bs: fix buffer over-read in rtw_update_protection
Date: Tue, 16 Jun 2026 20:30:05 +0530
Message-ID: <20260616145108.484196092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit 514ab98364595007d4557ecc85d7e5f012c504d3 upstream.

rtw_update_protection() is called with a pointer offset into the
ies buffer but the full ie_length is passed, causing a potential
buffer over-read.

Fixes: e945c43df60b ("Staging: rtl8723bs: Delete dead code from update_current_network()")
Fixes: d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-staging/DI2H39EAAFBZ.3KI5NWN02AQ2S@linux.dev
Cc: stable@vger.kernel.org
Signed-off-by: Salman Alghamdi <me@cipherat.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260508222649.23989-1-me@cipherat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -471,8 +471,11 @@ static void update_current_network(struc
 
 	if ((check_fwstate(pmlmepriv, _FW_LINKED) == true) && (is_same_network(&pmlmepriv->cur_network.network, pnetwork, 0))) {
 		update_network(&pmlmepriv->cur_network.network, pnetwork, adapter, true);
+		if (pmlmepriv->cur_network.network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+			return;
+
 		rtw_update_protection(adapter, (pmlmepriv->cur_network.network.ies) + sizeof(struct ndis_802_11_fix_ie),
-								pmlmepriv->cur_network.network.ie_length);
+								pmlmepriv->cur_network.network.ie_length - sizeof(struct ndis_802_11_fix_ie));
 	}
 }
 
@@ -1100,8 +1103,11 @@ static void rtw_joinbss_update_network(s
 			break;
 	}
 
+	if (cur_network->network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+		return;
+
 	rtw_update_protection(padapter, (cur_network->network.ies) + sizeof(struct ndis_802_11_fix_ie),
-									(cur_network->network.ie_length));
+									(cur_network->network.ie_length - sizeof(struct ndis_802_11_fix_ie)));
 
 	rtw_update_ht_cap(padapter, cur_network->network.ies, cur_network->network.ie_length, (u8) cur_network->network.configuration.ds_config);
 }


