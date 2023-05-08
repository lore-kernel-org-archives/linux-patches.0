Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF423A4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9F0C433EF;
	Mon,  8 May 2023 10:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541977;
	bh=IYZmfJeCMlc1+aGeb8ZTQac3SndB7d8Aqed+x0PqdsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zghd/H3yvXlxkTwP0gQkPgcbVAnQBEV1L96bp+Flox0Xi+3XkzyP3+zMyTskvy5S6
	 Gh8fJcAfPPj5NWD3GU0PPMjDSPSV4IT+yu0ILXlPzmR0q681ZboL8WlKqAtm3o0C+I
	 puhMMQVdY/494qZpAPbeUa16+J/fiGLBELqJE7XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <john@metanate.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 287/663] wifi: brcmfmac: support CQM RSSI notification with older firmware
Date: Mon,  8 May 2023 11:41:53 +0200
Message-Id: <20230508094437.527872534@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Keeping <john@metanate.com>

[ Upstream commit ec52d77d077529f198fd874c550a26b9cc86a331 ]

Using the BCM4339 firmware from linux-firmware (version "BCM4339/2 wl0:
Sep  5 2019 11:05:52 version 6.37.39.113 (r722271 CY)" from
cypress/cyfmac4339-sdio.bin) the RSSI respose is only 4 bytes, which
results in an error being logged.

It seems that older devices send only the RSSI field and neither SNR nor
noise is included.  Handle this by accepting a 4 byte message and
reading only the RSSI from it.

Fixes: 7dd56ea45a66 ("brcmfmac: add support for CQM RSSI notifications")
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230124104248.2917465-1-john@metanate.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b8c99bfce963a..d17bb22422f48 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6494,18 +6494,20 @@ static s32 brcmf_notify_rssi(struct brcmf_if *ifp,
 {
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	struct brcmf_rssi_be *info = data;
-	s32 rssi, snr, noise;
+	s32 rssi, snr = 0, noise = 0;
 	s32 low, high, last;
 
-	if (e->datalen < sizeof(*info)) {
+	if (e->datalen >= sizeof(*info)) {
+		rssi = be32_to_cpu(info->rssi);
+		snr = be32_to_cpu(info->snr);
+		noise = be32_to_cpu(info->noise);
+	} else if (e->datalen >= sizeof(rssi)) {
+		rssi = be32_to_cpu(*(__be32 *)data);
+	} else {
 		brcmf_err("insufficient RSSI event data\n");
 		return 0;
 	}
 
-	rssi = be32_to_cpu(info->rssi);
-	snr = be32_to_cpu(info->snr);
-	noise = be32_to_cpu(info->noise);
-
 	low = vif->cqm_rssi_low;
 	high = vif->cqm_rssi_high;
 	last = vif->cqm_rssi_last;
-- 
2.39.2



