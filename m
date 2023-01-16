Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F646FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E56C433D2;
	Mon, 16 Jan 2023 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887386;
	bh=D++9V9Oyy3oxs2XcPMNi7DAfIPKA9ks4j1KYZ9XVxrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNswLKSf1eOSgtHa/an2LGVy+lRwVYLyCzxpTWVN0W9D/acokSbKVKr0dPR1Sj/gL
	 dGO+QIGwLmDBYiJ2TkI9nP6amXhCkSmjU0/Vl/KhkJqp7EEgfZFIIyHlIzKzyGnc6r
	 oS/b/alzCboDcnmvpL5q2GY69QA8z0fR2pQwfLSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/521] wifi: mac80211: fix memory leak in ieee80211_if_add()
Date: Mon, 16 Jan 2023 16:46:31 +0100
Message-Id: <20230116154853.031531034@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 358028a09ce4..5d252d144cb9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1888,6 +1888,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = register_netdevice(ndev);
 		if (ret) {
+			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.35.1



