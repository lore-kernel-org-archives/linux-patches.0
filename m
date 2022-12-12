Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B60C28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB7C43396;
	Mon, 12 Dec 2022 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853383;
	bh=OyJ+I3D0F90WRZF+J2iwpsLfKEJ1HT0fAfcoBMQ+/Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V94RT7WpX/nKKwyenhM59figbjzKxtCV377ZbfYz9aEnWOkP3cnLsKMhY8VH9VM9k
	 WWm4WDDgQ+4ZOXTpfVtsFytB1eJqu41Dxt8lZu3wJM6zhM6tqStmNbppiWbqqA6ZEL
	 3zpm6HHYrEnKUCJFlDtg0PgjyjgkjHarB3yna4UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Alexander Aring <aahringo@redhat.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/31] mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
Date: Mon, 12 Dec 2022 14:19:38 +0100
Message-Id: <20221212130911.101560720@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b3d72d3135d2ef68296c1ee174436efd65386f04 ]

Kernel fault injection test reports null-ptr-deref as follows:

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: 0010:cfg802154_netdev_notifier_call+0x120/0x310 include/linux/list.h:114
Call Trace:
 <TASK>
 raw_notifier_call_chain+0x6d/0xa0 kernel/notifier.c:87
 call_netdevice_notifiers_info+0x6e/0xc0 net/core/dev.c:1944
 unregister_netdevice_many_notify+0x60d/0xcb0 net/core/dev.c:1982
 unregister_netdevice_queue+0x154/0x1a0 net/core/dev.c:10879
 register_netdevice+0x9a8/0xb90 net/core/dev.c:10083
 ieee802154_if_add+0x6ed/0x7e0 net/mac802154/iface.c:659
 ieee802154_register_hw+0x29c/0x330 net/mac802154/main.c:229
 mcr20a_probe+0xaaa/0xcb1 drivers/net/ieee802154/mcr20a.c:1316

ieee802154_if_add() allocates wpan_dev as netdev's private data, but not
init the list in struct wpan_dev. cfg802154_netdev_notifier_call() manage
the list when device register/unregister, and may lead to null-ptr-deref.

Use INIT_LIST_HEAD() on it to initialize it correctly.

Fixes: fcf39e6e88e9 ("ieee802154: add wpan_dev_list")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Alexander Aring <aahringo@redhat.com>

Link: https://lore.kernel.org/r/20221130091705.1831140-1-weiyongjun@huaweicloud.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 06019dba4b10..9f2355cb6701 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -670,6 +670,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
-- 
2.35.1



