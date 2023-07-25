Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E821EA96
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80011C433C7;
	Tue, 25 Jul 2023 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283575;
	bh=ODRuBjStX3BMfPh5gTpYX4QlgfL59gthAj/7hjoESrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSxteYo8tFM/j345e1dVhg41ZsbPLE3Wy/S9bgEZruKGnH57WHVUFlB7mKrGZ4B4Q
	 aeJXc/ropsFqWEYNKEXSB06pfpyydO//b+TzytoQ1Q0obKqTDqc4lK1OeWV70ZFRHk
	 +1nU1kTGgfm6CjYMRA4XFK1OXFo+NNqQ4PYkmwmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amisha Patel <amisha.patel@microchip.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/509] wifi: wilc1000: fix for absent RSN capabilities WFA testcase
Date: Tue, 25 Jul 2023 12:39:45 +0200
Message-ID: <20230725104555.789482779@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amisha Patel <amisha.patel@microchip.com>

[ Upstream commit 9ce4bb09123e9754996e358bd808d39f5d112899 ]

Mandatory WFA testcase
CT_Security_WPA2Personal_STA_RSNEBoundsVerification-AbsentRSNCap,
performs bounds verfication on Beacon and/or Probe response frames. It
failed and observed the reason to be absence of cipher suite and AKM
suite in RSN information. To fix this, enable the RSN flag before extracting RSN
capabilities.

Fixes: cd21d99e595e ("wifi: wilc1000: validate pairwise and authentication suite offsets")
Signed-off-by: Amisha Patel <amisha.patel@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230421181005.4865-1-amisha.patel@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index b25847799138b..884f45e627a72 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -470,6 +470,9 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 		int rsn_ie_len = sizeof(struct element) + rsn_ie[1];
 		int offset = 8;
 
+		param->mode_802_11i = 2;
+		param->rsn_found = true;
+
 		/* extract RSN capabilities */
 		if (offset < rsn_ie_len) {
 			/* skip over pairwise suites */
@@ -479,11 +482,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 				/* skip over authentication suites */
 				offset += (rsn_ie[offset] * 4) + 2;
 
-				if (offset + 1 < rsn_ie_len) {
-					param->mode_802_11i = 2;
-					param->rsn_found = true;
+				if (offset + 1 < rsn_ie_len)
 					memcpy(param->rsn_cap, &rsn_ie[offset], 2);
-				}
 			}
 		}
 	}
-- 
2.39.2



