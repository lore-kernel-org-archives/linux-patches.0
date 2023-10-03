Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D036AF5;
	Tue,  3 Oct 2023 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E9DC433C7;
	Tue,  3 Oct 2023 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696358169;
	bh=uur6FVNUPgA68DU0+0V7uI6bm+Kw9EG25C8ZPIVUe20=;
	h=From:Date:Subject:To:Cc:From;
	b=ajILCUP9UyDP8jjvmTp66s7MbbRLmlzeH/og8T/AJIYctp8zr8JN7Yn8WHrzeo8yF
	 44o8sDdWsRpFjZEhn5Uzq0wyN9pyCfU5pLu7lNJS+KxT58DWp4ecGok7oRWWDPDCjU
	 mG2brcB5CgzM4RTCbaKezkpgYjfvSbcDDvTgxvmnZcaibnd7pHO6R5K2SFgs07FGEW
	 DnsegVdOv1SPyF54+RfpsjPRUB7KIzoatAzgwUxvgfkDQn6gVJCgOhSRtMFKXbkOWL
	 CWssFAvcIZMGoIpQrFUkDWuaF6PAw6BdM8NMiUKFzcsB9DYpLQtkVJcph0r9E1IxJS
	 9PsO9GbqSVQgg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 03 Oct 2023 11:35:53 -0700
Subject: [PATCH] um: net: Fix return type of uml_net_start_xmit()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231003-um-net-wifpts-v1-1-02888c634ee7@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAhfHGUC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI2NDAwNj3dJc3bzUEt3yzLSCkmJdQ5NEcxMjy2RzUyMTJaCegqLUtMwKsHn
 RsbW1APIlzJJfAAAA
To: richard@nod.at, anton.ivanov@cambridgegreys.com, 
 johannes@sipsolutions.net
Cc: ndesaulniers@google.com, trix@redhat.com, linux-um@lists.infradead.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224; i=nathan@kernel.org;
 h=from:subject:message-id; bh=uur6FVNUPgA68DU0+0V7uI6bm+Kw9EG25C8ZPIVUe20=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKky8RKZ/HJHlvMZn8lhlpq76f0N8fq4sMlsMkk7F9YFe
 bWlPb/ZUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZi0s7wP3uCUNF91bJkY3U1
 iy0/WeSY7d93Xs/7kfJhyxK2ix8ErzEyPJ3k7PpBesnF+GLTzpLdGfJ7hNsiCy0EGr9pzqxYylf
 HAAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
warning in clang aims to catch these at compile time, which reveals:

  arch/um/drivers/net_kern.c:353:21: warning: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Wincompatible-function-pointer-types-strict]
    353 |         .ndo_start_xmit         = uml_net_start_xmit,
        |                                   ^~~~~~~~~~~~~~~~~~
  1 warning generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of uml_net_start_xmit()
to match the prototype's to resolve the warning. While UML does not
currently implement support for kCFI, it could in the future, which
means this warning becomes a fatal CFI failure at run time.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310031340.v1vPh207-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/um/drivers/net_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 3d7836c46507..cabcc501b448 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -204,7 +204,7 @@ static int uml_net_close(struct net_device *dev)
 	return 0;
 }
 
-static int uml_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t uml_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct uml_net_private *lp = netdev_priv(dev);
 	unsigned long flags;

---
base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
change-id: 20231003-um-net-wifpts-14a7429c7524

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

