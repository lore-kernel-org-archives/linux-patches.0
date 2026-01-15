Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CE43271F2;
	Thu, 15 Jan 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498867; cv=none; b=cbSe63BMONi1pt/XP/7auUFcxG3qQFxj4ukddZl0QU7d6KTmUS9sgNZIJHl5TzqglBpTmjyEp222U5M4mlnLaSyK3pN5i8uKf30pUSonZ+iwZqLmMVP6HPHwavqJ/f0cECjITucxUA+sVpmjujSXNbUY5t2A4yFjkJP9s66euS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498867; c=relaxed/simple;
	bh=QWuVjbbJWXbZ4AfqrC9/yu5E6CeaDGLbPeYVQUHjfl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ms5iD7UewTg//e1h7woTG9WpO5nmlzID0Z3mvl7Lsk469qlu/JbYwovNg+2GH6kMzJBs/cnKFFS84aj3d/2z/M1SwdxYeyUsONZbGohMqSbdYeumbOmxDIrDaQUMV62Uy2aJv+xyUa1bvYhE6fR0VY6BbaFNp2lPj7zQkSYJJ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7icK8O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7icK8O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D03C19422;
	Thu, 15 Jan 2026 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498867;
	bh=QWuVjbbJWXbZ4AfqrC9/yu5E6CeaDGLbPeYVQUHjfl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7icK8O3by6lbohCSN61JiomTMBDuZmk90QNbscwXLM415Amx5IbEaZ2NavLAk8kc
	 4ZOvPJaIbeqR6OOo2fXUwfIO3/l0Em9CF961ZIypFWCjM4lPihptulDV3AQhIBG1NY
	 etxlUSu53TY+HHQU7zAqyIpfVrQIBCh+c25+ekwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 027/451] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Thu, 15 Jan 2026 17:43:48 +0100
Message-ID: <20260115164231.874871687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navaneeth K <knavaneeth786@gmail.com>

commit 6ef0e1c10455927867cac8f0ed6b49f328f8cf95 upstream.

The Supported Rates IE length from an incoming Association Request frame
was used directly as the memcpy() length when copying into a fixed-size
16-byte stack buffer (supportRate). A malicious station can advertise an
IE length larger than 16 bytes, causing a stack buffer overflow.

Clamp ie_len to the buffer size before copying the Supported Rates IE,
and correct the bounds check when merging Extended Supported Rates to
prevent a second potential overflow.

This prevents kernel stack corruption triggered by malformed association
requests.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -1281,6 +1281,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = _STATS_FAILURE_;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1288,7 +1291,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p !=  NULL) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


