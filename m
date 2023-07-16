Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C288C433C7;
	Sun, 16 Jul 2023 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537568;
	bh=iUSRCU4s9x5u4NXgagCdljN1NamwjsBKrGKdnDzzU4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eoi1T4o0dpqbJNvTcN6BD2Zb2Y9N+CCZRz4TlQ1j0BrdmU+QSGJ3TeL2vIyCkCzKQ
	 tPQ9hOjhtgBRKsoWKrOMamPiPZNzE9rpWOGK4r2teAt2Tizj23lHIZpJ7jtsZO/mtP
	 XNKw6j4mwQFJQK+8FjBKy9GK5RNuQSJIF4xRO3l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amisha Patel <amisha.patel@microchip.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 115/800] wifi: wilc1000: fix for absent RSN capabilities WFA testcase
Date: Sun, 16 Jul 2023 21:39:28 +0200
Message-ID: <20230716194951.781198174@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 5adc69d5bcae3..a28da59384813 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -485,6 +485,9 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 		int rsn_ie_len = sizeof(struct element) + rsn_ie[1];
 		int offset = 8;
 
+		param->mode_802_11i = 2;
+		param->rsn_found = true;
+
 		/* extract RSN capabilities */
 		if (offset < rsn_ie_len) {
 			/* skip over pairwise suites */
@@ -494,11 +497,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
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



