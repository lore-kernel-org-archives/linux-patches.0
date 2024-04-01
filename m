Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE984778E;
	Mon,  1 Apr 2024 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987226; cv=none; b=iP66RlZmlOK263bGVoS8LOQLBS7m1SpbpMEsTX2PRFn/JlS2Kd+d5pF//9yxJxBY1zPL3AJ5qqhm6hHg06S5K4CRKaPjkEwXkd4zVrhUaKKdXxXN9Z7NF3R8VOTJRpJNcPqqW7nge2RchwMlJv3zJkEPMVc5Efezj6SEyKoY3SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987226; c=relaxed/simple;
	bh=V4QeehWxabO8hNVyMEc6xdJsTbPEgQqttv42EozAdTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5vykUkq1lGj05jMP1W5RpOSGDYixGZnM3wUegqs9snvSIJ03tqXmmHecD9n6pkEwqrd821oZCg4KqnrRp10NkFF2ec7fSkLgeWrLxMu4Um6Rray7tgLLBcNjBjLde7dW7/OSgb4iEvuu2tqphNvMc1bUXFGpuCsdPUXMJfxp/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0SRfVzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0SRfVzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F10C433F1;
	Mon,  1 Apr 2024 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987226;
	bh=V4QeehWxabO8hNVyMEc6xdJsTbPEgQqttv42EozAdTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0SRfVzQIKxkrLFoM5YhRvqOn/hmrBckOdaosK8u5J1xn2dUIurKlbmanwlv4y5BT
	 EXigxaFDhgs6unijAy8VLYxQPZh/OALN6Y5TKDg3niI2mC29eGbvVfrjsw3cgnookR
	 K5CQbln5GpGGtexAwhnbol6EUV2pEB6gy+X2PZks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 222/399] wifi: brcmfmac: add per-vendor feature detection callback
Date: Mon,  1 Apr 2024 17:43:08 +0200
Message-ID: <20240401152555.807873916@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 14e1391b71027948cdbacdbea4bf8858c2068eb7 ]

Adding a .feat_attach() callback allowing per-vendor overrides
of the driver feature flags. In this patch the callback is only
provided by BCA vendor to disable SAE feature as it has not been
confirmed yet. BCA chips generally do not have the in-driver
supplicant (idsup) feature so they rely on NL80211_CMD_EXTERNAL_AUTH
to trigger user-space authentication.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240103095704.135651-3-arend.vanspriel@broadcom.com
Stable-dep-of: 85da8f71aaa7 ("wifi: brcmfmac: Demote vendor-specific attach/detach messages to info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bca/core.c  |  8 ++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c   |  3 +++
 .../net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h | 12 ++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
index ac3a36fa3640c..a5d9ac5e67638 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
@@ -7,6 +7,7 @@
 #include <core.h>
 #include <bus.h>
 #include <fwvid.h>
+#include <feature.h>
 
 #include "vops.h"
 
@@ -21,7 +22,14 @@ static void brcmf_bca_detach(struct brcmf_pub *drvr)
 	pr_err("%s: executing\n", __func__);
 }
 
+static void brcmf_bca_feat_attach(struct brcmf_if *ifp)
+{
+	/* SAE support not confirmed so disabling for now */
+	ifp->drvr->feat_flags &= ~BIT(BRCMF_FEAT_SAE);
+}
+
 const struct brcmf_fwvid_ops brcmf_bca_ops = {
 	.attach = brcmf_bca_attach,
 	.detach = brcmf_bca_detach,
+	.feat_attach = brcmf_bca_feat_attach,
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 6d10c9efbe93d..909a34a1ab503 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -13,6 +13,7 @@
 #include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
+#include "fwvid.h"
 #include "feature.h"
 #include "common.h"
 
@@ -339,6 +340,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_SCAN_V2, "scan_ver");
 
+	brcmf_fwvid_feat_attach(ifp);
+
 	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
 			  ifp->drvr->feat_flags,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
index 43df58bb70ad3..17fbdbb76f51b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
@@ -8,10 +8,12 @@
 #include "firmware.h"
 
 struct brcmf_pub;
+struct brcmf_if;
 
 struct brcmf_fwvid_ops {
 	int (*attach)(struct brcmf_pub *drvr);
 	void (*detach)(struct brcmf_pub *drvr);
+	void (*feat_attach)(struct brcmf_if *ifp);
 };
 
 /* exported functions */
@@ -44,4 +46,14 @@ static inline void brcmf_fwvid_detach(struct brcmf_pub *drvr)
 	brcmf_fwvid_detach_ops(drvr);
 }
 
+static inline void brcmf_fwvid_feat_attach(struct brcmf_if *ifp)
+{
+	const struct brcmf_fwvid_ops *vops = ifp->drvr->vops;
+
+	if (!vops->feat_attach)
+		return;
+
+	vops->feat_attach(ifp);
+}
+
 #endif /* FWVID_H_ */
-- 
2.43.0



