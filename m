Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2270FA59;
	Wed,  2 Nov 2022 16:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB74C433D7;
	Wed,  2 Nov 2022 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667406788;
	bh=50kQ6owO8SzQI6+G9QUfCAtJgqi3aZcY8S6jn9Ofr0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSttuC6KSjo+IQVF76/jjjClrLvoQHgT+PX1bOq4XwGjMOLako3E74Y2OSytwTTSu
	 ki4QDY5vd5dJrtfQDQPSIhhWAiGQNkcD6HE6ND65niRNelLkNP7x9ejmzInvlf7yuK
	 OJCqp50qW8GUhayJIm6OAbrED/7R22a82WaEjwNrEhmwvj/spvEe6bVe/9zkBevvuW
	 EH2BoR05PAMP263XSTMGAeJFooshLEJC1ZyVPkigcT36bJf2hnGoxGWlmSRR3ktzwo
	 9ZQyyrQO9HSVANaqo/8UFuYBEG/hCgrF9siFoiGiYftf8WBSNOCuQaESpTWtJqoY9A
	 YHdQhDqyGiCnQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/3] s390/netiucv: Fix return type of netiucv_tx()
Date: Wed,  2 Nov 2022 09:32:51 -0700
Message-Id: <20221102163252.49175-2-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102163252.49175-1-nathan@kernel.org>
References: <20221102163252.49175-1-nathan@kernel.org>
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

  drivers/s390/net/netiucv.c:1854:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = netiucv_tx,
                                    ^~~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of netiucv_tx() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/s390/net/netiucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 65aa0a96c21d..1a7f2bc3a87b 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1256,7 +1256,7 @@ static int netiucv_close(struct net_device *dev)
  *         Note: If we return !0, then the packet is free'd by
  *               the generic network layer.
  */
-static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct netiucv_priv *privptr = netdev_priv(dev);
 	int rc;
-- 
2.38.1

