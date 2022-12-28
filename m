Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06622C433EF;
	Wed, 28 Dec 2022 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242654;
	bh=H7SQm+nsc6E7nY8m6I1Nzd5PkMSJcdD1Syg4IkKJv7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiu0x3y9v2k+3ufQ4mfihF5jYUb3heoqXpyiILSrSGxRILXoHQUTtD9PyKWOLIrIQ
	 /yo16lrksjFqbuazUS1z/AyHQm0Dv2lnR7GwunOtdiZjc7g3YUGZPnOZicjMPuop1n
	 qrCb4oY/mPuWxGfPjDfUsaOasqmII+hA0xCF6qzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0436/1073] wifi: mac80211: fix memory leak in ieee80211_if_add()
Date: Wed, 28 Dec 2022 15:33:44 +0100
Message-Id: <20221228144339.869825563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 95b58c5cac07..c3eb08b5a47e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2414,6 +2414,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
+			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.35.1



