Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07179C1;
	Thu,  3 Nov 2022 22:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F362AC433C1;
	Thu,  3 Nov 2022 22:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667512853;
	bh=dluWjDGdC07I/AD6wdKBCeMDMLBVhk113lXX5gZ2rXU=;
	h=From:To:Cc:Subject:Date:From;
	b=jn0hZf8zNkSiysdNZ/+wAaZ4b9wAQOT0WC2bjA6PPgFN5X+M1e34p3qgkaDkElxc1
	 RZdDEBbZC57/diZc5DbFkwZdwCaSWXuM8htcBcV2+ENxOeEtl1MeUGWPO95mE8Yowp
	 GkEwSBMYUr0dQKyrLCz+aGrT+M+u7ClGBvRvpb3NmiWg7hRFOlEmK4JJAw2jkIqprX
	 wicnEA9/PspLYP5tUkcpsVGpYGLxCnaKBKjlcTOgWuPnUqKYwyFKVmyRJ0LTM63xzz
	 +cFQIxDNcdjl1FeHLZbg+VoFXvQ1LG0Xjim+bdUSAsIE08LDJGwHIPGPQV3w+zr466
	 /xBCm4fYp36sg==
From: Nathan Chancellor <nathan@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net: ethernet: renesas: Fix return type of rswitch_start_xmit()
Date: Thu,  3 Nov 2022 15:00:32 -0700
Message-Id: <20221103220032.2142122-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/net/ethernet/renesas/rswitch.c:1533:20: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit = rswitch_start_xmit,
                          ^~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of rswitch_start_xmit()
to match the prototype's to resolve the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 20df2020d3e5..f0168fedfef9 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1390,7 +1390,7 @@ static int rswitch_stop(struct net_device *ndev)
 	return 0;
 };
 
-static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_gwca_queue *gq = rdev->tx_queue;

base-commit: ef2dd61af7366e5a42e828fff04932e32eb0eacc
-- 
2.38.1

