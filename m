Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240DE6FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C64C433C1;
	Wed, 30 Nov 2022 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833092;
	bh=7NUUWUMtiYfO84K3ucl91eIZysht5KrFNu8mGZayvNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsWxSvBApijTlazpCiSvJLg9Yw/4a6JGH2fF9DYA3fCdRFP/cnrqX0SLynSu5ENWj
	 IbdxIEUgN14fMcv3C/x/YmNP8+7iOmgDayj2q36R07sshksB3CgFY+Crd1Fkl1zfGb
	 AsHCvpmd6URoweHPpU5xxenHn/mXEfxzOBDePNVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Turnbull <philipturnbull@github.com>,
	Ajay Kathat <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 148/162] wifi: wilc1000: validate pairwise and authentication suite offsets
Date: Wed, 30 Nov 2022 19:23:49 +0100
Message-Id: <20221130180532.490964729@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phil Turnbull <philipturnbull@github.com>

commit cd21d99e595ec1d8721e1058dcdd4f1f7de1d793 upstream.

There is no validation of 'offset' which can trigger an out-of-bounds
read when extracting RSN capabilities.

Signed-off-by: Phil Turnbull <philipturnbull@github.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Acked-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221123153543.8568-2-philipturnbull@github.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -467,14 +467,25 @@ void *wilc_parse_join_bss_param(struct c
 
 	rsn_ie = cfg80211_find_ie(WLAN_EID_RSN, ies->data, ies->len);
 	if (rsn_ie) {
+		int rsn_ie_len = sizeof(struct element) + rsn_ie[1];
 		int offset = 8;
 
-		param->mode_802_11i = 2;
-		param->rsn_found = true;
 		/* extract RSN capabilities */
-		offset += (rsn_ie[offset] * 4) + 2;
-		offset += (rsn_ie[offset] * 4) + 2;
-		memcpy(param->rsn_cap, &rsn_ie[offset], 2);
+		if (offset < rsn_ie_len) {
+			/* skip over pairwise suites */
+			offset += (rsn_ie[offset] * 4) + 2;
+
+			if (offset < rsn_ie_len) {
+				/* skip over authentication suites */
+				offset += (rsn_ie[offset] * 4) + 2;
+
+				if (offset + 1 < rsn_ie_len) {
+					param->mode_802_11i = 2;
+					param->rsn_found = true;
+					memcpy(param->rsn_cap, &rsn_ie[offset], 2);
+				}
+			}
+		}
 	}
 
 	if (param->rsn_found) {


