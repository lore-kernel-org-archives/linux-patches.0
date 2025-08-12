Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773582FD1D1;
	Tue, 12 Aug 2025 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020603; cv=none; b=m2r7O2uNQYJdL8tZSF3XZasZEkybUojKYUtSTtOzpWSt+sPgisvp0HNRdaAweg+V48jQBfa/Ar/qpPUuyZaNxXckRmo//cc12quu1iF6XTunXQzRSgzMekMPjfxt9uLGqjEPqHqWXe0aDFbw4oUIgO4bhndJVP326nI5+VpNok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020603; c=relaxed/simple;
	bh=Qm6fA73OhwkGPy5VL+tBc62vLBtXOTsX0GOkZl2AHFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYuAl8QM3u5Wv1oyH12vTUhYuTh+Yo4DhbJFV/vNOONUUYUlFYCq7y3swmG1/I/1fXjzgBw0ggNP9CA7ZJ+TzKb0R/Hm3U7FooMnJP5A1unOKsw7HTQh3HHg6LUpk94Zm0s10rrTr1xa60heB0bw8ju/Jj1nkCyY9t8TajclCPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+99iFPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+99iFPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF602C4CEF0;
	Tue, 12 Aug 2025 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020603;
	bh=Qm6fA73OhwkGPy5VL+tBc62vLBtXOTsX0GOkZl2AHFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+99iFPv423Cfc63yHj4oojv8j4q87+tsRYBdLs/Nza7Un/tgVG8XRAvyOSTuklQs
	 btYLUT2pGsq9jXEQppSJnj8aODRkrVCQA8HShjrC8NsY72DEprbKZXI6bW+d1sHVdz
	 FwRgh7+OSpqjLaIk3BKOPghjfB3aryq1k/Pa3D9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/253] wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE
Date: Tue, 12 Aug 2025 19:28:35 +0200
Message-ID: <20250812172954.100088477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24a3d5a593f1..8b6e3cbaf463 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1200,10 +1200,6 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EAGAIN;
 	}
 
-	/* If scan req comes for p2p0, send it over primary I/F */
-	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
-		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
-
 	brcmf_dbg(SCAN, "START ESCAN\n");
 
 	cfg->scan_request = request;
@@ -1219,6 +1215,10 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
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



