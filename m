Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDC8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F7EC433C9;
	Sun, 16 Jul 2023 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539739;
	bh=kQiBnlv7gBNtg/e/LUp3qXRpCbpB9gJ/1oy7zfC4GXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12x2BiHSux7zBNLZ/F4jr1w4uIBtkof7WzR5iAq5fXXC1/oJJOG1wLMvoiOKfzC8s
	 0Umwtb4oG4pt/20EReWi1yF2KvGjQCqxwmANOR38oclP2Rf8Fe84bjdQRAAkLlp1cI
	 HD0E6VzzUcUxMXAtnnyhvBOLhC08FSXQpOMuvLkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/591] wifi: cfg80211/mac80211: Fix ML element common size calculation
Date: Sun, 16 Jul 2023 21:44:14 +0200
Message-ID: <20230716194926.853020964@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 1403b109c9a5244dc6ab79154f04eecc209ef3d2 ]

The common size is part of the length in the data
so don't add it again.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: ce6e1f600b0c ("wifi: ieee80211: Fix the common size calculation for reconfiguration ML")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d3088666f3f44..470fafce2e707 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4573,18 +4573,17 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
-		common += sizeof(struct ieee80211_mle_basic_common_info);
-		break;
 	case IEEE80211_ML_CONTROL_TYPE_PREQ:
-		common += sizeof(struct ieee80211_mle_preq_common_info);
+	case IEEE80211_ML_CONTROL_TYPE_TDLS:
+		/*
+		 * The length is the first octet pointed by mle->variable so no
+		 * need to add anything
+		 */
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
 		if (control & IEEE80211_MLC_RECONF_PRES_MLD_MAC_ADDR)
 			common += ETH_ALEN;
 		return common;
-	case IEEE80211_ML_CONTROL_TYPE_TDLS:
-		common += sizeof(struct ieee80211_mle_tdls_common_info);
-		break;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		if (control & IEEE80211_MLC_PRIO_ACCESS_PRES_AP_MLD_MAC_ADDR)
 			common += ETH_ALEN;
-- 
2.39.2



