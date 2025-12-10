Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9D127380A;
	Wed, 10 Dec 2025 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351990; cv=none; b=pcp+I3mf6Jt5RJad57el0PFkjkOHytaxEoUZkeptuIhGL2MK4LS8Gy+F8O1ci8pvdPAWQpZWXzVUQICsnWPT3mB6WAzgO6TDf9YWNoC5bsiT5ydo5U3BuEITiBo/sMVd1vtx4tAk5z0cHJyEfTQjai9/Q8+AJA7DDA7M3N0KHM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351990; c=relaxed/simple;
	bh=yJcL+t+XK8A8YrbEAErUF6TTOSrgv3syNiN/MPmRxGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pma7DXR9IZRlkY2vQ2B+FQK1plhIkRysmeVCO4ARgO5MQq62e8D2E5o1FUBWEFZFTyURor1swLpF3cY/GaB/BkIVdkzVmQVQ4nFhZyyuz22BOUEtz5LXFrPNA89VwhjQORO68gvTb0+jTYYm646Ry9vOEep9oZVpqqfTaKdc7iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3UHr6Ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3UHr6Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2860C4CEF1;
	Wed, 10 Dec 2025 07:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351990;
	bh=yJcL+t+XK8A8YrbEAErUF6TTOSrgv3syNiN/MPmRxGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3UHr6EcELTGGlvjZu77FjEM+y4Fc/mvv4vy9hqwraGaDyUywYeL3Rrwl8xboI0Lt
	 H9YDPoDQ3N0W5UpvvqxfZa4bhnz84NqUTyl+I0Djdo6Xje6JJ02w+UyM5IFEjMH9RH
	 BZTu0A8CTHB1AmsHI5RudfSMQVBLFaCR3IpdmRhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 47/49] staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing
Date: Wed, 10 Dec 2025 16:30:17 +0900
Message-ID: <20251210072949.334692604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,9 +579,11 @@ unsigned int OnBeacon(struct adapter *pa
 
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


