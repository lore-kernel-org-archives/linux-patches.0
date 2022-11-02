Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993776D18;
	Wed,  2 Nov 2022 16:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F660C433C1;
	Wed,  2 Nov 2022 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667405181;
	bh=uC/huKB8ojZr8E05891PDIL9GMzoWr5Ol6Vawz7NAHA=;
	h=From:To:Cc:Subject:Date:From;
	b=qbRk6eCBhBWgx0CQOO8Ik3q+htKp2pOYraMX06ybmCfSfqt/k/glkH97uTHhjR0M6
	 hcGl8TwcwSEkKCclmwA+UvEd0fxu/Q+nq0yIqgPoMzz44jRTlrU3KiD3Lfh5AaGsSg
	 AYsmL3hr5pyJBOQQlncDwfP36xRqSCg5hYB+cOiUUcF4dSZ59FBpN4vv43478FM6kk
	 Vk2piNjs/G9UgECa0gQIiO4dZk6bIz4cGlIDiJWEGzGqpM20K9TjtVWgun7EVKBBjq
	 swIQumGh12Wn9Bt5g/0FQlavdScVCqIdG5UM/M1wtcK84sqR2JCyArpj6QTUsk3str
	 Zt28kbB47Q4JA==
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Sailer <t.sailer@alumni.ethz.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-hams@vger.kernel.org,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] hamradio: baycom_epp: Fix return type of baycom_send_packet()
Date: Wed,  2 Nov 2022 09:06:10 -0700
Message-Id: <20221102160610.1186145-1-nathan@kernel.org>
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

  drivers/net/hamradio/baycom_epp.c:1119:25: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit      = baycom_send_packet,
                                ^~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of baycom_send_packet()
to match the prototype's to resolve the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/hamradio/baycom_epp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 791b4a53d69f..bd3b0c2655a2 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -758,7 +758,7 @@ static void epp_bh(struct work_struct *work)
  * ===================== network driver interface =========================
  */
 
-static int baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

