Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014E3A9637;
	Wed, 23 Sep 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172871; cv=none; b=E2736v1VMt2zPeVSFVPda3ZAzBuovf+6O5jXuDwoQ0jF1pb6jMrgsy8VbE1h//g+vLNx3MiDi6gGEE5nP7M79KxdzkbMY5RazWlkwodlF2sIF27Oi9Kss28+SXUkyQ8n0oaJQrpqF5ZonlUrsFBIOiTx3SILbpf6p+l21WN836g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172871; c=relaxed/simple;
	bh=SDcVENeGXLmfWLuGFUQHAcNM29V3T7wVO6cVqb8SzP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9htatfTG/o8c7NISAiWsUFl/QySl/cs1VSHKz8SzTasGxd+OV8gSEfUR2gqONaXlDypF7wI3z385OH2Dzr4E5x6Q7kumacI32CwaPRYvv/+0V6SKXoyPw9j9nAxB2y1Pl/EqwDo3xIMkNKfoyPZKE5g9kdqRdhFFiCEp8H/jfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml4wuPVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml4wuPVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1866C1F000FF;
	Wed, 23 Sep 2026 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172870;
	bh=vXWuKG+yfPkoSbtuCc/7h3C5BEznvhxJ+lsjXlp7fHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ml4wuPVAqpNbVaNpurQbpm8B8CvnagmhM0BkkIsOEQU3lIjbxAjatD+6BUXUv+NB8
	 +9VKDLSZ7HcPBdacb165cJsKI60u6xCltMcrRCnRUAW6mVtlCaLHLyhdHb4ngxUqF4
	 yGFnrLsw6Mp7dUGBU6nsglWrSqFP0GfO3g2i/og8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 050/438] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Wed, 23 Sep 2026 16:01:11 +0200
Message-ID: <20260923140646.084506968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bogdan Nicolae <bogdan.nicolae@gmail.com>

[ Upstream commit e2de8d5eb2984416affdd9559e55f37c7f1bbf47 ]

Zero out auth_status on initialization. Otherwise, garbage will
leak from the stack to the firmware (when ssid is less than 32 bytes
and/or when params->pmkid is set). Then, pass the params->pmkid to the
firmware (without it, the firmware caches a garbage PMKID on successful
authentication and denies a subsequent association request that includes
the PMKID).

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260807163418.487508-1-bogdan.nicolae@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5174b..c86d0bdde8326 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -208,6 +208,9 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 	ifp = netdev_priv(dev);
 	drvr = ifp->drvr;
 	if (params->status == WLAN_STATUS_SUCCESS) {
+		if (params->pmkid)
+			memcpy(auth_status.pmkid, params->pmkid,
+			       WLAN_PMKID_LEN);
 		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
 	} else {
 		bphy_err(drvr, "External authentication failed: status=%d\n",
-- 
2.53.0



