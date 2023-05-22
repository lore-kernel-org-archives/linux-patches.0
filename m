Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B444D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BC3C433D2;
	Mon, 22 May 2023 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783938;
	bh=M4/N/P727Xn5RmLCNG5D2Ubwa0CegFwYl9cTDiHhMNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jt9W8qSsox1cstFpJB/gXj5oFRSz7zeRLOgHieWD1vBi/dhpsVAo+R80mQM07lATM
	 6vMNRjLw4YV1OpCbLtnJvDw5r1NFfI7Kyl2T22iWFGYaoUdi6wd5LltJADPpTpIUwq
	 A6htlrDMXWr8BpOnjqhPPu0ErQxYl0rzPYCuOQUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/292] wifi: cfg80211: Drop entries with invalid BSSIDs in RNR
Date: Mon, 22 May 2023 20:09:21 +0100
Message-Id: <20230522190411.056975952@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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

[ Upstream commit 1b6b4ed01493b7ea2205ab83c49198f7d13ca9d2 ]

Ignore AP information for entries that include an invalid
BSSID in the TBTT information field, e.g., all zeros BSSIDs.

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230424103224.5e65d04d1448.Ic10c8577ae4a85272c407106c9d0a2ecb5372743@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 3d86482e83f51..6c2b73c0d36e8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -5,7 +5,7 @@
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2016	Intel Deutschland GmbH
- * Copyright (C) 2018-2022 Intel Corporation
+ * Copyright (C) 2018-2023 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -543,6 +543,10 @@ static int cfg80211_parse_ap_info(struct cfg80211_colocated_ap *entry,
 	/* skip the TBTT offset */
 	pos++;
 
+	/* ignore entries with invalid BSSID */
+	if (!is_valid_ether_addr(pos))
+		return -EINVAL;
+
 	memcpy(entry->bssid, pos, ETH_ALEN);
 	pos += ETH_ALEN;
 
-- 
2.39.2



