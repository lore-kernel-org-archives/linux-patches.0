Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B851DF740;
	Wed,  6 Nov 2024 12:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895789; cv=none; b=oIU/+/2G7bOhpvxipds592+z7SVaAeTaPsuCVsNcuPwqEqo+ATzLLuqAc3YlAgzJWG/Lp+Q+NW5JO9m1UaAaOqeW6fbG1em2EuCRwOG6BbmADJyXW+3/P0chsektd//GSSbofDTy7fbNo5iPIv1rrGbsOKtdqycjbP1ZYJPhi5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895789; c=relaxed/simple;
	bh=hTY7Gm2/z88U4KdNYRHBrsiXP++MTLNdaI+qm79FO0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1Zj2z5lJXDdgbHryeAg4kbvdcyak3Uc/gjOijPMzxtTxAvP9/qaC4TJelm2w4wyhmtSyO3JxLhL8oveI3xR/4Wd+49XigMFi0700cEKzHce3vqPUtNDTaV/rGQQ5ky87Op2xWhjhkIMJA6tn7ozi2SzYtOIeUnysNpKnunB8gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APwJ+/nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APwJ+/nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE103C4CECD;
	Wed,  6 Nov 2024 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895789;
	bh=hTY7Gm2/z88U4KdNYRHBrsiXP++MTLNdaI+qm79FO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APwJ+/nuwG4RgtGb985qhBGnn8N0lJnzCfjZ9UTrhZYwbohGXIp4y5e9apa4OQmpu
	 UYCBVkF5kcyTQBZeu4BHS0OG6JtbwN0UXwUk4XFiZbdNeGeWsS8AYN+MY8jUQ6ds34
	 KAWEa4cUwWZf7kzdLBoFfdneB3sEkQhmGEg/4guM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 337/350] net: amd: mvme147: Fix probe banner message
Date: Wed,  6 Nov 2024 13:04:25 +0100
Message-ID: <20241106120329.032809198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 82c5b53140faf89c31ea2b3a0985a2f291694169 ]

Currently this driver prints this line with what looks like
a rogue format specifier when the device is probed:
[    2.840000] eth%d: MVME147 at 0xfffe1800, irq 12, Hardware Address xx:xx:xx:xx:xx:xx

Change the printk() for netdev_info() and move it after the
registration has completed so it prints out the name of the
interface properly.

Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/mvme147.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index 0a920448522f3..0bb27f4dd6428 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -105,10 +105,6 @@ struct net_device * __init mvme147lance_probe(int unit)
 	address = address >> 8;
 	dev->dev_addr[3] = address&0xff;
 
-	printk("%s: MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
-	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
-	       dev->dev_addr);
-
 	lp = netdev_priv(dev);
 	lp->ram = __get_dma_pages(GFP_ATOMIC, 3);	/* 32K */
 	if (!lp->ram) {
@@ -138,6 +134,9 @@ struct net_device * __init mvme147lance_probe(int unit)
 		return ERR_PTR(err);
 	}
 
+	netdev_info(dev, "MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
+		    dev->base_addr, MVME147_LANCE_IRQ, dev->dev_addr);
+
 	return dev;
 }
 
-- 
2.43.0



