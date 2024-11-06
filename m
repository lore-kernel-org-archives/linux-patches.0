Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2B31E04A8;
	Wed,  6 Nov 2024 12:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897076; cv=none; b=IDoWA6xXgbtxdW+VLgteWUAnzb1AhNVld+7ridF5L631XVuE0MxOeBwTI6jh0anDNpJB8dv+xJ6Eo7lB9JiGbncu/NUQE/VSOePAJZSXrsev29oGbLTNuLilFJEi5D1mJNNWLpR4T0fy5s6SAE1IhRiHwVJ4eXFIyri1lxeQe70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897076; c=relaxed/simple;
	bh=CILADQpozgqwbrL3/e6CQDiySmZtVh+U4ooG9Tn3q9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrNh8R8o9Jwy1uKK8ykpdOyaqqnTBiTAlnogOMBa9Mf+0ZJ8zMFN2SZ0VMQqppHUiyUoc0Nzo2+mguCX795IFtaeDsTIO8H1kNh9fNLaca0fZMMX+dadF9sePeW9wcTf6TZedeYPkVSjsQsHyWWSpjOLV8ZNizDBnla1xXL5Q8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3sJCtx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3sJCtx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B46CC4CECD;
	Wed,  6 Nov 2024 12:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897076;
	bh=CILADQpozgqwbrL3/e6CQDiySmZtVh+U4ooG9Tn3q9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3sJCtx49WYI+u/w/QtCmN6VFpF5eBsIX3gvpx1Qf4eQRlKs0EQ3M3ayNhJsrsaic
	 SS3WSWYxuHF1a6ex95GJ29TPUvUwt97xC2zroNmxqRFv8qF6q2U1zzkMLysFbzV6sl
	 Nedbmtj5vULgqtwfz+Z8RqDuYcWE5cuzmwSNqOYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/126] net: amd: mvme147: Fix probe banner message
Date: Wed,  6 Nov 2024 13:04:19 +0100
Message-ID: <20241106120307.664244299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 410c7b67eba4d..e6cc916d205f1 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -105,10 +105,6 @@ static struct net_device * __init mvme147lance_probe(void)
 	macaddr[3] = address&0xff;
 	eth_hw_addr_set(dev, macaddr);
 
-	printk("%s: MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
-	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
-	       dev->dev_addr);
-
 	lp = netdev_priv(dev);
 	lp->ram = __get_dma_pages(GFP_ATOMIC, 3);	/* 32K */
 	if (!lp->ram) {
@@ -138,6 +134,9 @@ static struct net_device * __init mvme147lance_probe(void)
 		return ERR_PTR(err);
 	}
 
+	netdev_info(dev, "MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
+		    dev->base_addr, MVME147_LANCE_IRQ, dev->dev_addr);
+
 	return dev;
 }
 
-- 
2.43.0



