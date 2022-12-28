Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48B91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACA4C433D2;
	Wed, 28 Dec 2022 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239751;
	bh=222BZMOFZZjvAP0LBSSj2syLf2ST6zQETqrGb5PKcU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr3bKSVF5dV5qaVje7LK6ruy6S15f8lP3+83bRbnwHUubp0nwsMyfHRaUx+0DdI0w
	 Pb0OaRZIQk/ZY4hgJPrjIdTDuTPItbl7VVstn8M6Xx+8aV9+OGwL9dNDwr7ZW5WS80
	 g9RoKX7i1yBP6sxSBegs9x9zYmIuBeBvR/a/i2KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/731] wifi: mac80211: fix memory leak in ieee80211_if_add()
Date: Wed, 28 Dec 2022 15:36:13 +0100
Message-Id: <20221228144304.277595311@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]

When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
isn't released. Fix it.

Fixes: 5a490510ba5f ("mac80211: use per-CPU TX/RX statistics")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221117064500.319983-1-shaozhengchao@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 041859b5b71d..a3347f245782 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2059,6 +2059,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
+			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.35.1



