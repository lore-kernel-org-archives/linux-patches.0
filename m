Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385351D619E;
	Wed,  6 Nov 2024 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899050; cv=none; b=G9CqDnhwgWeu7FNm/vhSIu40RUR7JZnif2KS/jRaEU7dDS1Z6gZpkBkuGQaHGlK0D5I6qIXUn3+rSV9NxT36YPVD+vet2I7MeFtnnT1Gtxy3EUSgU4fQsvTiayY/7bzuHeMopsDwo72o9YoDgEQCZ3msUICOG65o1NQpGwglHpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899050; c=relaxed/simple;
	bh=6llpqpwlYnTRfZD/wChKDWwIqqq96f++s02Fx1shxoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb4y191DRI5Cm0IZVMqdnIw+ZcZDm4VHs+ReEvol3Qmv2/kGhqf3SYEUP2mXoraBDZTP5NGkskqOjjdqsSr9nUCriQ0GzqSx6uIzgaVttgwWD55uTC2lNY1kuBZzEp4K1HD491rddv909Mdtv+NnKnSVTkvIwzyy9H7EAXUL+G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT3BRADX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT3BRADX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65DCC4CED4;
	Wed,  6 Nov 2024 13:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899050;
	bh=6llpqpwlYnTRfZD/wChKDWwIqqq96f++s02Fx1shxoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT3BRADXJzGU4uJOpkvFFp+Gl/aCrsxJ+/xCsc0Z+izQI/zPDCXv27FVVa5D9jJCt
	 a5ZvAzhyc3bbJlkHl7uEVp5Lc/Z+ybuMITI6tJKYQ4aTICKk9MMupsChI7Aix/GBTV
	 DKsfnKbpnbo/Matyr9TF9zykeX3sUnDYTSo37mgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 444/462] net: amd: mvme147: Fix probe banner message
Date: Wed,  6 Nov 2024 13:05:37 +0100
Message-ID: <20241106120342.469851002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 72abd3f82249b..eb7b1da2fb06f 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -106,10 +106,6 @@ struct net_device * __init mvme147lance_probe(int unit)
 	address = address >> 8;
 	dev->dev_addr[3] = address&0xff;
 
-	printk("%s: MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
-	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
-	       dev->dev_addr);
-
 	lp = netdev_priv(dev);
 	lp->ram = __get_dma_pages(GFP_ATOMIC, 3);	/* 32K */
 	if (!lp->ram) {
@@ -139,6 +135,9 @@ struct net_device * __init mvme147lance_probe(int unit)
 		return ERR_PTR(err);
 	}
 
+	netdev_info(dev, "MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
+		    dev->base_addr, MVME147_LANCE_IRQ, dev->dev_addr);
+
 	return dev;
 }
 
-- 
2.43.0



