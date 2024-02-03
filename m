Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CE111AA;
	Sat,  3 Feb 2024 04:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933894; cv=none; b=QUc5SruI2E9K4DeRRjfRfxPVM4pt0sytcccJF89cemVNZdsVqaarZ0dU80N+oJhtwzTlWosnwmDfuh3SUHz+f4GQtrbtcvbve3mORSStCVodXGETI+I4huqXVtJXpJzQG+bTTi+yswzJ0MgVl6R8Hs9i+9Cc5BLYI14OpCSxDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933894; c=relaxed/simple;
	bh=uyfV+1ynMaoAe2WkOd+9nO6kUygIlMKJ4fOjDGZL15k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxyMVjeWJNKReBGGxLzKexrKDjJh2AJQi0y3vNT3Fnkv0PgJOEwrB4GXmL9eFn2p9CPEavymcZkdfBksBMfPrgyeG5GvSLZzv1ZjvKPdZuK3P6lmEpg00cSSCqzdTYP/k9pcdLlfMZSDoFHeAHiVA6AtRmDL2Wp3cgLcopsp5a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A/b2Wc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A/b2Wc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820BCC43399;
	Sat,  3 Feb 2024 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933894;
	bh=uyfV+1ynMaoAe2WkOd+9nO6kUygIlMKJ4fOjDGZL15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0A/b2Wc8+sQUG6uvZudYHmoaUFe+0Ns3OiWMySFMREfzu66LRDrA/yiud12to3kbf
	 QyKhegh9Isy/PxiP6hgwdP2sfjy8DRSnhn+N2tAwxVL79hHWK10NhhCTQ9Of97J9jD
	 SL1IETzBsKRtOT8Gq2tFQinWSoUg+YnhFH9BjtW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 241/353] um: net: Fix return type of uml_net_start_xmit()
Date: Fri,  2 Feb 2024 20:05:59 -0800
Message-ID: <20240203035411.307252033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 7d748f60a4b82b50bf25fad1bd42d33f049f76aa ]

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
Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
-- 
2.43.0



