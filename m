Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630A752ED2F;
	Wed, 23 Sep 2026 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174217; cv=none; b=o9xqXyWVYtMh/b6v9QsbW1MUp0nkWlmfoo5TjciDw8c07O9V/TtTze+JJOuKCxZIBdmYlYnsSdvJVdiL1QyR6CtMmMJOIMUFR8spXpdPry4AF/ErwmTv4NwJhLa+oqzbvvcuGciB3mfSYsw093wQvw1guuIR1GqDA5rx8AGDHjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174217; c=relaxed/simple;
	bh=XOvV5BNMLjrv2BASdNs/ioso6+7B5iWi1v4ZiT3Cq64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjZ8Ah70a1VKkaed+In70OdDiT8krzCrd85lqbTUHcATK3ErI4QlXGRLW/L61KinX42hJkIFAxbZIwe7LDXwq5pJRGXJsPm8zoKUef89N3FPeAV4LA9Oy8fM9/HTZiyyZObFUx1f8QWL5UwcgPgarOB3GtmpJTfNLW9l0ogtk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tON7KZUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tON7KZUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBABE1F00898;
	Wed, 23 Sep 2026 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174216;
	bh=5D4LiDnwEDeP+FOIrznekP96tJ8lM7P1K0Xxrpt5rcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tON7KZUyTmO6CQ6H8Wl64tr3MICDyZF7spdDk3XNkCe4ChS2FKHP+zamhdFWOJ71H
	 07Pa4GPh3utVcjFfnOAucTqenp6vZSJMm1T8OWlviQI51nAHEBLkNifrPX54xho8PF
	 SzHOnNV8pI8LOHqLHh6TgoXC9p9t0wJoBCW7p2N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/398] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Wed, 23 Sep 2026 16:02:01 +0200
Message-ID: <20260923140644.643509754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index b7472e19dd608..32a6e9ca2a469 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -201,7 +201,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -209,6 +209,9 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
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



