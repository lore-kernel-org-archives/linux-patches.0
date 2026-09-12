Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCC234E75A;
	Sat, 12 Sep 2026 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201301; cv=none; b=LWZkSQd7GPiizJm1N1HTI9XXJBfK+gYnapIzMyUGS4fH1ZT+XIT2S+GrJc+MoDYSOO98mLt7MhNoWdtO2YXfp7BA7eUcGJOHAEnMlZT0O8sRD9fn+KqOQIBOYSNSbU//keKdVxfEM/3wrb6AE6G4LmdmlpIPRAg2xj68XvnnKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201301; c=relaxed/simple;
	bh=LWwT+pyTHzHiEERWIH3aN20OCVqO8BFZSyhNylsK+3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH4MZGHS5BNFnndMunaplIPrpTsXUEPGX43Er4CBqZbLZxR2xvSqVJKXILTmKnVfaG2oMkO1pyWCeNAKSjb/rnIOtzIGETiYXVXRjTCm1rO36amkpGCP4u3ENh+BWs0oW+RpJqSS/0xfm91orgecKHjfOdotu1P+6wxAlqhkxi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1j8pkwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1j8pkwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B373F1F000FF;
	Sat, 12 Sep 2026 08:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201299;
	bh=sPmfsDrNDbQfR5rufD483HHw9IxSlvroZNx+viXDbt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1j8pkwXNS4deMLeCmlcQA82I2yJ+ygl2+F5Xy9twDDKM4Vx1ZBGd8mGQRiRqrG2X
	 S3la6TROneIBReqG/HKaHSjnMaEmgHIIgmp7nqjnwErqQ9CS/n9aK02aPX6j9rPoMR
	 9i/pabKsQBi4XoSUf1A6GanWYlelrFyZJ93Eb5WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Huang <jason.huang2@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0969/1815] wifi: brcmfmac: fix P2P action frame handling without device vif
Date: Sat, 12 Sep 2026 08:45:19 +0200
Message-ID: <20260912065711.724999214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jason Huang <jason.huang2@infineon.com>

[ Upstream commit 1b1edb9ebed49099bdc924cef49a9aea8b552199 ]

Some P2P action frame paths assume the P2P device vif is always
available. That is not true when userspace sends non-P2P public action
frames through the primary interface, or when action-frame abort runs
after the P2P device vif has not been created.

Fall back to the primary vif when aborting an action frame without a P2P
device vif, and guard P2P device saved IE access before using it for
peer channel search.

Fixes: 30fb1b272909 ("brcmfmac: use actframe_abort to cancel ongoing action frame")
Fixes: 6eda4e2c5425 ("brcmfmac: Add tx p2p off-channel support.")
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260722082608.412472-1-Jason.Huang2@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 92c16a3173288..66557be28e7b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1283,6 +1283,9 @@ static s32 brcmf_p2p_abort_action_frame(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (!vif)
+		vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+
 	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe_abort", &int_val,
 					sizeof(s32));
 	if (err)
@@ -1819,6 +1822,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_if *ifp,
 	/* validate channel and p2p ies */
 	if (config_af_params.search_channel &&
 	    IS_P2P_SOCIAL_CHANNEL(le32_to_cpu(af_params->channel)) &&
+	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
 	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {
 		afx_hdl = &p2p->afx_hdl;
 		afx_hdl->peer_listen_chan = le32_to_cpu(af_params->channel);
-- 
2.53.0



