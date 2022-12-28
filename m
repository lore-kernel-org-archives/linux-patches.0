Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7E91C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F2EC433D2;
	Wed, 28 Dec 2022 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245778;
	bh=CwJ34qd6UTI9A6IbPwAliuNehPs83ziqfQ//1dcSAEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+C+0izPJVOU8Ma/kzpSmaa082qUU0shmK54DiFmJ5nX1Cu/D5y7wrW7zMlNiyn8j
	 M07az/sq/8UajZVGh7rAwXrL0jpF9SeCEweCFTD1UBSLwY6cxxBsh9T2k5b/3YLg6G
	 x8lRV0UHyhhb54CEaG43AB/uOmQew7sbfZ6k3ahw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0926/1073] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
Date: Wed, 28 Dec 2022 15:41:54 +0100
Message-Id: <20221228144353.179862676@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 63fe6ff674a96cfcfc0fa8df1051a27aa31c70b4 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/net/ethernet/ti/netcp_core.c:1944:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = netcp_ndo_start_xmit,
                                    ^~~~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of
netcp_ndo_start_xmit() to match the prototype's to resolve the warning
and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102160933.1601260-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b15d44261e76..267252560942 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1261,7 +1261,7 @@ static int netcp_tx_submit_skb(struct netcp_intf *netcp,
 }
 
 /* Submit the packet */
-static int netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
 	struct netcp_stats *tx_stats = &netcp->stats;
-- 
2.35.1



