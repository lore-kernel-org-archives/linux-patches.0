Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC2305E0D;
	Wed, 10 Dec 2025 07:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352202; cv=none; b=GUd8pzy3XEBiszGf9V3nIUPBzmBcj4BE1pTACXo6zB25giejetJiVm4nJoXMkCu8Tavoi3wjbPifQTBnfZpAU+OKiQqSWOdvg65GUYz2soy4xd9Ys6oStPJoWd1A6t0QzKYwccLEDNO1buObpme17ALcjjMY99gkIOnR5g7sLwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352202; c=relaxed/simple;
	bh=VjMAG9igzG3FeUzKMqxO09k75aRrXVoyppKf0Wjeib0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8c6w8/LPatMx8YDNZZ6nxL6K627wyKyNF+x1FlSxPrDT955dZ0Eb5p9R8kkVSb1VRNZKDkPOjJ53Pxotzwy+0QqHU8Lc+E3IFg+EUivrC1yc7TeZ32mF2XHIepyNQh7Quk1l4MhOenZ9plKyQxvM9RU182KhfHl1RRUeAkCDJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5FVkf7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5FVkf7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EE6C19422;
	Wed, 10 Dec 2025 07:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352201;
	bh=VjMAG9igzG3FeUzKMqxO09k75aRrXVoyppKf0Wjeib0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5FVkf7/JlIYLboDFdx/DAVtRKnKucPkBH/LDJQmGodbx4M6V+aaNnHaQvJmCgLD3
	 lvNqtI/cVuoC3WisHEOnm9LGX9CYMjt8T4IUxZN38l7Y/OqyewglIQB6f2rgyub+cg
	 /EjoRRnBN2FrflfhBupPz67Gi+Erl/90NHRDlYyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 28/29] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Wed, 10 Dec 2025 16:30:38 +0900
Message-ID: <20251210072945.128283276@linuxfoundation.org>
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
@@ -1042,6 +1042,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = WLAN_STATUS_CHALLENGE_FAIL;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1049,7 +1052,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


