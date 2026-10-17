Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C19D3AAF70;
	Sat, 17 Oct 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255113; cv=none; b=exQCgcu0i4tZQMWA4T2BMQm1C7Vw4RMktKdpECPrGu3HYhIUw7fY0n+kA+WhCOfGON/4P5jve2/ldraIrcouHpox4hxMbsXMpzn4+Q9kR0bl5GLIE6c6QEUnTzVyocm/aaEAoF85EYDlrja4sT20nweWgIuVMTXSl0RIhgLjuIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255113; c=relaxed/simple;
	bh=pIC/K9PaYNk1Ai7PRWAlYn79uhb3GVEYkG+/0u8ANgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3JclMkyF9NTeI1JKcc+p1wMCzUixDlCfRCG0T20egT+hyoGs//TLdUdHetOZdfhFhkiYzLPnZXNUhlr6V3Bb9/heGLWJ+9M33YSrboZziid16tY3fdINetgkmU0YFZ1WoiQ3B1PrgCqGpfFskDjehr0hjJVkQZdjKj8eY0dJME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5s0AYu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5s0AYu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B771F000C4;
	Sat, 17 Oct 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255111;
	bh=szI3cEiO3miaUUg/caD+lEwYBORmLJ568bAMie+1nXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5s0AYu7e3atad1MO8gi5CuhE4fDUVWmI3PDY3cgZDP0ewYnvHn4zRwLz0ZhQrWCf
	 +BWh9iK6jN08gQfGaGd1jDh84pWzM/faIHjJOMcD43DrCt3fJaUbMmfSl2AeB2y+GN
	 ZxMZO/GWGMCakCB7a0g7qXRERaC9ZoGgz/vFkdh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Huang <jason.huang2@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 670/869] wifi: brcmfmac: fix P2P action frame handling without device vif
Date: Sat, 17 Oct 2026 17:58:31 +0200
Message-ID: <20261017160054.168835419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef08b4163c937..c5fa6f61634a7 100644
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



