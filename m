Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB11A1C8FC4;
	Tue, 27 Aug 2024 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770976; cv=none; b=uo4gQvlMKnTKRkR/L/AA6trweJG4uOlghELzXIWKtLlwMu4MCDEE9caHUDdS7MSxwjvtf3W6R7XmqGCKA+08nC9P6WvbUerAn5juwLwt47x5LfNbdD0rF5QhXKMESTyCzz8vLtJapBjsYMW1ENDmuSEt1AhU8osGX+1GNOKR1fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770976; c=relaxed/simple;
	bh=c8MRR+iMxxerwivBq1bJce6UQLRur8XPgMwylWusI+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt8QsDZ/k3VxluMDdHy3rfp0z7sSchnEPsHXG8JwZ+IGZEDAT86bIdQ76m8oEmPCfjjQ+6rkTxq/syJoI/4aut9URX6lWYO0N2E7qyaPp3KCRUsOUQxV4g4wVfkdsSC0TMADK6oRWnE3RYdJNc4UeWHJR05E3pYI2i3Bw3JmjWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAHo7Dr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAHo7Dr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A0FC61043;
	Tue, 27 Aug 2024 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770975;
	bh=c8MRR+iMxxerwivBq1bJce6UQLRur8XPgMwylWusI+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAHo7Dr9SdWtxq1H0CO4UFxxwQZQTz90+1dJ3T9h8bRn45geh2ncwJKBeyZEmmj2B
	 7FjwLi93Wa7Fz3Q4C1O8c44zeHCgYOgFeG8gu05xb7kpPl/ruhTw+dOv/pmH626Dkc
	 p9xXhINxANs84IpR9e+1dMG+yhTtyEZz/PDDnv34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.10 049/273] wifi: brcmfmac: cfg80211: Handle SSID based pmksa deletion
Date: Tue, 27 Aug 2024 16:36:13 +0200
Message-ID: <20240827143835.264966263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 2ad4e1ada8eebafa2d75a4b75eeeca882de6ada1 upstream.

wpa_supplicant 2.11 sends since 1efdba5fdc2c ("Handle PMKSA flush in the
driver for SAE/OWE offload cases") SSID based PMKSA del commands.
brcmfmac is not prepared and tries to dereference the NULL bssid and
pmkid pointers in cfg80211_pmksa. PMKID_V3 operations support SSID based
updates so copy the SSID.

Fixes: a96202acaea4 ("wifi: brcmfmac: cfg80211: Add support for PMKID_V3 operations")
Cc: stable@vger.kernel.org # 6.4.x
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240803-brcmfmac_pmksa_del_ssid-v1-1-4e85f19135e1@jannau.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   13 +++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4320,9 +4320,16 @@ brcmf_pmksa_v3_op(struct brcmf_if *ifp,
 		/* Single PMK operation */
 		pmk_op->count = cpu_to_le16(1);
 		length += sizeof(struct brcmf_pmksa_v3);
-		memcpy(pmk_op->pmk[0].bssid, pmksa->bssid, ETH_ALEN);
-		memcpy(pmk_op->pmk[0].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
-		pmk_op->pmk[0].pmkid_len = WLAN_PMKID_LEN;
+		if (pmksa->bssid)
+			memcpy(pmk_op->pmk[0].bssid, pmksa->bssid, ETH_ALEN);
+		if (pmksa->pmkid) {
+			memcpy(pmk_op->pmk[0].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+			pmk_op->pmk[0].pmkid_len = WLAN_PMKID_LEN;
+		}
+		if (pmksa->ssid && pmksa->ssid_len) {
+			memcpy(pmk_op->pmk[0].ssid.SSID, pmksa->ssid, pmksa->ssid_len);
+			pmk_op->pmk[0].ssid.SSID_len = pmksa->ssid_len;
+		}
 		pmk_op->pmk[0].time_left = cpu_to_le32(alive ? BRCMF_PMKSA_NO_EXPIRY : 0);
 	}
 


