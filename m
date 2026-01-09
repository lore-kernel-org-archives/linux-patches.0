Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7F833987D;
	Fri,  9 Jan 2026 11:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959419; cv=none; b=QYItL5pOvs0hfKWfE397r+tI7n3a8TDm4CG0cOMnmBJJ3RT8rUwcXEF2GWCmqUkYfoepgocWcZ1INUVykkL3Sp3Q9OiQxGlkyGL2kPAX+vWmJLZAJbsL19P8tsGnkbD0nvxb/YEyuzlJdjdmBZ4qOYCGFB+1wIPWGwD8ZATzxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959419; c=relaxed/simple;
	bh=axpDNrF+gQaCJs9m1LrMd81MHTQOqv7+diMaiYkvNCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lF8jmbjJ3IEQ4XMT1/BVHUo8iT0eGx+K9BEKNPSp+TZzI/q+6Q5xfLgPyZM2tHteLr2HkScdiQbXkgSGpKgzFMrcWpmnAjj1DYZloG5bVWyg60jmQ6yZgEO5LONTDK6gsBanzinjuF3l4/cz5GK05i1kOY1I4ymy40GyLy2tlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMVL1dfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMVL1dfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2037FC16AAE;
	Fri,  9 Jan 2026 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959419;
	bh=axpDNrF+gQaCJs9m1LrMd81MHTQOqv7+diMaiYkvNCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMVL1dfzL/mcRWrPRM0XR6lkFKPvOeF/g2x/l82hKkF7uzzjzABys/5BIGmGUwaS7
	 KCDSxucd6DZSVwMSgh58GAdP/GLK0Y7K8aaa01Gbcl9tWNIC8RHkan3K9OVABfKyF6
	 AjAqejTMWy16leiaS5XISSpcXDXuvMwcqIGVtaPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 046/737] staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing
Date: Fri,  9 Jan 2026 12:33:05 +0100
Message-ID: <20260109112135.726918305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -580,9 +580,11 @@ unsigned int OnBeacon(struct adapter *pa
 
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


