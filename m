Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2293C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04857C433C0;
	Mon, 19 Jun 2023 10:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171180;
	bh=5eNRMy6eha9gqCKeb2VaekVDqmQJqeCBvf7jr6mFkVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1umqKb4erIS6BZqAhPwt6STQbQlJZGMSbMADWcr5Z4+B0lMtKLR5ltaKsyUeuGDd
	 bx41QXTHB0FL2YiEYRNqHFy9eIQgAsIJC80zCYQ4CsQvAjy5CyTd6osIeVC2D1T7mI
	 9zFDqASZRWNhXXc7ZLtc5fmFTU1N9xqbVvSwC8LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 176/187] net: macsec: fix double free of percpu stats
Date: Mon, 19 Jun 2023 12:29:54 +0200
Message-ID: <20230619102206.199565664@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 0c0cf3db83f8c7c9bb141c2771a34043bcf952ef ]

Inside macsec_add_dev() we free percpu macsec->secy.tx_sc.stats and
macsec->stats on some of the memory allocation failure paths. However, the
net_device is already registered to that moment: in macsec_newlink(), just
before calling macsec_add_dev(). This means that during unregister process
its priv_destructor - macsec_free_netdev() - will be called and will free
the stats again.

Remove freeing percpu stats inside macsec_add_dev() because
macsec_free_netdev() will correctly free the already allocated ones. The
pointers to unallocated stats stay NULL, and free_percpu() treats that
correctly.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path support")
Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a56..e040c191659b9 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3987,17 +3987,15 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 		return -ENOMEM;
 
 	secy->tx_sc.stats = netdev_alloc_pcpu_stats(struct pcpu_tx_sc_stats);
-	if (!secy->tx_sc.stats) {
-		free_percpu(macsec->stats);
+	if (!secy->tx_sc.stats)
 		return -ENOMEM;
-	}
 
 	secy->tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
-	if (!secy->tx_sc.md_dst) {
-		free_percpu(secy->tx_sc.stats);
-		free_percpu(macsec->stats);
+	if (!secy->tx_sc.md_dst)
+		/* macsec and secy percpu stats will be freed when unregistering
+		 * net_device in macsec_free_netdev()
+		 */
 		return -ENOMEM;
-	}
 
 	if (sci == MACSEC_UNDEF_SCI)
 		sci = dev_to_sci(dev, MACSEC_PORT_ES);
-- 
2.39.2



