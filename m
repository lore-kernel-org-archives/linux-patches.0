Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D239919CD06;
	Wed, 10 Dec 2025 07:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352205; cv=none; b=iuxIf++EW6S/uDBTqA9IMxXTURQ5cfzAfBsGBcVNzDcBpg53fAw4YWaEDAHOwlb+hZHVO+UsW3RR7XCzkkh3srLDhvr+e2/mDT/vIF3GG7tEfHYoql3hVW7bzx6UDjfSOS9apy2/tOcofujM2hKup3wyjno+sFcDkjTSat9Nfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352205; c=relaxed/simple;
	bh=xxeRq2QW6ieDwPHugxiLGOOWLDzSTfGEgioc9Ez3ZFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9StfJYIk5ELSebyZ9TPXs7lOz+UOB5AjbylNP2pd48S4OcOcoTFsbPAbJ3y9ECu3CHb+B+Q+CdxIb7jAk8DZTsJTfeWhEQR7x2zSf3kKRKizVDxzRWws4olEDmpPMizAHq8vn8rseSY0tzrx8hfKMGgjw3RYZjnPdVRYxwZzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WALMcHK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WALMcHK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76D1C116B1;
	Wed, 10 Dec 2025 07:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352205;
	bh=xxeRq2QW6ieDwPHugxiLGOOWLDzSTfGEgioc9Ez3ZFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WALMcHK94keuzQF3W/oot5HbQU7JBzZTe0/OVeRGhtspD5GfCPCzJg0l/Lgma4r5C
	 aoPUmnUnnK1cwOzNCsfWEYkt7w98mtsX0w/CJSqHnvlw/T161EGbnusJD8i4dQWMXT
	 /h9JK9+0BUe7+pi//fqx0ylyMpc5iMXmWFknE1xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 29/29] staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing
Date: Wed, 10 Dec 2025 16:30:39 +0900
Message-ID: <20251210072945.155447575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

From: Navaneeth K <knavaneeth786@gmail.com>

commit 502ddcc405b69fa92e0add6c1714d654504f6fd7 upstream.

The Extended Supported Rates (ESR) IE handling in OnBeacon accessed
*(p + 1 + ielen) and *(p + 2 + ielen) without verifying that these
offsets lie within the received frame buffer. A malformed beacon with
an ESR IE positioned at the end of the buffer could cause an
out-of-bounds read, potentially triggering a kernel panic.

Add a boundary check to ensure that the ESR IE body and the subsequent
bytes are within the limits of the frame before attempting to access
them.

This prevents OOB reads caused by malformed beacon frames.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -588,9 +588,11 @@ unsigned int OnBeacon(struct adapter *pa
 
 	p = rtw_get_ie(pframe + sizeof(struct ieee80211_hdr_3addr) + _BEACON_IE_OFFSET_, WLAN_EID_EXT_SUPP_RATES, &ielen, precv_frame->u.hdr.len - sizeof(struct ieee80211_hdr_3addr) - _BEACON_IE_OFFSET_);
 	if (p && ielen > 0) {
-		if ((*(p + 1 + ielen) == 0x2D) && (*(p + 2 + ielen) != 0x2D))
-			/* Invalid value 0x2D is detected in Extended Supported Rates (ESR) IE. Try to fix the IE length to avoid failed Beacon parsing. */
-			*(p + 1) = ielen - 1;
+		if (p + 2 + ielen < pframe + len) {
+			if ((*(p + 1 + ielen) == 0x2D) && (*(p + 2 + ielen) != 0x2D))
+				/* Invalid value 0x2D is detected in Extended Supported Rates (ESR) IE. Try to fix the IE length to avoid failed Beacon parsing. */
+				*(p + 1) = ielen - 1;
+		}
 	}
 
 	if (pmlmeext->sitesurvey_res.state == SCAN_PROCESS) {


