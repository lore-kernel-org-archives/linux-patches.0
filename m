Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BE72DA76C;
	Tue, 21 Jul 2026 20:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665026; cv=none; b=hE0s6MSGUZ4J1OkDfkrXncQL5ePvn4oU7PCW2cFuCBeozz9I84uGpLHpPyP4ecjIGlQ6q7hKLgRrFo+TluPDTDzzCboZgbJt3qhm4xkhMH1xBnpv2Gj+qQPdaXRO6FPL4wO4KGKZUOEworETd+/Tc4OIvj2ZYgeUfmZAjzpSoRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665026; c=relaxed/simple;
	bh=VRmTiNXmV2Oqm03ds4kmikHy5z9jWdL5GfJEG1f1B9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFc0W/n6Z4/A7KyppCvmisczWtNMbaF8dPa8sobdq3Nx3fGX2u2IxUCpZFU5W6oMnHhhyeOhxbHDGTz3PzF/yeT55gjvC193aPkM8EwpmPp30OYJIJciiRXYoxT2Gav7AYkgHWSg9bJi+LVrhNSx+ZvKcLnqOOhaXtMEyyE7aUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8UP1D1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8UP1D1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3211F000E9;
	Tue, 21 Jul 2026 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665024;
	bh=bhxbYAAK6Wan3Z5bQjY63zO8fDk4r5kXJF56O4uVXdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8UP1D1CMefs4k3uujfVWOG/Vaba32mQdykJGyGirlUjsfPdzuZVUVv1QkmTae/9N
	 SQfwxEndKrJkHUknALjpTF62jt3NHRA9Hn88/GrDzC9oLJJdK8Eh6oeNU5/d8zpm3o
	 U4htY0d5Ks2cWFKqYXhYfLO2fxM4lH2/NvrZPABs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.6 0149/1266] staging: rtl8723bs: fix OOB read in update_beacon_info() IE loop
Date: Tue, 21 Jul 2026 17:09:46 +0200
Message-ID: <20260721152445.140463624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit ed51de4a86e173c3b0ef78e039c2e49e08b11f16 upstream.

The IE parsing loop in update_beacon_info() advances by
(pIE->length + 2) each iteration but only guards on i < len.
When a malicious AP sends a Beacon whose last IE has only one byte
remaining in the frame (the element_id byte lands at len-1), the loop
reads pIE->length from one byte past the allocated receive buffer.

Additionally, even when the header bytes are in bounds, pIE->length
itself can extend the data window beyond len, passing a truncated IE
to the handler functions.

Add two guards at the top of the loop body:
  1. Break if fewer than sizeof(*pIE) bytes remain (can't read header).
  2. Break if the IE's declared data extends past len.

Also replace i += (pIE->length + 2) with i += sizeof(*pIE) + pIE->length
for consistency with the sizeof(*pIE) guards added above.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-2-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -1332,7 +1332,11 @@ void update_beacon_info(struct adapter *
 	len = pkt_len - (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN);
 
 	for (i = 0; i < len;) {
+		if (i + sizeof(*pIE) > len)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pframe + (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN) + i);
+		if (i + sizeof(*pIE) + pIE->length > len)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -1357,7 +1361,7 @@ void update_beacon_info(struct adapter *
 			break;
 		}
 
-		i += (pIE->length + 2);
+		i += sizeof(*pIE) + pIE->length;
 	}
 }
 


