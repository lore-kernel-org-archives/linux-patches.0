Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB5F4EE870;
	Tue, 13 Oct 2026 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894114; cv=none; b=NbgOd9++rlLWKkhLxfczPaIOFwttiS2/C4ED8+jeIogGqEhgCzGGxWLfGeJhUEVtgoVV6yzXSyJqBLShvLMsBfpMCUVbd+VqiiOWhzj6vLHVKIKSFCbNVDaIVCAEjYTMErqoG4Fq3+cgOuAPLoiBq0QJUtkn5eqqKCVmqrCj8zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894114; c=relaxed/simple;
	bh=xlOeQUKkhSuJi8tomKcm1NQxCytL5Mz7w7XdUywGl6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+SGa/H6RSpN+0HTl8KKzeBfzA4bl7uOR4kgL7B6ZTPJSa6PPbWIf2YfbbV+jHYucIQQbmgwbBoeN5f4dRI0vf/sCMbhIuB8KuQZxZ+yo/kIRNYDvGIUWC/EtAONwZN2lJk2JhF/P17RGzSYvGwH5KdaovPPa1/m0fKn7yXtHOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmp0IqrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmp0IqrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E791F00893;
	Tue, 13 Oct 2026 12:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894112;
	bh=2+7QmMzrV93ndsEcbQ17PkzxzMYC7JwrcsUSRlbSHPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vmp0IqrBSfTPEMSzO7dXoT58JRzoy28tanrlVJtvH4ZLtzTSOh4L2bnRZ10+P8FrM
	 e9H7/E/1C4pTkI7DkCWusvVYfcaAS5ecvEQhzemjtrSEzM/iuf1Lq8C0ZBL2r0Yvfn
	 WFUEKlJYz8xuFlZRk0BurUnk1XlvMXdVO4w3qvDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Huang <jason.huang2@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/621] wifi: brcmfmac: fix P2P action frame handling without device vif
Date: Tue, 13 Oct 2026 13:37:27 +0200
Message-ID: <20261013112931.557565901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index e1752a513c733..c2511a5a11a49 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1281,6 +1281,9 @@ static s32 brcmf_p2p_abort_action_frame(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (!vif)
+		vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+
 	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe_abort", &int_val,
 					sizeof(s32));
 	if (err)
@@ -1817,6 +1820,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_if *ifp,
 	/* validate channel and p2p ies */
 	if (config_af_params.search_channel &&
 	    IS_P2P_SOCIAL_CHANNEL(le32_to_cpu(af_params->channel)) &&
+	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
 	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {
 		afx_hdl = &p2p->afx_hdl;
 		afx_hdl->peer_listen_chan = le32_to_cpu(af_params->channel);
-- 
2.53.0



