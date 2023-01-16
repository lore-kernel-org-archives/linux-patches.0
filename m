Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58F046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C574C433EF;
	Mon, 16 Jan 2023 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886374;
	bh=9oiWed+y+dylobj+KkpI5BF0iQt4WrsPE7rg2K5NE2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFUjbAy7DpK7Ry3FWjJwpjmTz0LZM1/Dh1/grc/p8pO5shqMCT3oYZKXKBTsDd1g9
	 9RAzbD/ONuerVZvUY2cgUNN3V99Tz85gCIJiXXV1WoPuTiZC+uSW0f8jUQ/lELkscw
	 23xddso4xBu2RIAsv8OGA/E0pZZo/57qAYqQIa7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 406/658] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Date: Mon, 16 Jan 2023 16:48:14 +0100
Message-Id: <20230116154928.174259692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit aa5bf80c3c067b82b4362cd6e8e2194623bcaca6 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/s390/net/ctcm_main.c:1064:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = ctcm_tx,
                                    ^~~~~~~
  drivers/s390/net/ctcm_main.c:1072:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = ctcmpc_tx,
                                    ^~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of ctc{mp,}m_tx() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Additionally, while in the area, remove a comment block that is no
longer relevant.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ctcm_main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 437a6d822105..87d05b13fbd5 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -865,16 +865,9 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 /**
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- *  skb		Pointer to buffer containing the packet.
- *  dev		Pointer to interface struct.
- *
- * returns 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
 /* first merge version - leaving both functions separated */
-static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ctcm_priv *priv = dev->ml_priv;
 
@@ -917,7 +910,7 @@ static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* unmerged MPC variant of ctcm_tx */
-static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int len = 0;
 	struct ctcm_priv *priv = dev->ml_priv;
-- 
2.35.1



