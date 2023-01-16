Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750306FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1814C433D2;
	Mon, 16 Jan 2023 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888679;
	bh=Snoqf9VpvTgWOlojbJjZCtq0GETXBSR8Y1yfNZTxW94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymNaGTfyy9+o2nCFBwTY0WQQNbMB8UJ35txePN+I5jZ8sLKmJisFRuolAr72YiSdP
	 i2iM3wXyh17eiMe4DL/GKKtddu4rpQIvO0F6LJs/lS16wA87Y9iHNZAKtbOErfRrk8
	 1PpAp/Lhj6+AqmOyLZDuT31unoo3LALbS/XE4HCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/338] wifi: mac80211: fix memory leak in ieee80211_if_add()
Date: Mon, 16 Jan 2023 16:49:30 +0100
Message-Id: <20230116154825.125747074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index adafa29d3021..69af1d1ae33c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1902,6 +1902,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = register_netdevice(ndev);
 		if (ret) {
+			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.35.1



