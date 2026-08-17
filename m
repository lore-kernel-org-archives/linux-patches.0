Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0898F442FC0;
	Mon, 17 Aug 2026 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977019; cv=none; b=SDJQd3PVkc2tE2kz7EcBjvgPyGJ2dw+OT6loG7JjBn1+oJNeIjoGdsOzLKXTxE8qPDq3tqzCYnhasLmMFZtw3DGY4H1FdNY+FJhiIRt1jLW0d+/sYDNC8VEDTE0huywoNqBLBwEHcgr/ZNz8xYwLo4mndFcGQNn4MOWGyeFVZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977019; c=relaxed/simple;
	bh=dq1BhHjvb6HJv9HFInbzG3v/NjY4nbiKua0axnR3AWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IomLJniH1TVraFeCWxVQNkmIdpokhmNH/szV2p3nfXDo/28m8mD9M7i3KArzoYLpF7w6/ln6nHOrlCqXsi8Vhk17V33bzxEqBDE46W72hIbvcnmDFozrC9X/f/mnOeZD2iYdxVoY3MHiw3NJgZPHBOnwUxglsjpBym7NvCZctP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWvghzde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWvghzde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8271F00A3E;
	Mon, 17 Aug 2026 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977017;
	bh=fWyjN6PRdPRqHtQ14PNxXAx4/RZS6Y5VcbwHKQv5FaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWvghzdeYe1h+9KhTc2gb3BRZgNCfGL/B8SHNTHPh8eq+4vNs+t0kDOlggWv4WiG5
	 pfI59GTFuS+k4TUl6SLKzy+3YmrIwumCtkLPr7+AuYtEvvXVo+zCIjN7rkiddQvQt0
	 Laem5dS+WLn92LsPVTiSaI3/7OuzBFmTm+yPvpfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Moksh Panicker <mokshpanicker.7@gmail.com>
Subject: [PATCH 5.15 182/456] staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()
Date: Mon, 17 Aug 2026 15:29:32 +0200
Message-ID: <20260817132547.245871760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit 0e95ff792ae0aa6fbad9455943e9e1e4062670e9 upstream.

rtw_get_wps_ie() iterates over IE data from network frames without
validating that the IE header and payload fit within the remaining
buffer before reading them. Specifically:

- in_ie[cnt + 1] is read without checking cnt + 1 < in_len
- memcmp(&in_ie[cnt + 2], ...) accesses cnt + 2 without bounds check
- in_ie[cnt + 1] is used as length without verifying payload fits

Add bounds checks at the top of the loop body to break early if fewer
than 2 bytes remain for the IE header, or if the declared payload
extends past the end of the buffer. Also require at least 4 bytes of
payload before comparing the WPS OUI.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Link: https://patch.msgid.link/20260625202911.26782-1-mokshpanicker.7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -694,7 +694,14 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
 	while (cnt < in_len) {
 		eid = in_ie[cnt];
 
-		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
+		if (cnt + 2 > in_len)
+			break;
+
+		if (in_ie[cnt + 1] + 2 > in_len - cnt)
+			break;
+
+		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (in_ie[cnt + 1] >= 4) &&
+		    (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
 			wpsie_ptr = &in_ie[cnt];
 
 			if (wps_ie)


