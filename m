Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F214C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F207EC43140;
	Mon, 14 Nov 2022 13:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430927;
	bh=c3GSXw36R/EDWP2lscdREr+EKMj1iHztSYg5nnmxzLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlLKOqjc6KMjwCsd3bvqCqnFIg+/W32el0aOD/Ww0W5RnQXAll4/fce0ws47W569a
	 cE/6AAV/259YffVqtUTElkFQb0Tm1wxoIoISkwhSL9O2IbS8GCxrglwxldit+qTIBW
	 KXlhi7bgtS/VYDMoJIVqlEucH2iPM7Etg0CbG+hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antoine Tenart <atenart@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/190] macsec: fix secy->n_rx_sc accounting
Date: Mon, 14 Nov 2022 13:44:20 +0100
Message-Id: <20221114124500.357243508@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 73a4b31c9d11f98ae3bc5286d5382930adb0e9c7 ]

secy->n_rx_sc is supposed to be the number of _active_ rxsc's within a
secy. This is then used by macsec_send_sci to help decide if we should
add the SCI to the header or not.

This logic is currently broken when we create a new RXSC and turn it
off at creation, as create_rx_sc always sets ->active to true (and
immediately uses that to increment n_rx_sc), and only later
macsec_add_rxsc sets rx_sc->active.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3fce89a05312..6caab70efdb8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1427,7 +1427,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+					 bool active)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1451,7 +1452,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
-	rx_sc->active = true;
+	rx_sc->active = active;
 	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
@@ -1904,6 +1905,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
+	bool active = true;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1925,15 +1927,15 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
-	rx_sc = create_rx_sc(dev, sci);
+	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
+		active = nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
+
+	rx_sc = create_rx_sc(dev, sci, active);
 	if (IS_ERR(rx_sc)) {
 		rtnl_unlock();
 		return PTR_ERR(rx_sc);
 	}
 
-	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
-		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
-
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-- 
2.35.1



