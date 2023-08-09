Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140115AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F39C433C8;
	Wed,  9 Aug 2023 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578032;
	bh=w2ixkPO//+Xq16dEUHAh9Oem/YFXGoYSdUbHNEQoll0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1dnk/FO18/fA0jAuZ1QHh1Jq3TMFg5IjLNdq1XA24TN2Xk/4+3dB/9BuuJKC5GrY
	 IanuS03nzMpgG8drhHemj6jpUiAYNQ1vQmFt3mMQU1lqvg/hEMPL8w9WfPiqyxXlQZ
	 g3XALIW0Gtipz9h2McaS22kGsYJcsmQzmrtJu+ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 082/165] s390/qeth: Dont call dev_close/dev_open (DOWN/UP)
Date: Wed,  9 Aug 2023 12:40:13 +0200
Message-ID: <20230809103645.485777165@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 1cfef80d4c2b2c599189f36f36320b205d9447d9 ]

dev_close() and dev_open() are issued to change the interface state to DOWN
or UP (dev->flags IFF_UP). When the netdev is set DOWN it loses e.g its
Ipv6 addresses and routes. We don't want this in cases of device recovery
(triggered by hardware or software) or when the qeth device is set
offline.

Setting a qeth device offline or online and device recovery actions call
netif_device_detach() and/or netif_device_attach(). That will reset or
set the LOWER_UP indication i.e. change the dev->state Bit
__LINK_STATE_PRESENT. That is enough to e.g. cause bond failovers, and
still preserves the interface settings that are handled by the network
stack.

Don't call dev_open() nor dev_close() from the qeth device driver. Let the
network stack handle this.

Fixes: d4560150cb47 ("s390/qeth: call dev_close() during recovery")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h      | 1 -
 drivers/s390/net/qeth_core_main.c | 2 --
 drivers/s390/net/qeth_l2_main.c   | 9 ++++++---
 drivers/s390/net/qeth_l3_main.c   | 8 +++++---
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 1d195429753dd..613eab7297046 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -716,7 +716,6 @@ struct qeth_card_info {
 	u16 chid;
 	u8 ids_valid:1; /* cssid,iid,chid */
 	u8 dev_addr_is_registered:1;
-	u8 open_when_online:1;
 	u8 promisc_mode:1;
 	u8 use_v1_blkt:1;
 	u8 is_vm_nic:1;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 1d5b207c2b9e9..cd783290bde5e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5373,8 +5373,6 @@ int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
 	qeth_clear_ipacmd_list(card);
 
 	rtnl_lock();
-	card->info.open_when_online = card->dev->flags & IFF_UP;
-	dev_close(card->dev);
 	netif_device_detach(card->dev);
 	netif_carrier_off(card->dev);
 	rtnl_unlock();
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9f13ed170a437..75910c0bcc2bc 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2388,9 +2388,12 @@ static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 		qeth_enable_hw_features(dev);
 		qeth_l2_enable_brport_features(card);
 
-		if (card->info.open_when_online) {
-			card->info.open_when_online = 0;
-			dev_open(dev, NULL);
+		if (netif_running(dev)) {
+			local_bh_disable();
+			napi_schedule(&card->napi);
+			/* kick-start the NAPI softirq: */
+			local_bh_enable();
+			qeth_l2_set_rx_mode(dev);
 		}
 		rtnl_unlock();
 	}
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index af4e60d2917e9..b92a32b4b1141 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2018,9 +2018,11 @@ static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 		netif_device_attach(dev);
 		qeth_enable_hw_features(dev);
 
-		if (card->info.open_when_online) {
-			card->info.open_when_online = 0;
-			dev_open(dev, NULL);
+		if (netif_running(dev)) {
+			local_bh_disable();
+			napi_schedule(&card->napi);
+			/* kick-start the NAPI softirq: */
+			local_bh_enable();
 		}
 		rtnl_unlock();
 	}
-- 
2.40.1



