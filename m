Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62F72F8BE7;
	Tue, 12 Aug 2025 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021343; cv=none; b=YC+g54/PJ36afiQKJDUnXqowB7vc/o7iEGl6rjBiCx9jMxGMWkDqaNWgWXRKfAWEfwyk+O/TisZGpu2MEhJ9UEVNn1i/b2PfgUltul3J+HMIcJ9HUj0NfLTzv6s3tjMNsakLDizyUpuGbvYRBYZqi65QHlmXuQwhSEDIqicf7+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021343; c=relaxed/simple;
	bh=2rkDWEW1p09t9H1CwlR1nZp5QHmJ5PRtSF7ErPbeDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb2JrZ/Zjh+2WQqFKzCWKeLyjlVB7Yau3J5An8gDvHWpMIaurU9R6MBxuuM8i+aenzzp2ehtJpuLxLMboJGCsZzUjWNv3xeB7lPyDmCfNO7OLGDAXZuFGgdq6lvByXuPdC4485B4V2mT/0LcPj1OpxmOQ3wFjAtMLAQjGLi+uAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0qdoHUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0qdoHUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55771C4CEF1;
	Tue, 12 Aug 2025 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021342;
	bh=2rkDWEW1p09t9H1CwlR1nZp5QHmJ5PRtSF7ErPbeDY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0qdoHUtRmBpfv3slLKn2vZYUljQVeHOUXfdtbLUvIXeHS3X/VCFB+1xrawMTgPGf
	 GPZTOwXd06sEr0AZHvkxn7Vt6hAgZvP/4PY00WQ+o4jl0Y/JI6j9HC67mDKJ2WYlLC
	 pAlcoIYlulDFsCI5Bie5uLw60elgvv10TrKzf300=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/262] wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE
Date: Tue, 12 Aug 2025 19:27:57 +0200
Message-ID: <20250812172956.853881606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c708ae91c3ce..e883cf80f506 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1541,10 +1541,6 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EAGAIN;
 	}
 
-	/* If scan req comes for p2p0, send it over primary I/F */
-	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
-		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
-
 	brcmf_dbg(SCAN, "START ESCAN\n");
 
 	cfg->scan_request = request;
@@ -1560,6 +1556,10 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
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



