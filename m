Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774BB26A086;
	Tue,  8 Apr 2025 12:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113820; cv=none; b=poE+PNtd4PMTa/Ou9FQedXkdFScUsSQuaWS3aziMAfgxmoVVa1J0kz39wpJNkaS+6IFu5nnfqqkizCIvbntfOt+aT5bjB1EnqrpxeYfPimm+d5NXWgmxHit6W6PQrc2Qp7y7sMErTgxMNIuWrcCfkqXQ8pWktCfA0D+Ecg7sJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113820; c=relaxed/simple;
	bh=2aqrZb+nCV0TODisUdHR1DrSeVHobo2VUg0np2ZsuJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epkrr7uZ/14LjAP30oa/i8/h6FVyD7fpmYhg41axoIN9MXM0Qs1TUZHbySWHQEk2PBsD1tAyexuyWS1nQIJwzbvj8vMlUzspif9tjSesIW1F4nIAiAkNbebgc1RMq4tT/LZ6aZn7+ConUe9ulYEKtxKiOT/4DS5jU8Fa+/OAE6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jpQJdqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jpQJdqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060E8C4CEE5;
	Tue,  8 Apr 2025 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113820;
	bh=2aqrZb+nCV0TODisUdHR1DrSeVHobo2VUg0np2ZsuJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jpQJdqeltpy90oVyXz21oJRQu6RP8GPheaQ3M4WaQZU7seDUFI26e7LXCbVCVSVj
	 2fNQQ2uNnSfMuvmjj9g9KSk23jF9+ZOdSW5TM3R1vlJi1wbQO1xHlxVYyuHNMJmtVC
	 j97sJv1vwPqJKkRkMK3NiSQg9asGShi8iBfiJhd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/154] netpoll: Fix use correct return type for ndo_start_xmit()
Date: Tue,  8 Apr 2025 12:49:10 +0200
Message-ID: <20250408104815.587519835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit a54776f2c4939bdee084c9ecd00a4a5a25b7c429 ]

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 505ead7ab77f ("netpoll: hold rcu read lock in __netpoll_send_skb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9a67aa989d606..35a3277ee3567 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -70,10 +70,11 @@ module_param(carrier_timeout, uint, 0644);
 #define np_notice(np, fmt, ...)				\
 	pr_notice("%s: " fmt, np->name, ##__VA_ARGS__)
 
-static int netpoll_start_xmit(struct sk_buff *skb, struct net_device *dev,
-			      struct netdev_queue *txq)
+static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
+				      struct net_device *dev,
+				      struct netdev_queue *txq)
 {
-	int status = NETDEV_TX_OK;
+	netdev_tx_t status = NETDEV_TX_OK;
 	netdev_features_t features;
 
 	features = netif_skb_features(skb);
@@ -325,7 +326,7 @@ static int netpoll_owner_active(struct net_device *dev)
 void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 			     struct net_device *dev)
 {
-	int status = NETDEV_TX_BUSY;
+	netdev_tx_t status = NETDEV_TX_BUSY;
 	unsigned long tries;
 	/* It is up to the caller to keep npinfo alive. */
 	struct netpoll_info *npinfo;
-- 
2.39.5



