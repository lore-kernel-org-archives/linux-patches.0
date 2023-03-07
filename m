Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B714BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6574C433EF;
	Tue,  7 Mar 2023 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209698;
	bh=ZhR24g26aXXEXnsxxf6/w5Ej8tWNPt5zoAXsd/nSJfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzCN2cuqehxfdL3uyNY2O61LxdxXBinEV6sYmTNYO5YbTxYnze3Y+R69TZJWXZ7Hg
	 TUqFPMqKhNQFwW/X8tfeeRpgmsT9mLyMf+ddnkGh1fgYZEGh3G6ctlbDas5jVSXeOj
	 YEWWaoRDG+TEfyWHkNwREmpIQ/IKSuPiOoPbafOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0303/1001] wifi: mac80211: fix off-by-one link setting
Date: Tue,  7 Mar 2023 17:51:15 +0100
Message-Id: <20230307170034.715947692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cf08e29db760b144bde51e2444f3430c75763e26 ]

The convention for find_first_bit() is 0-based, while ffs()
is 1-based, so this is now off-by-one. I cannot reproduce the
gcc-9 problem, but since the -1 is now removed, I'm hoping it
will still avoid the original issue.

Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Fixes: 1d8d4af43474 ("wifi: mac80211: avoid u32_encode_bits() warning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 118648af979c7..7699fb4106701 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4434,7 +4434,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
+		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.2



