Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA911EF93D;
	Wed,  6 Nov 2024 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897488; cv=none; b=id6DPw7xidiQo26Am6OXIInZr/Vb1bS6viMKOFyAqjt1GM5LNl6sICkU14CZ+t3+nqC4nqNgib5i5RwXBoyROLOifWqjyAVVNOBIE2yzJJIChsbRNF/kZaRcFUO+xrcaI+FNmJc5sr5F5dyCCGut5Uc7YjMqRlq4Y4XM3OLdKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897488; c=relaxed/simple;
	bh=HHygwu3gJBB+qnsX+r6KB87NXdA5ke2Of3ZzBR0tNNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9LVkVWSZUNmgzw139uaBsiT7kc9FdnAms1b+mI42EM8+0PTYNtM9MAmZC6XnSbGkKQfq6iDxNhwAK2j345ukSKqGDepnHyrxQlOyBzp0nLSflhRmgOLIB/dtgJAVEvgU572aiCcovBfYAHMPZpR2Gq3kvsQQwIe5gfMCR8ZQdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9auCpGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9auCpGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB25C4CED3;
	Wed,  6 Nov 2024 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897488;
	bh=HHygwu3gJBB+qnsX+r6KB87NXdA5ke2Of3ZzBR0tNNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9auCpGh2scgdhKIUfb0ISaZKKCZFus0FKrrgN7t/L3CrlKl2CdxsGXlYGYddaBcw
	 1s06b8DXOGasdyURPgyJtY7I+xy6fr58p0DVMA/i/L0v4S3PBJ+5x1bKcHJnpFqbs+
	 KLiI7se7NOQLmFfRlkhurZfZRxCN7L7UX28nQzYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/151] net: amd: mvme147: Fix probe banner message
Date: Wed,  6 Nov 2024 13:04:17 +0100
Message-ID: <20241106120310.734616399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



