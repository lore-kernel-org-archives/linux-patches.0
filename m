Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD21352FFC;
	Tue, 26 Aug 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217360; cv=none; b=T2aiLCsrulzVpbzxe0YA8cnPhTi7al7hzHGU4Qpt+lBTJdlTWgM7EjYtRYqhHwfOKDjBb4WPW9H2B1+ttT05COaI60yVYF0RU18yivhlWIOgj1h9HLj8x6ReI8Njy1BcwbOAwNVcufY9RgzPv5/rxb5rVb/b/sg9YTASku8nPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217360; c=relaxed/simple;
	bh=lz99SGiYtz0zcUwqM9NiPUkEFvzuXaOtut7YixvTAKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUquEC8YZ9/G1LSpFD/4S8Rx65HGpe3Q/qbhMO2MvtT+XngNyP2j5fhSkkzTvlslENVtAkQ/bTmzNGnTgTwQVIi6aiFumkkJVsBB0Eiz+C4kh2m2KrX50+38+VUmTH9Z+JKNts8jhYlYJxiXBEdCQyiqcPyQW8DG7CSEQOaX+6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNZJQ39S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNZJQ39S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D12C116D0;
	Tue, 26 Aug 2025 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217358;
	bh=lz99SGiYtz0zcUwqM9NiPUkEFvzuXaOtut7YixvTAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNZJQ39StlY9avE8LRjOviJmLOBVGHgYnyDJCMCln0gU8AJsy8vo1VGF9xqzLes13
	 HHAD4sXZ78f1J/uILQrzX96X8IbHqeOhqbBideDvnFQ+pS2+WCybP1hFI+IKGXz01M
	 2wxD6PJGmVU6lfXW8WbME9p5cQiqZ7LdofM2nsh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/523] wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE
Date: Tue, 26 Aug 2025 13:05:24 +0200
Message-ID: <20250826110927.337145616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>

[ Upstream commit 579bf8037b70b644a674c126a32bbb2212cf5c21 ]

After commit bd99a3013bdc ("brcmfmac: move configuration of probe request
IEs"), the probe request MGMT IE addition operation brcmf_vif_set_mgmt_ie()
got moved from the brcmf_p2p_scan_prep() to the brcmf_cfg80211_scan().

Because of this, as part of the scan request handler for the P2P Discovery,
vif struct used for adding the Probe Request P2P IE in firmware got changed
from the P2PAPI_BSSCFG_DEVICE vif to P2PAPI_BSSCFG_PRIMARY vif incorrectly.
So the firmware stopped adding P2P IE to the outgoing P2P Discovery probe
requests frames and the other P2P peers were unable to discover this device
causing a regression on the P2P feature.

To fix this, while setting the P2P IE in firmware, properly use the vif of
the P2P discovery wdev on which the driver received the P2P scan request.
This is done by not changing the vif pointer, until brcmf_vif_set_mgmt_ie()
is completed.

Fixes: bd99a3013bdc ("brcmfmac: move configuration of probe request IEs")
Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20250626050706.7271-1-gokulkumar.sivakumar@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index fbb5e29530e3..af06f31db0e2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1199,10 +1199,6 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EAGAIN;
 	}
 
-	/* If scan req comes for p2p0, send it over primary I/F */
-	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
-		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
-
 	brcmf_dbg(SCAN, "START ESCAN\n");
 
 	cfg->scan_request = request;
@@ -1218,6 +1214,10 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	if (err)
 		goto scan_out;
 
+	/* If scan req comes for p2p0, send it over primary I/F */
+	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
+		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+
 	err = brcmf_do_escan(vif->ifp, request);
 	if (err)
 		goto scan_out;
-- 
2.39.5



