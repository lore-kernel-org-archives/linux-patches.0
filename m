Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0FE168D1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A8DC433D2;
	Mon, 22 May 2023 19:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783549;
	bh=AOFh1WhfR4xsMJ/bfPiml5mDJj6P2fKPo6om/hQdRh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8fSngBhFgXiUYdX6BZr7lzMm0vhndBCbe1FysKQvLpbBEB1eu8gTEfs1EuRxaQHX
	 o9b3mxwcjBczqfKaTMCp8FNSTsxKPAGv5vw3DdQu8hV0wKSylnyDjYjnzafjgHjjcM
	 8wjWftbuluL0GK9iJ25UR62tMZGZeAP+jnNfy/cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/292] net: pasemi: Fix return type of pasemi_mac_start_tx()
Date: Mon, 22 May 2023 20:07:18 +0100
Message-Id: <20230522190407.998440976@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit c8384d4a51e7cb0e6587f3143f29099f202c5de1 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
warning in clang aims to catch these at compile time, which reveals:

  drivers/net/ethernet/pasemi/pasemi_mac.c:1665:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = pasemi_mac_start_tx,
                                    ^~~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of
pasemi_mac_start_tx() to match the prototype's to resolve the warning.
While PowerPC does not currently implement support for kCFI, it could in
the future, which means this warning becomes a fatal CFI failure at run
time.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index aaab590ef548d..ed7dd0a042355 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1423,7 +1423,7 @@ static void pasemi_mac_queue_csdesc(const struct sk_buff *skb,
 	write_dma_reg(PAS_DMA_TXCHAN_INCR(txring->chan.chno), 2);
 }
 
-static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct pasemi_mac * const mac = netdev_priv(dev);
 	struct pasemi_mac_txring * const txring = tx_ring(mac);
-- 
2.39.2



