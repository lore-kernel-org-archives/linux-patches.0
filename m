Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC1B253932;
	Mon, 23 Mar 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278462; cv=none; b=htuZ+AJtyCrb+8Zr+oknfnf6rGREQLq+j1Rz5TvPTq05kjtTCW+z7ZQ4TRauOAxG+U+DIC5ShDeXZmMq+aSTKWy2Fb5EaK3d9/XFO9r4XvuZ+kpENQxmr2qBOax4CI/dgGAKP9yL1jyWKZ3gXlxzoHxoejHhBIOjg6aNijaoT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278462; c=relaxed/simple;
	bh=lYhz9Jp99qhYY4eRKO/SH8xePh/gSoMskOfe4tEgVRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLkHRhA5psVHoKImgq/x2s/zU2MZyEcTnOMlG0ux+ZypaGP+eIhc21clFriw5j0OfGtUsL36OC7QbyP0oHeBw1B0w3QRhquV4BCvB82IVAi/0QHFI9Fy2QGwKNEDzmwaUMIok66sA2/cJ2FpaDD0f5pQmOR7+0t+JYInWoiCxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2s7PRwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2s7PRwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9F9C2BCB1;
	Mon, 23 Mar 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278462;
	bh=lYhz9Jp99qhYY4eRKO/SH8xePh/gSoMskOfe4tEgVRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2s7PRwD6Hond2SkTkon8Mq8g45DgJdPeYxsAxp15R06TOTa4poHLLyn+PcjYuqfs
	 ykLjJ2y16OaSC2Pf2QHCt62RnY2yQwybMuuNsT6/K/e8uDL0qNZDGuEc92bIxmLZcd
	 Ne7wQNSgowAL/+zf58rJcQNPgrZFW7dJ2tKTdIQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Navaneeth K <knavaneeth786@gmail.com>
Subject: [PATCH 6.6 314/567] staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()
Date: Mon, 23 Mar 2026 14:43:54 +0100
Message-ID: <20260323134541.595358408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f0109b9d3e1e455429279d602f6276e34689750a upstream.

Just like in commit 154828bf9559 ("staging: rtl8723bs: fix out-of-bounds
read in rtw_get_ie() parser"), we don't trust the data in the frame so
we should check the length better before acting on it

Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Tested-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Navaneeth K <knavaneeth786@gmail.com>
Link: https://patch.msgid.link/2026022336-arrange-footwork-6e54@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -186,20 +186,25 @@ u8 *rtw_get_ie_ex(u8 *in_ie, uint in_len
 
 	cnt = 0;
 
-	while (cnt < in_len) {
+	while (cnt + 2 <= in_len) {
+		u8 ie_len = in_ie[cnt + 1];
+
+		if (cnt + 2 + ie_len > in_len)
+			break;
+
 		if (eid == in_ie[cnt]
-			&& (!oui || !memcmp(&in_ie[cnt+2], oui, oui_len))) {
+			&& (!oui || (ie_len >= oui_len && !memcmp(&in_ie[cnt + 2], oui, oui_len)))) {
 			target_ie = &in_ie[cnt];
 
 			if (ie)
-				memcpy(ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(ie, &in_ie[cnt], ie_len + 2);
 
 			if (ielen)
-				*ielen = in_ie[cnt+1]+2;
+				*ielen = ie_len + 2;
 
 			break;
 		}
-		cnt += in_ie[cnt+1]+2; /* goto next */
+		cnt += ie_len + 2; /* goto next */
 	}
 
 	return target_ie;


